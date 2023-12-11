#!/bin/bash

IP_ADDRESS="your_target_ip"
INTERFACE="your_network_interface"
CAPTURE_FILE="capture.pcap"
PACKET_LOSS_THRESHOLD=5  # Adjust the threshold as needed

# Function to capture packets using tcpdump
capture_packets() {
    sudo tcpdump -i $INTERFACE -w $CAPTURE_FILE host $IP_ADDRESS
}

# Monitor the ping command for packet loss
ping -i 1 $IP_ADDRESS | while read line; do
    packet_loss=$(echo $line | grep -oP '\d+(?=% packet loss)')
    if [ ! -z "$packet_loss" ]; then
        if [ "$packet_loss" -ge "$PACKET_LOSS_THRESHOLD" ]; then
            echo "Packet loss detected: $packet_loss%"
            capture_packets
            exit 0
        fi
    fi
done
