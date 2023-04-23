# ISEConf2023_MySample01

## 概要

z/OS上のGit Client (Rocket Git) を使用してCOBOLのプログラムを管理するデモを行うためのリポジトリです。

シンプルなCOBOLのソースが3つ含まれます。その他、操作簡略化のため、管理用のJCLやスクリプトなども含んでいます。

COBOLソース
- TMAIN01.cbl: メインプログラム (以下のサブプログラムを動的CALL)
- TSUB02.cbl: サブプログラム
- TSUB03.cbl: サブプログラム

COPYBOOK
- CPPARM01.cpy: TMAIN01の引数を表す構造体
- CPPARM02.cpy: TSUB02の引数を表す構造体
- CPPARM03.cpy: TSUB03の引数を表す構造体

管理用スクリプトなど (build以下)
- 01_allocate.jcl: 作業用PDSデータセット作成用JCL
- 02_copyFile2PDS.sh: USS上のCOBOLソース、CopybookをPDSにコピーするスクリプト
- 03_cobcmp.jcl: COBOLプログラムをコンパイルするJCL
- 04_cobrun.jcl: COBOLバッチを実行(単体テスト)するJCL
- 05_copyPDS2File.sh: 変更、追加されたPDS上のメンバーをUSS上にコピーするスクリプト

その他
- .gitattributes: 文字コード関連の設定を含む構成ファイル

## 前提

Rocket Gitがセットアップされてgitのコマンドが使用できるようになっていることが前提です。

USSから各種z/OS操作を行う以下のツールがセットアップされていることが前提です。

[Lightweight Command Utility on USS](https://github.com/tomotagwork/Lightweight_Command_Utility_on_USS)

## 使い方

### (1) リポジトリのクローン

当リポジトリをUSS上の適当なディレクトリにクローンします。

`git clone https://github.com/tomotagwork/ISEConf2023_MySample01.git`

必要に応じてブランチを作成して切替えます。

`git checkout -b test01`

### (2) プロパティーファイル(prop.txt)のカスタマイズ

環境に合わせて、prop.txtファイルをカスタマイズします。

設定例:

```properties
@HLQ@=IDZUSR1.TEST01
@VOL@=IDZ001
@CompLibrary@=IGYV6R4.SIGYCOMP
@LinkLibrary@=CEE.SCEELKED
@ProgName@=TMAIN01

```

補足:
- @HLQ@: COBOLのソースやCOPYBOOKなどを配置するPDSのHLQ
- @VOL@: COBOLのソースやCOPYBOOKなどを配置するPDSのVOLSER (非SMSの場合)
- @CompLibrary@: COBOLコンパイラ(IGYCRCTL)を含むライブラリ
- @LinkLibrary@: LINKプログラム(IEWL)を含むライブラリ
- @ProgName@: 操作対象のCOBOLソース
- ※末尾に必ず空行を入れておくこと

### (3) PDSデータセットの作成

作業用のPDSデータセットを作成します。既に存在する場合は実施不要です。

`01_allocate.jcl` を使用してデータセットを作成します。buildディレクトリ下で以下を実行します(Lightweight Command Utilityを使用してUSSからJCLをサブミットします)。

```sh
sub -f 01_allocate.jcl -p prop.txt -c
```

これにより以下のPDSが作成されます。
- `@HLQ@.JCL`
- `@HLQ@.COBOL.SOURCE`
- `@HLQ@.COBOL.COPYLIB`
- `@HLQ@.COBOL.OBJ`
- `@HLQ@.COBOL.OUTPUT`
- `@HLQ@.COBOL.SYSDEBUG`
- `@HLQ@.LOAD`

### (4) ソース、CopybookをUSSからPDSへコピー

以下のスクリプトを実行することで、COBOLソースを`@HLQ@.COBOL.SOURCE`に、Copybookを`@HLQ@.COBOL.COPYLIB`にコピーします。
buildディレクトリ下で以下を実行します

```sh
./02_copyFile2PDS.sh
```

### (5) ソース編集

適当なツール/エディター(PCOM, VS Code, Eclipse,...) を使用して、作業用のPDSにコピーされたソースを適宜編集します。

### (6) コンパイル/リンク

prop.txtを編集して、コンパイルしたいプログラム名を@ProgName@に指定します。

設定例:

```properties
@HLQ@=IDZUSR1.TEST01
@VOL@=IDZ001
@CompLibrary@=IGYV6R4.SIGYCOMP
@LinkLibrary@=CEE.SCEELKED
@ProgName@=TMAIN01

```

補足:
- @ProgName@: コンパイル対象のCOBOLソース
- ※末尾に必ず空行を入れておくこと

`03_cobcmp.jcl` を使用してコンパイル/リンクを実施します。buildディレクトリ下で以下を実行します(Lightweight Command Utilityを使用してUSSからJCLをサブミットします)。

```sh
sub -f 03_cobcmp.jcl -p prop.txt -c
```

複数のプログラムをコンパイルしたい場合は、プログラムごとにprop.txtの@ProName@の変更、および03_cobcomp.jclの実行を繰り返します。

### (7) 単体テスト

ここで用意しているのはシンプルなCOBOLのバッチなので、JCLからバッチを実行してみます。
prop.txtを編集して、実行したいプログラム名を@ProgName@に指定します。

設定例:

```properties
@HLQ@=IDZUSR1.TEST01
@VOL@=IDZ001
@CompLibrary@=IGYV6R4.SIGYCOMP
@LinkLibrary@=CEE.SCEELKED
@ProgName@=TMAIN01

```

補足:
- @ProgName@: コンパイル対象のCOBOLソース
- ※末尾に必ず空行を入れておくこと

`04_cobrun.jcl`を使用してCOBOLバッチの実行を行います。buildディレクトリ下で以下を実行します(Lightweight Command Utilityを使用してUSSからJCLをサブミットします)。

```sh
sub -f 04_cobrun.jcl -p prop.txt -c
```

JOBLOGを確認し、正しく修正が反映されたことを確認します。再度ソースを修正する場合は、(5)～(7)の手順を繰り返します。

### (8) ソース、CopybookをPDSからUSSへコピー

以下のスクリプトを実行することで、修正し終わったPDS上のメンバーをUSSのディレクトリにコピーします。また、合わせてコンパイル・リストの情報もUSS上(logsディレクトリ下)にコピーします。
buildディレクトリ下で以下を実行します

```sh
./05_copyPDS2File.sh
```

### (9) GitHubリモート・リポジトリへPush

変更した内容、logの情報をGitHub上に反映させます。ローカル・リポジトリのトップのディレクトリで以下のgitコマンドを実行します。

ステージング:

```sh
git add .
```

コミット:

```sh
git commit -m "update xxx"
```

プッシュ:

```sh
git push -u origin test01
```

※ブランチ名は適宜使用しているものに読み替えてください。
