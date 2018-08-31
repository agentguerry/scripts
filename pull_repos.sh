#!/bin/bash
# Pull down repository updates from Red Hat
# Need to install createrepo and yum-utils before use.
# Need to subscribe and enable repos before use also.
# Set "download_dir" to you repository path.
# Added this line on 6/21/17 to make backup of previous repo log file.
echo "Backing up old reposync log"
mv -v /var/log/reposync.log /var/log/reposync.`date +%m%d%y`.log

download_dir="/data/reposync"

/usr/bin/reposync --gpgcheck -m --download-metadata -l -p ${download_dir}/ >> /var/log/reposync.log 2>&1

for dirname in `find ${download_dir} -maxdepth 1 -mindepth 1 -type d`; do
  echo $dirname: | tee -a /var/log/reposync.log
	if [ -f "${dirname}/comps.xml" ]; then
		cp ${dirname}/comps.xml ${dirname}/Packages/ >> /var/log/reposync.log 2>&1
		createrepo  --update -p --workers 2 -g ${dirname}/Packages/comps.xml ${dirname} >> /var/log/reposync.log 2>&1
	else
		createrepo  --update -p --workers 2 ${dirname}/ >> /var/log/reposync.log 2>&1
	fi	
	set -o pipefail 
	updateinfo=$(ls -1t  ${dirname}/*-updateinfo.xml.gz 2>/dev/null | head -1 ) 
	if [[ -f $updateinfo  &&  $? -eq 0 ]]; then
		echo "Updating errata information for ${dirname}" >> /var/log/reposync.log 2>&1
		\cp $updateinfo ${dirname}/updateinfo.xml.gz  >> /var/log/reposync.log 2>&1
		gunzip -df ${dirname}/updateinfo.xml.gz  >> /var/log/reposync.log 2>&1
		modifyrepo ${dirname}/updateinfo.xml ${dirname}/repodata/  >> /var/log/reposync.log 2>&1
	else
		echo "No errata information to be processed for ${dirname}" >> /var/log/reposync.log 2>&1
	fi
done
# Adding this line to provide new packages that are going to be installed.
# This list will then be emailed to the SE team.
grep -i downloading /var/log/reposync.log | awk '{print $7}' > /tmp/new_updates_`date +%m%d%y`
chmod -R 755 /data/reposync
mail -s "Yum Updates for `date +%m%d%y`" user@domain.com,user2@domain.com  < /tmp/new_updates_`date +%m%d%y`
