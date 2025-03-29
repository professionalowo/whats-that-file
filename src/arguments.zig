const std = @import("std");
const fs = std.fs;
const process = std.process;
const Allocator = std.mem.Allocator;

const readlineAlloc = @import("readline").readlineAlloc;

/// Reads the first argument from the command line or stdin if no argument is
/// provided. The argument is allocated using the provided `allocator`.
pub fn getInArgAlloc(allocator: Allocator) !?[]const u8 {
    const args = try process.argsAlloc(allocator);
    defer process.argsFree(allocator, args);
    if (args.len >= 2) {
        return try allocator.dupe(u8, args[args.len - 1]);
    }
    return try readlineAlloc(allocator, "Path: ");
}
