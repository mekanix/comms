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
