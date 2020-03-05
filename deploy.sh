#! /bin/bash
./build.sh
coscmd delete -r /
coscmd upload -rs docs/ /
