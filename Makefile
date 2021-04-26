REGGAE_PATH = /usr/local/share/reggae
FQDN ?= example.com
USE = letsencrypt ldap redis mail coturn jabber znc webmail nginx
.include <${REGGAE_PATH}/mk/use.mk>

post_setup:
.for service url in ${ALL_SERVICES}
	@echo "FQDN = ${FQDN}" >>services/${service}/project.mk
.endfor
	@echo "/usr/cbsd/jails-data/letsencrypt-data/usr/local/etc/dehydrated/certs /etc/certs nullfs rw 0 0" >services/ldap/templates/fstab
	@echo "/usr/cbsd/jails-data/letsencrypt-data/usr/local/etc/dehydrated/certs /etc/certs nullfs rw 0 0" >services/coturn/templates/fstab
	@echo "/usr/cbsd/jails-data/letsencrypt-data/usr/local/etc/dehydrated/certs /etc/certs nullfs rw 0 0" >services/nginx/templates/fstab
	@echo "/usr/cbsd/jails-data/webmail-data/usr/local/www/rainloop /usr/local/www/rainloop nullfs rw 0 0" >>services/nginx/templates/fstab
	@echo "/usr/cbsd/jails-data/letsencrypt-data/usr/local/etc/dehydrated/certs /etc/certs nullfs rw 0 0" >services/mail/templates/fstab
	@echo "/usr/cbsd/jails-data/letsencrypt-data/usr/local/etc/dehydrated/certs /etc/certs nullfs rw 0 0" >services/jabber/templates/fstab

cron:
	@sudo bin/cron.sh

.include <${REGGAE_PATH}/mk/project.mk>
