#!/bin/bash

cd /Volumes/SANDISK\ 8GB/;
find . -maxdepth 1 -type f -name ".*" -exec rm "{}" \;
