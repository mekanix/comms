DOMAIN?=example.com
STAGE?=prod
UID?=1001
GID?=1001
SERVICE_NAMES=${SERVICES:N*github*}
SERVICE_URLS=${SERVICES:M*github*}

all: fetch setup
.if defined(service)
	@echo "=== ${service} ==="
	@${MAKE} ${MAKEFLAGS} -C services/${service}
.else
.for service in ${SERVICE_NAMES}
	@echo "=== ${service} ==="
	@${MAKE} ${MAKEFLAGS} -C services/${service}
.endfor
.endif

up: fetch setup
.if defined(service)
	@echo "=== ${service} ==="
	@${MAKE} ${MAKEFLAGS} -C services/${service} up
.else
.for service in ${SERVICE_NAMES}
	@echo "=== ${service} ==="
	@${MAKE} ${MAKEFLAGS} -C services/${service} up
.endfor
.endif


init:
.if !exists(services)
	@mkdir services
.endif

fetch:
.for service in ${SERVICE_NAMES}
.if !exists(services/${service})
	git clone https://github.com/mekanix/jail-${service} services/${service}
.endif
.endfor

setup:
.for service in ${SERVICE_NAMES}
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
.if defined(service)
	@${MAKE} ${MAKEFLAGS} -C services/${service} destroy
.else
.for service in ${SERVICE_NAMES}
	@${MAKE} ${MAKEFLAGS} -C services/${service} destroy
.endfor
.endif

login:
	@${MAKE} ${MAKEFLAGS} -C services/${service} login

down: setup
.if defined(service)
	@${MAKE} ${MAKEFLAGS} -C services/${service} down
.else
.for service in ${SERVICE_NAMES}
	@${MAKE} ${MAKEFLAGS} -C services/${service} down
.endfor
.endif
