# bash-log

## 概要
bash用のログです。
・３段階のログレベル(Debug/Info/Error)に対応しています。
・ログレベルによって、標準出力に出力されるログが色分けされます。

## 使い方
### サンプルコード

```bash
#!/bin/bash

# ソースファイル読み込み
source ./log.sh

# デバッグログ
logDebug "test debug"

# 情報ログ
logInfo "test debug"

# エラーログ
logError "test debug"
```

### 実行結果

```
[2022-12-31T01:46:19] [Debug] ((test.sh:6:main)) test debug
[2022-12-31T01:46:19] [Info] ((test.sh:7:main)) test info
[2022-12-31T01:46:19] [Error] ((test.sh:8:main)) test error
```

## 定義
### ログファイル出力
ログファイルを出力する場合、LOG_FILE変数の定義を変更して下さい。
※ 未定義の場合(空文字列)の場合は、ログを出力しません。

```bash
LOG_FILE="./test.log"
```

### ログレベル変更
ログレベルを変更する場合、LOG_LEVEL変数の定義を変更して下さい。

```bash
readonly LOG_LEVEL_DEBUG=0
readonly LOG_LEVEL_INFO=1
readonly LOG_LEVEL_ERROR=2
readonly LOG_LEVEL=${LOG_LEVEL_DEBUG}
```

### ログ出力時の色変更
ログ出力時の色を変更する場合、__getLogColor()関数の色定義を変更して下さい。
LOG_LEVEL_FORE_COLOR : 文字色
LOG_LEVEL_BACK_COLOR : 背景色


```bash
    case ${CURRENT_LOG_LEVEL} in
    ${LOG_LEVEL_DEBUG}) 
        LOG_LEVEL_FORE_COLOR="${LOG_LEVEL_FORE_COLOR_WHITE}"
        LOG_LEVEL_BACK_COLOR="${LOG_LEVEL_BACK_COLOR_BLACK}"
        ;;
    ${LOG_LEVEL_INFO}) 
        LOG_LEVEL_FORE_COLOR="${LOG_LEVEL_FORE_COLOR_BLUE}"
        LOG_LEVEL_BACK_COLOR="${LOG_LEVEL_BACK_COLOR_BLACK}"
        ;;
    ${LOG_LEVEL_ERROR}) 
        LOG_LEVEL_FORE_COLOR="${LOG_LEVEL_FORE_COLOR_WHITE}"
        LOG_LEVEL_BACK_COLOR="${LOG_LEVEL_BACK_COLOR_RED}"
        ;;
    esac
```
