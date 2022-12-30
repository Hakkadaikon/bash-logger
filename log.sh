#!/bin/bash

# シェルオプション指定
# -e          : スクリプトの実行中にエラー(非0)が発生すると、スクリプト終了
# -u          : 未定義の変数を使用した場合、スクリプト終了
# -o pipefail : pipeで繋げたコマンドがエラーだった時、スクリプト終了
set -euo pipefail

# パス指定時、ログを出力する
readonly LOG_FILE=""

# ログレベル(指定されたログレベル以上のログは出さない)
readonly LOG_LEVEL_DEBUG=0
readonly LOG_LEVEL_INFO=1
readonly LOG_LEVEL_ERROR=2
readonly LOG_LEVEL=$LOG_LEVEL_DEBUG

# ログレベル文字列取得
# $1 : ログレベル(LOG_LEVEL_DEBUG/LOG_LEVEL_INFO/LOG_LEVEL_ERROR)
function __getLogLevelStr() {
    local CURRENT_LOG_LEVEL=$1
    local LOG_LEVEL_STR="Unknown"

    case ${CURRENT_LOG_LEVEL} in
    ${LOG_LEVEL_DEBUG}) 
        LOG_LEVEL_STR="Debug"
        ;;
    ${LOG_LEVEL_INFO}) 
        LOG_LEVEL_STR="Info"
        ;;
    ${LOG_LEVEL_ERROR}) 
        LOG_LEVEL_STR="Error"
        ;;
    esac

    echo "[${LOG_LEVEL_STR}]"
}

# 現在日時 -> 文字列変換
function __getLogDate() {
    echo "[$(date '+%Y-%m-%dT%H:%M:%S')]"
}

# 文字列 -> ログレベル別の色定義を取得
# $1 : ログレベル(LOG_LEVEL_DEBUG/LOG_LEVEL_INFO/LOG_LEVEL_ERROR)
function __getLogColor() {
    local CURRENT_LOG_LEVEL=$1

    # 文字色定義
    local LOG_LEVEL_FORE_COLOR_BLACK="30"
    local LOG_LEVEL_FORE_COLOR_RED="31"
    local LOG_LEVEL_FORE_COLOR_GREEN="32"
    local LOG_LEVEL_FORE_COLOR_YELLOW="33"
    local LOG_LEVEL_FORE_COLOR_BLUE="34"
    local LOG_LEVEL_FORE_COLOR_MAGENTA="35"
    local LOG_LEVEL_FORE_COLOR_CYAN="36"
    local LOG_LEVEL_FORE_COLOR_WHITE="37"

    # 背景色定義
    local LOG_LEVEL_BACK_COLOR_BLACK="40"
    local LOG_LEVEL_BACK_COLOR_RED="41"
    local LOG_LEVEL_BACK_COLOR_GREEN="42"
    local LOG_LEVEL_BACK_COLOR_YELLOW="43"
    local LOG_LEVEL_BACK_COLOR_BLUE="44"
    local LOG_LEVEL_BACK_COLOR_MAGENTA="45"
    local LOG_LEVEL_BACK_COLOR_CYAN="46"
    local LOG_LEVEL_BACK_COLOR_WHITE="47"

    # デフォルト色を指定
    local LOG_LEVEL_FORE_COLOR="${LOG_LEVEL_FORE_COLOR_WHITE}"
    local LOG_LEVEL_BACK_COLOR="${LOG_LEVEL_BACK_COLOR_BLACK}"

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

    echo "${LOG_LEVEL_FORE_COLOR};${LOG_LEVEL_BACK_COLOR}m"
}

# ログファイルに指定文字列を出力する
function __outputLogFile() {
    local LOG_STR=$1
    local LOG_OUTPUT_COMMAND=":"

    if [[ "${LOG_FILE}" != "" ]]; then
        echo "${LOG_STR}" >> ${LOG_FILE}
    fi
}

# ログ出力(デバッグ)
function logDebug() {
    local CURRENT_LOG_LEVEL=${LOG_LEVEL_DEBUG}

    if [ ${LOG_LEVEL} -gt ${CURRENT_LOG_LEVEL} ]; then
        exit
    fi

    # 現在日時
    local LOG_DATE=`__getLogDate`

    # ログレベル文字列
    local LOG_LEVEL_STR=`__getLogLevelStr ${CURRENT_LOG_LEVEL}`

    # 実行ファイル名:行数:実行関数名
    local LOG_FILE_NAME=${BASH_SOURCE[1]##*/}
    local LOG_FUNC_NAME="((${LOG_FILE_NAME}:${BASH_LINENO[0]}:${FUNCNAME[1]}))"

    # ログ文字列フォーマット
    local LOG_STR="${LOG_DATE} ${LOG_LEVEL_STR} ${LOG_FUNC_NAME} $@"

    # ログの文字色・背景色を取得
    local LOG_COLOR=`__getLogColor ${CURRENT_LOG_LEVEL}`
    local LOG_ESC=$(printf '\033')
    local LOG_COLOR_START="${LOG_ESC}[$LOG_COLOR"
    local LOG_COLOR_END="${LOG_ESC}[m"

    # ログ出力
    echo "${LOG_COLOR_START}${LOG_STR}${LOG_COLOR_END}"
    __outputLogFile "${LOG_STR}"
}

# ログ出力(情報)
function logInfo() {
    local CURRENT_LOG_LEVEL=${LOG_LEVEL_INFO}

    if [ ${LOG_LEVEL} -gt ${CURRENT_LOG_LEVEL} ]; then
        exit
    fi

    # 現在日時
    local LOG_DATE=`__getLogDate`

    # ログレベル文字列
    local LOG_LEVEL_STR=`__getLogLevelStr ${CURRENT_LOG_LEVEL}`

    # 実行ファイル名:行数:実行関数名
    local LOG_FILE_NAME=${BASH_SOURCE[1]##*/}
    local LOG_FUNC_NAME="((${LOG_FILE_NAME}:${BASH_LINENO[0]}:${FUNCNAME[1]}))"

    # ログ文字列フォーマット
    local LOG_STR="${LOG_DATE} ${LOG_LEVEL_STR} ${LOG_FUNC_NAME} $@"

    # ログの文字色・背景色を取得
    local LOG_COLOR=`__getLogColor ${CURRENT_LOG_LEVEL}`
    local LOG_ESC=$(printf '\033')
    local LOG_COLOR_START="${LOG_ESC}[$LOG_COLOR"
    local LOG_COLOR_END="${LOG_ESC}[m"

    # ログ出力
    echo "${LOG_COLOR_START}${LOG_STR}${LOG_COLOR_END}"
    __outputLogFile "${LOG_STR}"
}

# ログ出力(エラー)
function logError() {
    local CURRENT_LOG_LEVEL=${LOG_LEVEL_ERROR}

    if [ ${LOG_LEVEL} -gt ${CURRENT_LOG_LEVEL} ]; then
        exit
    fi

    # 現在日時
    local LOG_DATE=`__getLogDate`

    # ログレベル文字列
    local LOG_LEVEL_STR=`__getLogLevelStr ${CURRENT_LOG_LEVEL}`

    # 実行ファイル名:行数:実行関数名
    local LOG_FILE_NAME=${BASH_SOURCE[1]##*/}
    local LOG_FUNC_NAME="((${LOG_FILE_NAME}:${BASH_LINENO[0]}:${FUNCNAME[1]}))"

    # ログ文字列フォーマット
    local LOG_STR="${LOG_DATE} ${LOG_LEVEL_STR} ${LOG_FUNC_NAME} $@"

    # ログの文字色・背景色を取得
    local LOG_COLOR=`__getLogColor ${CURRENT_LOG_LEVEL}`
    local LOG_ESC=$(printf '\033')
    local LOG_COLOR_START="${LOG_ESC}[$LOG_COLOR"
    local LOG_COLOR_END="${LOG_ESC}[m"

    # ログ出力
    echo "${LOG_COLOR_START}${LOG_STR}${LOG_COLOR_END}"
    __outputLogFile "${LOG_STR}"
}
