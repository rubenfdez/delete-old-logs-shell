#!/bin/bash

source entorno.conf

FECHA=`date +"%Y-%m-%d"`
LOG_FILE="/path/logDelete.log.$FECHA"

log(){
# Escribe en $LOG_FILE el mensaje formateado $1
    HORA=`date +"%d/%m/%Y-%H:%M:%S"`
    if [ ! -f $LOG_FILE ];then
        umask 000
        touch $LOG_FILE
    fi
    echo "$HORA $USER $1" | tee -a $LOG_FILE
}

errorlog(){
    RESULT=$?
    if [ $RESULT -ne 0 ];then
        log "ERROR: Se ha producido un error en la ejecucion de la tarea"
        log "INFO: Ejecucion finalizada."
        exit $RESULT
    fi
}

for file in ${DELETE_FILES[@]};do
	find `dirname "${file}"` -name `basename "${file}"` -type f -mtime "+$DAYS" -exec rm {} \;
	if [ ! -f $file ];then
		log "Se ha borrado $file"
	fi
done

echo $?
