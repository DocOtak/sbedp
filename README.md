# r2r/sbe
A dockerized version of the SeaBird Data Processing Tools with the following features:

* Lightweight Window Manager with a VNC server
* Built in browser based VNC client
* Windows SeaBird Software working under a wine layer
* Works on arm based macs M1 or later, will probably work on Arm based linux machines
* Completely unknown if it works on Intel (x64) based machines, but reading of the docks for wine/hangover suggest it should be possible

## Building:
The base image is ubuntu 24.04 with a very lightweight window manager, vnc server, and browser based control server.

It installs [hangover](https://github.com/AndreRH/hangover) 10.6.1  then grafts a .wine directory (sbe_wine.tar.gz) into the root directory (/).
Note that an earlier version of this installed things into the home directory (/config), in the base image, this directory is marked as being a VOLUME, which was causing very large (1GB+) dangling anon volumes.

To build:

while in the same directory as the Dockerfile:

```
docker build -t r2r/sbe:10.6.1 -t r2r/sbe:latest .
```
Where r2r/sbe:10.6.1 is the tag for the image, in this case <org>/<name>:<hangover version>
It also sets the "latest" tag so that a a bare "r2r/sbe" can be used
when launching the container

to run (preliminary) see more in interaction

```
docker run --rm -it -p 3000:3000 r2r/sbe bash
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

## How was sbe_wine.tar.gz made?
It did not seem to be possible to install the seabird data processing software non interactively, a window needed to pop up and have some interaction (the next button mostly).
To do this, the base image (see the "from" line in the Dockerfile) was run manually using the above run steps.
Hangover and wine were manually installed (from the deb dir), then the seabird processing software was manually installed.
The .wine directory that is made during this process is portable and can be moved from one system to another.
The .wine directory was tared and compressed then moved out of this manually made container using volume bind mounts.