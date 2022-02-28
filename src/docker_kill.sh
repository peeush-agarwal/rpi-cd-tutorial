#!/bin/sh
ids=$(docker ps -q --filter "name=rpi-cd-tutorial")
for id in $ids
    do
    echo "$id"
    docker kill $id
    done
