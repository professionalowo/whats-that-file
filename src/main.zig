const std = @import("std");

/// This imports the separate module containing `root.zig`. Take a look in `build.zig` for details.
const lib = @import("whats_that_file_lib");

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
    // Parse args into string array (error union needs 'try')

    const path = lib.getPathAlloc(allocator) catch @panic("Could not obtain the filepath");

    const absolute = try lib.resolveAbsoluteAlloc(path, allocator);

    std.debug.print("Path: {s}\n", .{absolute});
}
