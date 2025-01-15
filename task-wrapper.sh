#!/bin/bash

# Check if go-task is available
if command -v go-task &> /dev/null
then
    go-task "$@"
# Check if task is available
elif command -v task &> /dev/null
then
    task "$@"
else
    echo "Neither go-task nor task is installed."
    exit 1
fi