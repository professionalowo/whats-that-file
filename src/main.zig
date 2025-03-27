const std = @import("std");

/// This imports the separate module containing `root.zig`. Take a look in `build.zig` for details.
const lib = @import("whats_that_file_lib");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    // Parse args into string array (error union needs 'try')
    const args = try std.process.argsAlloc(allocator);

    const path = lib.get_path(args) catch @panic("Could not obtain the filepath");

    std.debug.print("Path: {s}\n", .{path});
}
