#!/bin/bash

domain=$1
fdomain=$domain".co.il"

echo "Getting information of domain: " $fdomain

whois $fdomain | grep -E 'validity|e-mail|name'
curl --head $fdomain


