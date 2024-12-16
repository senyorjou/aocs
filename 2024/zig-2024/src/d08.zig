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

fn calcAntinodes(grid: *Grid, antis: *Grid, x: u16, y: u16, i: u16, j: u16) void {
    // std.debug.print("[{d}, {d}] - [{d}, {d}]\n", .{ x, y, i, j });
    const anti_1x: i32 = @as(i32, i) + @as(i32, i) - @as(i32, x);
    const anti_1y: i32 = @as(i32, j) + @as(i32, j) - @as(i32, y);

    if (grid.inGrid(anti_1x, anti_1y)) {
        antis.set(@intCast(anti_1x), @intCast(anti_1y), '#');
    }

    const anti_2x: i32 = @as(i32, x) + @as(i32, x) - @as(i32, i);
    const anti_2y: i32 = @as(i32, y) + @as(i32, y) - @as(i32, j);

    if (grid.inGrid(anti_2x, anti_2y)) {
        antis.set(@intCast(anti_2x), @intCast(anti_2y), '#');
    }
}

fn calcAntisPlus(grid: *Grid, antis: *Grid, x: u16, y: u16, i: u16, j: u16) void {
    // These points are in line, so mark both original points as antinodes
    antis.set(x, y, '#');
    antis.set(i, j, '#');

    // Get the direction vector
    const dx: i32 = @as(i32, i) - @as(i32, x);
    const dy: i32 = @as(i32, j) - @as(i32, y);

    // Simplify the vector to its smallest form
    const abs_dx: u32 = @intCast(@abs(dx));
    const abs_dy: u32 = @intCast(@abs(dy));
    const gcd = std.math.gcd(abs_dx, abs_dy);

    const step_x: i32 = @divExact(dx, @as(i32, @intCast(gcd)));
    const step_y: i32 = @divExact(dy, @as(i32, @intCast(gcd)));

    // Mark all points in line in both directions
    var curr_x = @as(i32, x);
    var curr_y = @as(i32, y);

    // Go forward
    while (true) {
        curr_x += step_x;
        curr_y += step_y;
        if (grid.inGrid(curr_x, curr_y)) {
            antis.set(@intCast(curr_x), @intCast(curr_y), '#');
        } else {
            break;
        }
    }

    // Go backward
    curr_x = @as(i32, x);
    curr_y = @as(i32, y);
    while (true) {
        curr_x -= step_x;
        curr_y -= step_y;
        if (grid.inGrid(curr_x, curr_y)) {
            antis.set(@intCast(curr_x), @intCast(curr_y), '#');
        } else {
            break;
        }
    }
}

pub fn solve() !types.Solution {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var iter = try buffIter.iterLines("./data/08-input.txt");
    // var iter = try buffIter.iterLines("./data/08-sample.txt");
    defer iter.deinit();

    var grid = try createGridFromIter(allocator, &iter);
    defer grid.deinit();

    var antis = try Grid.init(allocator, grid.width, grid.height);
    defer antis.deinit();

    var antis_plus = try Grid.init(allocator, grid.width, grid.height);
    defer antis_plus.deinit();

    antis_plus.fill('.');
    var y: u16 = 0;
    while (y < grid.height) : (y += 1) {
        var x: u16 = 0;
        while (x < grid.width) : (x += 1) {
            const value = grid.get(x, y);
            if (value != '.' and value != '#') {
                var i = x + 1;
                while (i < grid.width) : (i += 1) {
                    const match = grid.get(i, y);
                    if (value == match) {
                        calcAntinodes(&grid, &antis, x, y, i, y);
                        calcAntisPlus(&grid, &antis_plus, x, y, i, y);
                    }
                }

                var j = y + 1;
                while (j < grid.height) : (j += 1) {
                    i = 0;
                    while (i < grid.width) : (i += 1) {
                        const match = grid.get(i, j);
                        if (value == match) {
                            calcAntinodes(&grid, &antis, x, y, i, j);
                            calcAntisPlus(&grid, &antis_plus, x, y, i, j);
                        }
                    }
                }
            }
        }
        // std.debug.print("On line {d}\n", .{y});
    }

    // Fill with some data
    // grid.set(2, 0, 'A');
    // grid.set(1, 1, 'A');

    // Access data
    // const value = grid.get(2, 0); // gets 'A'

    // Print the grid
    grid.print();

    const howMany = antis.count('#');
    const total = antis_plus.count('#');

    std.debug.print("\n", .{});

    antis_plus.print();
    return .{
        .part1 = .{ .number = howMany },
        .part2 = .{ .number = total },
    };
}
