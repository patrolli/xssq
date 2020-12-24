#!/bin/bash

hugo

git add .
git commit -m "refresh"
git push origin master
