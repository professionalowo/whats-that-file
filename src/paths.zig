const std = @import("std");
const fs = std.fs;
const Allocator = std.mem.Allocator;

fn resolveAbsoluteAlloc(path: []const u8, allocator: Allocator) ![]u8 {
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

pub fn getRealPathAlloc(path: []const u8, allocator: Allocator) ![]u8 {
    const absolute = try resolveAbsoluteAlloc(path, allocator);
    defer allocator.free(absolute);

    const realPath = try realpathAlloc(absolute, allocator);
    return realPath;
}
