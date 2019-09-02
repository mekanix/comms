# FreeBSD / CBSD / Reggae based mail server


```
echo 'FQDN = mydomain.com' >>vars.mk
make service=letsencrypt
make login service=letsencrypt
```

Edit /usr/local/etc/letsencrypt_domains.txt. You'll aready have an example as
Ansible will create that file only if it doesn't exist, and poppulate it with
fake data.

```
letsencrypt_update.sh
logout
make
```

LDAP data based on `services/mail/ldap`.

```
sudo cp -r services/mail/ldap /usr/cbsd/jails-data/ldap-data/root/
make login service=ldap
sed -e 's/DOMAIN/mydomain.com/g' ldap/domain.ldif >mydomain.com.ldif
sed -e 's/DOMAIN/mydomain.com/g' -e 's/USER/beastie/g' -e 's/FIRST/Bea/g' -e 's/LAST/Stie/g' ldap/user.ldif >beastie@mydomain.com.ldif
ldapadd -W -D cn=root,dc=ldap -f ldap/top.ldif
ldapadd -W -D cn=root,dc=ldap -f mydomain.com.ldif
ldapadd -W -D cn=root,dc=ldap -f beastie@mydomain.com.ldif
ldappasswd -W -D cn=root,dc=ldap uid=beastie,ou=mydomain.com,dc=ldap
```

If you want to test it on your local machine, run this as root:
            
```
echo `cbsd jget jname=mail ip4_addr | cut -f 2 -d ' '` imap.mydomain.com smtp.mydomain.com >>/etc/hosts
echo `cbsd jget jname=jabber ip4_addr | cut -f 2 -d ' '` mydomain.com >>/etc/hosts
echo `cbsd jget jname=nginx ip4_addr | cut -f 2 -d ' '` mail.mydomain.com >>/etc/hosts
```

Visit https://mail.mydomain.com?admin and use admin/12345 as user/pass.

## DNS Setup
| Type  | Record                 | Value                                             |
|------:|:----------------------:|:--------------------------------------------------|
| A     | comms                  | IP                                                |
| CNAME | lists                  | comms.example.com                                 |
| CNAME | smtp                   | comms.example.com                                 |
| CNAME | imap                   | comms.example.com                                 |
| CNAME | conference             | comms.example.com                                 |
| CNAME | mail                   | comms.example.com                                 |
| SRV   | \_xmpp-client.\_tcp    | 0 5222 comms.example.com                          |
| SRV   | \_xmpp-server.\_tcp    | 0 5269 comms.example.com                          |
| TXT   | lists                  | "v=spf1 mx ip4:IP include:lists.example.com -all" |
| TXT   |                        | "v=spf1 mx ip4:IP include:example.com -all"       |
| TXT   | mail.\_domainkey.lists | "v=DKIM1;k=rsa;p=..."                             |
| TXT   | mail.\_domainkey       | "v=DKIM1;k=rsa;p=..."                             |
| TXT   | \_dmarc.lists          | "v=DMARC1;p=reject;pct=100;rua=MAIL"              |
| TXT   | \_dmarc                | "v=DMARC1;p=reject;pct=100;rua=MAIL"              |
| MX    | lists                  | comms.example.com                                 |
| MX    |                        | comms.example.com                                 |
