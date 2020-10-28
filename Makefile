REGGAE_PATH = /usr/local/share/reggae
FQDN ?= example.com
SERVICES = letsencrypt https://github.com/mekanix/jail-letsencrypt \
	   ldap https://github.com/mekanix/jail-ldap \
	   mail https://github.com/mekanix/jail-mail \
	   coturn https://github.com/mekanix/jail-coturn \
	   jabber https://github.com/mekanix/jail-jabber \
	   znc https://github.com/mekanix/jail-znc \
	   webmail https://github.com/mekanix/jail-webmail \
	   nginx https://github.com/mekanix/jail-nginx

post_setup:
.for service url in ${SERVICES}
	@echo "FQDN = ${FQDN}" >>services/${service}/project.mk
.endfor
	@echo "/usr/cbsd/jails-data/letsencrypt-data/usr/local/etc/dehydrated/certs /etc/certs nullfs rw 0 0" >services/coturn/templates/fstab
	@echo "/usr/cbsd/jails-data/letsencrypt-data/usr/local/etc/dehydrated/certs /etc/certs nullfs rw 0 0" >services/ldap/templates/fstab
	@echo "/usr/cbsd/jails-data/letsencrypt-data/usr/local/etc/dehydrated/certs /etc/certs nullfs rw 0 0" >services/nginx/templates/fstab
	@echo "/usr/cbsd/jails-data/webmail-data/usr/local/www/rainloop /usr/local/www/rainloop nullfs rw 0 0" >>services/nginx/templates/fstab
	@echo "/usr/cbsd/jails-data/letsencrypt-data/usr/local/etc/dehydrated/certs /etc/certs nullfs rw 0 0" >services/mail/templates/fstab
	@echo "/usr/cbsd/jails-data/letsencrypt-data/usr/local/etc/dehydrated/certs /etc/certs nullfs rw 0 0" >services/jabber/templates/fstab

cron:
	@sudo bin/cron.sh

.include <${REGGAE_PATH}/mk/project.mk>
