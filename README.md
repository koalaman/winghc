# winghc -- Docker image with Wine + Windows Haskell Platform

This docker image aims to be a convenient way of compiling Haskell
for Windows, while still running Linux.

## To run:

    docker pull koalaman/winghc
    docker run -v "$PWD:/appdata" koalaman/winghc cabal yourcommand

All of cabal and ghc's temp files will be stored in /appdata,
which is here mounted as the current directory. This is also the working
directory in the container.

For the case of running cabal update, install --dependencies-only and
build, there's a convenience script `cuib`. Here's an example of
building a [shellcheck.exe](https://github.com/koalaman/shellcheck):

    git clone https://github.com/koalaman/shellcheck
    docker pull koalaman/winghc
    cd shellcheck && docker run -v "$PWD:/appdata" koalaman/winghc cuib

This should result in a `shellcheck.exe` somewhere in `dist/`.

