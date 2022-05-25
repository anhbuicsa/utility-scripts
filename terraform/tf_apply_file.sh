
#!/bin/bash
usage() {     
  scriptname=`basename $0`  
  echo "Usage: $scriptname  [<file 1>.tf] [<file 2>.tf]" 1>&2 
  echo "Plan Apply based on file name"

}
args=`echo "$@"`
TF_TARGETS=""
if [ -n "$args" ]; then 
  for var in $args; do
    if [[ $var =~ .*".tf" ]]; then
      TF_TARGET=`awk '{gsub(/^[ \t]*#+/,"",$0);print $0}' $var  | awk -F'#' '$1 ~ /^[[:space:]]*(module|resource)[[:space:]]+/ {gsub(/\x22/,"",$1);gsub(/^[[:space:]]*(resource)?[[:space:]]*/,"",$1);print $1}' | awk '{print " -target " $1"."$2 " \\\ "}' `
      TF_TARGETS=`echo -e "$TF_TARGETS \\\n $TF_TARGET"`
    fi
  done
  if [ -n "$TF_TARGETS" ]; then
    TF_TARGETS=$(echo -e "$TF_TARGETS" | sort -u | tr '\n' '#' | awk '{gsub(/\\([[:space:]]*\x23[[:space:]]*)*$/,"",$0);print $0}' | awk ' {gsub(/#[[:space:]]*$/,"",$0);print $0}' | tr '#' '\n' | awk '$0 !~ /^[[:space:]]*$/ {gsub(/^[[:space:]]*/,"    ",$0);gsub(/[[:space:]]*$/,"",$0);print $0}')  
    echo ""
    echo "tfa \\"
    echo -e "$TF_TARGETS"
    sleep 1
    eval "terraform apply $TF_TARGETS"

  fi;

fi;