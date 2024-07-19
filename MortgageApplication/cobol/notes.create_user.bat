#!/bin/sh
#new user <ID>
# create a new racf user to tso and omvs with ssh key init
# manual steps:
#  - for optional ssh access, add users local public ssh key to /u/$uid/.ssh/authorized_keys
#    local cli  >  ssh-keygen -t rsa -b 4096
#  - for 3270 tls 2.1 on port 922, use IDz 3270 or zoc  - pcom needs a cert
#  - use 3270 tso login to reset temp password sys1i
#  - for vscode use rseapi with racf user $uid and new password sys1
#  - zoc @ https://www.emtec.com/download.html#zocfiles
# reset passwd > tsocmd 'ALTUSER user02 PASSWORD(sys1)'
# arg: $1 = user id to create
. /etc/profile
 
uid=$1
if [ -z "$1" ]; then
  echo "newuser.sh: Error: Miss missing new RAFC ID argument."
  pause
  exit
fi  
echo "***                          newuser.sh (beta) started                           ***"
echo "***     Creating OMVS,TSO and SSH keys for RACF user $uid in home /u"
echo "***     temp RACF password is sys1. Use 3270 to reset it."
echo " ***"
sleep 1
 
 
tsocmd "AU  $uid NAME(wass_$uid) PASSWORD(SYS1) OWNER(IBMUSER)  TSO(ACCTNUM(ACCT001) PROC(PROC001) JOBCLASS(A) MSGCLASS(H) )  "
tsocmd "ALU $uid OMVS(AUTOUID HOME("/u/$uid") PROGRAM(/bin/sh) AUTOUID)  "
tsocmd "PE  PROC001 CLASS(TSOPROC) ID($uid) ACCESS(READ)"          
tsocmd "PE  ACCT001 CLASS(ACCTNUM) ID($uid) ACCESS(READ)"          
tsocmd "SETROPTS RACLIST(TSOPROC ACCTNUM) REFRESH "          
tsocmd "lu $uid tso,omvs"
 
mkdir -p /u/$uid/.ssh
touch /u/$uid/.ssh/authorized_keys
ssh-keygen  -t rsa -b 4096 -C "$uid@ibm.com"  -f "/u/$uid/.ssh/id_rsa" -q -N ""          
 
chown -R $uid /u/$uid
chmod -R 700 /u/$uid/.ssh
 
ls -las /u/$uid
echo " ***"
 
#  ref
# tsocmd "RDEFINE SURROGAT BPX.SRV.$uid  UACC(READ) "          
# tsocmd "SETROPTS RACLIST(SURROGAT) REFRESH                    "          

		SSH and Telnet Client for Windows and macOS - Download our Telnet Client ZOC and Other Software
	
ZOC is a SHH/telnet client and terminal emulator for Windows and macOS. Download this telnet and client and other communications software by Emtec - free trial versions are available.