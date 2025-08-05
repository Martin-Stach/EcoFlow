#!/bin/bash

# Load environment variables from .env file
if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "Error: .env file not found. Please copy .env.example to .env and add your credentials."
    exit 1
fi

# Function to show usage
show_help() {
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  get      - Get current device settings (default)"
    echo "  set      - Set device settings"
    echo "  help     - Show this help"
    echo ""
    echo "Examples:"
    echo "  $0           # Get current settings"
    echo "  $0 get       # Get current settings"
    echo "  $0 set       # Set device settings"
}

# Get command (default to 'get')
COMMAND=${1:-get}

case $COMMAND in
    "get")
        echo "Getting current device settings..."
        curl -X GET "https://api.ecoflow.com/iot-open/sign/device/quota" \
          -H "accessKey: $ACCESS_KEY" \
          -H "timestamp: $(date +%s)" \
          -H "Content-Type: application/json" \
          -d "{\"sn\": \"$DEVICE_SERIAL\"}"
        ;;
    
    "set")
        echo "Setting device configuration..."
        # Example setting - you'll need to adjust the endpoint and data based on EcoFlow API docs
        curl -X POST "https://api.ecoflow.com/iot-open/sign/device/settings" \
          -H "accessKey: $ACCESS_KEY" \
          -H "timestamp: $(date +%s)" \
          -H "Content-Type: application/json" \
          -d "{\"sn\": \"$DEVICE_SERIAL\", \"settings\": {\"example\": \"value\"}}"
        ;;
    
    "help"|"-h"|"--help")
        show_help
        exit 0
        ;;
    
    *)
        echo "Error: Unknown command '$COMMAND'"
        echo ""
        show_help
        exit 1
        ;;
esac

echo ""