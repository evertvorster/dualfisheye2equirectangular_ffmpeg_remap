#!/bin/bash
cp *tif Original
for i in {1..3}
do
./Multimap $1
done
