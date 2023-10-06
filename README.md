# [BackUpMaster](https://github.com/sergeiown/BackUpMaster/releases/tag/Final_version)

BackUpMaster is more than just a data compression tool - it's a solution for automated and secure backup. It combines user-friendliness with powerful capabilities, helping safeguard critical information reliably.

## Features and Capabilities

- **Executable Files for Ease:** The program comes with [executable (.exe)](https://github.com/sergeiown/BackUpMaster/releases) installation file that simplifies the installation and launch of the program processes.
- **Multilingual support** Automatically selects from three available languages: EN, UK, RU.
- **Configuration Flexibility:** Convenient configuration via `config.ini` with a separate configurator for super convenient changes allows you to customize paths, compression level, excluded file extensions, number of saved copies and more.
- **Automatic Startup:** The option for BackUpMaster to launch during system startup ensures continuous backup operations.
- **Copy Management:** Automatic management of backup copies, allowing to retain only the necessary number of copies and remove outdated ones.
- **Exclusion of File Extensions:** The ability to exclude specific file extensions from the compression process provides greater control over the content of backup copies.
- **Logging and Notifications:** Generating log files for each copy process allows you to track the results and receive notifications of success or failure. Two types of log files are available: general and last operation logs, which allows you to fine-tune all aspects of the backup process.
- **Graphical Interface:** Through the command-line interface and graphical user interface, you can conveniently interact with the program.
- **Individual Path Settings:** The capability to specify paths to backup and storage folders ensures tool flexibility.
- **Configuration Editor:** A separate configuration editor file is provided, making it even more convenient to manage and fine-tune your backup settings.

![image](https://github.com/sergeiown/BackUpMaster/assets/112722061/33085149-33b7-4ef4-8576-6d1d7f564722)

## Usage

- The main method is to use installation file: [executable (.exe)](https://github.com/sergeiown/BackUpMaster/releases)
- An alternative approach involves using batch files.
- The usage is intuitive and requires no additional explanations.

BackUpMaster offers versatile methods of usage, combining executable files with batch files for seamless and efficient control of backup settings.

## Module Logic and Interaction Overview

- **BackUpMaster.bat :**  
This file orchestrates the general backup creation process.
It begins with console configuration and UTF-8 encoding settings.
The presence of the 7-Zip program is checked.
The existence of the configuration file is verified.
The `compression.bat` is invoked to perform the actual backup creation.
- **language.bat :**  
This script automatically selects the language based on the system locale and then uses the universal UTF-8 code. It first retrieves the system's locale using wmic os get locale and then checks for specific locale codes. After setting the correct file name, it changes the console code page to 65001 (UTF-8) and clears the screen.
The script then uses the external files to load the messages. Each message is stored in a variable named after the message name.
- **config.bat :**  
This file checks for the presence of the 7-Zip program and configures paths to it if it is installed.
If 7z is not found, a warning is issued and a download offer is made.
It stores the current path to BackUpMaster and other settings.
It provides all the interaction with the user regarding the program settings.
- **autorun.bat :**  
If the script is run without administrator privileges, it elevates itself to administrator level.
This file also creates or removes the BackUpMaster shortcut from autostart.
- **compression.bat :**  
This file performs the actual file compression and backup creation.
It reads data from the configuration file.
It generates a backup file name based on the date and time.
It compresses files into an archive using the 7-Zip program.
The result of copy creation is checked, and if successful, old copies are cleaned up according to the specified limit.

This modular solution ensures uninterrupted interaction and organized execution of various components of the BackUpMaster program.

## License

BackUpMaster is released under the MIT License.

For more details, please refer to the full license text at:
[MIT License](https://github.com/sergeiown/BackUpMaster/blob/main/LICENSE)
