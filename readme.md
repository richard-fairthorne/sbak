# SBAK

SBAK is a unix server backup tool which can be used to make regular and frequent uncompressed backups while consuming minimal disk space. It is tested primarily on Ubuntu Linux and OSX.

## Installation

Simply run the install program, installing sbak to /usr/local/bin

```
./install.sh
```

Alternatively, copy the sbak program to anywhere on your path, or run it where it is.

### Prerequisites

Sbak depends on rsync 3.1 or greater.

#### OSX

You can install an up to date rsync using the package manager, [homebrew](http://brew.sh).

First, make sure the package manager is installed:

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Then install rsync.

```
brew install rsync
```

#### Ubuntu (debian)

You can install an up to date rsync using the system package manager, apt.

```
sudo apt-get install -y rsync
```

## Usage

Run ./sbak for full usage. Here is a typical usage:

```
sbak example.com
```

This will backup the entire server example.com to your default backup archive located at ~/.sbak

You can find files related to this backup at ~/.sbak/example.com/

## FAQ

### What are the benefits of SBAK
- You can retrieve files fast because your backups are not bundled or zipped together.
- Your backups are not compressed or altered in any way by SBAK, so they are fully functional copies of your filesystem. If they are on the same filesystem as your original, you can do a split second file operation to move a backup into production.
- Files are de-duplicated at the filesystem level, so even though 1000 backups contain a copy of the same file, the file exists on the disk only once.

### How do I know how much space my backups actually consume?
- With SBAK, like with Apple Time Machine, backups are de-duplicated by using hard links. You can


## Announcement

I am beginning to offer support for sbak through [HashBang Media](http://hashbang.info).

sbak has been in an unmaintained state for 10 years. I've just deployed it to a major network and am now maintaining it at [Github](http://github.com/richard-fairthorne/sbak).

## Roadmap

### High Priority

The high priority roadmap includes features I am currently working on for paid clients:

- support for transfer protocols
  - backup on local filesystem

### Short Term

The short term includes items which are likely to be funded within the next few months.

- assistance with choosing which files to include in the backups
- support for additional transfer methods
  - SSH
  - RSYNC server
  - NFS volume
- configurable official docker container

Wishlist:

- multithreaded rsync

And and all assistance is welcome :D

## Features

- Runs over a common SSH connection that exists on most servers.
- Uses the RSYNC protocol which is common and reliable
- Uses compression over the line
- Only transfers blocks which have changed.
- Continues failed backups from where they left off. Suitable for unreliable connections.

## More info

The initial backup takes the same space as the original files, while additional backups take only limited space due to the file deduplicating properties of hard-links.

Each backup appears on the filesystem as a complete backup, and can easily be manipulated using any tool.
