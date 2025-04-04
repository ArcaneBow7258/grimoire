+++
date = '2025-04-01T02:13:34Z'
draft = false
title = 'Jersey CTF V'
description = "Some writeups for Jersey CTF V hosted by the NJIT. Competed with my good SFS pals :]"
+++
# WebApps
 ## Encoded Deception
 - We see in console.log some values
 - We look at sscript and see a "secret message" value
	 - base64 decode shows `Part 1: jctfv{myst3ry`
 - Looking around, only other  ineteresting part is the request to `info.php`
	 - Look at the network request in your browser...
	 - There is an `Important: UGFydCAyOiBfMHAzcjR0MTBufQ==` header...
	 - decodes to be `Part 2: _0p3r4t10n}`
## Time of Date
- Changing the url parameters, we're getting a command error similar to bash...
	- lets try adding `; ls` to run a seperate command
	- wow that works
	- `| cat flag.txt` to end of url
## Layers of Lies
- inside the pae we see a <script></script> tag that fetches some urls
	- Notice, the first letters are XORMIGHTHELP
	- One of pages is `The Key is 0x14
	- Lot of junk in the pages... except on says "The lock is found in the home of Loab"
- We can use php wrapper to bypass the filter seen (.. replacement and no / start)
	- view.php?file=php://filter/convert.base64-encode/resource=/etc/passwd
- https://book.hacktricks.wiki/en/pentesting-web/file-inclusion/lfi2rce-via-php-filters.html#full-script
- In fact, you need to do a bigger filter one.
	- you can use the one above but its easier when u get RCE
## Something's Fishy
- Webpage has "no robots allowed!" Wow that couldn'tbe robots.txt
	- Has mention to "swagger API doc" on server
	- "Swap out original url to API Documentation"
- The extension points to an api endpoint named  of the same url except `a` swapped with `b`, just swap to port 80
	- We find some login pannel
	- /api/communication still works...
- -> gobuster swagger api wordlist
	- found /apidocs
	- theres  /api/admin/getUsername and getPassword
CipherBot67587
z8vj2Rtn@68CxP!
## Something's Fishy 2
- Apparently we're to know that the `botnet` table endpoint performs a query on the database

## Leaky-Endpoints
- Looking around, there registration, order/cart, and menu
- Make an account, seems necessary.
- Looking at files, we see a `src/` folder which gives us some information about the routes used
	- `@dMiN` is unauthorized for our simple user account
	- -> reaches `/api/admin/(dev)/users`
		- We'll see later we need the (dev) version
- From there, try creating some orders
	- Refers us to `Orders/userid/orderid`
	- Create an API call to `/api/orders/userid/orderid`
		- userid seems not not mean anything
		- BUT we can traverse `orderid`
	- We look at order id 1 and see information about `admin@admin.gmail.com`
		- Personal Information Hint -> Phone Number
		- Gives us a login
- Moving back to `/api/admin(dev)/users`, we can try for SQLi
	- We get a bite!
	- `' UNION SELECT name FROM sqlite_master WHERE type = 'table' -- `
	- `SELECT * FROM flog3`

# Bearer of Bad News
- Bearer... like cookies
- if you decode the jwt token, we see `"admin": false`
	- eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoidXNlciIsImFkbWluIjpmYWxzZSwiaWF0IjoxNzQzMjgyNjYwLCJleHAiOjE3NDMzNjkwNjB9.54BwJYn00t4wcDYW87-3ttTafplBtNfpG4LitxyjaK0
	- 54BwJYn00t4wcDYW87-3ttTafplBtNfpG4LitxyjaK0
	- but where is the key?
	- On planet 9!
	- therss a message the srcolls srcosss the srceen -> 1F0Und4seCREtOnp1En79
- eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoidXNlciIsImFkbWluIjp0cnVlLCJpYXQiOjE3NDMyODI2NjAsImV4cCI6MTc0MzM2OTA2MH0.29LwU51UX9ZCwMW4ZaruXbrdfgCBV-YrMqBGHxpzWWs
	- replace and hit Get Your Secert!
# Whats-your-number
1.' UNION SELECT 1, "admin", "$2a$10$FRKbtimzbhLAViWBaHeA0u4bfVmw.mPLH2pSLhp63RL/eghWcZ8e2" -- 

# Forensics
## evtx

# Binary Exploitation
## Play Fair
    for i in range(10):
        a=reverseMe(a)
        print(a)

# Misc
- https://lemire.me/blog/2018/07/02/predicting-the-truncated-xorshift32-random-number-generator/
## Golden-Cricle
- uses steghide