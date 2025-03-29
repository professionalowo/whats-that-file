const std = @import("std");
const args = @import("arguments");
const paths = @import("paths");

const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdOut().writer();

pub fn main() !void {
    var buffer: [std.fs.max_name_bytes * 16]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);

    const allocator = fba.allocator();

    const inArg = try args.getInArgAlloc(allocator) orelse errexit("please provide at least one argument");
    defer allocator.free(inArg);

    const realPath = paths.getRealPathAlloc(allocator, inArg) catch errexit("please provide a valid filepath");
    defer allocator.free(realPath);

    try stdout.print("{s}", .{realPath});
}

fn errexit(comptime message: []const u8) noreturn {
    defer std.process.exit(1);
    try stderr.print(message, .{});
}
