const std = @import("std");
const types = @import("types.zig");
const buffIter = @import("buff-iter.zig");
const Grid = @import("grid.zig").Grid;

fn createGridFromIter(allocator: std.mem.Allocator, iter: *buffIter.ReadByLineIterator) !Grid {
    var lines = std.ArrayList([]u8).init(allocator);
    defer {
        for (lines.items) |line| {
            allocator.free(line);
        }
        lines.deinit();
    }

    var width: u16 = 0;
    while (try iter.next()) |line| {
        if (width == 0) width = @intCast(line.len);
        const line_copy = try allocator.alloc(u8, line.len);
        @memcpy(line_copy, line);
        try lines.append(line_copy);
    }

    const height: u16 = @intCast(lines.items.len);
    var grid = try Grid.init(allocator, width, height);

    for (lines.items, 0..) |line, y| {
        for (line, 0..) |char, x| {
            grid.set(@intCast(x), @intCast(y), char);
        }
    }

    return grid;
}

pub fn solve() !types.Solution {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // var iter = try buffIter.iterLines("./data/10-input.txt");
    var iter = try buffIter.iterLines("./data/10-sample.txt");
    defer iter.deinit();

    var grid = try createGridFromIter(allocator, &iter);
    defer grid.deinit();

    grid.print();

    // std.debug.print("Grid: {any}", .{grid});
    return .{
        .part1 = .{ .number = 99 },
        .part2 = .{ .number = 99 },
    };
}
