# easy_sysctl

#### Table of Contents

1. [Description](#description)
1. [Instructions](#instructions)

## Description

This module wraps around the **augeasproviders_sysctl** module to make it easier to drive through Hiera.  It adds an abstraction
layer, allowing you to build hashes of data in hiera for your sysctl configuration with minimal setting metadata.  It will merge the hashes
found in Hiera.

It groups the sysctl settings into actions within hiera.  The following groupings are currently implemented:
  * **active** - these settings are only made active in the running kernel and will not be written to disk
  * **persist** - these settings will become immediately active and written to disk so they are active on the next reboot
  * **remove** - these settings will be removed (any entries conflicting with persist octive will be ignored)

The hashes in Hiera have an intermediate level in them which allows different setting for each OS family of Linux within the same Hiera scope.

Setting kernel parameter values uses a hash of names and values.  If the values are provided as an array, the first element is the value, the second 
is the comment.

Removing items from sysctl is simply a list of kernel parameter names.

## Instructions
Include the class:
```
  class { 'easy_sysctl': }
```


Specify hiera details along the following lines:

```
sysctl::active: 
  Linux:
    net.core.rmem_max: 67108864
sysctl::persist:
  Linux:
    kernel.msgmax: 65536
    kernel.msgmnb: [65536,"set to this value for various reasons"]
    kernel.randomize_va_space: 1
    kernel.sysrq: 1
    net.core.netdev_max_backlog: 250000
    net.core.wmem_max: 67108864
    net.ipv4.conf.all.secure_redirects: 1
    net.ipv4.conf.default.accept_source_route: 0
    net.ipv4.conf.default.rp_filter: 2
    net.ipv4.ip_forward: 0
    net.ipv4.tcp_congestion_control: reno
    net.ipv4.tcp_no_metrics_save: 1
    net.ipv4.tcp_rmem: "4096        87380   67108864"
    net.ipv4.tcp_sack: 1
    net.ipv4.tcp_syncookies: 1
    net.ipv4.tcp_timestamps: 1
    net.ipv4.tcp_wmem: "4096        65536   67108864"
  Debian: 
    net.ipv6.conf.all.disable_ipv6: 1
  RedHat: 
    net.ipv6.conf.all.disable_ipv6: 0

sysctl::remove:
  Linux:
    - kernel.core_uses_pid
```


