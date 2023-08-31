pwd=`pwd`
. $pwd/unifi-api.sh

unifi_login
#"Usage: $0 <mac> <minutes> [up=kbps] [down=kbps] [bytes=MB] [ap_mac=mac]"
unifi_authorize_guest 00:00:00:00:00:00 525600

unifi_logout