#!/bin/bash

#name of downloaded file
INFILE=$1

ean=$(cut -d "-" -f 1 <<< $1)

#gets ean from dowloaded file
echo $ean

#NAME
cat $INFILE | grep -A1 -m1 "<h1 class='page-header'>" | tail -1

#BRAND
cat $INFILE | grep -A3 -m2 "Marca:" | tail -1 | cut -d ">" -f2 

#CATEGORY
cat $INFILE | grep -A3 -m1 "Categoria (GPC):" | tail -1 | cut -d ">" -f2

#PESO BRUTO
cat $INFILE | grep -A3 -m1 "Peso Bruto:" | tail -1 | cut -d ">" -f2

#PESO LIQUIDO
cat $INFILE | grep -A3 -m1 "Peso Líquido:" | tail -1 | cut -d ">" -f2

#PREÇO MÉDIO
cat $INFILE | grep -A3 -m1 "o Médio:" | tail -1 | cut -d ">" -f2

