const std = @import("std");
const buffIter = @import("buff-iter.zig");

const STRNUMS = [_][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };

pub fn main() !void {
    var iter = try buffIter.iterLines("./data/01-in.txt");
    defer iter.deinit();

    var p1: u32 = 0;
    var p2: u32 = 0;

    while (try iter.next()) |line| {
        p1 += processLineP1(line);
        p2 += processLineP2(line);
    }

    std.debug.print("P1: {d}\n", .{p1});
    std.debug.print("P2: {d}\n", .{p2});
}

fn processLineP1(line: []const u8) u8 {
    var first: ?u8 = null;
    var second: u8 = 0;

    for (line) |char| {
        if (std.ascii.isDigit(char)) {
            const digit = char - '0';
            if (first == null) {
                first = digit * 10;
            }
            second = digit;
        }
    }

    return first.? + second;
}

fn findNumStr(line: []const u8) ?u8 {
    var digit: ?u8 = null;
    for (STRNUMS, 1..) |strNum, num_digit| {
        if (std.mem.startsWith(u8, line, strNum)) {
            digit = @intCast(num_digit);
        }
    }
    return digit;
}

fn processLineP2(line: []const u8) u8 {
    var first: ?u8 = null;
    var second: u8 = 0;

    // TODO: move that to a while to advance when a STRNUM is found
    for (line, 0..) |char, line_index| {
        var digit: ?u8 = null;

        if (std.ascii.isDigit(char)) {
            digit = char - '0';
        } else {
            digit = findNumStr(line[line_index..]);
            // TODO: digit must be used to get number of chars to advance on line
        }
        if (digit != null) {
            if (first == null) {
                first = digit.? * 10;
            }
            second = digit.?;
        }
    }

    return first.? + second;
}
