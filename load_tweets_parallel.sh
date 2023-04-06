#!/bin/sh

files=$(find data/*)

echo '================================================================================'
echo 'load pg_denormalized'
echo '================================================================================'
echo "$files" | time parallel sh load_denormalized.sh
    #time unzip -p "$file" | sed 's/\\u0000//g' | psql postgresql://postgres:pass@localhost:3269/ -c "COPY tweets_jsonb (data) FROM STDIN csv quote e'\x01' delimiter e'\x02';"

echo '================================================================================'
echo 'load pg_normalized'
echo '================================================================================'
echo "$files" | time parallel python3 -u load_tweets.py --db=postgresql://postgres:pass@localhost:6996/ --inputs

echo '================================================================================'
echo 'load pg_normalized_batch'
echo '================================================================================'
echo "$files" | time parallel python3 -u load_tweets_batch.py --db=postgresql://postgres:pass@localhost:9669/ --inputs
