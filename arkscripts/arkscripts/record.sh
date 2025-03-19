#!/usr/bin/env sh

# Record Screen Script.


set -e # To Exit the script if any error happen

############
## COLORS ##
############
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

##################
## LOG FUNCTION ##
##################
log_info() {
    echo -e "${BLUE}[INFO]${RESET} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${RESET} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${RESET} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${RESET} $1"
}


# Start

DEFAULT_OUTPUT="$HOME/Videos/recording_$(date +'%Y-%m-%d_%H-%M-%S').mkv"
log_info "Specify the output file (Press Enter for default: $DEFAULT_OUTPUT): " OUTPUT
read -r OUTPUT
OUTPUT=${OUTPUT:-$DEFAULT_OUTPUT}



log_info "Starting record, press Ctrl + C to end record"
wf-recorder -f "$OUTPUT"
trap 'log_warning "Recording stopped. File saved as $OUTPUT"; exit' INT
