Alert Logic Agent Puppet Manifests
=================
These Puppet Manifests are used for installing al-agent package via Puppet


Requirements
------------
The following platforms are tested directly on.

- ubuntu-12.04
- ubuntu-14.04
- centos-6.4
- centos-7.0
- debian-7.8
- fedora-19

Attributes
----------

* `$registration_key` - your required registration key. String defaults to `your_registration_key_here` - Edit line: 90 in Manifest
* `$egress_url` - By default all traffic is sent to https://vaporator.alertlogic.com:443.  This attribute is useful if you have a machine that is responsible for outbound traffic (NAT box).  If you specify your own URL ensure that it is a properly formatted URI.  String defaults to `https://vaporator.alertlogic.com:443` - Edit line: 84 in Manifest
* `$agent_proxy` - By default al-agent does not require the use of a proxy.  This attribute is useful if you want to avoid a single point of egress.  When a proxy is used, both `$egress_url` and `$agent_proxy` values are required.  If you specify a proxy URL ensure that it is a properly formatted URI.  String defaults to `undef` - Edit line: 87 in Manifest

Usage Example
-------------
### Default
* By default, the manifests will use `node default {}` which applies to all nodes in your Puppet environment.
```
node default {} # Line 103
```

### Specific Nodes Only
* To specify specific nodes to run the manifest against, you can replace the `node default {}` with a list of nodes separated by commas
```
node 'node1','node2','node3' {} # Line 103
```

Troubleshooting
---------------

If the cookbook fails at the provisioning step, one cause is that the agent cannot connect to the egress_url.  Ensure that the proper permissions are configured on the security groups and ACLs to allow for outbound access.  Also check your egress_url attribute and ensure that it is a properly formatted URI.

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
5. Test the changes, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
License:

Distributed under the Apache 2.0 license.

Authors: Justin Early (jearly@alertlogic.com)