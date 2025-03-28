const std = @import("std");

/// This imports the separate module containing `root.zig`. Take a look in `build.zig` for details.
const args = @import("arguments");

pub fn main() !void {
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
        _ = try std.io.getStdErr().writer().print("please provide a valid filepath");
        std.process.exit(1);
    };

    std.debug.print("Path: {s}\n", .{realPath});
}
