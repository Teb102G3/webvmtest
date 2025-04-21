#****************************************************************#
# PROGRAM ID  : U00                                              #
# LANGUAGE    : SHELL SCRIPT                                     #
# PURPOSE     : Configuration for monitor shells                 #
# VERSION     : V1.0                                             #
# AUTHOR      : 馮科迪(iceis@cht.com.tw)                         #
# SPEC. BY    : 馮科迪(iceis@cht.com.tw)                         #
# CREATE DATE : 112/2/23                                        #
# O.S.        : LINUX                                            #
#****************************************************************#
__BD_CONF__=$(date +%s)

_SYSCD_FILE_=BD_SYSCD.sh
. "$( cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P )/${_SYSCD_FILE_}"

HDP_CMD_PROMPT="hdfs dfs"

# Prestage/Stage file system, which apply to BD_UTILS_[HDFS|LFS].sh
# $BD_FS_STG_LFS | $BD_FS_STG_HDFS
BD_FS_STG="${BD_FS_STG_LFS}"

BD_ENC_DEFAULT="UTF8"

BD_GRP_PREFIX='g'
BD_GRP_LEN=4 #digital number length for group cd
BD_GRP_DFL="${BD_GRP_PREFIX}0001"

# Default Category Name for stage job
BD_CATE_STG_DFL='stage'

BD_CIPHER_TYPE="aes-256-cbc"

BD_LOCK_EXPIRED=480 #in min
##test
#BD_PROJ_NAME="chtdic"
BD_PROJ_NAME="prod_chtdic" #####測試完務必要改回來
BD_DIR_ROOT="/home/dicuser/sbd/${BD_PROJ_NAME,,}"
BD_DIR_APPS="${BD_DIR_ROOT}/APPS"
BD_DIR_HQL="${BD_DIR_ROOT}/HQL"
BD_DIR_SQP="${BD_DIR_ROOT}/SQP"
BD_DIR_RSH="${BD_DIR_ROOT}/RSH"
BD_DIR_LIB="${BD_DIR_ROOT}/LIB"
BD_DIR_LOG="${BD_DIR_ROOT}/LOG"
BD_DIR_SHELL="${BD_DIR_ROOT}/BD_SH"
BD_DIR_TEMP="${BD_DIR_ROOT}/TEMP"
BD_DIR_PRETMP="${BD_DIR_ROOT}/PRETEMP"
BD_DIR_FTPDATA="${BD_DIR_ROOT}/FTPDATA"
BD_DIR_SYS="${BD_DIR_ROOT}/BD_SYS"

# Sub directory in $BD_DIR_PRETMP/${SYS_NAME}/..
# May set as empty while BD_DIR_FTPDATA=BD_DIR_PRETMP
BD_PRETMP_SUB_PUT="/PUT"
BD_PRETMP_SUB_TRANS="/TRANS"

BD_SERVICE_USER="dicuser"

## no use 
BD_HDFS_ROOT="/tmp"

BD_HDFS_BACKUP="${BD_HDFS_ROOT}/user/${BD_SERVICE_USER}/${BD_PROJ_NAME,,}_backup"
BD_HDFS_STATUS="${BD_HDFS_ROOT}/user/${BD_SERVICE_USER}/${BD_PROJ_NAME,,}_status"
BD_HDFS_STAGE="${BD_HDFS_ROOT}/stage"
BD_HDFS_PRESTG="${BD_HDFS_ROOT}/prestage"
BD_HDFS_OUTERSTG="${BD_HDFS_ROOT}/outerstage"
BD_HDFS_FTPDATA="${BD_HDFS_ROOT}/ftpdata"
BD_HDFS_TMP="${BD_HDFS_ROOT}/tmp"
BD_HDFS_RM_OPT="-skipTrash" # "-skipTrash" | ""

BD_ITS_EXTERNAL_ROOT="/itsdat/external/sftp/sbd/ftpdata"
BD_SPT_EXTERNAL_ROOT="/sptdat/external/sftp/sbd/ftpdata"

# Use Control Table for service info or file system
# $BD_SERVICE_INFO_DB | $BD_SERVICE_INFO_FS
BD_SERVICE_INFO="${BD_SERVICE_INFO_DB}"

BD_SERVICE_EXPIRED=240 #in min

BD_SERVICE_NM_ALL=("$BD_SERVICE_NM_MAIN" "$BD_SERVICE_NM_FILE")
# Keep array empty while no HA supported.
#BD_SERVICE_NM_ALL=()

BD_CRON_BASH="source ~/.bash_profile;"
declare -A BD_SERVICE_CRON=()
BD_SERVICE_CRON[${BD_SERVICE_NM_MONITOR}]="5,20,35,50 * * * * ${BD_DIR_SHELL}/BD_MONITOR.sh >/dev/null 2>&1"
BD_SERVICE_CRON[${BD_SERVICE_NM_MAIN}]="# Job register
15 1,9,17 * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_JOB_REGISTER.sh now 4day >/dev/null 2>&1
25 1,9,17 * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_JOB_UNREGISTER.sh now 2day >/dev/null 2>&1
1,16,31,46 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_JOB_DEPEN_UPD.sh >/dev/null 2>&1
5,20,35,50 * * * 1,2,3,4,5 ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_JOB_DISPATCHER.sh >/dev/null 2>&1
5,20,35,50 * * * 6,0 ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_JOB_DISPATCHER.sh >/dev/null 2>&1
15 2,10,18 * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_CHK_REGISTER.sh now 4day >/dev/null 2>&1
25 2,10,18 * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_CHK_UNREGISTER.sh now 2day >/dev/null 2>&1
7,17,27,37,47,57 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_CHK_DEPEN_UPD.sh >/dev/null 2>&1
10,25,40,55 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_CHK_DISPATCHER.sh >/dev/null 2>&1
6,21,36,51 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_JOB_FAIL_RERUN_UPD.sh >/dev/null 2>&1

# Clean up
0 2 * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_CLEANER.sh >/dev/null 2>&1 "
BD_SERVICE_CRON[${BD_SERVICE_NM_FILE}]="# Batch put to prestage
#15 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_PUT_PRESTAGE.sh sbd >/dev/null 2>&1
#20 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_PRESTAGE_WORK.sh sbd >/dev/null 2>&1
5 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_PUT_FTPDATA.sh its ltx >/dev/null 2>&1
15 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_PUT_OUTERSTAGE.sh its ltx >/dev/null 2>&1
20 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_OUTERSTAGE_WORK.sh its ltx >/dev/null 2>&1
35 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_PUT_FTPDATA.sh its its >/dev/null 2>&1
45 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_PUT_OUTERSTAGE.sh its its >/dev/null 2>&1
50 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_OUTERSTAGE_WORK.sh its its >/dev/null 2>&1
10 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_PUT_FTPDATA.sh spt spt >/dev/null 2>&1
20 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_PUT_OUTERSTAGE.sh spt spt >/dev/null 2>&1
25 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_OUTERSTAGE_WORK.sh spt spt >/dev/null 2>&1
15 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_PUT_FTPDATA_DEXODS.sh spt dex >/dev/null 2>&1
25 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_PUT_OUTERSTAGE.sh spt dex >/dev/null 2>&1
30 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_OUTERSTAGE_WORK.sh spt dex >/dev/null 2>&1
20 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_PUT_FTPDATA_DEXODS.sh spt ods >/dev/null 2>&1
30 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_PUT_OUTERSTAGE.sh spt ods >/dev/null 2>&1
35 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_OUTERSTAGE_WORK.sh spt ods >/dev/null 2>&1
25 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_PUT_FTPDATA_DEXODS.sh spt dic >/dev/null 2>&1
35 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_PUT_OUTERSTAGE.sh spt dic >/dev/null 2>&1
40 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_OUTERSTAGE_WORK_DIC.sh >/dev/null 2>&1
#20 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_STAGE_DISPATCHER.sh sbd >/dev/null 2>&1
#25 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_CONVERTER.sh sbd >/dev/null 2>&1
15,45 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_PRESTAGE_TBL.sh sbd >/dev/null 2>&1
10 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_OUTERSTAGE_SEND.sh its fit >/dev/null 2>&1
40 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_FTPDATA_SEND_FIT.sh >/dev/null 2>&1
20 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_OUTERSTAGE_SEND.sh spt ods >/dev/null 2>&1
50 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_FTPDATA_SEND_ODS.sh >/dev/null 2>&1
10 * * * * ${BD_CRON_BASH}${BD_DIR_SHELL}/BD_BATCH_OUTERSTAGE_SEND.sh spt dic >/dev/null 2>&1
"

# Time duration for find files in X mins ago (in mins)
FIND_FILE_DELAY=10

# Time for file sending list get (in mins)
FILE_TRANS_CHK_INTERVAL=180

# $FILE_TRANS_MODE_ALL | $FILE_TRANS_MODE_ONCE
FILE_TRANS_MODE=$FILE_TRANS_MODE_ONCE

# Control DATABASE INFO
CONTROL_DB_TYPE="sqlserver" # [postgresql | mysql | sqlserver]
CONTROL_DB="ctrl"
CONTROL_SCHEMA="dbo"
CONTROL_TB_JOB="ctrl_job_info"
CONTROL_TB_EXEC_INFO="ctrl_job_exec_info"
CONTROL_TB_EXEC_STUS="ctrl_job_exec_stus"
CONTROL_TB_EXEC_LOG="ctrl_job_exec_log"
CONTROL_TB_FILE_STUS="ctrl_file_exec_stus"
CONTROL_TB_FILE_TRANS="ctrl_file_trans_info"
CONTROL_TB_DEL_CD="ctrl_data_del_set_cd"
CONTROL_TB_SERVICE="ctrl_service_stus"
CONTROL_TB_CHECK_INFO="ctrl_check_info"
CONTROL_TB_CHECK_STUS="ctrl_check_exec_stus"
CONTROL_TB_DISPATCHER_EXEC_LIST="v_ctrl_job_wait2run_list"
CONTROL_TB_DISPATCHER_RUNNING_LIST="v_ctrl_job_running_list"
CONTROL_FN_GET_JOBID="fn_get_job_id"
CONTROL_FN_UPD_DEPEN="pr_upd_job_dept"
CONTROL_FN_REGISTER_JOB="pr_register_job"
CONTROL_FN_UNREGISTER_JOB="pr_unregister_job"
CONTROL_FN_UPD_CHK_DEPEN="pr_upd_check_stus"
CONTROL_FN_REGISTER_CHK="pr_register_check"
CONTROL_FN_UNREGISTER_CHK="pr_unregister_check"
CONTROL_FN_UPD_JOB_FAIL_RERUN="pr_upd_job_fail_rerun"
SQL_CONN_CTRL="sqlcmd -d ${CONTROL_DB}"

#SQL CONNECTION
SQL_CONN_HIVE=""
SQL_CONN_IMPALA=""
SQL_CONN_IMPALA_SHL=""
SQL_CONN_SQP=""
SQL_CONN_PSQL="psql "

#20240221 add
SQL_CONN_DB2="db2 "
SQL_CONN_ORC="sqlplus "
SQL_CONN_ORC_3S="sqlplus_3s "

# The default connection for executing HQL
BD_HQL_CONN='SQL_CONN_IMPALA_SHL' #[SQL_CONN_HIVE|SQL_CONN_IMPALA|SQL_CONN_IMPALA_SHL]

# PRESTAGE TO STAGE TIMEOUT
PRESTGTOSTG_TIMEOUT=10 #TIMEOUT
PRESTGTOSTG_SLEEP=2 #SLEEPINTERVAL

# Param for BD_MONITOR, TYPE,INTERVAL,DURATION,END-HHMM(optional)
BD_MNTR_TYPE="O" # [[O]nce | [I]nterval INTERVAL DURATION END-HHMM]

# max jobs run currently
DPCH_JOB_EXEC_MAX1=40 #10
# max jobs run in non rush hour
DPCH_JOB_EXEC_MAX2=50 #15
# week day for rush hour
DPCH_RUSH_WEEK_DAY='1 2 3 4 5'
# begin hour for rush hour
DPCH_RUSH_HOUR_BGN='0600'
# end hour for rush hour
DPCH_RUSH_HOUR_END='2000'
# invoke interval between each job (in seconds)
DPCH_EXEC_INTERVAL=5

#BD_FILE_STG_ORDER=(${BD_FILE_STG_PREWRK} ${BD_FILE_STG_PRESTG} ${BD_FILE_STG_STGCNVT} ${BD_FILE_STG_STGWRK} ${BD_FILE_STG_STAGE})
BD_FILE_STG_ORDER=(${BD_FILE_STG_OUTERWRK} ${BD_FILE_STG_OUTERSTG} ${BD_FILE_STG_PREWRK} ${BD_FILE_STG_PRESTG})

# JOB name delimiter for Table & Group, ex: TABLE_NAME${BD_JOB_NM_DLMTR}GROUP
BD_JOB_NM_DLMTR='_'

BD_JOB_NM_SUFFIX_INIT="${BD_JOB_NM_DLMTR}init"
BD_JOB_NM_SUFFIX_DFL=""

# The count for commit
BD_CMT_OUTERSTG=50
BD_CMT_PRESTG=50
BD_CMT_STAGE=40
BD_CMT_ERROR=10

# The tolerence of stage column variation (Fail if greater than ..)
BD_HTS_COL_VARIATION_LIMIT=50;

# A+B=C, D=((C-A)*100/B)% (Fail if D < Threshold) 
BD_DIFF_FSIZE_THRESHOLD=90

# login information for postgresql control tables
BD_PGPASS=''
BD_PGFILE=	#host:port:db:user:password

#***** for Trinity start *****
#
BD_TRNTY_CONN="" #Empty for local "ssh trinity@192.168.0.123 export TRINITY_JCSCMD_PWD=E8B5522E2C19B7CBF0A8848118A0EF30;"
BD_TRNTY_AGENT_HOME="/data/Trinity/JCSAgent"
BD_TRNTY_JCSCMD_CFG="${BD_TRNTY_AGENT_HOME}/cfg/jcscmd.conf"
BD_TRNTY_TP_DFL="${BD_TRNTY_TP_JOB}" #default type [job|flow]
BD_TRNTY_BN_DFL="A00_BD" #default business name
BD_TRNTY_USER="ap_sbd"
BD_TRNTY_PWD="0A6447378E3EAC5699954ED22BAA3A58"
BD_TRNTY_USER_JOB=""
BD_TRNTY_PWD_JOB=""
BD_TRNTY_USER_CHK=""
BD_TRNTY_PWD_CHK=""
BD_TRNTY_CONSOLE_ENC="UTF8"
BD_TRNTY_BN_CHK="SDG"
BD_TRNTY_CN_CHK="CHECK"
#
#***** for Trinity end *****

# For Converter decide to replace newline '\n' in field
BD_HCSV_REPLACE_NEWLINE=1 #1: enable, 0: disable

# For iconv on/off in prestage
BD_PRESTG_ICONV=1 # 1:on / other: off
# For checksum check in prestage
BD_PRESTG_CHKSUM=0 # 1:on / other: off

# For iconv on/off in prestage
BD_OUTERSTG_ICONV=1 # 1:on / other: off
# For checksum check in prestage
BD_OUTERSTG_CHKSUM=0 # 1:on / other: off

# info_key=[report sql path],[email title with %cnt% & %date%],[email list]
BD_REPORT_INFO="job_stus_d=${BD_DIR_SYS}/report/job_stus_d.sql,job_stus_d.hql(%cnt%) - %date%,aaa@bbb.com
"

BD_UTILS_DFL_TIME="00:00:00"
BD_UTILS_DFL_S_TIME="000000"
BD_UTILS_DTFMT='21' # postgresql-to_timestamp/YYYYMMDDHH24MISS, mysql-str_to_date/%Y%m%d%H%i%S, sqlserver-convert/21
BD_UTILS_DTFMT2='YYYY-MM-DD_HH24:MI:SS' # select to_char(...) from db

BD_BIN_JAVA="${BD_DIR_APPS}/CONVERTER/java/bin/java"
BD_BIN_CONVERTER="${BD_BIN_JAVA} -jar ${BD_DIR_APPS}/CONVERTER/converter-camel.jar"

# Backup ${BD_DIR_ROOT} entire or not
BD_OPT_BACKUP=0 #1: enable, 0: disable

# Check expire by date in file or mtime
BD_CLEANER_MTIME=1 #1: mtime, 0: date in filename

# Time period for local dir housekeeping (in days)
KEEP_DAY_LOG=100
KEEP_DAY_TEMP=7
KEEP_DAY_PRETMP=90
KEEP_DAY_FTPDATA=90

BD_CLEANER_LOCAL_SET=(
    # "LOCAL DIR"     "FILE PATTERN"      "KEEP DAYS"
    # "${BD_DIR_FTPDATA}/SYSTEM '*' ${KEEP_DAY_FTPDATA}" 
    "${BD_DIR_LOG}    '*.${FILE_EXT_LOG}' ${KEEP_DAY_LOG}"
    "${BD_DIR_TEMP}   '*'                 ${KEEP_DAY_TEMP}"
    "${BD_DIR_PRETMP} '*'                 ${KEEP_DAY_PRETMP}"
)

BD_CLEANER_DW_SET=("${BD_JOB_STG_PRESTG}" "${BD_JOB_STG_STAGE}" "${BD_JOB_STG_HIVE}")

# Array of CHk ETL;
declare -A BD_CHK_EXEC_SET=() 
# BD_CHK_EXEC_SET['CHECK_CD']="'CHECK_ETL_NAME' MAX_GROUP_NO"
BD_CHK_EXEC_SET['A0101']="SDG:CHECK:SRC_DATA_ROWCOUNT_CHK 5"
BD_CHK_EXEC_SET['A0102']="SDG:CHECK:SRC_DATA_COLCOUNT_CHK 5"
BD_CHK_EXEC_SET['A01']="SDG:RULE:SRC_DATA_COUNT_RULE 5"
BD_CHK_EXEC_SET['A0201']="SDG:CHECK:SRC_DATA_SPEC_CHK 5"
BD_CHK_EXEC_SET['A02']="SDG:RULE:SRC_DATA_SPEC_RULE 5"
BD_CHK_EXEC_SET['A0301']="SDG:CHECK:DATE_RANGE_CHK 5"
BD_CHK_EXEC_SET['A03']="SDG:RULE:DATE_RANGE_RULE 5"
BD_CHK_EXEC_SET['A0401']="SDG:CHECK:DATA_MEASURE_CHK 5"
BD_CHK_EXEC_SET['A04']="SDG:RULE:DATA_MEASURE_RULE 5"
BD_CHK_EXEC_SET['B0301']="SDG:CHECK:YOY_EXEC_DURATION_CHK 5"
BD_CHK_EXEC_SET['B03']="SDG:RULE:YOY_EXEC_DURATION_RULE 5"
BD_CHK_EXEC_SET['C0101']="SDG:CHECK:LOAD_ROWCOUNT_CHK 5"
BD_CHK_EXEC_SET['C01']="SDG:RULE:LOAD_ROWCOUNT_RULE 5"
BD_CHK_EXEC_SET['C0201']="SDG:CHECK:YOY_ROWCOUNT_CHK 5"
BD_CHK_EXEC_SET['C02']="SDG:RULE:YOY_ROWCOUNT_RULE 5"
BD_CHK_EXEC_SET['C0501']="SDG:CHECK:SUMY_DATA_CHK 5"
BD_CHK_EXEC_SET['C05']="SDG:RULE:SUMY_DATA_RULE 5"
BD_CHK_EXEC_SET['D0101']="SDG:CHECK:IDN_ERRCOUNT_CHK 5"
BD_CHK_EXEC_SET['D0102']="SDG:CHECK:BAN_ERRCOUNT_CHK 5"
BD_CHK_EXEC_SET['D0103']="SDG:CHECK:IDNBAN_ERRCOUNT_CHK 5"
BD_CHK_EXEC_SET['D01']="SDG:RULE:IDN_BAN_ERRCOUNT_RULE 5"
BD_CHK_EXEC_SET['D0201']="SDG:CHECK:DATE_ERRCOUNT_CHK 5"
BD_CHK_EXEC_SET['D0202']="SDG:CHECK:TIMESTAMP_ERRCOUNT_CHK 5"
BD_CHK_EXEC_SET['D02']="SDG:RULE:DATE_TIMESTAMP_ERRCOUNT_RULE 5"
BD_CHK_EXEC_SET['D0301']="SDG:CHECK:NULL_ERRCOUNT_CHK 5"
BD_CHK_EXEC_SET['D03']="SDG:RULE:NULL_ERRCOUNT_RULE 5"
BD_CHK_EXEC_SET['D0401']="SDG:CHECK:NUM_ERRCOUNT_CHK 5"
BD_CHK_EXEC_SET['D04']="SDG:RULE:NUM_ERRCOUNT_RULE 5"

# Common function
APP_FILE_NAME=$(basename "$0")
APP_NAME=${APP_FILE_NAME%%.*}

function MSG_INFO() { NOW=$(date "+%Y-%m-%d %H:%M:%S");  echo "[$NOW] [$APP_NAME] [INFO] $@";}
function MSG_WARN() { NOW=$(date "+%Y-%m-%d %H:%M:%S");  echo "[$NOW] [$APP_NAME] [WARN] $@";}
function MSG_ERROR() { NOW=$(date "+%Y-%m-%d %H:%M:%S"); echo "[$NOW] [$APP_NAME] [ERROR] $@";}
function MSG_DEBUG() { NOW=$(date "+%Y-%m-%d %H:%M:%S"); echo "[$NOW] [$APP_NAME] [DEBUG] $@";}

# default profile extension
BD_PROFILE="prod"
BD_HOST_SET=( # IP for prod/test/dev env, which apply to use localsetting.xxx
    # "EXT  IP"
    "prod  10.161.113.2"
    "uat   10.171.113.8"
    "cht   192.168.43.134"
    "cht   127.0.0.1"
)

# Set local settings profile
BD_HOSTIP=$(hostname -i 2>/dev/null)
idx=0;while [ $idx -lt ${#BD_HOST_SET[@]} ]; do
    BD_HOST_SET_EXT=$(echo "${BD_HOST_SET[$idx]}" | awk '{print $1}')
    BD_HOST_SET_IP=$(echo "${BD_HOST_SET[$idx]}" | awk '{print $2}')
    if [ "$BD_HOSTIP" == "$BD_HOST_SET_IP" ]; then BD_PROFILE="$BD_HOST_SET_EXT"; break; fi
    let idx+=1
done
# load local setting, eg hive/impala connection string for testing or production
LOCALSETTING=$BD_DIR_SHELL/localsetting.$BD_PROFILE
if [ -f $LOCALSETTING ]; then MSG_INFO "load local setting file:$LOCALSETTING"; source $LOCALSETTING; fi;

## add
CTRL_CONN_IP_FILE=$BD_DIR_SHELL/ctrl_conn_ip_file.$BD_PROFILE
if [ -f $CTRL_CONN_IP_FILE ]; then MSG_INFO "load ctrl connect ip file:$CTRL_CONN_IP_FILE"; source $CTRL_CONN_IP_FILE; fi;

