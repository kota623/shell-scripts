#!/bin/bash
# Load environment variables from .env file
: ${DB_USER:=root}

#ssh user@domain
options=("hoge@hoge")
options=$(printf '%s\n' "${options[@]}")
selected=$(echo -e "ダンプを収集するリモートサーバを選択してください:\n$options" | /root/.fzf/bin/fzf)

if [ -z "$selected" ]; then
  echo "リモートサーバが選択されませんでした。デフォルトのリモートサーバを使用します。"
  #ssh user@domain
  selected="hoge@hoge"
fi

date_suffix=$(date +"%Y-%m-%d")
selected_path="staging-db-dump-${date_suffix}.sql"
selected_dumpfile="relma_staging"
local_path="/staging-dump/staging-db-dump-${date_suffix}.sql"

trap 'ssh $selected "rm $selected_path"' EXIT

echo "サーバから $selected_dumpfile のdumpを採取し、ローカルにダウンロードします。"
ssh "$selected" "mysqldump -u$DB_USER -p $selected_dumpfile > $selected_path"
scp "$selected:$selected_path" "$local_path"