const std = @import("std");
const args = @import("arguments");
const paths = @import("paths");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stderr = std.io.getStdOut().writer();

    var buffer: [std.fs.max_name_bytes * 16]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);

    const allocator = fba.allocator();

    const inArg = try args.getInArgAlloc(allocator) orelse {
        try stderr.print("please provide at least one argument", .{});
        defer std.process.exit(1);
    };
    defer allocator.free(inArg);

    const realPath = paths.getRealPathAlloc(allocator, inArg) catch {
        try stderr.print("please provide a valid filepath", .{});
        defer std.process.exit(1);
    };
    defer allocator.free(realPath);

    try stdout.print("{s}", .{realPath});
}
