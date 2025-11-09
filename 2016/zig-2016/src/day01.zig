const std = @import("std");
const types = @import("types.zig");
const file_reader = @import("file_reader.zig");

const Direction = enum { R, L, U, D };
const Move = struct {
    direction: Direction,
    steps: i32,
};

const Heading = enum { North, East, South, West };
const AbsMove = struct {
    heading: Heading,
    steps: i32,
};

const Position = struct {
    x: i32,
    y: i32,
};

fn getDirection(direction: u8) !Direction {
    return switch (direction) {
        'R' => Direction.R,
        'L' => Direction.L,
        'U' => Direction.U,
        'D' => Direction.D,
        else => return error.InvalidDirection,
    };
}

fn turn(current: Heading, dir: Direction) Heading {
    return switch (current) {
        Heading.North => switch (dir) {
            Direction.R => Heading.East,
            Direction.L => Heading.West,
            else => current,
        },
        Heading.East => switch (dir) {
            Direction.R => Heading.South,
            Direction.L => Heading.North,
            else => current,
        },
        Heading.South => switch (dir) {
            Direction.R => Heading.West,
            Direction.L => Heading.East,
            else => current,
        },
        Heading.West => switch (dir) {
            Direction.R => Heading.North,
            Direction.L => Heading.South,
            else => current,
        },
    };
}

fn checkPosition(positions: []const Position, pos: Position) bool {
    for (positions) |p| {
        if (p.x == pos.x and p.y == pos.y) {
            return true;
        }
    }
    return false;
}

pub fn solve() !types.Solution {
    const file = try std.fs.cwd().openFile("data/day01.txt", .{});
    defer file.close();

    // std.debug.print("File opened successfully {any}\n", .{file});

    // reader
    var buffer: [1024]u8 = undefined;
    var reader = file.reader(&buffer);

    // lists
    var directions = std.array_list.Managed(Move).init(std.heap.page_allocator);
    defer directions.deinit();
    var movements = std.array_list.Managed(AbsMove).init(std.heap.page_allocator);
    defer movements.deinit();
    var positions = std.array_list.Managed(Position).init(std.heap.page_allocator);
    defer positions.deinit();

    while (reader.interface.takeDelimiterInclusive('\n')) |line| {
        // std.debug.print("Line: {s} len: {d}\n", .{ line, line.len });
        var token_it = std.mem.splitScalar(u8, line, ',');
        while (token_it.next()) |number_str| {
            const trimmed = std.mem.trim(u8, number_str, " \t\r\n");
            const direction = try getDirection(trimmed[0]);
            const distance = std.fmt.parseUnsigned(i32, trimmed[1..], 10) catch 0;
            const move = Move{ .direction = direction, .steps = distance };
            try directions.append(move);
        }
    } else |err| switch (err) {
        error.EndOfStream => {},
        else => return err,
    }

    // for (directions.items) |direction| {
    //     std.debug.print("Direction: {s}, Steps: {d}\n", .{ @tagName(direction.direction), direction.steps });
    // }

    var heading = Heading.North;
    for (directions.items) |move| {
        heading = turn(heading, move.direction);
        const movement = AbsMove{ .heading = heading, .steps = move.steps };
        try movements.append(movement);
        // std.debug.print("Heading: {s}, Steps: {d}\n", .{ @tagName(heading), move.steps });
    }

    var x: i32 = 0;
    var y: i32 = 0;
    var x_cross: i32 = 0;
    var y_cross: i32 = 0;
    for (movements.items) |m| {
        const moves: usize = @intCast(m.steps);
        switch (m.heading) {
            Heading.North => {
                for (0..moves) |_| {
                    y += 1;
                    const position = Position{ .x = x, .y = y };
                    const is_duplicate = checkPosition(positions.items, position);
                    if (is_duplicate) {
                        // std.debug.print("Duplicate position found: ({d}, {d})\n", .{ position.x, position.y });
                        x_cross = x;
                        y_cross = y;
                        break;
                    }
                    try positions.append(position);
                }
            },
            Heading.East => {
                for (0..moves) |_| {
                    x += 1;
                    const position = Position{ .x = x, .y = y };
                    const is_duplicate = checkPosition(positions.items, position);
                    if (is_duplicate) {
                        // std.debug.print("Duplicate position found: ({d}, {d})\n", .{ position.x, position.y });
                        x_cross = x;
                        y_cross = y;
                        break;
                    }
                    try positions.append(position);
                }
            },
            Heading.South => {
                for (0..moves) |_| {
                    y -= 1;
                    const position = Position{ .x = x, .y = y };
                    const is_duplicate = checkPosition(positions.items, position);
                    if (is_duplicate) {
                        // std.debug.print("Duplicate position found: ({d}, {d})\n", .{ position.x, position.y });
                        x_cross = x;
                        y_cross = y;
                        break;
                    }
                    try positions.append(position);
                }
            },
            Heading.West => {
                for (0..moves) |_| {
                    x -= 1;
                    const position = Position{ .x = x, .y = y };
                    const is_duplicate = checkPosition(positions.items, position);
                    if (is_duplicate) {
                        // std.debug.print("Duplicate position found: ({d}, {d})\n", .{ position.x, position.y });
                        x_cross = x;
                        y_cross = y;
                        break;
                    }
                    try positions.append(position);
                }
            },
        }
    }

    const manhattan_distance = @abs(x) + @abs(y);
    // std.debug.print("Manhattan distance: {d}\n", .{manhattan_distance});
    const first_duplicate = @abs(x_cross) + @abs(y_cross);

    // for (positions.items) |position| {
    //     std.debug.print("Position: ({d}, {d})\n", .{ position.x, position.y });
    // }

    return .{
        .part1 = .{ .number = @as(u64, manhattan_distance) },
        .part2 = .{ .number = @as(u64, first_duplicate) },
    };
}
