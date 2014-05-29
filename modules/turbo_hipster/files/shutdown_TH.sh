#!/bin/bash
# Check if TH is still running otherwise shut down the node

# Check to see if turbo-hipster has ever started. The debug log should exist
# if it has.
if [[ ! -f /var/log/turbo-hipster/debug.log ]]; then
    echo "No debug.log found. Assuming TH didn't start so we won't exit yet"
    exit;
fi

# Check to make sure turbo-hipster isn't being set up still
if pidof -x start_TH_service.sh > /dev/null; then
    echo "Turbo-hipster still being set up. Won't exit yet."
    exit;
fi

# Check to see if turbo-hipster is still running
if pidof -x turbo-hipster > /dev/null; then
    echo "Turbo-hipster still running. Won't exit yet".
    exit;
fi

echo "Shutting down node because we can't see TH running"
shutdown -h now
