const std = @import("std");
const fs = std.fs;
const Allocator = std.mem.Allocator;

const readlineAlloc = @import("readline").readlineAlloc;

/// Reads the first argument from the command line or stdin if no argument is
/// provided. The argument is allocated using the provided `allocator`.
pub fn getInArgAlloc(allocator: Allocator) !?[]const u8 {
    const args = try std.process.argsAlloc(allocator);
    if (args.len >= 2) {
        return args[1];
    }
    return try readlineAlloc(allocator, "Path: ");
}
