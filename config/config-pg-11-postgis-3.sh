#!/bin/bash

ufw disable
ufw reset
ufw default deny outgoing
ufw default deny incoming
ufw allow ssh
ufw allow 5432
ufw allow 80
ufw start
