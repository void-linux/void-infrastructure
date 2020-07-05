# VPN

Void maintains an overlay mesh network which contains all of Void's
hosts.  This network uses the `nebula` VPN implementation to provide
point-to-point overlay tunnels across the internet.

Access to this network is tightly controlled, and is provided on a
need-to-use basis.  Typically membership is restricted to
`netauth/dante` and even then the VPN links should only be activated
when necessary.  A strong preference should be shown to accessing
systems via HTTP transports over the internet.
