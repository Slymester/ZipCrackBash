ZIPCrackBash v1.0

ZIPCrackBash is a Bash script designed to perform brute-force attacks on password-protected ZIP files. It generates permutations from an input file and tests each password until the correct one is found.

⚠️ This script is intended for legal and ethical use only, strictly within the context of authorized pentesting activities. Misuse of this tool is prohibited.
New in Version 1.0

This major update introduces several enhancements for a better user experience:

Enhanced User Introduction: A detailed and friendly welcome message explains the script's purpose and how to use it effectively. Includes an example of a correctly formatted input file.
Progress Tracking: Added a progress bar to visualize the script's advancement. This feature is only available when verbose (-v) or log options are not enabled.
Improved Output Display: Visual indicators clearly highlight when a password is found or a test fails, improving usability.
Code Refinements: Streamlined validations and performance improvements ensure smoother execution.

Features

Permutation Generation: Generates all possible combinations from columns in an input file.
Temporary File Management: Stores permutations in a temporary file for optimized processing.
Multi-Line Input Support: Reads user information (e.g., first names, last names, years) from a text file.
Verbose Mode: Displays tested passwords in real-time (-v flag).
Save Results: Option to save attempts and results in an external file (-s flag).
Input Validation: Handles empty lines, ignores duplicates, and limits the number of analyzed columns.
Friendly Interactive Prompts: When not provided in the command line, the script asks for necessary inputs.

Prerequisites

Operating System: Linux or any Bash-compatible environment.
Required Tools:
    unzip: Used to test passwords against the ZIP archive.

Installation

Clone this repository to your local machine:
'''bash
git clone https://github.com/Slymester/ZIPCrackBash.git  


Make the script executable:

chmod +x ZIPCrackBash.sh  


Usage
Syntax

./ZCB.sh [-v] [-s save_file.txt] [input_file.txt] [archive.zip]  


Options

    -t    input_file.txt : Input file containing users informations (max 5 words per line).
    -z    archive.zip: Target ZIP archive to crack.
    -s    save_file.txt : Saves tested passwords and statistics to a specified text file (optional).
    -v    Verbose mode, displays passwords being tested (optional).
    -o    Output log file to store the results (optional).
    -d    Enable debug mode for detailed logs (optional).
    -h    Display this help message.


Example Execution

    With all arguments:

./ZCB.sh -v -s attempts.log -t users.txt -z archive.zip -d -h  


Interactive mode:

    ./ZCB.sh  
    What is the name of the file containing users information? users.txt  
    What is the name of the ZIP file to crack? archive.zip  


Example Input File (users.txt)

Each line represents a user with details separated by spaces:

John Smith 1984  
Alice Brown 2020  
Mark Lee ML59 

The script generates all possible permutations from these inputs, e.g.:

    John
    Smith
    1984
    JohnSmith
    SmithJohn
    Smith1984John
    ...


Results

    Password Found: A clear success message is displayed with visual indicators.
    Password Not Found: Displays Password not found. Process completed.


Cleaning Up

The script creates a temporary file for storing permutations, which is automatically deleted after execution.
Limitations

    Input Columns: Limited to 5 words per line to avoid excessive permutations.
    Input File Format: Must contain alphanumeric characters separated by spaces.


Future Plans

The next version will expand functionality to support other archive types (e.g., RAR, 7z), adding flexibility for pentesters.


Legal Disclaimer

This tool is strictly for authorized penetration testing and educational purposes. Unauthorized use is illegal and punishable by law. Always obtain proper permissions before testing.


Contributing

Contributions are welcome!
