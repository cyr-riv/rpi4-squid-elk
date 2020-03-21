function FindProxyForURL(url, host) {
    // our local URLs from the domains
    if (isInNet(host, "192.168.0.0",  "255.255.255.0"))    {
       return "DIRECT";
    }
    
    // All other requests go through Squid.
    return "PROXY 192.168.0.35:32267";
 }