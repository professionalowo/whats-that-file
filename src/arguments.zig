//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const fs = std.fs;
const Allocator = std.mem.Allocator;

const arguments = @This();

fn getPathAlloc(allocator: Allocator) ![]u8 {
    const args = try std.process.argsAlloc(allocator);
    if (args.len == 2) {
        return args[1];
    }
    return try readFromStdinAlloc(allocator);
}

fn readFromStdinAlloc(allocator: Allocator) ![]u8 {
    const stdin = std.io.getStdIn().reader();
    return try stdin.readUntilDelimiterOrEofAlloc(allocator, '\n', fs.max_path_bytes) orelse @panic("read null from stdin");
}

fn resolveAbsoluteAlloc(path: []u8, allocator: Allocator) ![]u8 {
    const cwd = try fs.cwd().realpathAlloc(allocator, ".");
    defer allocator.free(cwd);

    return try fs.path.resolve(allocator, &.{ cwd, path });
}

///resolves the `std.fs.realpath` of `pathname` and dupes it with `allocator`
fn realpathAlloc(pathname: []const u8, allocator: Allocator) ![]u8 {
    var buffer = [_]u8{0} ** fs.max_path_bytes;
    const realPath = try std.fs.realpath(pathname, &buffer);
    return allocator.dupe(u8, realPath);
}

pub fn getRealPathOfInArg(allocator: Allocator) ![]u8 {
    const path = arguments.getPathAlloc(allocator) catch |err| {
        return error.WrapErrorMessage("Failed to obtain the filepath", err);
    };
    defer allocator.free(path);

    const absolute = try arguments.resolveAbsoluteAlloc(path, allocator) catch |err| {
        return error.WrapErrorMessage("Failed to resolve absolute path", err);
    };
    defer allocator.free(absolute);

    const realPath = try arguments.realpathAlloc(absolute, allocator);
    return realPath;
}
