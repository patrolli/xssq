#!/bin/bash

hugo

git add .
git commit -m "updates $(date)"
git push origin master
