#/bin/bash

for i in `find . -type f -name "*.miz" -print0`;
do
  echo "$i"
done
