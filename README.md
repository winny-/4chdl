4chdl
=====

[![No Maintenance Intended](https://unmaintained.tech/badge.svg)](https://unmaintained.tech/)
[![CI](https://github.com/winny-/4chdl/actions/workflows/ci.yml/badge.svg)](https://github.com/winny-/4chdl/actions/workflows/ci.yml)

4chan image downloader and library to interact with the JSON API.  Use this to
[snarf](https://www.freebsd.org/cgi/man.cgi?query=snarf&apropos=0&sektion=0&manpath=FreeBSD+13.0-RELEASE+and+Ports&arch=default&format=html)
down all the excellent wallpapers from `/wg/` and reaction gifs from `/wsg/`.
Maybe find a few retro-computing threads in `/g/`?

See also https://github.com/g-gundam/yotsubAPI

## Install

```
raco pkg install --auto --name 4chdl
```

## Usage

```
# Get the usage.
4chdl --help

# Snarf down a melancholy thread
4chdl https://boards.4channel.org/wsg/thread/4303742
```

API docs forthcoming.

## License

GNU Lesser General Public License v3.0 or later

### Why LGPL

Why not?
