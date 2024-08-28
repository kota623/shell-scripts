#!/bin/bash

#start_time=$(date +%s)
#
## リモートサーバーでスクリプトを実行
#ssh hoge@hoge << EOF
## このスクリプトはリモートサーバーで実行されます。
#
## DB設定変数を読み込む
#source ./db_config.sh
#
## 各sqlファイルでループ処理を行う
#for sql_file in ./exports/*.sql; do
#  # ファイル名からテーブル名を取得（.sql拡張子を削除）
#  tbl=\$(basename "\$sql_file" .sql)
#
#  # 対象データベースにファイルをインポート
#  mysql -h \$target_db_host -P \$target_db_port -u \$target_db_user -p\$target_db_password -D \$target_db_name < "\$sql_file"
#  echo "テーブル \$tbl のインポート処理が完了しました。"
#done
#EOF
#
#end_time=$(date +%s)
#execution_time=$((end_time - start_time))
#echo "リモートサーバーですべてのテーブルが正常にインポートされました。全体の実行時間は $execution_time 秒でした。"

########################### ローカルテスト用 ###########################

start_time=$(date +%s)

# DB設定変数を読み込む
source ./db_config.sh

# 各sqlファイルでループ処理を行う
for sql_file in ./exports/*.sql; do
  # ファイル名からテーブル名を取得（.sql拡張子を削除）
  tbl=$(basename "$sql_file" .sql)

  # 対象データベースにファイルをインポート
  mysql -h $target_db_host -P $target_db_port -u $target_db_user -p$target_db_password -D $target_db_name < "$sql_file"
  echo "テーブル $tbl のインポート処理が完了しました。"
done

end_time=$(date +%s)
execution_time=$((end_time - start_time))

echo "すべてのテーブルが正常にインポートされました。全体の実行時間は $execution_time 秒でした。"