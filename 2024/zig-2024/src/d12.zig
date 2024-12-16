const std = @import("std");
const types = @import("types.zig");
const buffIter = @import("buff-iter.zig");
const Grid = @import("grid.zig").Grid;

const Element = struct {
    area: u16,
    perimeter: u16,

    pub fn add(self: Element, other: Element) Element {
        return .{ .area = self.area + other.area, .perimeter = self.perimeter + other.perimeter };
    }
};

const Coords = struct { x: u16, y: u16 };

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

fn findArea(grid: *Grid, coords: *std.ArrayList(Coords), match: u8, x: u16, y: u16) !Element {
    if (!grid.inGrid(x, y)) {
        return .{ .area = 0, .perimeter = 0 };
    }
    if (grid.get(x, y) != match) {
        return .{ .area = 0, .perimeter = 0 };
    }

    try coords.append(Coords{ .x = x, .y = y });
    grid.set(x, y, '.');

    var total: Element = .{ .area = 1, .perimeter = 0 };
    const perimeter = grid.perimeter(match, x, y);
    std.debug.print("Element: {c}, [{d},{d}]\tTotal:{any}\tPerimeter:{}\n", .{ match, x, y, total, perimeter });

    total = total.add(try findArea(grid, coords, match, x + 1, y));
    if (x > 0) {
        total = total.add(try findArea(grid, coords, match, x - 1, y));
    }

    total = total.add(try findArea(grid, coords, match, x, y + 1));
    if (y > 0) {
        total = total.add(try findArea(grid, coords, match, x, y - 1));
    }

    return total;
}

pub fn solve() !types.Solution {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var iter = try buffIter.iterLines("./data/12-sample.txt");
    defer iter.deinit();

    var grid = try createGridFromIter(allocator, &iter);
    defer grid.deinit();
    var coords = std.ArrayList(Coords).init(allocator);
    defer coords.deinit();

    const element = grid.get(0, 0);

    const found = try findArea(&grid, &coords, element, 0, 0);
    std.debug.print("Element: {c}\n", .{element});
    std.debug.print("Total: {any}\n", .{found});
    std.debug.print("Coords: {any}\n", .{coords});

    grid.print();

    std.debug.print("\n", .{});
    return .{
        .part1 = .{ .number = 99 },
        .part2 = .{ .number = 99 },
    };
}
