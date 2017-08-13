.if exists(vars.mk)
.include <vars.mk>
.endif

.include <include.mk>


all: fetch setup
.if defined(jail)
	@echo "=== ${jail} ==="
	@${MAKE} ${MAKEFLAGS} -C projects/${jail}
.else
	@echo "=== mail ==="
	@${MAKE} ${MAKEFLAGS} -C projects/mail
	@echo
	@echo "=== web ==="
	@${MAKE} ${MAKEFLAGS} -C projects/web
	@echo
	@echo "=== webmail ==="
	@${MAKE} ${MAKEFLAGS} -C projects/webmail
	@${MAKE} ${MAKEFLAGS} -C projects/webmail web
	@${MAKE} ${MAKEFLAGS} -C projects/webmail sync_static
.endif

up: fetch setup
.if defined(jail)
	@echo "=== ${jail} ==="
	@${MAKE} ${MAKEFLAGS} -C projects/${jail} up
.else
	@echo "=== mail ==="
	@${MAKE} ${MAKEFLAGS} -C projects/mail up
	@echo
	@echo "=== web ==="
	@${MAKE} ${MAKEFLAGS} -C projects/web up
	@echo
	@echo "=== webmail ==="
	@${MAKE} ${MAKEFLAGS} -C projects/webmail up
	@${MAKE} ${MAKEFLAGS} -C projects/webmail web up
	@${MAKE} ${MAKEFLAGS} -C projects/webmail sync_static up
.endif


init:
.if !exists(projects)
	@mkdir projects
.endif

fetch:
	@${MAKE} ${MAKEFLAGS} SUBPROJECT=mail fetch_subproject
	@${MAKE} ${MAKEFLAGS} SUBPROJECT=web fetch_subproject
	@${MAKE} ${MAKEFLAGS} SUBPROJECT=webmail fetch_subproject

fetch_subproject: init
.if !exists(projects/${SUBPROJECT})
	git clone https://github.com/mekanix/jail-${SUBPROJECT} projects/${SUBPROJECT}
.endif

setup:
	@${MAKE} ${MAKEFLAGS} SUBPROJECT=mail setup_subproject
	@${MAKE} ${MAKEFLAGS} SUBPROJECT=web setup_subproject
	@${MAKE} ${MAKEFLAGS} SUBPROJECT=webmail setup_subproject

setup_subproject: fetch
	@rm -f projects/${SUBPROJECT}/vars.mk
	@echo ".if !defined(STAGE)" >>projects/${SUBPROJECT}/vars.mk
	@echo "STAGE=${STAGE}" >>projects/${SUBPROJECT}/vars.mk
	@echo ".endif" >>projects/${SUBPROJECT}/vars.mk
	@echo "" >>projects/${SUBPROJECT}/vars.mk
	@echo ".if !defined(DOMAIN)" >>projects/${SUBPROJECT}/vars.mk
	@echo "DOMAIN=${DOMAIN}" >>projects/${SUBPROJECT}/vars.mk
	@echo ".endif" >>projects/${SUBPROJECT}/vars.mk
	@echo "" >>projects/${SUBPROJECT}/vars.mk
	@echo ".if !defined(UID)" >>projects/${SUBPROJECT}/vars.mk
	@echo "UID=${UID}" >>projects/${SUBPROJECT}/vars.mk
	@echo ".endif" >>projects/${SUBPROJECT}/vars.mk
	@echo "" >>projects/${SUBPROJECT}/vars.mk
	@echo ".if !defined(GID)" >>projects/${SUBPROJECT}/vars.mk
	@echo "GID=${GID}" >>projects/${SUBPROJECT}/vars.mk
	@echo ".endif" >>projects/${SUBPROJECT}/vars.mk
	@echo "" >>projects/${SUBPROJECT}/vars.mk

destroy: down
.if defined(jail)
	@${MAKE} ${MAKEFLAGS} -C projects/${jail} destroy
.else
	@${MAKE} ${MAKEFLAGS} -C projects/mail destroy
	@${MAKE} ${MAKEFLAGS} -C projects/web destroy
	@${MAKE} ${MAKEFLAGS} -C projects/webmail destroy
.endif

login:
	@${MAKE} ${MAKEFLAGS} -C projects/${jail} login

down: setup
.if defined(jail)
	@${MAKE} ${MAKEFLAGS} -C projects/${jail} down
.else
	@${MAKE} ${MAKEFLAGS} -C projects/mail down
	@${MAKE} ${MAKEFLAGS} -C projects/web down
	@${MAKE} ${MAKEFLAGS} -C projects/webmail down
.endif
