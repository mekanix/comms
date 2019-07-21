REGGAE_PATH = /usr/local/share/reggae
DOMAIN ?= example.com
SERVICES = letsencrypt https://github.com/mekanix/jail-letsencrypt \
	   ldap https://github.com/mekanix/jail-ldap \
	   mail https://github.com/mekanix/jail-mail \
	   jabber https://github.com/mekanix/jail-jabber \
	   webmail https://github.com/mekanix/jail-webmail \
	   nginx https://github.com/mekanix/jail-nginx

pre_up:
	echo ${DOMAIN}

.include <${REGGAE_PATH}/mk/project.mk>
