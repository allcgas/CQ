#!/bin/bash

## CQ rocks, lol.
## not really.
## HipChat test comment.
## HipChat custom test.
## testing exec of custom bash payload.

# functions 
##############################
function usage() {
        cat <<EOF >&2
[+] Usage: $0 [-d backup_dir] [-p port] [-u username] [-z password]
EOF

        return 0
}

###############################
function getBackup() {
        echo "[+] URI: $BKUP_CMD"
        $BKUP_CMD

        return 0
}

###############################

# parse custom backup dir, if any
while getopts d:p:u:z: opt ; do
        case $opt in
    		d) BKUP_DIR=${OPTARG}    ;;
		p) INST_PORT=${OPTARG}   ;;
		u) INST_USER=${OPTARG}    ;;	
		z) INST_PASSWD=${OPTARG} ;;
                \?) echo "[+] Invalid option: ${OPTARG}, exiting .." >&2 && usage && exit 127 ;;
        esac
done

[ -z "$BKUP_DIR" ] && BKUP_DIR="$HOME/cq_repo_backups"
[ -z "$INST_PORT" ] && INST_PORT="4502"
[ -z "$INST_USER" ] && INST_USER="admin"
[ -z "$INST_PASSWD" ] && INST_PASSWD='my_pass'

# some variables
CURL=$(which curl)
CURDATE_STAMP="$(date +%m-%d-%Y)"
BKUP_CMD="$CURL -u ${INST_USER}:${INST_PASSWD} -X POST http://localhost:${INST_PORT}/system/console/jmx/com.adobe.granite:type=Repository/op/startBackup/java.lang.String?target=${BKUP_DIR}/backup-${CURDATE_STAMP}.zip"

# we create the backup dir if does not exist
[ ! -d "$BKUP_DIR" ] && { 
  echo -e "[+] creating backup directory: $BKUP_DIR ..\n"
  mkdir -p $BKUP_DIR
}

echo "[+] backing up to $BKUP_DIR .."
echo


getBackup


exit 0
