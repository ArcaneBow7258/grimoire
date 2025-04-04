+++
date = '2025-04-01T02:16:46Z'
draft = false
title = 'picoCTF / General'

+++
# chalkboard
 - grep -v "I WILL NOT BE SNEAKY"
 - In**b**vert matching, finds lines that do not have this full content
 - We can assemble the flag from that
 - picoCTF{chalkboard_bert_7c69b78b}
# Cryptography
## RSA
- For n, n is made up of p*q where p and q are supposedly large primes
- notice the even number for n... only even prime is 2 (any other prime is odd, and odd*odd = odd).
- that manes p\*q = N, one of pq must be 2
- you can get decryption key this way
- Code decryption in python

## GUess my Chesse part 1
- affine cihper
- each iteration of NC gives different a b values for afffine cipher
- encrypt 2 cheeses, check for which a b value with auto bruteforcer on [dcode](https://www.dcode.fr/affine-cipher)
- decrypt message with a b
