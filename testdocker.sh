#!/bin/bash

docker run \
    --rm \
    -ti --privileged -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix fsluser/fsl \
    --mount type=bind,source=/Users/frederic/code/rapidtide/rapidtide/data/examples,destination=/data \
    -it ukbb-pipeline:latest \
    bash

