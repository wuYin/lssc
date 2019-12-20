#!/bin/bash

# simulate time cmds

start=$(date +%s)
sleep 2
end=$(date +%s)
diff=$((end - start))
echo "time take $diff"
