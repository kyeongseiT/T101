#!/bin/bash
echo "Hello, T101 Study Kyeongsei" > index.html
nohup busybox httpd -f -p 8090 &