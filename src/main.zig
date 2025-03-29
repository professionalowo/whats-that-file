const std = @import("std");
const args = @import("arguments");
const paths = @import("paths");

pub fn main() !void {
    var buffer: [std.fs.max_name_bytes * 16]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);

    const allocator = fba.allocator();

    const inArg = try args.getInArgAlloc(allocator) orelse errexit("please provide at least one argument");
    const trimmed = std.mem.trim(u8, inArg, &[_]u8{ '\r', '\n', ' ' });
    defer allocator.free(inArg);

    const realPath = paths.getRealPathAlloc(allocator, trimmed) catch errexit("please provide a valid filepath");
    defer allocator.free(realPath);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("{s}", .{realPath});
}

/// Prints an error message to stderr and exits with status code 1.
fn errexit(comptime message: []const u8) noreturn {
    defer std.process.exit(1);
    const stderr = std.io.getStdOut().writer();
    try stderr.print(message, .{});
}
