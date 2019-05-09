#!/bin/bash
cp *tif data/Original
for i in {1..3}
do
./Multimap $1
done
