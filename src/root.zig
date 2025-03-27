//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");

pub fn get_path(args: [][:0]u8) ![]u8 {
    if (args.len == 2) {
        return args[1];
    }
    return read_from_stdin();
}

fn read_from_stdin() ![]u8 {
    const stdin = std.io.getStdIn().reader();
    const buff_size = comptime (1024 * 8);
    var buf = [_]u8{0} ** buff_size;
    const result = try stdin.readUntilDelimiterOrEof(&buf, '\n') orelse @panic("read null from stdin");
    return result;
}
