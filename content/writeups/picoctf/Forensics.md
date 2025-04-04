+++
date = '2025-04-01T02:16:42Z'
draft = false
title = 'picoCTF / Forensics'

+++
# Ph4nt0m 1ntrud3r
pcpap capture
first, sort by time (obviously out of order)
ones of len 12 on bottom are base64 encoded -> get flag after copying and conveerting all TCP payloads
# Red
- supposedly normal red.png
- do strings files
- Get a poem
	- Notice the first letters spell "CHECK LSB"
- Go to https://georgeom.net/StegOnline/upload
	- Hit the "Extract Files/Data"
- Per lsb, grab bit 0 (least significant bit) of all 4 channels 
- YOu'll find repeated base64 values to decode
# Flags are Stepic
- Hint says to find non-matching flag
- We have a University listed as one of the countries
	- you can grab the json data from source if u want and compare names
	- Note: the flag abreviations are actually accurate
- You find university at the bottom
	- You can't download it directorly
	- BUT you can go into  Inspect -> Application -> Frames -> Image and download it there
- https://github.com/1049451037/stepic
	- get flag

# Bitlocker-1
1. Given a .dd file (disk duplicate or whatever)
2. bitlocker2john `filename.dd`
	1. Will provide 4 passwords, one is user password one is recovery key, and copies of both. Extract one of them (userpassword is first one and is necessary enough)
3. use john or hashcat to crack with rockyou.txt
	1. password is jacqueline
4. on linux, install dislocker
	1. sudo dislocker -v -V .dd --user-password=pass /media/bitlocker -> will create a dislocker-file inside
	2. to mount, mount -o loop,ro /media/bitlcoker/disclocker-file /mnt/wherever
5. Flag is in first directory.
# Event Viewing
- ctrl+f 
# Bitlocker-2
1. We have a RAM .mem dump -> volatility
	1. We look for bitlocker related volatility tools
	2. https://github.com/breppo/Volatility-BitLocker
	3. -> allows for dislocker integration
2. need volatility 2 not 3
3. volatility needs to have a profile (ie OS), 
	1. imageinfo plugin
4. python2 vol.py -f .mem bitlocker --profile={profleAbove} --dislocker
5. You'll get .fvek files to use with dislocker, which you can refer to Bitlocker-1 for how to decode and mount file
	1. insteadd of --user-password, use --kvek=
6. Flag is stored in first level of mount
5b6ff64e4a0ee8f89050b7ba532f6256
60be5ce2a190dfb760bea1ece40e4223c8982aecfd03221a5a43d8fdd302eaee
1ed2a4b8dd0290f646ded074fbcff8bd
bccaf1d4ea09e91f976bf94569761654