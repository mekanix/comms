REGGAE_PATH = /usr/local/share/reggae
FQDN ?= example.com
SERVICES = letsencrypt https://github.com/mekanix/jail-letsencrypt \
	   ldap https://github.com/mekanix/jail-ldap \
	   mail https://github.com/mekanix/jail-mail \
	   jabber https://github.com/mekanix/jail-jabber \
	   webmail https://github.com/mekanix/jail-webmail \
	   nginx https://github.com/mekanix/jail-nginx

pre_up:
.for service url in ${SERVICES}
	@echo "FQDN ?= ${FQDN}" >>services/${service}/vars.mk
.endfor

cron:
	@sudo bin/cron.sh

.include <${REGGAE_PATH}/mk/project.mk>
