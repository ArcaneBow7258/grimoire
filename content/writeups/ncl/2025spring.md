+++
date = '2025-04-18T01:09:56Z'
draft = false
title = '2025 Spring'
description = "I told myself I wouldn't go that hard... I went pretty hard. And then I forgot to do any writeups as I went so most of this is me doing forensics on myself. I blame collin"
ShowToc = true
TocOpen = true
TocSide = "right"
+++
# OSINT
## (Hard) Cats?
- The payload is actually just some iPhone 3 jailbreak. Completely irrelevant
	- The other two files, look at hex and see its a jpeg.
- I reversed image search the logo to find `dramcorp` or you can use the poster to find `omega mart` directly.
- The cat named LV is shown in a TikTok / YouTube video.
# Crypto
## (Medium) Messages
```
for n in {1..50}; do echo $n;  cat "message_$n.txt" | openssl dgst -sha256 -hmac "ciCloud-API-20240315-4f7b9c" | sed -e "s/SHA2-256(stdin)= //" | sed -z '$ s/\n$//' | diff - "message_$n.hmac"; done | grep "<" -B 2
```
- For each message, get the content, get the sha256 hmac digest with given key
- Then trim it
- Compare it to the hmac's given, and see what hashes were different
`for n in {1..50}; do cat "message_$n.hmac"; printf "\n"; done | grep "3349ac94b3bcfccda44df33da49cc5f6bdfe6fbae8d1107621bb92f399d6acd8"`
- Lets you finding the mismatched hmac. (Repeat for each of the above)

## (Medium) Zugzwang
- need a really specific library
https://github.com/WintrCat/chessencryption
- Importantly, you should run through the text examples.
	- The encoding output is data of ALL `.pgn` files combined
- Thus, to decode we need to read all the data from each file and put them all together
	- Importantly, each file is split by a `\n\n` so you need to join individual files with that.
```python
parts = []
p = "../parts"
o = 'out/'
for i in range(1,433):
    print(p + f'/game_{str(i)}.pgn')
    with open(p + f'/game_{str(i)}.pgn') as f:
        l = f.read()
        parts.append(l)
decode.decode('\n\n'.join(parts), 'out.jpeg')
```
## (Hard) QR Code/STL
- File is a .gcode file (if you're familiar with 3d printing it helps a lot)
- https://ncviewer.com/
- I went into a pixelart thing and reconstructed it by hand...
![[Pasted image 20250412153315.png]]

# Passwords 

## (Hard) DIce
- I got my wordlist from here: https://www.eff.org/dice
- The challenge named was  "Dice" so I instinctively looked for a short wordlist.
- Then a lot of hashcat. Most my commands I have to run 3 variations to get `word-word-liber8`, `word-liber8-word`, and `liber8-word-word` combinations.
```bash
# liber8.txt is just "liber8"
hashcat --stdout -a 1 dice.txt liber8.txt -j "$-" -k "$-" > mid.txt # creates all "word-liber8-" combinations
hashcat -a 3 hashes.txt mid.txt dice.txt # Crack by concatting combinations of "word-liber8-" and "word" making "word-liber8-word"
# Repeat above for combinations of "liber8-word-" and "-word-liber8"
# Later for special cahracters...
hashcat --stdout -a 6 dice.txt ?s > specialdice.txt # creates word[?s] where ?s is any special character
# repeat above with liber8

# then with sepcialdice/specialliber8 combinations you repeat the cracking
```

# Log Analysis
## (Medium)
- I used `awk` to get the answer to questions as well as grep
`cat social_data.sql  | grep -e "'[0-9]\{3\}-" -o  | sort | uniq -c | sort -n`
## (Hard)
- They gave you a format, up to you to parse it and look through it.
```python
import pandas as pd
raw = None
with open("logins.bin", 'rb') as f:
    raw = f.read()
point = 0
data = []
while point <  len(raw):
    username_length = int(raw[point:4+point].hex(),16)
    username = raw[4+point:4+username_length+point].decode()
    ip = raw[4+username_length+point:4+username_length+4+point].hex()
    ip = '.'.join([str(int(ip[i:i+2], 16)) for i in range(0, len(ip), 2)])
    timestamp = int(raw[4+username_length+4+point:4+username_length+4+4+point].hex(),16)
    success = int(raw[4+username_length+4+4+point:4+username_length+4+4+1+point].hex())
    data.append([username_length, username, ip, timestamp, success])
    point = 4+username_length+4+4+1+point 
df = pd.DataFrame(data, columns = ["username_length", "username", 'ip','timestamp','success'])
df['failure'] = (df.success + 1) % 2

# Final answer i got through this:
# It was someone who got denied 2x and success. People say its a really short login time (like milliseconds apart)
df[['ip','failure']].groupby("ip").mean().sort_values('failure')
```
# Network Traffic

## (Medium) Wifi
- some simple reading of the pcap file then using `aircrack-ng` with `rockyou.txt` to crack.
https://github.com/aircrack-ng/aircrack-ng
## (Hard) Exfil
- Investigating the file, we can see a DNS query for `asset.xxxxx.ci`
- On the first one, we can see that the `xxxxx` is a file header that matches a `xz` archive.
`strings exfil.pcapng | grep -e "-.*\.ci" -o | sed  "s/-//" | sed "s/.ci//" | tr -d "\n" | xxd -r -p > asset.bmp.xz`
# Forensics
## (Easy) Dog
- inside the .png data, we see a reference to `exiftool`
- this allows us to grab exif metadata from the .png
	- The flag is encoded in base64 from exfil tool
## (Medium) ForYou
- If you load the file into a hex-editor, we can see its oddly large... and that theres multiple file headers inside!
- `binwalk -dd=.* -e ForYou.jpg`
	- you need `-dd=.*`  to get all filetypes, otherwise it'll only grab the zip file.
- I hear `foremost` is also very effective and a simple 1 liner.
## (Hard) whatever the .img file was
- `strings` gets you the file name
- you can use `autopsy` to reconstruct the data or probably `binwalk` 
# Scanning
## (Hard) School
- Start with an `nmap -sC` scan
	- need `-sC` or `ldap` scripts to get the domains we need to enumerate
	- find `dc=cloud0`, but drop the 0.
- Simply use `ldapsearch` to find what is needed
 `ldapsearch host -b "dc=cloud"` for example.
# Web Apps
## (Easy) Dog Gallery
- notice if you have over the file you can see that the source is `http://url/image?photo=path/to/.png`
- We can do directory traversal to find a `flag.txt`
## (Medium)
- inspect the source code for the user/password bypass.
## (Hard) Dogstagram
- Inside the source code (`__buildmanifest`), we can see the `static/chunk/secret_dogo_stash_xxxxx.js` and `static/chunk/main_xxxxx.js`.
	- These are not accessible through just the baseurl
	- Notice the sources come from `_next/static` -> use these 
- That gets you 2 of the flags
- To find the version, we can simply do `next` in the console. This is probably imbedded in some `.js` file loaded
	- (You can use any function/variable from any included js in the debugger/source code)
# E&E
## (medium) crackme
- Ghidra shows a "decodeimage" function.
	- Inside, we can see an `encoded_image` in memory and we add our input `key` to all values (iterating through each character in our key, aka index 0 + 0)
	- Key is 8 characters long
- The file result must match some hex `0x...F8FF` or whatever the `.png` file header is
	- Simple reverse from `.png hex = encoded hex + key hex`, and solve for the key.
```c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
void main(){
    int t;
    unsigned long ver, enc;
    FILE *fp;
    unsigned char buffer[9];
    fp = fopen("smart.png", "rb");
    if ( fp != NULL ) {
    int read = 0;
    read = fread(buffer, 1, 8, fp);
    fclose(fp);
    printf("%s", buffer);
    }
    ver =  0xa1a0a0d474e5089; // File header to match (png)

    //printf("ver %s\n", (&ver));
    //enc = 0x41efd616dad7e3e9;
    enc = 0xe9e3d7da16d6ef41; // first 8 bytes of encoded file.
    for(int i = 0; i < 8; i++){
        printf("%X", ((unsigned char *)(&ver))[i] - ((unsigned char *)(&enc))[i]);
    }
    printf("\n");
    printf("mod %X\n", ((unsigned char *)(&enc))[5]);

    t =memcmp(buffer, &enc, 8);
    printf("cmp %i\n", t);
}
```
## (hard) pwcheck
https://youtu.be/1hScemFvnzw?si=mt2Y1qvokAvQVW2C
- race condition
- The file has a `sticky-bit` which makes the file run as root to read `/etc/shadow`
- Using a decompiler, you can see that the file eventually does `getuid` and `setguid` to prevent exploits (i.e, the `execlp` function at the end calling `upload` binary.
- BUT, before it does so, it does `open(file)`
	- why does this matter? lets go into linux file systems
- What occurs with `open()` with the sticky-bit is that linux *copies the file into /proc/process_id*
	- which allows you to read it without root privilege
- chaining commands lets you read the `/proc/[pid]` dir as fast as possible  and then grab `/etc/shadow` contents.