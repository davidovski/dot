#!/bin/sh
ssh -NnT -o ExitOnForwardFailure=yes -L 6022:localhost:6022 ion &
sleep 1
#rsync -e 'ssh -p 6022' --delete -ravP "david@localhost:music/$1/" "$HOME/music/$1/" 
rsync -e 'ssh -p 6022' -ravP "music/$1/" "david@localhost:music/$1/" 
