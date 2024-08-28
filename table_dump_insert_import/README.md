### ディレクトリ説明
- exports dumpしたファイル群の出力先
- tmp/ 実行中のプロセスを保存するファイルが出力される。

### script
[db_config.sh](db_config.sh)
source_db_host: dumpを取得したいDBの接続情報を記載して下さい
target_db_host: truncate & insertを行いたいDBの接続情報を記載して下さい

[1.table_data_dump.sh](1.table_data_dump.sh)
dumpを取得してexportsディレクトリに出力します。

[2.truncate_tables.sh](2.truncate_tables.sh)
exportsディレクトリに存在するインサートを行うテーブルに対してtruncateを実行します。

[3.import.sh](3.import.sh)
exportsディレクトリに存在するファイルでインサートを行います。

### 手順
1. db_config.shのsource_db_hostに本番の接続情報を記載します。
2. target_db_hostに移行先の接続情報を記載します。
3. 実行権限がなければ`chmod +x *.sh`を行い付与します。
4. 1.table_data_dump.sh, 2.truncate_tables.sh, 3.import.sh を順番に実行します。

※フレームワークごとに除外したいテーブルがある場合は除外設定が可能なので適宜設定して下さい。

TODO: function化してsshの時とズレないようにしたい