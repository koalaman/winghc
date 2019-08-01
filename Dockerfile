FROM ubuntu:19.04

# Install wine and such
USER root
WORKDIR /root
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y wine32 curl

# Install the Haskell Platform
RUN curl -o setup.exe -L 'https://www.haskell.org/platform/download/8.6.3/HaskellPlatform-8.6.3-core-i386-setup.exe'
RUN wine setup.exe /S
RUN rm setup.exe
RUN mkdir /appdata
RUN rm -r "$HOME/.wine/drive_c/users/root/Application Data"
RUN ln -s "/appdata" "$HOME/.wine/drive_c/users/root/Application Data"

# Convenience scripts for running commands
COPY winewrap cabal ghc cuib /usr/bin/

# Cabal config for reducing size
COPY cabal-config /etc/

# Tweaks to the environment to allow running as any user
ENV WINEPATH C:/Program Files/Haskell Platform/8.6.3/bin;C:/Program Files/Haskell Platform/8.6.3/lib/Extralibs/bin;C:/Program Files/Haskell Platform/8.6.3/mingw/i686-w64-mingw32/bin
WORKDIR /appdata
ENTRYPOINT ["/usr/bin/winewrap"]
