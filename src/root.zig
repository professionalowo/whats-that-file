//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const fs = std.fs;
const Allocator = std.mem.Allocator;

pub fn getPathAlloc(allocator: Allocator) ![]u8 {
    const args = try std.process.argsAlloc(allocator);
    if (args.len == 2) {
        return args[1];
    }
    return try readFromStdinAlloc(allocator);
}

fn readFromStdinAlloc(allocator: Allocator) ![]u8 {
    const stdin = std.io.getStdIn().reader();
    return try stdin.readUntilDelimiterOrEofAlloc(allocator, '\n', 1024 * 8) orelse @panic("read null from stdin");
}

pub fn resolveAbsoluteAlloc(path: []u8, allocator: Allocator) ![]u8 {
    const cwd = try fs.cwd().realpathAlloc(allocator, ".");
    defer allocator.free(cwd);

    return try fs.path.resolve(allocator, &.{ cwd, path });
}
