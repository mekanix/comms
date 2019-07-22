REGGAE_PATH = /usr/local/share/reggae
FQDN ?= example.com
SERVICES = letsencrypt https://github.com/mekanix/jail-letsencrypt \
	   ldap https://github.com/mekanix/jail-ldap \
	   mail https://github.com/mekanix/jail-mail \
	   jabber https://github.com/mekanix/jail-jabber \
	   webmail https://github.com/mekanix/jail-webmail \
	   nginx https://github.com/mekanix/jail-nginx

post_setup:
.for service url in ${SERVICES}
	@echo "FQDN ?= ${FQDN}" >>services/${service}/vars.mk
.endfor
	@echo "/usr/cbsd/jails-data/letsencrypt-data/usr/local/etc/dehydrated/certs /etc/certs nullfs rw 0 0" >services/nginx/templates/fstab
	@echo "/usr/cbsd/jails-data/webmail-data/usr/local/www/rainloop /usr/local/www/rainloop nullfs rw 0 0" >>services/nginx/templates/fstab
	@echo "/usr/cbsd/jails-data/letsencrypt-data/usr/local/etc/dehydrated/certs /etc/certs nullfs rw 0 0" >services/jabber/templates/fstab

cron:
	@sudo bin/cron.sh

.include <${REGGAE_PATH}/mk/project.mk>
