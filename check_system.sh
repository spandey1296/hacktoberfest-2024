#!/bin/bash

# Output file
OUTPUT_FILE="system_info.txt"

# Create or clear the output file
echo "System Information Report" > $OUTPUT_FILE
echo "=========================" >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

# Get system hostname
echo "Hostname: $(hostname)" >> $OUTPUT_FILE

# Get current date and time
echo "Date and Time: $(date)" >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

# Check disk usage
echo "Disk Usage:" >> $OUTPUT_FILE
df -h >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

# Get system memory information
echo "Memory Information:" >> $OUTPUT_FILE
free -h >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

# Get CPU information
echo "CPU Information:" >> $OUTPUT_FILE
lscpu >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

# Get OS information
echo "Operating System Information:" >> $OUTPUT_FILE
cat /etc/os-release >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

# Get list of installed packages (Debian/Ubuntu)
if command -v dpkg > /dev/null; then
    echo "Installed Packages:" >> $OUTPUT_FILE
    dpkg --get-selections >> $OUTPUT_FILE
    echo "" >> $OUTPUT_FILE
fi

# Get list of installed packages (RedHat/CentOS)
if command -v rpm > /dev/null; then
    echo "Installed Packages:" >> $OUTPUT_FILE
    rpm -qa >> $OUTPUT_FILE
    echo "" >> $OUTPUT_FILE
fi

# Completion message
echo "System information has been saved to $OUTPUT_FILE."
