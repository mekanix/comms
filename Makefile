.if exists(vars.mk)
.include <vars.mk>
.endif

.include <include.mk>

SERVICES = letsencrypt \
	    ldap \
	    mail \
	    jabber \
	    webmail \
	    web \
	    webconsul


all: fetch setup
.if defined(jail)
	@echo "=== ${jail} ==="
	@${MAKE} ${MAKEFLAGS} -C services/${jail}
.else
.for service in ${SERVICES}
	@echo "=== ${service} ==="
	@${MAKE} ${MAKEFLAGS} -C services/${service}
.endfor
.endif

up: fetch setup
.if defined(jail)
	@echo "=== ${jail} ==="
	@${MAKE} ${MAKEFLAGS} -C services/${jail} up
.else
.for service in ${SERVICES}
	@echo "=== ${service} ==="
	@${MAKE} ${MAKEFLAGS} -C services/${service} up
.endfor
.endif


init:
.if !exists(services)
	@mkdir services
.endif

fetch:
.for service in ${SERVICES}
.if !exists(services/${service})
	git clone https://github.com/mekanix/jail-${service} services/${service}
.endif
.endfor

setup:
.for service in ${SERVICES}
	@rm -f services/${service}/vars.mk
	@echo ".if !defined(STAGE)" >>services/${service}/vars.mk
	@echo "STAGE=${STAGE}" >>services/${service}/vars.mk
	@echo ".endif" >>services/${service}/vars.mk
	@echo "" >>services/${service}/vars.mk
	@echo "" >>services/${service}/vars.mk
	@echo ".if !defined(UID)" >>services/${service}/vars.mk
	@echo "UID=${UID}" >>services/${service}/vars.mk
	@echo ".endif" >>services/${service}/vars.mk
	@echo "" >>services/${service}/vars.mk
	@echo ".if !defined(GID)" >>services/${service}/vars.mk
	@echo "GID=${GID}" >>services/${service}/vars.mk
	@echo ".endif" >>services/${service}/vars.mk
	@echo "" >>services/${service}/vars.mk
.endfor

destroy:
.if defined(jail)
	@${MAKE} ${MAKEFLAGS} -C services/${jail} destroy
.else
.for service in ${SERVICES}
	@${MAKE} ${MAKEFLAGS} -C services/${service} destroy
.endfor
.endif

login:
	@${MAKE} ${MAKEFLAGS} -C services/${jail} login

down: setup
.if defined(jail)
	@${MAKE} ${MAKEFLAGS} -C services/${jail} down
.else
.for service in ${SERVICES}
	@${MAKE} ${MAKEFLAGS} -C services/${service} down
.endfor
.endif
