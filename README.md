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
```

Next, create LDAP jail.
```
make service=ldap
```

If your jail is already accessible at `ldap.mydomain.com` (depends on your DHCP
and DNS setup), no action is needed in order to start using it, but if its FQDN
is something like `ldap.mymachine.mydomain.com` you can enter fake DNS entries
to make it work locally. In `services/ldap` directory run:
```
make fake_dns

```

If you want to remove the fake DNS entries later run:
```
make unfake_dns
```

Load LDAP data based on `services/ldap/examples`.

```
sudo cp -r services/ldap/examples $(jls -j ldap path)/root/ldap
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

Visit https://mail.mydomain.com?admin and use admin/12345 as user/pass.

## DNS Setup

| Type  | Record                 | Value                                                         |
|------:|:----------------------:|:--------------------------------------------------------------|
| A     | comms                  | IPv4                                                          |
| AAAA  | comms                  | IPv6                                                          |
| CNAME | smtp                   | comms.mydomain.com                                            |
| CNAME | imap                   | comms.mydomain.com                                            |
| CNAME | conference             | comms.mydomain.com                                            |
| CNAME | mail                   | comms.mydomain.com                                            |
| SRV   | \_stun.\_tcp           | 0 3478 comms.mydomain.com                                     |
| SRV   | \_stun.\_udp           | 0 3478 comms.mydomain.com                                     |
| SRV   | \_stuns.\_tcp          | 0 5349 comms.mydomain.com                                     |
| SRV   | \_stuns.\_udp          | 0 5349 comms.mydomain.com                                     |
| SRV   | \_turn.\_tcp           | 0 3478 comms.mydomain.com                                     |
| SRV   | \_turn.\_udp           | 0 3478 comms.mydomain.com                                     |
| SRV   | \_turns.\_tcp          | 0 5349 comms.mydomain.com                                     |
| SRV   | \_turns.\_udp          | 0 5349 comms.mydomain.com                                     |
| SRV   | \_xmpp-client.\_tcp    | 0 5222 comms.mydomain.com                                     |
| SRV   | \_xmpp-server.\_tcp    | 0 5269 comms.mydomain.com                                     |
| TXT   |                        | "v=spf1 mx ip4:IPv4 ip6:IPv6 include:mydomain.com -all"       |
| TXT   | mail.\_domainkey       | "v=DKIM1;k=rsa;p=..."                                         |
| TXT   | \_dmarc                | "v=DMARC1;p=reject;pct=100;rua=MAIL"                          |
| MX    |                        | comms.mydomain.com                                            |


## Per service/jail documentation

* [LDAP](https://github.com/mekanix/jail-ldap)
* [Mail](https://github.com/mekanix/jail-mail)
* [Jabber](https://github.com/mekanix/jail-jabber)
