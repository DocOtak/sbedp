FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntunoble

ENV HODLL=libwow64fex.dll
ENV WINEPREFIX=/.wine

RUN <<EOF 
    mkdir build &&
    cd build && 
    curl -L -O https://github.com/AndreRH/hangover/releases/download/hangover-10.6.1/hangover_10.6.1_ubuntu2404_noble_arm64.tar &&
    tar xf *.tar &&
    apt-get update &&
    apt-get install -y ./*.deb &&
    apt-get clean &&
    cd / && rm -rf /build
EOF

# The following also creates the /.wine diriectory when winetricks is run
# at the end of the step, we give the ownership of this wine directory to the abc user (from base image)
RUN <<EOF
    apt-get update &&
    apt-get install -y winetricks xvfb &&
    xvfb-run winetricks -q vcrun2010 vcrun2012 &&
    apt-get remove -y winetricks xvfb &&
    apt-get autoremove -y &&
    apt-get clean &&
    chown -R abc /.wine
EOF

ADD /graft /.wine

HEALTHCHECK --interval=1s CMD pidof Xvnc || exit 1
