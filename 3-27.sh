#!/bin/bash 
# logevents.sh, 由Stephane Chazelas所编写. 

# 把事件记录在一个文件中. 
# 必须以root身份运行 (这样才有权限访问/var/log).  
ROOT_UID=0
# 只有$UID值为0的用户才具有root权限.
E_NOTROOT=67
# 非root用户的退出错误.
if [ "$UID" -ne "$ROOT_UID" ]
	then 
	echo "Must be root to run this script." 
	exit $E_NOTROOT 
fi 

FD_DEBUG1=3
FD_DEBUG2=4
FD_DEBUG3=5
# 去掉下边两行注释中的一行, 来激活脚本. 
# LOG_EVENTS=1
# LOG_VARS=1 25 26 27 log() # 把时间和日期写入日志文件. 
{ 
echo "$(date) $*" >&7 # 这会把日期*附加*到文件中.
# 参考下边的代码.
} 
case $LOG_LEVEL in 
	1) exec 3>&2 4> /dev/null 5> 
/dev/null;; 
	2) exec 3>&2 4>&2 5> /dev/null;;
	3) exec 3>&2 4>&2 
5>&2;; 
	*) exec 3> /dev/null 4> /dev/null 5> /dev/null;;
esac 


FD_LOGVARS=6 
if [[ $LOG_VARS ]]
	then exec 6>> /var/log/vars.log 
else exec 6> /dev/null # 丢弃输出.
fi 

FD_LOGEVENTS=7
if [[ $LOG_EVENTS ]]
	then 51 # then 
	exec 7 >(exec gawk '{print strftime(), $0}' >> /var/log/event.log)
	# 上面这行不能在2.04版本的Bash上运行.
	exec 7>> /var/log/event.log # 附加到"event.log".
log # 记录日期与时间.
else exec 7> /dev/nul # 丢弃输出.
fi

echo "DEBUG3: beginning" >&${FD_DEBUG3} 

ls -l >&5 2>&4 # command1 >&5 2>&4

echo "Done" # command2

echo "sending mail" >&${FD_LOGEVENTS} # 将字符串"sending mail"写到文件描述符#7.
