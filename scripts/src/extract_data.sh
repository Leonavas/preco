#!/bin/bash
while read p; do
  /home/leonavas/projects/pers/preco/scripts/src/page_extrator.sh $p
done < /home/leonavas/projects/pers/preco/scripts/src/ean.csv
