#!/bin/bash

# Files needed
pwd=`pwd`
. $pwd/unifi-api.sh

# Generation settings
if [ -n "$1" ]; then
  time=$1 # Voucher time limit (minutes)
else
  time=60 # Voucher time limit (minutes)
fi
if [ -n "$2" ]; then
  amount=$2 # New vouchers to generate
else
  amount=10 # New vouchers to generate
fi
# So by the two if statements above, without providing 2 arguments required when generating vouchers, the script generates 10 vouchers each lasting 60 minutes

#Necessary to format in hours as the display is {24,72.96} hours
line2="$(($time/60))"

# Generate vouchers
unifi_login
voucherID=`unifi_create_voucher $time $amount $note`
unifi_get_vouchers $voucherID > vouchers.tmp
unifi_logout

vouchers=`awk -F"[,:]" '{for(i=1;i<=NF;i++){if($i~/code\042/){print $(i+1)} } }' vouchers.tmp | sed 's/\"//g'`

# Build HTML
if [ -e vouchers.csv ]; then
  echo "Removing old vouchers."
  rm vouchers.csv
fi

#necessary columns for db insertion
echo "_id","hours" >> vouchers.csv

for code in $vouchers
do
    line3=${code:0:5}" "${code:5:10}
    values=$line3','$line2
   
    echo $values >> vouchers.csv
done



# Remove tmp
if [ -e vouchers.tmp ]; then
  echo "Removing vouchers tmp file."
  rm vouchers.tmp
fi
