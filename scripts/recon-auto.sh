#!/bin/bash

# ============================
#  RECON AUTOMATION SCRIPT
# ============================

INPUT_FILE="../input/domains.txt"
OUTPUT_SUB="../output/all-subdomains.txt"
OUTPUT_LIVE="../output/live.txt"

LOG_PROGRESS="../logs/progress.log"
LOG_ERROR="../logs/errors.log"

timestamp() {
    date "+%Y-%m-%d %H:%M:%S"
}

echo "[$(timestamp)] Starting recon..." | tee -a $LOG_PROGRESS

# Check input file
if [[ ! -f "$INPUT_FILE" ]]; then
    echo "[$(timestamp)] ERROR: input file not found!" | tee -a $LOG_ERROR
    exit 1
fi

# Clear previous outputs
> $OUTPUT_SUB
> $OUTPUT_LIVE

while read domain; do
    echo "[$(timestamp)] Enumerating subdomains for $domain" | tee -a $LOG_PROGRESS

    # Example: using assetfinder
    assetfinder "$domain" 2>> $LOG_ERROR | anew $OUTPUT_SUB

done < "$INPUT_FILE"

echo "[$(timestamp)] Finding live hosts..." | tee -a $LOG_PROGRESS

# Check live hosts using httpx
cat $OUTPUT_SUB | httpx -silent 2>> $LOG_ERROR | anew $OUTPUT_LIVE

# Summary
TOTAL_SUB=$(wc -l < $OUTPUT_SUB)
TOTAL_LIVE=$(wc -l < $OUTPUT_LIVE)

echo "=============================="
echo " Recon Finished"
echo " Unique Subdomains: $TOTAL_SUB"
echo " Live Hosts: $TOTAL_LIVE"
echo "=============================="

echo "[$(timestamp)] Recon completed." | tee -a $LOG_PROGRESS
