const std = @import("std");
const fs = std.fs;
const Allocator = std.mem.Allocator;

fn resolveAbsoluteAlloc(relativePath: []const u8, allocator: Allocator) ![]u8 {
    const cwd = try fs.cwd().realpathAlloc(allocator, ".");
    defer allocator.free(cwd);

    return try fs.path.resolve(allocator, &.{ cwd, relativePath });
}

pub fn getRealPathAlloc(path: []const u8, allocator: Allocator) ![]u8 {
    const absolute = try resolveAbsoluteAlloc(path, allocator);
    defer allocator.free(absolute);

    const realPath = try fs.realpathAlloc(allocator, absolute);
    return realPath;
}
