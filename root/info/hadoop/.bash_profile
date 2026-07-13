#!/bin/bash
#on this next line, we start keychain and point it to the private keys that
#we'd like it to cache
#/usr/bin/keychain ~/.ssh/id_rsa ~/.ssh/id_dsa
eval `keychain --eval id_rsa id_dsa`
export RUBYOPT=""
