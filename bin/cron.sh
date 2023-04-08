#!/bin/sh

/usr/local/bin/reggae start letsencrypt
/usr/local/bin/reggae jexec letsencrypt /usr/local/bin/letsencrypt_update.sh
/usr/local/bin/reggae stop letsencrypt

/usr/local/bin/reggae jexec ldap /usr/local/bin/update_certs.sh
/usr/local/bin/reggae jexec jabber /usr/local/bin/update_certs.sh
/usr/local/bin/reggae jexec mail /usr/sbin/service postfix reload
/usr/local/bin/reggae jexec mail /usr/sbin/service dovecot reload
/usr/local/bin/reggae jexec nginx /usr/sbin/service nginx reload
