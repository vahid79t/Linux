#permanent DNS
sudo apt install resolvconf

sudo systemctl start resolvconf.service
sudo systemctl enable resolvconf.service
sudo systemctl status resolvconf.service

nano /etc/resolvconf/resolv.conf.d/head 

sudo systemctl restart resolvconf.service
sudo systemctl restart systemd-resolved.service

resolvconf -u
nano /etc/resolv.conf 

systemd-resolve --status | grep 'DNS Servers' -A2
resolvectl status | grep "DNS Server" -A2




apt install bind9 bind9utils
/etc/hosts

127.0.0.1 localhost
127.0.1.1 srv2.vahid.com srv2
192.168.1.56 srv2.vahid.com srv2
--------------------------------------------------------ubuntu
name.conf.options::::::::::
recursion yes;
listen-on {192.168.1.56;};
allow-transfer {none;};
forwarders{8.8.8.8;};

name.conf.local::::::::::::
zone "vahid.com" IN {
    type master;
    file "/etc/bind/db.vahid.com";
};

zone "1.168.192.in-addr.arpa" IN{
    type master;
    file "etc/bind/db.1.168.192";
};

named-checkconf
db.vahid.com:::::::::::::::

$TTL    2d
$ORIGIN vahid.com.
@       IN      SOA     ns1.vahid.com. root.vahid.com. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                          86400 )       ; Negative Cache TTL
;Name Server Information
@       IN      NS      ns1.vahid.com.
;IP Address for Name Servers
;Mail Server MX (Mail Exchanger) Record
@       IN      MX      10      mail.example.com

;A Record for the Following Host Name
ns1     IN      A      192.168.1.56
www     IN      A      192.168.1.56
mail     IN      A      192.168.1.56
;#CNAME  IN  A  ftp.example.com


named-checkzone  vahid.com   db.vahid.com
------------------------------------------------------------------------------------------------------------
db.0.1.168.192::::::::::::::::::::
185.235.41.133

;
; BIND reverse data file for local loopback interface
;
$TTL    2d
@       IN      SOA     ns1.vahid.com. root.vahid.com. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      ns1.vahid.com.
56   IN      PTR     ns1.vahid.com.
56   IN      PTR     www.vahid.com.
56   IN      PTR     mail.vahid.com.


named-checkzone 1.168.192.in-addr.arpa   db.1.168.192

---------------------------------------------------------------------------------------------------------------
sudo service bind9 restart

nslookup www.vahid.com

sudo rm resolve.conf

sudo ln  -sf /run/systemd/resolve/resolv.conf  /etc/resolv.conf

/etc/nsswitch.conf:::::::
hodtd files dns .....

reboot

------------------------------------------------------------------------------------------------------------
/etc/nsswitch.conf
#yum install bind bind-utils
#apt install bind9 bind9utils
#systemctl start named
#ubuntu bind-->named.conf
#ubuntu /etc/bind/named.conf
#centos-->/etc/named.conf
#dig ns1.example.com @localhost
#nslookup ns1.example.com 192.168.1.193
dig @4.2.2.4 microsoft
nslookup google.om 192.168.1.152
dig google.om @192.168.1.152
options {
...
recursion no;
}

options {
listen-on port53 {<server-IP>;}
allow-query {<any>;IPs;}

forwarders {10.0.0.1; 10.0.0.2;};
forward only;
};
##################
/Forward Zone
zone "example.com" IN {
type master;
file "example.com.zone";
allow-update { none; };
allow-query { any; };
};
###################
Backward Zone
zone "1.168.192.in-addr.arpa" IN {
type master;
file "example.com.rev"; 
allow-update { none; };
allow-query { any; };
};         
##################
vi /var/named/example.com.zone
$TTL 2d
$ORIGIN example.com.
@ IN SOA ns1.example.com. hostmaster.example.com. (
2013081500 ; se = serial number
12h ; ref = refresh
15m ; ret = update retry
3w ; ex = expiry
2h ; min = minimum
)
;Name Server Information
@ IN NS ns1.example.com.
@ IN NS ns2.example.com.
;IP Address for Name Servers
IN A 192.168.1.8
IN A 192.168.1.9
;Mail Server MX (Mail Exchanger) Record
@ IN MX 10 mail.example.com.
#;CNAME RECORD
#IN CNAME  docs.example.com

;A Record for the Following Host Name
ns1 IN A 192.168.43.180
ns2 IN A 192.168.43.181
mail IN A 192.168.1.8
docs IN A 192.168.1.9
#CNAME  IN  A  ftp.example.com
########### REVERSE ###############################
$TTL 86400
@ IN SOA ns1.example.com. hostmaster.example.com. (
2021101900 ; Serial
12h ; Refresh
15m ; Retry
3w ; Expire
2h ; Minimum TTL
) 
;Name Server Information 
@ IN NS ns1.example.com.
;Reverse lookup for Name Server
133 IN PTR ns1.example.com.
134 IN PTR ns2.example.com.
135 IN PTR mail.example.com.
#######################################################
chown named:named /var/named/example.com.zone
chown named:named /var/named/example.com.rev
named-checkconf /etc/named.conf
named-checkzone example.com /var/named/example.com.zone
named-checkzone 192.168.43.176 /var/named/example.com.rev
systemctl restart named
firewall-cmd  --add-service=dns --zone=public --permanent
firewall-cmd --reload


----------------------------------------------------------------------------
systemctl status systemd-resolved
systemctl stop systemd-resolved
systemctl disable systemd-resolved
cd /run/systemd/resolve/
nano stub-resolv.conf
nameserver 127.0.0.1 
vi /etc/resolve.conf
systemctl restart bind9
rndc flush
ufw allow 53/udp
ufw status
tcpdump -vv -n -i eth0 port 53

other server:::: dig @130.185.121.138 linux.org
-------------------------------------------------------------------------------
options {
        directory "/var/cache/bind";

        // If there is a firewall between you and nameservers you want
        // to talk to, you may need to fix the firewall to allow multiple
        // ports to talk.  See http://www.kb.cert.org/vuls/id/800113

        // If your ISP provided one or more IP addresses for stable
        // nameservers, you probably want to use them as forwarders.
        // Uncomment the following block, and insert the addresses replacing
        // the all-0's placeholder.

        recursion yes;
        allow-query { any; };
        allow-query-cache {any;};
        allow-recursion {any;};

        listen-on { any;};
        forwarders {
                0.0.0.0;


         };
        forward only;

        //========================================================================
        // If BIND logs error messages about the root key being expired,
        // you will need to update your keys.  See https://www.isc.org/bind-keys
        //========================================================================
        dnssec-validation auto;

        listen-on-v6 { any; };
        listen-on port 53 { any; };

};







