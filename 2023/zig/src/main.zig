const std = @import("std");
const d01 = @import("d01.zig");
const d02 = @import("d02.zig");
const d03 = @import("d03.zig");

pub fn main() !void {
    std.debug.print("AOC 2023\n--------\n", .{});
    std.debug.print("Day 01.\n", .{});
    try d01.main();
    std.debug.print("Day 02.\n", .{});
    try d02.main();
    std.debug.print("Day 03.\n", .{});
    try d03.main();
}
