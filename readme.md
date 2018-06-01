# SBAK

## About

sbak is a unix/linux oriented server backup tool which can be used to make regular and frequent uncompressed backups while consuming minimal disk space.

## Announcement

I am beginning to offer support for sbak through [HashBang Media](http://hashbang.info).

sbak has been in an unmaintained state for 10 years. I've just deployed it to a major network and am now maintaining it at [Github](http://github.com/richard-fairthorne/sbak).

The short term roadmap is limited but includes:

- assistance with choosing which files to include in the backups
- more sane defaults for 2018
- better documentation

Wishlist:

- multithreaded rsync

And and all assistance is welcome :D

## Usage

Run ./sbak for full usage. Here is a typical usage:

```
sbak example.com
```

This will backup the entire server example.com to your default backup archive located at ~/.sbak

You can find files related to this backup at ~/.sbak/example.com/

## Features

- Runs over a common SSH connection that exists on most servers.
- Uses the RSYNC protocol which is common and reliable
- Uses compression over the line
- Only transfers blocks which have changed.
- Continues failed backups from where they left off. Suitable for unreliable connections.

## More info

The initial backup takes the same space as the original files, while additional backups take only limited space due to the file deduplicating properties of hard-links.

Each backup appears on the filesystem as a complete backup, and can easily be manipulated using any tool.
