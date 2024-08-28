#!/bin/bash

#start_time=$(date +%s)
#
#ssh hoge@hoge << EOF
## このスクリプトはリモートサーバーで実行されます。
#
## DB設定変数を読み込む
#source ./db_config.sh
#echo "DB設定が ./db_config.sh から読み込まれました"
#
## スキップするテーブル
#skip_tables=("schema_migrations")
#
## テーブル名を取得
#tables=\$(mysql -h \$source_db_host -P \$source_db_port -u \$source_db_user -p\$source_db_password \$source_db_name -e "SHOW TABLES;" | awk '{ print \$1}' | grep -v '^Tables' )
#echo "取得したテーブル: \$tables"
#
## 個々のテーブルを個々のファイルにダンプする
#for tbl in \$tables; do
#  if [[ " \${skip_tables[@]} " =~ " \${tbl} " ]]; then
#    echo "テーブル \$tbl をスキップします"
#    continue
#  fi
#
#  echo "テーブル\$tbl をダンプしています"
#  mysqldump --no-create-info -h \$source_db_host -P \$source_db_port -u \$source_db_user -p\$source_db_password \$source_db_name \$tbl > "./exports/\$tbl.sql"
#  echo "テーブル\$tblは正常にダンプされました"
#done
#
#echo "すべてのテーブルが正常にダンプされました"
#EOF
#
#end_time=$(date +%s)
#execution_time=$((end_time-start_time))
#
#echo "リモートサーバーでのダンプが完了しました。全体の実行時間は$execution_time 秒でした。"

########################### ローカルテスト用 ###########################

start_time=$(date +%s)

# DB設定変数を読み込む
source ./db_config.sh
echo "DB設定が ./db_config.sh から読み込まれました"

# スキップするテーブル
skip_tables=("schema_migrations")

# テーブル名を取得
tables=$(mysql -h $source_db_host -P $source_db_port -u $source_db_user -p$source_db_password $source_db_name -e "SHOW TABLES;" | awk '{ print $1}' | grep -v '^Tables' )
echo "取得したテーブル: $tables"

# 個々のテーブルを個々のファイルにダンプする
for tbl in $tables; do
  if [[ " ${skip_tables[@]} " =~ " ${tbl} " ]]; then
    echo "テーブル $tbl をスキップします"
    continue
  fi

  echo "テーブル$tbl をダンプしています"
  mysqldump --no-create-info -h $source_db_host -P $source_db_port -u $source_db_user -p$source_db_password $source_db_name $tbl > "./exports/$tbl.sql"
  echo "テーブル$tblは正常にダンプされました"
done

end_time=$(date +%s)
execution_time=$((end_time-start_time))

echo "ローカル環境でのダンプが完了しました。全体の実行時間は$execution_time 秒でした。"