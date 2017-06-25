FROM ubuntu:17.04

# Install wine and such
USER root
WORKDIR /root
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y wine32 curl

# Create an /appdata directory for cabal/ghc to install things in
RUN adduser haskell
RUN mkdir /appdata
RUN chown haskell: /appdata

# Install the Haskell Platform
USER haskell
WORKDIR /home/haskell
RUN curl -o setup.exe -L 'https://haskell.org/platform/download/8.0.2/HaskellPlatform-8.0.2-a-minimal-i386-setup.exe'
RUN wine setup.exe /S
RUN rm setup.exe
RUN rm -r "$HOME/.wine/drive_c/users/haskell/Application Data"
RUN ln -s "/appdata" "$HOME/.wine/drive_c/users/haskell/Application Data"
# Allow winewrap to kludge the home dir
RUN chmod -R o+w "$HOME/.wine/drive_c/users/"

# Convenience scripts for running commands
USER root
COPY winewrap cabal ghc cuib /usr/bin/

# Tweaks to the environment to allow running as any user
USER haskell
ENV WINEPATH C:/Program Files/Haskell Platform/8.0.2-a/bin;C:/Program Files/Haskell Platform/8.0.2-a/lib/Extralibs/bin
ENV HOME /home/haskell
WORKDIR /appdata
ENTRYPOINT ["/usr/bin/winewrap"]

