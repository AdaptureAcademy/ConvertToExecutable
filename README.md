# Description
The scripts should bundle the dependencies of a `.py` file and output executable standalone `.exe` and `.tar.gz` files.

# Assumptions
The script should run on the same level as the `venv` (virtual environment) directory. To run the script, use the following command in terminal and CMD respectively:

## Linux
```./convert_to_tar.sh main.py```

## Windows
```convert_to_exe.bat main.py```

# Technical Challenges
To generate a `.exe`, you have to run the `convert_to_exe.bat` file on Windows and to generate a `.tar.gz` file, you have to run the `convert_to_tar.sh` file on Linux
