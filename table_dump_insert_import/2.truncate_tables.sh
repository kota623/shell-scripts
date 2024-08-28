#!/bin/bash

#start_time=$(date +%s)
#
#ssh hoge@hoge << EOF
## このスクリプトはリモートサーバーで実行されます。
#
## DB設定変数を読み込む
#source ./db_config.sh
#
## 削除しないテーブル名を配列に格納
#skip_tables=("schema_migrations")
#
#for sql_file in ./exports/*.sql; do
#  # ファイル名からテーブル名を取得（.sql拡張子を削除）
#  tbl=\$(basename "\$sql_file" .sql)
#
#  # 削除しないテーブルでなければ、全レコードを削除
#  if [[ ! " \${skip_tables[@]} " =~ " \${tbl} " ]]; then
#    mysql -h \$target_db_host -P \$target_db_port -u \$target_db_user -p\$target_db_password -D \$target_db_name -e "SET FOREIGN_KEY_CHECKS = 0; TRUNCATE TABLE \`$tbl\`; SET FOREIGN_KEY_CHECKS = 1;"
#    echo "テーブル \$tbl の削除処理が完了しました。"
#  fi
#done
#EOF
#
#end_time=$(date +%s)
#execution_time=$((end_time - start_time))
#
#echo "すべてのテーブルが正常に削除されました。全体の実行時間は $execution_time 秒でした。"

########################### ローカルテスト用 ###########################

start_time=$(date +%s)

# DB設定変数を読み込む
source ./db_config.sh

# 削除しないテーブル名を配列に格納
skip_tables=("schema_migrations")

for sql_file in ./exports/*.sql; do
  # ファイル名からテーブル名を取得（.sql拡張子を削除）
  tbl=$(basename "$sql_file" .sql)

  # 削除しないテーブルでなければ、全レコードを削除
  if [[ ! " ${skip_tables[@]} " =~ " ${tbl} " ]]; then
    mysql -h $target_db_host -P $target_db_port -u $target_db_user -p$target_db_password -D $target_db_name -e "SET FOREIGN_KEY_CHECKS = 0; TRUNCATE TABLE \`$tbl\`; SET FOREIGN_KEY_CHECKS = 1;"
    echo "テーブル $tbl の削除処理が完了しました。"
  fi
done

end_time=$(date +%s)
execution_time=$((end_time - start_time))

echo "すべてのテーブルが正常に削除されました。全体の実行時間は $execution_time 秒でした。"