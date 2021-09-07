#!/bin/bash

hugo --buildFuture

git add .
git commit -m "updates $(date)"
git push origin master
