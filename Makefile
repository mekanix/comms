REGGAE_PATH = /usr/local/share/reggae
FQDN ?= example.com
USE = letsencrypt ldap redis mail turn jabber znc webmail nginx
.include <${REGGAE_PATH}/mk/use.mk>

BACKEND != reggae get-config BACKEND
BASE_WORKDIR != reggae get-config BASE_WORKDIR
CBSD_WORKDIR != sysrc -s cbsd -n cbsd_workdir

post_setup:
.for service url in ${ALL_SERVICES}
	@echo "FQDN = ${FQDN}" >>services/${service}/project.mk
.endfor
.if ${BACKEND} == base
	@echo "${BASE_WORKDIR}/letsencrypt/usr/local/etc/dehydrated/certs \$${path}/etc/certs nullfs rw 0 0" >services/ldap/templates/fstab
	@echo "${BASE_WORKDIR}/letsencrypt/usr/local/etc/dehydrated/certs \$${path}/etc/certs nullfs rw 0 0" >services/turn/templates/fstab
	@echo "${BASE_WORKDIR}/letsencrypt/usr/local/etc/dehydrated/certs \$${path}/etc/certs nullfs rw 0 0" >services/nginx/templates/fstab
	@echo "${BASE_WORKDIR}/mail/usr/home/mlmmj/webarchive \$${path}/usr/local/www/webarchive nullfs rw 0 0" >>services/nginx/templates/fstab
	@echo "${BASE_WORKDIR}/webmail/usr/local/www/rainloop \$${path}/usr/local/www/rainloop nullfs rw 0 0" >>services/nginx/templates/fstab
	@echo "${BASE_WORKDIR}/letsencrypt/usr/local/etc/dehydrated/certs \$${path}/etc/certs nullfs rw 0 0" >services/mail/templates/fstab
	@echo "${BASE_WORKDIR}/letsencrypt/usr/local/etc/dehydrated/certs \$${path}/etc/certs nullfs rw 0 0" >services/jabber/templates/fstab
.elif ${BACKEND} == cbsd
	@echo "${CBSD_WORKDIR}/jails-data/letsencrypt-data/usr/local/etc/dehydrated/certs /etc/certs nullfs rw 0 0" >services/ldap/templates/fstab
	@echo "${CBSD_WORKDIR}/jails-data/letsencrypt-data/usr/local/etc/dehydrated/certs /etc/certs nullfs rw 0 0" >services/turn/templates/fstab
	@echo "${CBSD_WORKDIR}/jails-data/letsencrypt-data/usr/local/etc/dehydrated/certs /etc/certs nullfs rw 0 0" >services/nginx/templates/fstab
	@echo "${CBSD_WORKDIR}/jails-data/mail-data/usr/home/mlmmj/webarchive /usr/local/www/webarchive nullfs rw 0 0" >>services/nginx/templates/fstab
	@echo "${CBSD_WORKDIR}/jails-data/webmail-data/usr/local/www/rainloop /usr/local/www/rainloop nullfs rw 0 0" >>services/nginx/templates/fstab
	@echo "${CBSD_WORKDIR}/jails-data/letsencrypt-data/usr/local/etc/dehydrated/certs /etc/certs nullfs rw 0 0" >services/mail/templates/fstab
	@echo "${CBSD_WORKDIR}/jails-data/letsencrypt-data/usr/local/etc/dehydrated/certs /etc/certs nullfs rw 0 0" >services/jabber/templates/fstab
.endif

cron:
	@sudo bin/cron.sh

.include <${REGGAE_PATH}/mk/project.mk>
