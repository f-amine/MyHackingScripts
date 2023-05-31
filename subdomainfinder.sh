#!/bin/bash

while getopts ":d:" opt; do
  case $opt in
    d)
      file=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [ -z "$file" ]; then
  echo "Please provide a file with domain names using the -d option."
  exit 1
fi

while read -r domain; do
  amass enum -passive -src -d "$domain" -o "${domain%.*}"
  grep -o '[^ ]*\.'"$domain" "${domain%.*}" | httprobe > httprobe/"${domain%.*}"
  cat httprobe/"${domain%.*}"
done < "$file"