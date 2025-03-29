//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const fs = std.fs;
const Allocator = std.mem.Allocator;

/// Reads the first argument from the command line or stdin if no argument is
/// provided. The argument is allocated using the provided `allocator`.
pub fn getInArgAlloc(allocator: Allocator) !?[]u8 {
    const args = try std.process.argsAlloc(allocator);
    if (args.len == 2) {
        return args[1];
    }
    return try readFromStdinAlloc(allocator);
}

fn readFromStdinAlloc(allocator: Allocator) !?[]u8 {
    const stdin = std.io.getStdIn().reader();
    return try stdin.readUntilDelimiterOrEofAlloc(allocator, '\n', fs.max_path_bytes);
}
