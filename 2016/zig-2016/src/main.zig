const std = @import("std");
const types = @import("types.zig");

const d01 = @import("day01.zig");
const d02 = @import("day02.zig");

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
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});
    printSolution(1, try d01.solve());
    printSolution(2, try d02.solve());
}

test "simple test" {
    const gpa = std.testing.allocator;
    var list: std.ArrayList(i32) = .empty;
    defer list.deinit(gpa); // Try commenting this out and see if zig detects the memory leak!
    try list.append(gpa, 42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "fuzz example" {
    std.debug.print("Fuzzing example\n", .{});
    const Context = struct {
        fn testOne(context: @This(), input: []const u8) anyerror!void {
            _ = context;
            // Try passing `--fuzz` to `zig build test` and see if it manages to fail this test case!
            try std.testing.expect(!std.mem.eql(u8, "canyoufindme", input));
        }
    };
    try std.testing.fuzz(Context{}, Context.testOne, .{});
}
