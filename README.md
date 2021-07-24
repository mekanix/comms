# FreeBSD / CBSD / Reggae based mail server

## Building / Configuring Services

```
echo 'FQDN = mydomain.com' >>vars.mk
make service=letsencrypt
make login service=letsencrypt
```

Edit /usr/local/etc/letsencrypt_domains.txt. You'll aready have an example as
Ansible will create that file only if it doesn't exist and poppulate it with
fake data.

```
letsencrypt_update.sh
logout
make service=ldap
```

LDAP data based on `services/ldap/examples`.

```
sudo cp -r services/ldap/examples /usr/cbsd/jails-data/ldap-data/root/ldap
make login service=ldap
sed -e 's/DOMAIN/mydomain.com/g' ldap/domain.ldif >mydomain.com.ldif
sed -e 's/DOMAIN/mydomain.com/g' -e 's/USER/beastie/g' -e 's/FIRST/Bea/g' -e 's/LAST/Stie/g' ldap/user.ldif >beastie@mydomain.com.ldif
ldapadd -W -D cn=root,dc=ldap -f ldap/top.ldif
ldapadd -W -D cn=root,dc=ldap -f mydomain.com.ldif
ldapadd -W -D cn=root,dc=ldap -f beastie@mydomain.com.ldif
ldappasswd -W -D cn=root,dc=ldap uid=beastie,ou=mydomain.com,dc=ldap
```

Build all other services:
```
make
```
**Don't forget to configure cron to run `bin/cron.sh`!**

If you want to test it on your local machine, run this as root:

```
echo `cbsd jget jname=mail ip4_addr | cut -f 2 -d ' '` imap.mydomain.com smtp.mydomain.com >>/etc/hosts
echo `cbsd jget jname=jabber ip4_addr | cut -f 2 -d ' '` mydomain.com >>/etc/hosts
echo `cbsd jget jname=nginx ip4_addr | cut -f 2 -d ' '` mail.mydomain.com >>/etc/hosts
```

Visit https://mail.mydomain.com?admin and use admin/12345 as user/pass.

## DNS Setup

| Type  | Record                 | Value                                              |
|------:|:----------------------:|:---------------------------------------------------|
| A     | comms                  | IP                                                 |
| CNAME | smtp                   | comms.mydomain.com                                 |
| CNAME | imap                   | comms.mydomain.com                                 |
| CNAME | conference             | comms.mydomain.com                                 |
| CNAME | mail                   | comms.mydomain.com                                 |
| SRV   | \_stun.\_tcp           | 0 3478 comms.mydomain.com                          |
| SRV   | \_stun.\_udp           | 0 3478 comms.mydomain.com                          |
| SRV   | \_stuns.\_tcp          | 0 5349 comms.mydomain.com                          |
| SRV   | \_stuns.\_udp          | 0 5349 comms.mydomain.com                          |
| SRV   | \_turn.\_tcp           | 0 3478 comms.mydomain.com                          |
| SRV   | \_turn.\_udp           | 0 3478 comms.mydomain.com                          |
| SRV   | \_turns.\_tcp          | 0 5349 comms.mydomain.com                          |
| SRV   | \_turns.\_udp          | 0 5349 comms.mydomain.com                          |
| SRV   | \_xmpp-client.\_tcp    | 0 5222 comms.mydomain.com                          |
| SRV   | \_xmpp-server.\_tcp    | 0 5269 comms.mydomain.com                          |
| TXT   |                        | "v=spf1 mx ip4:IP include:mydomain.com -all"       |
| TXT   | mail.\_domainkey       | "v=DKIM1;k=rsa;p=..."                              |
| TXT   | \_dmarc                | "v=DMARC1;p=reject;pct=100;rua=MAIL"               |
| MX    |                        | comms.mydomain.com                                 |


## Per service/jail documentation

* [LDAP](https://github.com/mekanix/jail-ldap)
* [Mail](https://github.com/mekanix/jail-mail)
* [Jabber](https://github.com/mekanix/jail-jabber)
