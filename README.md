# DiscordExtras

An iOS tweak that lets you apply patches the iOS Discord client.  
Available on my repo [here](https://repo.panties.moe).  

# Components

## DiscordExtrasServer
This includes the lightweight background service that injects into SpringBoard, since the main Tweak injects itself into Discord directly, it is impossible for me to run my tool to patch the jsbundle file within the Discord process.  
All it does is wait for an IPC command to run the tool in the background.  

## jsbundletools
This includes jsbundletools, the tool used to patch the jsbundle file, it compiles the go binary into arm64 and package it properly for the tweak.  
NOTE: The code isn't included in the tweak, you can copy over `main.go` from the [jsbundletools repo](https://github.com/NotZoeyDev/jsbundletools).  
NOTE 2: Go is required if you wanna be able to compile the tweak properly.  

## DiscordExtras  
The tweak itself is all implemented in Tweak.x and all it does it hijack Discord loading process to get the path of the jsbundle file it's trying to load, patch it accordingly, save the patched file in its cache folder and tell the client to load that patched file instead.  
