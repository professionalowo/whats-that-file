const std = @import("std");
const fs = std.fs;
const Allocator = std.mem.Allocator;

fn resolveAbsoluteAlloc(allocator: Allocator, relativePath: []const u8) ![]u8 {
    const cwd = try fs.cwd().realpathAlloc(allocator, ".");
    defer allocator.free(cwd);

    return try fs.path.resolve(allocator, &.{ cwd, relativePath });
}

pub fn getRealPathAlloc(allocator: Allocator, relativePath: []const u8) ![]u8 {
    const absolute = try resolveAbsoluteAlloc(allocator, relativePath);
    defer allocator.free(absolute);

    const realPath = try fs.realpathAlloc(allocator, absolute);
    return realPath;
}
