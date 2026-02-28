#!/bin/sh

HOST=pi
SESSION_NAME=pine_serial
DEVICE=/dev/ttyUSB0
BAUDRATE=115200

ssh -t $HOST "screen -r $SESSION_NAME || screen -S $SESSION_NAME $DEVICE $BAUDRATE"
