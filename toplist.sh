#!/bin/bash

# Print a toplist given the keystats.json file
jq . ~/keystats.json |grep '"'|sed 's/  "\([^"]*\)": \([0-9]*\)/\2 \1/'|sort -gr
