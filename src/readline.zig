const mem = @import("std").mem;

extern var rl_completion_append_character: c_int;

extern fn readline(prompt: [*:0]const u8) callconv(.C) ?[*:0]u8;
extern fn free(ptr: ?*anyopaque) callconv(.C) void;

/// Reads a line from stdin using the GNU Readline library.
/// The line is allocated using the provided `allocator`.
/// The caller has to free the returned slice
pub fn readlineAlloc(allocator: mem.Allocator, comptime prompt: [:0]const u8) !?[]const u8 {
    if (rl_completion_append_character != 0) {
        rl_completion_append_character = 0;
    }
    const line = readline(prompt) orelse return null;
    defer free(line);

    return try allocator.dupe(u8, mem.span(line));
}
