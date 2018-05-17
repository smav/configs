#!/usr/bin/env python

import virtinst.util
print "UUID:\t", virtinst.util.uuidToString(virtinst.util.randomUUID())
print "MAC:\t", virtinst.util.randomMAC(type="qemu")

  # for one-liner
  # python -c 'from virtinst.util import *; print uuidToString(randomUUID())'
  # python -c 'from virtinst.util import *; print randomMAC(type="qemu")'
