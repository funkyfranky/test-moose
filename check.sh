#/bin/bash

for i in `find . -type f -name "*.miz" -exec echo \{\} \`;
do
  echo "$i"
done
