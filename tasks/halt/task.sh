#!/bin/bash -e

echo "The train is stopping at ${station} for ${stopover_time}s."
sleep "${stopover_time}"
echo "The train is now leaving ${station}."
