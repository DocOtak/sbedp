# sbedp
A dockerized version of the SeaBird Data Processing Tools with the following features:

* Lightweight Window Manager with a VNC server (inherited from the base image)
* Built in browser based VNC client (inherited from the base image)
* Windows SeaBird Software working under a wine layer
* Works on arm based macs M1 or later, will probably work on Arm based linux machines

## Building:
The base image is ubuntu 24.04 with a very lightweight window manager, vnc server, and browser based control server.

It installs [hangover](https://github.com/AndreRH/hangover) 10.6.1 and the runtime requirements (visual basic 2010 and 2012) for SBEDataProcessing using winetricks.
The SeaBird processing software is then copied to the correct place in the image along with the system registry.

To build:

while in the same directory as the Dockerfile:

```
docker build -t some_tag .
```

to run (preliminary) see more in interaction

```
docker run --rm -it -p 3000:3000 some_tag bash
```

--rm deletes the container on exit
-it lets you interact with it in the terminal
-p 3000:3000 maps the internal server port to the host one, this is only needed if you want to interact with the VNC server
r2r/sbe is the name of the container image (see the -t flag in the build instructions), if this is does not specify a tag (:<something>) it will automatically use :latest
bash is the command to run inside, if one is not specified, you'll need to kill/stop the container from another terminal session

## Interaction
Assuming you are running this on your local machine and have done the "docker run" command above...

Open a browser and go to localhost:3000

cd into /.wine/drive_c/Program\ Files\ \(x86\)/Sea-Bird/SBEDataProcessing-Win32/

run
```
wine SBEDataProc.exe
```

And the sea bird data processing program should pop up...

For more automated interaction, volume mounts and files need to be bound to the running image.