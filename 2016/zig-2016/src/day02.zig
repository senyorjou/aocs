const std = @import("std");
const types = @import("types.zig");

const Keypad = [5][5]u8;

const Numpad = struct {
    keypad: Keypad,
    x: u8,
    y: u8,

    pub fn init() Numpad {
        return Numpad{
            .keypad = .{
                .{ '@', '@', '@', '@', '@' },
                .{ '@', '1', '2', '3', '@' },
                .{ '@', '4', '5', '6', '@' },
                .{ '@', '7', '8', '9', '@' },
                .{ '@', '@', '@', '@', '@' },
            },
            .x = 2,
            .y = 2,
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
                    new_y -|= 1;
                },
                'D' => {
                    new_y +|= 1;
                },
                'L' => {
                    new_x -|= 1;
                },
                'R' => {
                    new_x +|= 1;
                },
                else => {},
            }

            // Check boundaries and if the new position is a wall
            if (new_x >= 0 and new_x < 5 and new_y >= 0 and new_y < 5) {
                if (self.keypad[new_y][new_x] != '@') {
                    self.x = new_x;
                    self.y = new_y;
                }
            }
        }
    }
};

fn readData(alloc: std.mem.Allocator) !std.array_list.Managed(u8) {
    const file = try std.fs.cwd().openFile("data/foo.txt", .{});
    defer file.close();

    // reader
    var buffer: [1024]u8 = undefined;
    var reader = file.reader(&buffer);

    var all_chars = std.array_list.Managed(u8).init(alloc);

    while (reader.interface.takeDelimiterInclusive('\n')) |line| {
        const line_no_nl = line[0 .. line.len - 1];

        try all_chars.appendSlice(line_no_nl);
    } else |err| switch (err) {
        error.EndOfStream => {},
        else => return err,
    }

    return all_chars;
}

pub fn solve() !types.Solution {
    const alloc = std.heap.page_allocator;
    const all_chars = try readData(alloc);
    defer all_chars.deinit();

    var numpad = Numpad.init();
    numpad.moveTo("UUL");
    std.debug.print("Code: {c}\n", .{numpad.getCurrPos()});
    numpad.moveTo("RRDDD");
    std.debug.print("Code: {c}\n", .{numpad.getCurrPos()});
    numpad.moveTo("LURDL");
    std.debug.print("Code: {c}\n", .{numpad.getCurrPos()});
    numpad.moveTo("UUUUD");
    std.debug.print("Code: {c}\n", .{numpad.getCurrPos()});

    std.debug.print("Read {d} characters:\n{s}\n", .{ all_chars.items.len, all_chars.items });
    return .{
        .part1 = .{ .string = "ABC" },
        .part2 = .{ .number = 0 },
    };
}

test "Numpad creation and getCurrPos" {
    var numpad = Numpad.init();
    try std.testing.expectEqual(numpad.x, 2);
    try std.testing.expectEqual(numpad.y, 2);
    try std.testing.expectEqual(numpad.getCurrPos(), '5');
}

test "Numpad moveTo functionality" {
    var numpad = Numpad.init();

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
