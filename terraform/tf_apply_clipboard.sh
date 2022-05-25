#!/bin/bash
usage() {     
  scriptname=`basename $0`  
  echo "Usage: copy block of codes and run: $scriptname" 1>&2 
  echo "Apply terraform based on clipboard"
}
TF_TARGET=`echo -e "$(pbpaste)" | awk '{gsub(/\./," ",$0); print $0}' | awk '{gsub(/^[ \t]*#+/,"",$0);print $0}' | awk -F'#' '$1 ~ /^[[:space:]]*(module|resource)[[:space:]]+/ {gsub(/\x22/,"",$1);gsub(/^[[:space:]]*(resource)?[[:space:]]*/,"",$1);print $1}' | awk '{print " -target " $1"."$2 " \\\ "}' `
TFC=$(echo -e "$TF_TARGET" | sort -u | tr '\n' '#' | awk '{gsub(/\\([[:space:]]*\x23[[:space:]]*)*$/,"",$0);print $0}' | awk ' {gsub(/\\#[[:space:]]*$/,"",$0);print $0}' | tr '#' '\n' | awk '$0 !~ /^[[:space:]]*$/ {gsub(/^[[:space:]]*/,"    ",$0);gsub(/[[:space:]]*$/,"",$0);print $0}')
echo "tfa \\"
if [ -n "$TFC" ]; then
    echo -e "$TFC"
    sleep 1
    eval "terraform apply $TFC"
    echo "tfa \\"
    echo -e "$TFC"
fi;
#echo -e "$TFC"