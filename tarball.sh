#!/bin/sh
export dir=`basename "$PWD"`
cd ..;tar --exclude ModelLibrary --exclude .git --exclude .vagrant --exclude  .http_proxy --exclude .gitmodules --exclude $dir.tgz -czf $dir/$dir.tgz $dir