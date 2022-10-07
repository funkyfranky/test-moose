#/bin/bash

for i in `find . -type f -name "*.img" -o -name "*.bin" -o -name "*.txt"`;
do
  echo "$i"
done
