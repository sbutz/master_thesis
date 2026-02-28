Raspberry Pi Wi-Fi → Ethernet Network Bridge (NAT)

Hardware: Raspberry Pi 4 Model B
OS: Raspberry Pi OS Lite (Bookworm)
Goal:

wlan0 connects to router (DHCP from router)

eth0 provides network to downstream device

Downstream device gets internet via NAT

⚠️ True L2 bridging over Wi-Fi is not possible.
This setup uses routing + NAT.

1. Verify interfaces
ip addr


Expected:

wlan0 → has IP from router

eth0 → no IP yet

2. Configure static IP on Ethernet (NetworkManager)
List connections
nmcli connection show


Assume the Ethernet connection is named:

Wired connection 1

Assign static IP to eth0
sudo nmcli connection modify "Wired connection 1" \
  ipv4.method manual \
  ipv4.addresses 192.168.50.1/24 \
  ipv4.gateway "" \
  ipv4.dns ""


Bring it up:

sudo nmcli connection up "Wired connection 1"


Verify:

ip addr show eth0


Expected:

inet 192.168.50.1/24

3. Enable IPv4 forwarding

Enable immediately:

sudo sysctl -w net.ipv4.ip_forward=1


Persist across reboots:

sudo nano /etc/sysctl.conf


Ensure this line exists and is uncommented:

net.ipv4.ip_forward=1

4. Install and configure DHCP server (dnsmasq)
Install
sudo apt update
sudo apt install dnsmasq

Configure
sudo nano /etc/dnsmasq.conf


Add:

interface=eth0
dhcp-range=192.168.50.10,192.168.50.100,255.255.255.0,24h


Restart:

sudo systemctl restart dnsmasq

5. Configure NAT (iptables)
Add rules
sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
sudo iptables -A FORWARD -i wlan0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT

6. Persist firewall rules
sudo apt install iptables-persistent
sudo netfilter-persistent save

7. Connect downstream device

Set downstream device to DHCP.

It should receive:

IP: 192.168.50.x

Gateway: 192.168.50.1

DNS: via Pi
