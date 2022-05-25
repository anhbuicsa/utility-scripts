 #!/bin/bash
#check RAM usage and CPU usage

usage() {                                      # Function: Print a help message.
  scriptname=`basename $0`
  echo -e "Usage:\n    - $scriptname [ -n NAMESPACE ] [-l spark-role=executor,spark-app-selector=spark-application ]" 1>&2
  echo "    - $scriptname - to list all namespaces"
  echo "    - $scriptname default - to list in default namespace"

}
FLAG_1=$1
FLAG_2=$2
FLAG_3=$3
FLAG_4=$4
FLAG="-A"
if [ -n "$FLAG_1" ]; then
  if [ "$FLAG_1" != "-n" ] && [  "$FLAG_1" != "-l" ]; then 
    usage;
    echo "exit 1"
    exit;
  fi;
  if [ -z "$FLAG_2" ]; then 
    usage;
    echo "exit 2"
    exit;
  fi;
  if [ -n "$FLAG_3" ] && [ -z "$FLAG_4" ]; then 
    usage;
    echo "exit 3"
    exit;
  fi;

  if [ "$FLAG_1" -eq "$FLAG_3" ]; then
    echo "duplicate Flags FLAG_1  $FLAG_1 FLAG_3 $FLAG_3"
    usage;
    echo "exit 4"
    exit;
  fi;
  if  [ -n "$FLAG_3" ] && [ "$FLAG_3" != "-n" ] && [  "$FLAG_3" != "-l" ]; then 
    usage;
    echo "exit 5"
    exit;
  fi;
  FLAG="$FLAG_1 $FLAG_2 $FLAG_3 $FLAG_4"
  if [ "$FLAG_1" == "-l" ] && [ -z "$FLAG_3" ]; then
     FLAG="$FLAG_1 $FLAG_2 -A"
  fi;

fi;
FLAG=`echo "$FLAG" | awk '{gsub(/^[ \t]*$/,"",$0); print $0}'`

echo kubectl top pods $FLAG --sort-by=memory --no-headers
 Resource_usage=`kubectl top pods $FLAG --sort-by=memory`
 echo -e "$Resource_usage"
 Boundarys="-----------------------------------------------------------------------------------"
 #echo "$Boundarys"
 RUSAGES=`echo -e "$Resource_usage" | sed 1d`
 #echo -e "$RUSAGES"
 echo "$Boundarys"
 echo -e "$RUSAGES" |awk '{print $3}'| awk '$0 !~ /null/ {\
 gsub(/\x22/,"",$0);NPR=NPR+1;
 if(tolower($0) ~ /gi/){gsub(/[Gg]i/,"",$0);$0=$0*1024}; \
 if(tolower($0) ~ /g/){gsub(/[Gg]/,"",$0);$0=$0*1000}; \
 gsub(/m/,"",$0);s+=$0;};\
 END {print "CPU usage: " s "mCPU/" s/NPR " total pods: " NPR}'
 echo -e "$RUSAGES" |awk '{print $4}'| awk '$0 !~ /null/ {\
   gsub(/\x22/,"",$0); \
   if(tolower($0) ~ /gi/){gsub(/[Gg]i/,"",$0);$0=$0*1024}; \
   if(tolower($0) ~ /g/){gsub(/[Gg]/,"",$0);$0=$0*1000}; \
   if(tolower($0) ~ /mi/){gsub(/[Mm]i/,"",$0);$0=$0*1.048576}; \
   if(tolower($0) ~ /ki/){gsub(/[Kk]i/,"",$0);$0=$0*1.048576/1024}; \
   gsub(/M/,"",$0); s+=$0;NPR=NPR+1};\
 END {print "RAM usage: " s "MB/" s/NPR " total pods: " NPR}'
 echo "$Boundarys"
echo kubectl get pods $FLAG -o json 
 CPODS=`kubectl get pods $FLAG -o json | tr '\r\n' ' '`
 CPUrs=`echo "$CPODS" |  jq '.items[].spec.containers[].resources.requests.cpu' | awk '$0 !~ /null/ {\
 gsub(/\x22/,"",$0);NPR=NPR+1;
 if(tolower($0) ~ /gi/){gsub(/[Gg]i/,"",$0);$0=$0*1024}; \
 if(tolower($0) ~ /g/){gsub(/[Gg]/,"",$0);$0=$0*1000}; \
 gsub(/m/,"",$0);$0=$0+0;s+=$0;maxr=$0>maxr?$0:maxr};\
 END {print "CPU requests: " s "m/" s/NPR }'`
 MEMrs=`echo "$CPODS" |  jq '.items[].spec.containers[].resources.requests.memory' | awk '$0 !~ /null/ {\
   gsub(/\x22/,"",$0); \
   if(tolower($0) !~ /(ki|mi|g|gi)/){$0=$0/(1024*1024)}; \
   if(tolower($0) ~ /gi/){gsub(/[Gg]i/,"",$0);$0=$0*1024}; \
   if(tolower($0) ~ /g/){gsub(/[Gg]/,"",$0);$0=$0*1000}; \
   if(tolower($0) ~ /mi/){gsub(/[Mm]i/,"",$0);$0=$0*1.048576}; \
   if(tolower($0) ~ /ki/){gsub(/[Kk]i/,"",$0);$0=$0*1.048576/1024}; \
   gsub(/M/,"",$0);$0=$0+0; s+=$0;NPR=NPR+1;maxr=$0>maxr?$0:maxr};\
 END {print "RAM requests: " s "MB/" s/NPR }'`
 echo "$CPUrs"
 echo "$MEMrs"
CPUrs=`echo "$CPUrs" | awk '{print $3}'`
echo "$MEMrs" | awk '{print "RAM/CPU:     " $3/'"$CPUrs"'}'
echo ""
ASYSTEM_PODS=`kubectl get pods $FLAG --no-headers | awk '$4 !~ /Completed/ {print $0}'`
KSYSTEM_PODS=`echo "$ASYSTEM_PODS" | awk '$1 ~ /^kube-system$/ {print $2}' | wc -l`
NSYSTEM_PODS=`echo "$ASYSTEM_PODS" | awk '$1 !~ /^kube-system$/ {print $2}' | wc -l`
ALLSYSTEM_PODS=`echo "$ASYSTEM_PODS" | wc -l`
echo -e "System_PODS: $KSYSTEM_PODS\nApplication_PODS: $NSYSTEM_PODS\nAll_PODS: $ALLSYSTEM_PODS" | column -t -s ' '
echo "Be careful with Completed and Crashloopback pods"
echo "$Boundarys"
CPODS=`echo "$CPODS" | jq -rc '.items[]|{name:.metadata.name,cpu:(.spec.containers[].resources.requests.cpu) , ram:(.spec.containers[].resources.requests.memory)}' | awk '{print substr($0, 2, length($0) - 2)}' | awk '{gsub(/\x22/,"",$0);gsub(/\x2C/,":",$0);print $0}' | awk -F':' '{print $2" "$4" "$6}' | awk '{if($2 ~ /^[[:space:]]*$/){$2=0};if($3 ~ /^[[:space:]]*$/){$3=0}; print $0}' | awk '$0 !~ /[[:space:]]0[[:space:]]+0$/'`
CPUrs=`echo "$CPODS" | awk '{\
 gsub(/\x22/,"",$2);
 if(tolower($2) ~ /gi/){gsub(/[Gg]i/,"",$2);$2=$2*1024}; \
 if(tolower($2) ~ /g/){gsub(/[Gg]/,"",$2);$2=$2*1000}; \
 gsub(/m/,"",$2);$2=$2+0;  print $0}'`
MEMCPUrs=`echo "$CPUrs" | awk '{\
   gsub(/\x22/,"",$3); 
   if(tolower($3) !~ /(ki|mi|g|gi)/){$3=$3/(1024*1024)}; \
   if(tolower($3) ~ /gi/){gsub(/[Gg]i/,"",$3);$3=$3*1024}; \
   if(tolower($3) ~ /g/){gsub(/[Gg]/,"",$3);$3=$3*1000}; \
   if(tolower($3) ~ /mi/){gsub(/[Mm]i/,"",$3);$3=$3*1.048576}; \
   if(tolower($3) ~ /ki/){gsub(/[Kk]i/,"",$3);$3=$3*1.048576/1024}; \
   gsub(/M/,"",$3);$3=$3+0; print $0}' `
echo "Top 10 Pod's Memory Requests: (mCPU,MB)"
MEMrs=`echo "$MEMCPUrs" | sort -rnk3 | head -n15`
echo -e "Units mCPU MB\n$MEMrs" | column -t -s' '
echo "$Boundarys"
echo "Top 10 Pod's CPU Requests: (mCPU,MB)"
CPUrs=`echo "$MEMCPUrs" | sort -rnk2 | head -n15`
echo -e "Units mCPU MB\n$CPUrs" | column -t -s' '
echo "$Boundarys"
echo "Done"

