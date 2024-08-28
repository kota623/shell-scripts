#!/bin/bash

# Determine script's own directory
SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

# Load environment variables from .env file in the script's directory
if [ -f "${SCRIPT_DIR}/.env" ]; then
  export $(grep -v '^#' "${SCRIPT_DIR}/.env" | xargs)
else
  echo "No .env file found in the script's directory. Please create one with appropriate values."
  exit 1
fi

options=( $(docker ps --format "{{.ID}}:{{.Names}}" | grep db) )
options=$(printf '%s\n' "${options[@]}")
selected=$(echo -e "dumpをインポートするコンテナを選択してください:\n$options" | fzf)

# Early return when no container is selected
if [ -z "$selected" ]; then
  echo "コンテナが選択されませんでした。"
  exit 1
fi

IFS=':' read -r selected_id selected_name <<< "$selected"
echo "'$selected_name'(ID: $selected_id)"

db_list=$(docker exec -i "$selected_id" sh -c "mysql -u$DB_USER -p$DB_PASS -e 'show databases;'" | awk 'NR>1')
selected_db=$(echo -e "反映先のデータベースを選択してください: \n$db_list" | fzf)

if [ -z "$selected_db" ]; then
  echo "No databases selected."
  exit 1
fi

file_options=$(ls ${SCRIPT_DIR}/dump/*.sql)
selected_file=$(echo -e "インポートするsqlファイルを選択してください:\n$file_options" | fzf)

if [ ! -f "$selected_file" ]; then
  echo "No file selected."
  exit 1
fi

read -p "container: $selected_name db: $selected_db dumpfile: $selected_file ...importを実行しますか? (y/N) " -n 1 -r
echo "Executing the script on the selected container and database..."

if [[ $REPLY =~ ^[Yy]$ ]]; then
  docker exec -i "$selected_id" mysql -u$DB_USER -p$DB_PASS "$selected_db" < "$selected_file"
fi