# [BackUpMaster](https://github.com/sergeiown/BackUpMaster/releases.)
BackUpMaster is more than just a data preservation tool; it's a solution for automated and secure backup. It combines user-friendliness with powerful capabilities, helping safeguard critical information reliably.

## Features and Capabilities:

- **Executable Files for Ease:** The program comes with [executable (.exe)](https://github.com/sergeiown/BackUpMaster/releases) files that simplify use by allowing you to easily run the program and all its components.
- **Configuration Flexibility:** Convenient configuration via `config.ini` with a separate configurator for super convenient changes allows you to customize paths, compression level, excluded file extensions, number of saved copies and more..
- **Automatic Startup:** The option for BackUpMaster to launch during system startup ensures continuous backup operations.
- **Copy Management:** Automatic management of backup copies, allowing to retain only the necessary number of copies and remove outdated ones.
- **Exclusion of Exclusive Extensions:** The ability to exclude specific file extensions from the compression process provides greater control over the content of backup copies.
- **Logging and Notifications:** Generating log files for each copy process allows you to track the results and receive notifications of success or failure. Two types of log files are available: general and last operation logs, which allows you to fine-tune all aspects of the backup process.
- **Graphical Interface:** Through the command-line interface and graphical user interface, you can conveniently interact with the program.
- **Individual Path Settings:** The capability to specify paths to backup and storage folders ensures tool flexibility.
- **Configuration Editor:** A separate configuration editor file is provided, making it even more convenient to manage and fine-tune your backup settings.

![image](https://github.com/sergeiown/BackUpMaster/assets/112722061/fcbd8242-f724-4b56-9f04-b767a5e243fe)

## Usage:

- The primary method of usage involves the executable files: `BackUpMaster.EXE` and `Config.EXE`, which are delivered as a self-extracting archive named [BackUpMaster_install.exe](https://github.com/sergeiown/BackUpMaster/releases.)
- Upon initial extraction, both executable files will be accessible, and in any case, the configuration tool for initial settings will be launched.
- In the subsequent stages, BackUpMaster.EXE will handle the backup functions, while Config.EXE will be utilized for modifying all settings, including enabling and disabling automatic system startup for backup.
- An alternative approach involves using batch files, although for convenience, it's simpler to utilize the executables, leaving the batch files for direct code manipulation when needed.
- The usage is intuitive and requires no additional explanations.

BackUpMaster offers versatile methods of usage, combining executable files with batch files for seamless and efficient control of backup settings.

## Module Logic and Interaction Overview:

**BackUpMaster.bat:**
This file orchestrates the general backup creation process.
It begins with console configuration and UTF-8 encoding settings.
The presence of the 7-Zip program is checked.
The existence of the configuration file is verified.
The `compression.bat` is invoked to perform the actual backup creation.

**check_7z.bat:**
This file checks for the presence of the 7-Zip program and configures its paths if it's installed.
It utilizes the `where` command to check for the availability of 7z in the system.
If 7z is not found, a specific path for 7-Zip is checked.
If the script is launched without administrator privileges, it elevates itself to administrator level.
The path to 7-Zip is added to the PATH environment variable.

**write_config.bat:**
This file creates or removes the BackUpMaster shortcut from autostart.
It elevates the script's access rights to administrator level.
It stores the current path to BackUpMaster and other settings.
It provides all the interaction with the user regarding the program settings.

**autorun.bat:**
This file automates the backup creation process.
It reads data from the configuration file.
It generates a backup file name based on the date and time.
It compresses files and creates a backup.
After a successful copy creation, it checks the number of stored copies and, if necessary, deletes old copies.

**compression.bat:**
This file performs the actual file compression and backup creation.
It reads data from the configuration file.
It compresses files into an archive using the 7-Zip program.
The result of copy creation is checked, and if successful, old copies are cleaned up according to the specified limit.

This modular approach ensures seamless interaction and organized execution of the various components of the BackUpMaster program.

## License:

BackUpMaster is released under the MIT License.

For more details, please refer to the full license text at:
[MIT License](https://github.com/sergeiown/BackUpMaster/blob/main/LICENSE)
