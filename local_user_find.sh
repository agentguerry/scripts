#!/bin/bash                                                                                                                                                                                                        
#This script will check for local accounts on the servers specified by $WCOLL                                                                                                                                      
# Run the file as ./filename hostlist                                                                                                                                                                                                                   
export WCOLL=$1                                                                                                                                                                                                    
pdsh -R ssh "dzdo egrep 'bash|zsh' /etc/passwd|grep -v fake|grep home|grep -v master_ref" | uniq| sort                                                                                                         
exit 0
#
