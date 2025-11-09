const std = @import("std");
const types = @import("types.zig");

const Keypad = []const []const u8;

const Numpad = struct {
    keypad: Keypad,
    width: usize,
    height: usize,
    x: usize,
    y: usize,

    pub fn init(keypad: Keypad, start_x: usize, start_y: usize) Numpad {
        return Numpad{
            .keypad = keypad,
            .width = keypad[0].len,
            .height = keypad.len,
            .x = start_x,
            .y = start_y,
        };
    }

    pub fn getCurrPos(self: Numpad) u8 {
        return self.keypad[self.y][self.x];
    }

    pub fn moveTo(self: *Numpad, directions: []const u8) void {
        for (directions) |direction| {
            var new_x = self.x;
            var new_y = self.y;

            switch (direction) {
                'U' => {
                    if (new_y > 0) new_y -= 1;
                },
                'D' => {
                    if (new_y + 1 < self.height) new_y += 1;
                },
                'L' => {
                    if (new_x > 0) new_x -= 1;
                },
                'R' => {
                    if (new_x + 1 < self.width) new_x += 1;
                },
                else => {},
            }

            // Check if the new position is a wall
            if (self.keypad[new_y][new_x] != '.') {
                self.x = new_x;
                self.y = new_y;
            }
        }
    }
};

// 5x5 keypad definition
const keypad_5x5 = [_][]const u8{
    ".....",
    ".123.",
    ".456.",
    ".789.",
    ".....",
};

// Diamond-shaped keypad definition
const keypad_diamond = [_][]const u8{
    ".......",
    "...1...",
    "..234..",
    ".56789.",
    "..ABC..",
    "...D...",
    ".......",
};

fn readData(alloc: std.mem.Allocator) !std.array_list.Managed([]u8) {
    const file = try std.fs.cwd().openFile("data/day02.txt", .{});
    defer file.close();

    var buffer: [1024]u8 = undefined;
    var reader = file.reader(&buffer);

    var lines = std.array_list.Managed([]u8).init(alloc);

    while (reader.interface.takeDelimiterInclusive('\n')) |line| {
        const line_no_nl = line[0 .. line.len - 1];
        // Allocate a copy of the line
        const line_copy = try alloc.alloc(u8, line_no_nl.len);
        std.mem.copyForwards(u8, line_copy, line_no_nl);
        try lines.append(line_copy);
    } else |err| switch (err) {
        error.EndOfStream => {},
        else => return err,
    }

    return lines;
}

fn getCodeForNumpad(alloc: std.mem.Allocator, numpad: *Numpad, lines: [][]u8) ![]const u8 {
    var code_buffer = try alloc.alloc(u8, lines.len);

    for (lines, 0..) |line, i| {
        numpad.moveTo(line);
        code_buffer[i] = numpad.getCurrPos();
    }
    return code_buffer;
}

pub fn solve() !types.Solution {
    const alloc = std.heap.page_allocator;
    const input_lines = try readData(alloc);
    defer input_lines.deinit();

    var numpad = Numpad.init(&keypad_5x5, 2, 2);
    const code_1 = try getCodeForNumpad(alloc, &numpad, input_lines.items);

    numpad = Numpad.init(&keypad_diamond, 3, 3);
    const code_2 = try getCodeForNumpad(alloc, &numpad, input_lines.items);

    return .{
        .part1 = types.Answer{ .string = code_1 },
        .part2 = types.Answer{ .string = code_2 },
    };
}

test "Numpad creation and getCurrPos" {
    var numpad = Numpad.init(&keypad_5x5, 2, 2);
    try std.testing.expectEqual(numpad.x, 2);
    try std.testing.expectEqual(numpad.y, 2);
    try std.testing.expectEqual(numpad.getCurrPos(), '5');
}

test "Numpad moveTo functionality" {
    var numpad = Numpad.init(&keypad_5x5, 2, 2);

    // Test valid movements from '5'
    const move_up = [_]u8{'U'};
    numpad.moveTo(&move_up);
    try std.testing.expectEqual(numpad.getCurrPos(), '2');

    const move_down_twice = [_]u8{ 'D', 'D' };
    numpad.moveTo(&move_down_twice); // From 2, D to 5, then D to 8
    try std.testing.expectEqual(numpad.getCurrPos(), '8');

    const move_up_left = [_]u8{ 'U', 'L' };
    numpad.moveTo(&move_up_left); // From 8, U to 5, then L to 4
    try std.testing.expectEqual(numpad.getCurrPos(), '4');

    const move_right_twice = [_]u8{ 'R', 'R' };
    numpad.moveTo(&move_right_twice); // From 4, R to 5, then R to 6
    try std.testing.expectEqual(numpad.getCurrPos(), '6');

    const move_left = [_]u8{'L'};
    numpad.moveTo(&move_left); // Back to 5
    try std.testing.expectEqual(numpad.getCurrPos(), '5');

    // Test invalid movements
    // From '5', move L to 4, then cannot go 'L' from '4'
    const move_left_twice = [_]u8{ 'L', 'L' };
    numpad.moveTo(&move_left_twice);
    try std.testing.expectEqual(numpad.getCurrPos(), '4');

    // From '4', cannot go 'L'
    numpad.moveTo(&move_left);
    try std.testing.expectEqual(numpad.getCurrPos(), '4');

    // From '6', cannot go 'R'
    numpad.x = 3; // Manually set to 6 (x=3, y=2)
    numpad.y = 2;
    const move_right_invalid = [_]u8{ 'R', 'R' };
    numpad.moveTo(&move_right_invalid); // Current is 6
    try std.testing.expectEqual(numpad.getCurrPos(), '6');

    // From '2', cannot go 'U'
    numpad.x = 2; // Manually set to 2 (x=2, y=1)
    numpad.y = 1;
    const move_up_invalid = [_]u8{ 'U', 'U' };
    numpad.moveTo(&move_up_invalid); // Current is 2
    try std.testing.expectEqual(numpad.getCurrPos(), '2');
}
