#!/bin/bash
echo "Insert your name that will be used to create a directory: "
read name
mkdir "submission_reminder_$name"
cd submission_reminder_$name
mkdir app modules assets config
touch app/reminder.sh modules/functions.sh assets/submissions.txt config/config.env startup.sh

cat <<EOL > app/reminder.sh
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOL

cat <<EOL > modules/functions.sh
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOL

cat <<EOL > assets/submissions.txt
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Happy, Python, submitted
Olga, DSA, not submitted
Elliot, Arts, submitted
Rachette, Shell Advanced, not submitted
Christille, English, submitted
EOL

cat <<EOL > config/config.env
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOL

cat <<EOL > startup.sh
#!/bin/bash
# This script starts the reminder app
echo "Starting the Submission Reminder App..."
echo "________________________________________________"
bash app/reminder.sh
EOL

chmod +x startup.sh
chmod +x app/reminder.sh
chmod +x modules/functions.sh
chmod +x config/config.env
echo "Environment setup is complete!"
