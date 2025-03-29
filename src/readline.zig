const std = @import("std");
const mem = std.mem;
const Allocator = mem.Allocator;

extern fn readline(prompt: [*:0]const u8) callconv(.C) ?[*:0]u8;
extern fn free(ptr: ?*anyopaque) callconv(.C) void;

pub fn readLineAlloc(allocator: Allocator, comptime prompt: [:0]const u8) !?[]const u8 {
    const line = readline(prompt) orelse return null;
    defer free(line);

    const span = mem.span(line);
    const result = try allocator.dupe(u8, span);

    return result;
}
