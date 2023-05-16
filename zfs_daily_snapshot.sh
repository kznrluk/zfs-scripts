#!/bin/bash

# スナップショットを撮るデータセットのリスト
datasets=("lda/armoire" "lda/record" "lda/archive")

timestamp=$(date +%Y%m%d-%H%M%S)

# 各データセットに対してスナップショットを撮る
for dataset in "${datasets[@]}"; do
    /usr/sbin/zfs snapshot ${dataset}@${timestamp}
done

# 一週間以上前のスナップショットを削除
for dataset in "${datasets[@]}"; do
    /usr/sbin/zfs list -t snapshot -o name -H -r ${dataset} | while read snapshot; do
        creation=$(/usr/sbin/zfs get -H -o value creation "${snapshot}")
        if [ $(date -d "$creation" +%s) -lt $(date -d "1 week ago" +%s) ]; then
            /usr/sbin/zfs destroy "${snapshot}"
        fi
    done
done