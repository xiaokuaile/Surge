#!/usr/bin/env bash

set -uo pipefail

repository_root=$(git rev-parse --show-toplevel)
cd "$repository_root"

source_table="Ruleset/Mirror/sources.tsv"
temporary_dir=$(mktemp -d)
trap 'rm -rf "$temporary_dir"' EXIT

updated_count=0
failure_count=0

while IFS=$'\t' read -r rule_file policy source_url original_url note; do
  if [[ "$rule_file" == "file" ]]; then
    continue
  fi

  if [[ -z "$rule_file" || "$rule_file" == */* || "$rule_file" == *..* ]]; then
    echo "跳过不安全的文件名：$rule_file"
    failure_count=$((failure_count + 1))
    continue
  fi

  temporary_file="$temporary_dir/$rule_file"
  destination_file="Ruleset/Mirror/$rule_file"

  if ! curl --fail --location --silent --show-error \
    --retry 3 --retry-delay 2 --connect-timeout 20 --max-time 120 \
    "$source_url" -o "$temporary_file"; then
    echo "下载失败，保留旧副本：$rule_file"
    failure_count=$((failure_count + 1))
    continue
  fi

  if [[ ! -s "$temporary_file" ]] || grep -Eiq '<!doctype|<html|<body' "$temporary_file"; then
    echo "内容无效，保留旧副本：$rule_file"
    failure_count=$((failure_count + 1))
    continue
  fi

  first_rule=$(awk '!/^[[:space:]]*(#|$)/ { print; exit }' "$temporary_file")
  if ! printf '%s\n' "$first_rule" | grep -Eq '^(DOMAIN|DOMAIN-SUFFIX|DOMAIN-KEYWORD|DOMAIN-REGEX|IP-CIDR|IP-CIDR6|IP-ASN|PROCESS-NAME|USER-AGENT|URL-REGEX|DEST-PORT|SRC-IP|PROTOCOL|GEOIP|AND|OR|NOT),'; then
    echo "不像规则列表，保留旧副本：$rule_file"
    failure_count=$((failure_count + 1))
    continue
  fi

  if cmp -s "$temporary_file" "$destination_file"; then
    echo "没有变化：$rule_file"
    continue
  fi

  mv "$temporary_file" "$destination_file"
  echo "已更新：$rule_file"
  updated_count=$((updated_count + 1))
done < "$source_table"

echo "同步完成：更新 $updated_count 个，失败并保留旧副本 $failure_count 个。"
