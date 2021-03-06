#! /bin/bash

function build_dir {
    DIR="$1"
    pushd $DIR
    rsync -rv ../_layouts/ ./_layouts/
    rm -rf _book
    gitbook init
    gitbook install
    gitbook build
    popd
}
build_dir java8
build_dir home

TARGET_DIR=docs

mkdir ${TARGET_DIR}
rm -rf ${TARGET_DIR}/!\(CNAME\)

cp -r ./home/_book/* ${TARGET_DIR}/

mkdir ${TARGET_DIR}/java8/
cp -r ./java8/_book/* ${TARGET_DIR}/java8/

