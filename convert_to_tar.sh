#!/bin/bash

# Check for Windows
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    echo "It looks like you're using Windows. Please use a Windows batch file to create an .exe file."
    exit 1
fi

# Check if the script name was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <script-to-convert>.py"
    exit 1
fi

ENTRY_SCRIPT=$1
VENV_DIR="venv"
DIST_DIR="dist"

# Activate the virtual environment
source $VENV_DIR/bin/activate

# Determine the Python version used in the venv
PYTHON_VERSION=$(python -c "import sys; print('python' + '.'.join(map(str, sys.version_info[:2])))")

# Install PyInstaller if it's not already installed
pip install pyinstaller

# Check for PyInstaller installation success
if ! pyinstaller --version > /dev/null 2>&1; then
    echo "PyInstaller installation failed."
    exit 1
fi

# Create the .exe file with PyInstaller
pyinstaller --onefile --add-data "$VENV_DIR/lib/$PYTHON_VERSION/site-packages/*:./lib" "$ENTRY_SCRIPT"

# Check if PyInstaller succeeded
if [ ! -f "$DIST_DIR/${ENTRY_SCRIPT%.*}" ]; then
    echo "PyInstaller failed to create an executable."
    deactivate
    exit 1
fi

# Move to the dist directory to archive the executable
cd $DIST_DIR || exit

# Archive the executable in tar.gz format
tar -czvf "${ENTRY_SCRIPT%.*}.tar.gz" "${ENTRY_SCRIPT%.*}"

# Check if tar succeeded
if [ ! -f "${ENTRY_SCRIPT%.*}.tar.gz" ]; then
    echo "Failed to create tar.gz archive."
    deactivate
    cd ..
    exit 1
fi

# Deactivate the virtual environment
deactivate

# Move the .exe and .tar.gz to the current directory
mv "${ENTRY_SCRIPT%.*}.tar.gz" ../

# Check if executable is a .exe or not (this will only be .exe on Windows)
if [ -f "${ENTRY_SCRIPT%.*}.exe" ]; then
    mv "${ENTRY_SCRIPT%.*}.exe" ../
    EXECUTABLE="${ENTRY_SCRIPT%.*}.exe"
else
    EXECUTABLE="${ENTRY_SCRIPT%.*}"
fi

# Clean up the build directories
cd ..
rm -rf build/
rm -rf "$ENTRY_SCRIPT".spec

echo "The standalone $EXECUTABLE and .tar.gz files have been created."
