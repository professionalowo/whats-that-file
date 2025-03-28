const std = @import("std");
const args = @import("arguments");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stderr = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{ .thread_safe = false }).init;
    defer switch (gpa.deinit()) {
        .leak => @panic("allocator leaked memory"),
        else => {},
    };

    const parentAllocator = gpa.allocator();

    var arena = std.heap.ArenaAllocator.init(parentAllocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const realPath = args.getRealPathOfInArg(allocator) catch {
        try stderr.print("please provide a valid filepath", .{});
        defer std.process.exit(1);
    };

    try stdout.print("{s}", .{realPath});
}
