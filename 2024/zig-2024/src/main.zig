const std = @import("std");

const types = @import("types.zig");

const d01 = @import("d01.zig");
const d02 = @import("d02.zig");
const d08 = @import("d08.zig");
const d09 = @import("d09.zig");
const d10 = @import("d10.zig");
const d11 = @import("d11.zig");
const d12 = @import("d12.zig");

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

fn runAll() !void {
    printSolution(1, try d01.solve());
    printSolution(2, try d02.solve());
    printSolution(8, try d08.solve());
    printSolution(9, try d09.solve());
    printSolution(10, try d10.solve());
    printSolution(11, try d11.solve());
    printSolution(12, try d12.solve());
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    std.debug.print("AOC 2024 in Zig\n", .{});
    std.debug.print("--------------\n", .{});

    if (args.len == 1) {
        // No additional arguments, run all solutions
        try runAll();
        return;
    }

    if (args.len == 2) {
        const day = try std.fmt.parseInt(u8, args[1], 10);
        switch (day) {
            1 => printSolution(1, try d01.solve()),
            2 => printSolution(2, try d02.solve()),
            8 => printSolution(8, try d08.solve()),
            9 => printSolution(9, try d09.solve()),
            10 => printSolution(10, try d10.solve()),
            11 => printSolution(11, try d11.solve()),
            12 => printSolution(12, try d12.solve()),
            else => {
                std.debug.print("Day {d} not implemented\n", .{day});
                return;
            },
        }
    } else {
        std.debug.print("Usage: {s} [day_number]\n", .{args[0]});
        return;
    }
}
