REGGAE_PATH = /usr/local/share/reggae
FQDN ?= example.com
USE = letsencrypt ldap redis rspamd cyrus postfix ejabberd znc webmail radicale nginx
.include <${REGGAE_PATH}/mk/use.mk>

BACKEND != reggae get-config BACKEND
CBSD_WORKDIR != sysrc -s cbsd -n cbsd_workdir 2>/dev/null || true

post_setup:
.for service url in ${ALL_SERVICES}
	@echo "FQDN = ${FQDN}" >>services/${service}/project.mk
	@echo "DHCP ?= ${DHCP}" >>services/${service}/project.mk
.if defined(VERSION)
	@echo "VERSION = ${FQDN}" >>services/${service}/project.mk
.endif
.endfor
.if ${BACKEND} == base
	@echo "\$${base}/letsencrypt/usr/local/etc/dehydrated/certs \$${path}/etc/certs nullfs rw 0 0" >services/ldap/templates/fstab
	@echo "\$${base}/letsencrypt/usr/local/etc/dehydrated/certs \$${path}/etc/certs nullfs rw 0 0" >services/nginx/templates/fstab
	@echo "\$${base}/mail/usr/home/mlmmj/webarchive \$${path}/usr/local/www/webarchive nullfs rw 0 0" >>services/nginx/templates/fstab
	@echo "\$${base}/webmail/usr/local/www/rainloop \$${path}/usr/local/www/rainloop nullfs rw 0 0" >>services/nginx/templates/fstab
	@echo "\$${base}/letsencrypt/usr/local/etc/dehydrated/certs \$${path}/etc/certs nullfs rw 0 0" >services/cyrus/templates/fstab
	@echo "\$${base}/letsencrypt/usr/local/etc/dehydrated/certs \$${path}/etc/certs nullfs rw 0 0" >services/postfix/templates/fstab
	@echo "\$${base}/letsencrypt/usr/local/etc/dehydrated/certs \$${path}/etc/certs nullfs rw 0 0" >services/ejabberd/templates/fstab
.elif ${BACKEND} == cbsd
	@echo "${CBSD_WORKDIR}/jails-data/letsencrypt-data/usr/local/etc/dehydrated/certs /etc/certs nullfs rw 0 0" >services/ldap/templates/fstab
	@echo "${CBSD_WORKDIR}/jails-data/letsencrypt-data/usr/local/etc/dehydrated/certs /etc/certs nullfs rw 0 0" >services/nginx/templates/fstab
	@echo "${CBSD_WORKDIR}/jails-data/mail-data/usr/home/mlmmj/webarchive /usr/local/www/webarchive nullfs rw 0 0" >>services/nginx/templates/fstab
	@echo "${CBSD_WORKDIR}/jails-data/webmail-data/usr/local/www/rainloop /usr/local/www/rainloop nullfs rw 0 0" >>services/nginx/templates/fstab
	@echo "${CBSD_WORKDIR}/jails-data/letsencrypt-data/usr/local/etc/dehydrated/certs /etc/certs nullfs rw 0 0" >services/mail/templates/fstab
	@echo "${CBSD_WORKDIR}/jails-data/letsencrypt-data/usr/local/etc/dehydrated/certs /etc/certs nullfs rw 0 0" >services/cyrus/templates/fstab
	@echo "${CBSD_WORKDIR}/jails-data/letsencrypt-data/usr/local/etc/dehydrated/certs /etc/certs nullfs rw 0 0" >services/postfix/templates/fstab
	@echo "${CBSD_WORKDIR}/jails-data/letsencrypt-data/usr/local/etc/dehydrated/certs /etc/certs nullfs rw 0 0" >services/ejabberd/templates/fstab
.endif

cron:
	@sudo bin/cron.sh

.include <${REGGAE_PATH}/mk/project.mk>
