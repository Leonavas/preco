#!/bin/bash

#name of downloaded file
INFILE=$1

HOME_DIR=/home/leonavas/projects/pers/preco/scripts/src


if [ $# -lt 2 ];then
    echo -e "Usage: ./page_extractor <INFILE> <CONFIG FILE>"
    exit 1
else
    CONF=$2
fi

LOG4SH_PROPERTIES=$(cat $CONF | grep log4sh_properties | awk '{ if ($1 == "log4sh_properties") print $2}' FS=\=)

# load log4sh
if [ -r $HOME_DIR/config/log4sh/log4sh ]; then
  LOG4SH_CONFIGURATION=$LOG4SH_PROPERTIES . $HOME_DIR/config/log4sh/log4sh
else
  echo "ERROR: could not load (log4sh)" >&2
  exit 1
fi

# change the default message level from ERROR to INFO
logger_setLevel DEBUG

logger_info "Started extracting data from "$INFILE
#gets ean from dowloaded file
ean=$(cut -d "-" -f 1 <<< $1)

#NAME
name=$(cat $INFILE | grep -A1 -m1 "<h1 class='page-header'>" | tail -1)

#BRAND
brand=$(cat $INFILE | grep -A3 -m2 "Marca:" | tail -1 | cut -d ">" -f2)

#CATEGORY
category=$(cat $INFILE | grep -A3 -m1 "Categoria (GPC):" | tail -1 | cut -d ">" -f2)

#PESO BRUTO
gross_weight=$(cat $INFILE | grep -A3 -m1 "Peso Bruto:" | tail -1 | cut -d ">" -f2)

#PESO LIQUIDO
net_weight=$(cat $INFILE | grep -A3 -m1 "Peso Líquido:" | tail -1 | cut -d ">" -f2)

#PREÇO MÉDIO
medium_price=$(cat $INFILE | grep -A3 -m1 "o Médio:" | tail -1 | cut -d ">" -f2)

#IMG
img=$(cat $INFILE | grep "id=\"main-thumbnail\"" | cut -d "=" -f7 | cut -d "\"" -f2)
if [[ $img == *"product-placeholder"* ]]; then
    unset img
fi

echo $ean";"$name";"$category";"$medium_price";"$brand";"$gross_weight";"$net_weight";"$img