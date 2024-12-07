const std = @import("std");

const types = @import("types.zig");

const d01 = @import("d01.zig");
const d02 = @import("d02.zig");

fn printSolution(day: u8, result: types.Solution) void {
    std.debug.print("Day {d}:\n", .{day});
    switch (result.part1) {
        .number => |n| std.debug.print("  P1: {d}\n", .{n}),
        .string => |s| std.debug.print("  P1: {s}\n", .{s}),
    }
    switch (result.part2) {
        .number => |n| std.debug.print("  P2: {d}\n", .{n}),
        .string => |s| std.debug.print("  P2: {s}\n", .{s}),
    }
}

pub fn main() !void {
    std.debug.print("AOC 2024 in Zig\n", .{});
    std.debug.print("--------------\n", .{});

    printSolution(1, try d01.solve());
    printSolution(1, try d02.solve());
}
