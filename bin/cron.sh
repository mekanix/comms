#!/bin/sh

/usr/local/bin/cbsd jstart letsencrypt
/usr/local/bin/cbsd jexec jname=letsencrypt /usr/local/bin/letsencrypt_update.sh
/usr/local/bin/cbsd jstop letsencrypt
/usr/local/bin/cbsd jexec jname=nginx /usr/sbin/service nginx reload
