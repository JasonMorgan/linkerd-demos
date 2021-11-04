#!/bin/bash

civo kubernetes delete NYC2 -y

civo kubernetes delete LON2 --region LON1 -y

rm -rf ~/tmp/ca/*












