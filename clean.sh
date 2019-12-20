#!/bin/bash

find . \( -iname "tmp*" -o -iname "*.html" \) -exec rm -rf {} \;
