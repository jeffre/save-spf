#!/bin/bash

# Accepts any number valid domain names.
#
# For each given domain, the spf record is found and stored locally to a
# file named "{DOMAIN}.spf". If the saved spf record contains "include:"
# directives, those domains are recursively queried and stored locally. 
# This does not attempt to avoid cyclical includes.

save_spf(){
    for host in "$@"; do
        spf=$(host -t txt "$host" | grep -o '"v=spf1\s\+[^"]*"')
        echo "$spf" | tee "$host.spf"

        for include in $(echo "$spf" | grep -o "include:[^ ]\+" | sed -e 's|^include:||1'); do
            save_spf "$include"
        done
    done
}

save_spf "$@"
