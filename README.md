# RDIFF - remote diff command

### This tool allows you to compare local files with files on remote hosts.

First you need to clone the repository and **cd** in:
```bash
git clone https://github.com/dimasikks/rdiff; cd rdiff/
```

Grant execution rights to the script and start alias script:
```bash
chmod +x rdiff_alias.sh; ./rdiff_alias.sh
```

### The command above will not apply the changes to the current terminal, so you will need to log out of the terminal and log back in.

## Usage

```bash
rdiff local_file user@host:/path/to/remote_file
```

```bash
rdiff user_1@host_1:/path/to/remote_file_1 user_2@host_2:/path/to/remote_file_2
```

### RDIFF also can be used like a normal diff

```bash
rdiff local_file_1 local_file_2
```


