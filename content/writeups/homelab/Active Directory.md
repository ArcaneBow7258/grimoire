+++
date = '2025-02-11T00:43:45Z'
draft = false
title = 'Homelab / Active Directory'
summary = 'Basically what I did to test out active directory on my homelab'
ShowToc = true
TocOpen = true
TocSide = "right"
+++
# Introduction
Hi! I'm not an expert on active directory and a lot of information I'm about to tell you is already available online, but writing it myself and disseminating helps me learn (i think). Plus might as well add more information to my website.

# Basic Explaination
Active Directory (AD) is a centralized authentication and authorization architecture that interfaces with Windows devices.  

AD comes in a few parts:
1. Domain - a workspace designated by an actualy domain. This is the highest level and sets the policies company wide. Ran by a *domain controller* (DC).
2. Organization Units (OU) - Logical grouping of users, devices, and groups that helps organize your permissions. For example, you can have a OU for *accounting*, and within a group named *tax people* and give permissions accordingly.
3. Group - a group of users.
4. User - you!
5. Resourecs - like printers.

Many types of policies can be set including: security, password, access, account management (different levels of IT) and even computer power management. I'd like to think for every windows setting, we can roll out a setting to specific subset of users and devices.

Furthermore, authorization to different services/resources like FTP, share drives, and printers.

The shape of a Domain is a forest: a bunch of trees. You can create subomains for specific parts of a company or maybe even regions. These can have their own domain controller.

## Protocol
dunno, use LDAPS tho  
Kreberos or something like that
## Why AD?
- Centralized management (and replication through more DC)
- Compartmentalization of groups of users.
    - Organization! The tree/directory like nature allows for easy cascading and look-ups.
- Extensive Windows management
- Allows for single account across many services.

# What I did
As I do not own an enterprise license of Windows, I decided to use Azure. Also helps me offload some processing.
Windows Enterprise or 
## Homelab
1. I set up Windows Server 2022 on my Computer
    - Make sure you don't only do Server Core (to get GUI)
    - Add feature/role: Active Directory
2. Create a user
    - tools -> Group and User management -> add user
    - This user should be the user you'll be joining your other VM as.
3.  Need to generate a certicate ([self-signed](https://learn.microsoft.com/en-us/azure/vpn-gateway/point-to-site-certificate-gateway)) 
    - After creating, switch to Azure side
4. Connect your AD to Azure Gateway
5. Check if you can ping, you might have to do somet firewall to allow ICMPv4

## Azure
1. Create a VM
    - To save some costs, make sure your OS Disk is on HDD
2. Use Azure Virtual Network Gateway
    - Important setting: VPN types. Should allow OpenVPN and IKEv2 for Windows.
    - Acts as a point-to-site VPN.
    - Get public-key of certificate and provide it to Azure.
    - You can download a package for set-up the VPN's with click of button.
3. Ping DC IP 
4. Add Domain Controller to DNS (first stop)
5. System / Computer Name settings -> Domain -> Change Domain