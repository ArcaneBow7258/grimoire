---
marp: true
theme: gaia

date: '2025-02-07T14:25:46Z'
draft: false
title: 'Payloads and MSFvenom'
summary: 'Quick presentation over bind shells, reverse shells, MSFvenom, and things to look out for in defense.'
ShowToc: true
TocOpen: true
TocSide: "right"
class: "invert"
---
<!---  --->

# (sea)Shells <br /> Payloads <br /> and MSFvenom
![bg right:40%](https://th-thumbnailer.cdn-si-edu.com/QsYOcBjhQbIjXBQdrw2QH_hcpuc=/1000x750/filters:no_upscale():focal(990x769:991x770)/https://tf-cmsv2-smithsonianmag-media.s3.amazonaws.com/filer/54/45/5445b3e4-8c1e-45b6-9d07-ce4286b5b4d3/image-1_web.jpg)
UofL Cyber Defense

---
<!-- paginate: true -->
# Disclaimer
- Don't try at home <br />(okay at home but not at other people while at home)
- Regurgtating information I did a module on
- Not super practical unless you're advanced (i am not)

---
# Table of Contents
1. Payloads
2. Shells
3. MSFVenom
4. File Upload Example
5. Avoiding AV's
6. .Exe Embedding

---
# What's a Payload?
![bg contain right:40%](https://static.wikia.nocookie.net/overwatch/images/9/95/Dorado_screenshot_3.png/revision/latest/scale-to-width-down/1200?cb=20160630044824)
- A bomb you sent/upload to a server
    - Triggers RCE
    - Injects
    - Creates *shells*
- Resources
    - Payload all the Things
    - Metasploit Framework
    - 
---
# Shells
![bg contain  right:40%](https://upload.wikimedia.org/wikipedia/en/thumb/6/60/Mario_Kart_Blue_Shell.png/220px-Mario_Kart_Blue_Shell.png)
- **S**ecure **SH**ell
- ba**sh**, power**shell**, z**sh**
- interacts with the terminal
- Metepreter
- Web Shells
---
![bg contain  right:40%](https://www.lockheedmartin.com/content/dam/lockheed-martin/rms/photo/cyber/THE-CYBER-KILL-CHAIN-body.png.pc-adaptive.1280.medium.png)
# How to get to the shell part
- Find an attack vector!
    - FTP
    - Webserver file uploads
    - Dropped a USB
---
# Types of connections
- Bind - Target listens for connection
    - opens port
- Reverse - Host listens, Target Initiates
    - Circumvents firewalls and rules
    - Need a listener
        - ncat / netcat
        - MSF multi/handler
    
[Demo Cue]

<!-- footer: https://www.revshells.com/ --> 
---
# Web Shells
![bg contain right:40%](https://i.redd.it/5ofaq45gfmpb1.jpg)
- File upload vulnerability
    - PHP
    - dotnet ASP
    - Javascript Server Pages (JSP)
    - Usually after you get admin access to a website
- Laudanum
- MSFvenom

<!-- footer: "" -->
---
# Damn Vulnerable Web App
![bg contain right:20% ](https://static.wikia.nocookie.net/slay-the-spire/images/a/ae/Icon_Vulnerable.png/revision/latest?cb=20200202234658)
- Part of kali environment (i think)
- whole host of vulnerabilities
- Alternatvies: 
OWASP Juicebox, Metasploitable, OWASP Mutillidae II, 
DV RESTurant, DV bank

https://github.com/WhiteWinterWolf/wwwolf-php-webshell/blob/master/webshell.php
<!-- footer: "https://github.com/digininja/DVWA " -->
---
# MSFvenom for payload creation
![bg contain right:20%](https://marriland.com/wp-content/plugins/marriland-core/images/pokemon/sprites/home/full/ekans.png)
- Different payloads (shells, meterpreter)
- Different platforms / arch
- Encodings
- File formants include ASPX, WAR, PHP, EXE, ELF

[Demo Cue]
<!-- footer: "E:\\Visual Studio 2022\\VC\\Tools\\MSVC\\14.41.34120\\bin\\Hostx64\\x64\\ml64\" template_x64_windows.asm /link /subsystem:windows /defaultlib:\"C:\\Program Files (x86)\\Windows Kits\\10\\Lib\\10.0.20348.0\\um\\x64\\kernel32.lib\" /entry:main" --> 


<!---
"E:\Visual Studio 2022\VC\Tools\MSVC\14.41.34120\bin\Hostx64\x64\ml64" template_x64_windows.asm /link /subsystem:windows /defaultlib:\"C:\\Program Files (x86)\\Windows Kits\\10\\Lib\\10.0.20348.0\\um\\x64\\kernel32.lib" /entry:main" 
-->
---
# Evasion
![bg contain right:40%](https://www.serebii.net/games/evasion.jpg)
- Encoding
- Templates
    - Modify existing ones
    - Use examples (injection)
    - Modify existing ones
https://www.ired.team/offensive-security/code-injection-process-injection/process-injection
<!-- footer: "https://www.blackhillsinfosec.com/modifying-metasploit-x64-template-for-av-evasion/" -->

