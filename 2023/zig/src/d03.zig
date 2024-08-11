const std = @import("std");
// const buffIter = @import("buff-iter.zig");

const Part = struct {
    begin: u32,
    end: u32,
    val: u32,
};

fn parseLine(line: []const u8) Part {
    var nums = std.mem.splitScalar(u8, line, '.');
    var index: u8 = 0;
    while (nums.next()) |num| : (index += 1) {
        if (num.len == 0) {
            continue;


        }
        // const index = std.mem.indexOf(u8, line, num).?;
        // const index_32 = @as(u32, @intCast(index));

        const foo: u32 = try std.fmt.parseInt(u32, num, 10);
        std.debug.print("VAL: {s} {d} {?d}\n", .{ num, num.len, foo });

        const part = Part{ .begin = index, .end = index + @as(u32, @intCast(num.len)) - 1, .val = 0 };

        std.debug.print("Part: {}\n", .{part});
    }

    return Part{ .begin = 0, .end = 0, .val = 0 };
}

fn runLine(line: []const u8) u8 {
    var number: u32 = 0;
    var exp: u32 = 1;
    var in_number: bool = false;

    for (line, 0..) |char, i| {
        if (std.ascii.isDigit(char)) {
            _ = i;
            in_number = true;
            number = number * exp + (char - '0');
            exp = 10;
            // std.debug.print("Found: {d} at {d}  ", .{ number, i });
        } else {
            if (in_number) {
                in_number = false;
                std.debug.print("Found: {d}\n", .{number});
                number = 0;
                exp = 1;
            }
        }
    }

    return 0;
}

pub fn main() !void {
    std.debug.print("P1, \n", .{});
    std.debug.print("P2, \n", .{});
}

test "test parseLine" {
    const line = ".....489............................152....503.........................180......200.........147.......13.......................239..........";

    const expected = parseLine(line);
    const actual = Part{ .begin = 0, .end = 0, .val = 0 };
    try std.testing.expectEqual(expected, actual);
}

test "test runLine" {
    const line = ".....489............................152....503.........................180......200.........147.......13.......................239..........";

    const expected = runLine(line);
    const actual: u8 = 0;

    try std.testing.expectEqual(expected, actual);
}
