# Whats that file (wtf)

## Description

A small zig utility that tells you the full real path of a file or directory

Currently doesnt work with files in path, only resolvable from current working directory

## Build

Build:

```bash
zig build
```

Build with optimizations for speed:

```bash
zig build --release=fast
```

Build with optimizations fot size:

```bash
zig build --release=small
```

## Dependencies

[GNU Readline](https://tiswww.case.edu/php/chet/readline/rltop.html)
libc
