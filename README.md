# TA-Respwnder
Splunk App To Detect LLMNR Poisoning Attacks

This app can be deployed to Universal Forwarders to create a distributed detection network against LLMNR poisoning. 

**You can and should disable LLMNR and similar mechanisms in your entire environment. Even with LLMNR disabled you can still make use of this app to mimic the active protocol in your network.** 

The script has 2 functions:
  - Broadcast LLMNR requests for non-existing hostnames. These can be generated randomly or manually specified.
  - Optionally, if requests receive suspicious responses it's possible to authenticate against the attacker machine. This can be used to either give the attacker some busy work or you can later on track where they used the creds to login and therefore track the attacker within your network.

Check out `inputs.conf` in the `default` folder to find examples of input configurations.
The script supports the following parameters:

`-Names` = A list of hostnames to query  (Default: Randomly generated string)  
`-Authenticate` = Enables additional authentication if responses were received (Default: False)  
`-Username` = Username to use for authentication  (Default: Administrator)  
`-Pass` = Password to use for authentication (Default: Randomly generated string)  

After Respwnder receives an LLMNR response it outputs an event to stdout using a key=value format:
```
2023/12/10 09:12:21 event_id=1 event_message="possible responder detected" query=6xd5pmst09b4 answer=fe80::250:56ff:fec0:8
2023/12/10 09:12:21 event_id=1 event_message="possible responder detected" query=6xd5pmst09b4 answer=192.168.29.1
```
If Respwnder is configured to authenticate against the received host another event is emitted:
```
2023/12/10 09:25:56 event_id=2 event_message="authenticated to possible responder" dest_ip=fe80::250:56ff:fec0:8 user=user=DOMAIN\Administrator
2023/12/10 09:25:56 event_id=2 event_message="authenticated to possible responder" dest_ip=192.168.29.1 user=user=DOMAIN\Administrator
``` 
