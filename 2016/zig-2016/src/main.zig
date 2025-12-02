const std = @import("std");
const types = @import("types.zig");

const d01 = @import("day01.zig");
const d02 = @import("day02.zig");
const d03 = @import("day03.zig");
const d04 = @import("day04.zig");

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
    const alloc = std.heap.page_allocator;
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});
    printSolution(1, try d01.solve());

    const d02_solution = try d02.solve();
    defer {
        if (d02_solution.part1 == .string) {
            alloc.free(d02_solution.part1.string);
        }
        if (d02_solution.part2 == .string) {
            alloc.free(d02_solution.part2.string);
        }
    }
    printSolution(2, d02_solution);

    const d03_solution = try d03.solve();
    defer {
        if (d03_solution.part1 == .string) {
            alloc.free(d03_solution.part1.string);
        }
        if (d03_solution.part2 == .string) {
            alloc.free(d03_solution.part2.string);
        }
    }
    printSolution(3, d03_solution);

    const d04_solution = try d04.solve();
    defer {
        if (d04_solution.part1 == .string) {
            alloc.free(d04_solution.part1.string);
        }
        if (d04_solution.part2 == .string) {
            alloc.free(d04_solution.part2.string);
        }
    }
    printSolution(4, d04_solution);
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
