+++
date = '2024-11-12T10:17:14-05:00'
draft = false
title = 'Homelab'
ShowToc = true
TocOpen = true
TocSide = "right"
+++
## Breadbox (Workstation) {{<image_icon "/images/ball/ub.png">}}
- Generic Windows 10 (for now)
- Ryzen 5600
- 32 GB Ram
- GTX 1660 Super
- Gaming
## VanillaPi (RPi 3B) {{<image_icon "/images/ball/pb.png">}}
- nginx reverse proxy
- camera server
- IaC through personal [ansible](https://github.com/ArcaneBow7258/ansible-pi)
## FruitPi (RPi 4) {{<image_icon "/images/ball/pb.png">}}
- Hugo Webserver
- Caddy Reverse Proxy
- PiHole DNS Server
## Actual Homelab
Here's the general layout of how everything is organized:
{{< figure-img-size placeholder 100px 100px >}}/images/pkm/mimikyu.png{{</ figure-img-size >}}
### EdgeRouter X
- Depreciated piece of hardware I should replace
- Runs wireguard tunnel to Phone, PC, and Laptop, allowing access to homelab anywhere securely.
- Practing network management, firewalls, port forwarding, DNS, DHCP, etc.
### Leyline (Proxmox) {{<image_icon "/images/ball/gb.png">}}
- [Aoostar Gem10](https://aoostar.com/products/aoostar-gem10-amd-ryzen-7-7840hs-mini-pc-with-win-11-pro-3-nvme-oculink-2-2-5g-lan?variant=47484035891498)
    - Ryzen 7840HS w/ Raedon 780m
    - 1x 1TB SSD, 1x 2TB SSD
    - 32 GB Ram
- Host VM's and Containers

#### Arcane (Arch Linux VM)
- Minecraft
- Thats about it for right now
#### Tiny (Ubuntu LXC)
- Open-source [Geoguesser](https://gitlab.com/glatteis/earthwalker) alternative
- Runs nginx reverse proxy
