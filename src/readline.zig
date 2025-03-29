const std = @import("std");
const mem = std.mem;
const Allocator = mem.Allocator;

extern fn readline(prompt: [*:0]const u8) callconv(.C) ?[*:0]u8;
extern fn free(ptr: ?*anyopaque) callconv(.C) void;

pub fn readlineAlloc(allocator: Allocator, comptime prompt: [:0]const u8) !?[]const u8 {
    const line = readline(prompt) orelse return null;
    defer free(line);

    return try allocator.dupe(u8, mem.span(line));
}
