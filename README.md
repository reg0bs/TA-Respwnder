# TA-Respwnder
Splunk App To Detect LLMNR Poisoning Attacks

This app can be deployed to Universal Forwarders to create a distributed detection network against LLMNR poisoning. 
The script has mainly 2 functions:
  - Broadcast LLMNR requests for names of services that don't exist. These can be generated randomly or manually set by you
  - Optionally if requests are responded to it's possible to authenticate against the attacker machine. This can be used to either give the attacker some busy work or you can later on track where they used the creds to login and therefore tracking the attacker within your network.

Check out `inputs.conf` in the `default` folder to find examples of input configurations.
The script supports the following parameters:

`-Names` = A list of names to query  
`-Authenticate` = Enables additional authentication if responses were received  
`-Username` = Username to use for authentication  
`-Pass` = Password to use for authentication  