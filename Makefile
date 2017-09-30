REGGAE_PATH = /usr/local/share/reggae
SERVICES = letsencrypt https://github.com/mekanix/jail-letsencrypt \
	   ldap https://github.com/mekanix/jail-ldap \
	   mail https://github.com/mekanix/jail-mail \
	   jabber https://github.com/mekanix/jail-jabber \
	   webmail https://github.com/mekanix/jail-webmail \
	   web https://github.com/mekanix/jail-web \
	   webconsul https://github.com/mekanix/jail-webconsul
DOMAIN=lust4trust.com

.include <${REGGAE_PATH}/mk/project.mk>
