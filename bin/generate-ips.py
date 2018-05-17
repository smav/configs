#!/usr/bin/python
# -*- coding: utf-8 -*-
#
# generate vm network range

import virtinst.util
for num in range(110, 130+1):
    print("vm{0}\t192.168.222.{0}\t{1}".format(num, virtinst.util.randomMAC(type="qemu")))
