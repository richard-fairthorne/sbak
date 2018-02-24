# SBAK

sbak is a unix/linux oriented server backup tool which can be used to make regular and frequent uncompressed backups while consuming minimal disk space.

The initial backup takes the same space as the original files, while additional backups take only limited space due to the file deduplicating properties of hard-links.

Each backup appears on the filesystem as a complete backup, and can easily be manipulated using any tool.


## Usage

Run ./sbak for usage.
