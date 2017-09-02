.if exists(vars.mk)
.include <vars.mk>
.endif

.include <include.mk>


all: fetch setup
.if defined(jail)
	@echo "=== ${jail} ==="
	@${MAKE} ${MAKEFLAGS} -C projects/${jail}
.else
	@echo "=== letsencrypt ==="
	@${MAKE} ${MAKEFLAGS} -C projects/letsencrypt
	@echo
	@echo "=== ldap ==="
	@${MAKE} ${MAKEFLAGS} -C projects/ldap
	@echo
	@echo "=== mail ==="
	@${MAKE} ${MAKEFLAGS} -C projects/mail
	@echo
	@echo "=== webmail ==="
	@${MAKE} ${MAKEFLAGS} -C projects/webmail
	@echo
	@echo "=== web ==="
	@${MAKE} ${MAKEFLAGS} -C projects/web
	@echo
	@echo "=== webconsul ==="
	@${MAKE} ${MAKEFLAGS} -C projects/webconsul
.endif

up: fetch setup
.if defined(jail)
	@echo "=== ${jail} ==="
	@${MAKE} ${MAKEFLAGS} -C projects/${jail} up
.else
	@echo "=== letsencrypt ==="
	@${MAKE} ${MAKEFLAGS} -C projects/letsencrypt up
	@echo
	@echo "=== ldap ==="
	@${MAKE} ${MAKEFLAGS} -C projects/ldap up
	@echo
	@echo "=== mail ==="
	@${MAKE} ${MAKEFLAGS} -C projects/mail up
	@echo
	@echo "=== webmail ==="
	@${MAKE} ${MAKEFLAGS} -C projects/webmail up
	@echo
	@echo "=== web ==="
	@${MAKE} ${MAKEFLAGS} -C projects/web up
	@echo
	@echo "=== webconsul ==="
	@${MAKE} ${MAKEFLAGS} -C projects/webconsul up
.endif


init:
.if !exists(projects)
	@mkdir projects
.endif

fetch:
	@${MAKE} ${MAKEFLAGS} SUBPROJECT=letsencrypt fetch_subproject
	@${MAKE} ${MAKEFLAGS} SUBPROJECT=ldap fetch_subproject
	@${MAKE} ${MAKEFLAGS} SUBPROJECT=mail fetch_subproject
	@${MAKE} ${MAKEFLAGS} SUBPROJECT=web fetch_subproject
	@${MAKE} ${MAKEFLAGS} SUBPROJECT=webmail fetch_subproject
	@${MAKE} ${MAKEFLAGS} SUBPROJECT=webconsul fetch_subproject

fetch_subproject: init
.if !exists(projects/${SUBPROJECT})
	git clone https://github.com/mekanix/jail-${SUBPROJECT} projects/${SUBPROJECT}
.endif

setup:
	@${MAKE} ${MAKEFLAGS} SUBPROJECT=letsencrypt setup_subproject
	@${MAKE} ${MAKEFLAGS} SUBPROJECT=ldap setup_subproject
	@${MAKE} ${MAKEFLAGS} SUBPROJECT=mail setup_subproject
	@${MAKE} ${MAKEFLAGS} SUBPROJECT=web setup_subproject
	@${MAKE} ${MAKEFLAGS} SUBPROJECT=webmail setup_subproject
	@${MAKE} ${MAKEFLAGS} SUBPROJECT=webconsul setup_subproject

setup_subproject: fetch
	@rm -f projects/${SUBPROJECT}/vars.mk
	@echo ".if !defined(STAGE)" >>projects/${SUBPROJECT}/vars.mk
	@echo "STAGE=${STAGE}" >>projects/${SUBPROJECT}/vars.mk
	@echo ".endif" >>projects/${SUBPROJECT}/vars.mk
	@echo "" >>projects/${SUBPROJECT}/vars.mk
	@echo "" >>projects/${SUBPROJECT}/vars.mk
	@echo ".if !defined(UID)" >>projects/${SUBPROJECT}/vars.mk
	@echo "UID=${UID}" >>projects/${SUBPROJECT}/vars.mk
	@echo ".endif" >>projects/${SUBPROJECT}/vars.mk
	@echo "" >>projects/${SUBPROJECT}/vars.mk
	@echo ".if !defined(GID)" >>projects/${SUBPROJECT}/vars.mk
	@echo "GID=${GID}" >>projects/${SUBPROJECT}/vars.mk
	@echo ".endif" >>projects/${SUBPROJECT}/vars.mk
	@echo "" >>projects/${SUBPROJECT}/vars.mk

destroy:
.if defined(jail)
	@${MAKE} ${MAKEFLAGS} -C projects/${jail} destroy
.else
	@${MAKE} ${MAKEFLAGS} -C projects/webconsul destroy
	@${MAKE} ${MAKEFLAGS} -C projects/web destroy
	@${MAKE} ${MAKEFLAGS} -C projects/webmail destroy
	@${MAKE} ${MAKEFLAGS} -C projects/mail destroy
	@${MAKE} ${MAKEFLAGS} -C projects/ldap destroy
	@${MAKE} ${MAKEFLAGS} -C projects/letsencrypt destroy
.endif

login:
	@${MAKE} ${MAKEFLAGS} -C projects/${jail} login

down: setup
.if defined(jail)
	@${MAKE} ${MAKEFLAGS} -C projects/${jail} down
.else
	@${MAKE} ${MAKEFLAGS} -C projects/webconsul down
	@${MAKE} ${MAKEFLAGS} -C projects/web down
	@${MAKE} ${MAKEFLAGS} -C projects/webmail down
	@${MAKE} ${MAKEFLAGS} -C projects/mail down
	@${MAKE} ${MAKEFLAGS} -C projects/ldap down
	@${MAKE} ${MAKEFLAGS} -C projects/letsencrypt down
.endif
