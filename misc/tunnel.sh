#!/bin/sh

while true; do
    echo "digging a tunnel..."
    /usr/bin/ssh -NT -i /home/david/.ssh/ovski_rsa -p 4522 \
        -R 5069:localhost:5069 \
        -R 6680:localhost:6680 \
        -R 2022:localhost:22 \
        vski@86.10.87.187
done
