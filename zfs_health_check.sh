#!/bin/bash

errors=$(/usr/sbin/zpool status -x)

if [ "$errors" != "all pools are healthy" ]; then
    echo "$errors" | msmtp notice@anyfrog.net
else
    # エラーがない場合でもメールを送信
    # echo "All ZFS pools are healthy." | msmtp notice@anyfrog.net
fi