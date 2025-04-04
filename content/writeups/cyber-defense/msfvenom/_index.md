---
marp: true
theme: "gaia"

date: '2025-02-07T14:25:46Z'
draft: false
title: 'MSFvenom'
summary: 'Quick presentation over shells, MSFVenom, and evasion..'
ShowToc: true
TocOpen: true
TocSide: "right"
class: "invert"
---
{{< slides >}}
<!---  --->

# Shells and MSFvenom

![bg right:40%](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrxbJa-nhHziIG0l0KWJaB8hE06D7QFpF4wg&s)
UofL Cyber Defense

---
<!-- paginate: true -->
# Disclaimer
- Something about ethics
- Your AV will probably detect this
- Don't try at home <br />(okay at home but not at other people while at home, something about ethics)
- Regurgtating information I did a module on HTB

---
# Table of Contents
1. Payloads
2. MSFVenom
3. Basic Usage
4. Advanced Stuff
    - Obfuscation
    - Templates
    - .Exe Embedding
    - Process Injection

---
# What's a Payload?
![bg contain right:40%](https://preview.redd.it/the-payload-is-much-easier-to-climb-from-the-front-than-the-v0-tpyocdswnlke1.jpeg?auto=webp&s=d94f020d36f4cd2777ca5207e18f913e44a97112)
- A bomb you provide
    - Triggers RCE
    - Injects
    - Creates *shells*
- Resources
    - Payload all the Things
    - msfvenom
---
# Shells
![bg contain  right:40%](https://upload.wikimedia.org/wikipedia/en/thumb/6/60/Mario_Kart_Blue_Shell.png/220px-Mario_Kart_Blue_Shell.png)
- **S**ecure **SH**ell
- ba**sh**, power**shell**, z**sh**
- Metepreter - Metasploit's in-memory DDL Injection
- Web Shells

---
# Types of connections
- Bind - Target listens for connection, Host initiates (binds)
    - Needs open port
- Reverse - Host listens, Target Initiates (reverse)
    - Circumvents firewalls rules
    - Need a listener
        - ncat / netcat
        - MSF multi/handler
    


<!-- footer: https://www.revshells.com/ --> 
---
# Bind Shell
- Target: Sets a listener
- Attacker: makes NC
- Typically blocked on firewall
    - Look for any open/allowed ports
![image w:800px](https://alvintran.net/images/bash_bind_explain.png)

<!-- footer: ""--> 
---
# Reverse Shells
- Firewalls are less likely to block outward connections
- Example is in bash
- Useful if you're in a language / have RCE

![image w:600px](https://alvintran.net/images/bash_rev_explain.png)
{{< asciinema vpYU4n7HklTHNPCTQDbLp64wl >}}

---
# Why MSFVenom?
![bg contain right:20%](https://marriland.com/wp-content/plugins/marriland-core/images/pokemon/sprites/home/full/ekans.png)
- Different payloads (shells, meterpreter)
- Different platforms / arch
- Encodings
- File formants include ASPX, WAR, PHP, EXE, ELF, c code


<!-- footer:--> 
---
# Basic Usage
- `msfvenom -p [payload] -a [arch] --platform [plat] -f [filetype] LHOST=[host] LPORT=[port] -o [out]`
- You can check options with `msfvenom -l [option]`
- ex: `msfvenom -p windows/x64/shell_reverse_tcp -a x64 --platform windows -f raw`
    - will give you RAW code
    - used for combining with other methods

<!---
"E:\Visual Studio 2022\VC\Tools\MSVC\14.41.34120\bin\Hostx64\x64\ml64" template_x64_windows.asm /link /subsystem:windows /defaultlib:\"C:\\Program Files (x86)\\Windows Kits\\10\\Lib\\10.0.20348.0\\um\\x64\\kernel32.lib" /entry:main" 
-->
---
# Antiviruses :]
- Wow isn't it so nice windows defender stops your viruses on your computer
- (use linux)
- (or just turn it off)
---
# Staged vs Stageless Payloads
- Stageless: THe entire code in one file
    - Nice and contained, but obviously a virus.
- Staged: smaller initial, sends rest over network
    - Needs msf multi/handler
    - More network-traffic dependent

<!-- footer: https://docs.metasploit.com/docs/using-metasploit/advanced/meterpreter/meterpreter-stageless-mode.html -->
---

# Evasion
![image](https://www.serebii.net/games/evasion.jpg)

<!-- footer: "https://www.virustotal.com/gui/home/upload"-->
---
# Encoding
- msfvenom's `-e [enc] -u [iter]` command, `--list encoders`
- `x86/shikata_ga_nai` "It cannot be helped"
    - metasploit's signature encoder
- chaining!
- nopsleds
- Though rather later to party:
https://www.scriptjunkie.us/2011/04/why-encoding-does-not-matter-and-how-metasploit-generates-exes/
<!-- footer: ""-->

---
# Templates
- injections into files, what people generally think of malware
- `-x` option selects template (xemplate)
- `-k` preserves original function (keep)

<!-- footer: "https://www.offsec.com/metasploit-unleashed/backdooring-exe-files/ \n
https://www.blackhillsinfosec.com/modifying-metasploit-x64-template-for-av-evasion/" -->
---

# Process Injections
- Working more in c (custom .exe)
- Essentially exporting C output into actual C code


<!-- footer: "https://www.ired.team/offensive-security/code-injection-process-injection/process-injection" --->
---
# Doing it by hand
- https://gourish-singla.medium.com/pe-code-injection-in-windows-msfvenom-d9f9ff3fb128
- Literally going into assembly and editing hex
- Way more invovled.
- You can imagine why Malware Analysis/Reverses wants C/Assembly Knowledge
- Also avoids more AV's
- Try injecting the `injct.exe` code into `putty.exe` for example
<!-- footer: "" --->
---
# Alternative Tools + Extras
- encrypting shellcode with `--encrpyt`
    - helpful for more obfuscation
- command payloads


- Alternative options:
    - https://www.shellterproject.com/homepage/
    - https://github.com/trustedsec/unicorn