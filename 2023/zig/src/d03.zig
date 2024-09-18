const std = @import("std");
const ascii = std.ascii;
const testing = std.testing;
const buffIter = @import("buff-iter.zig");

const Part = struct {
    line: u32,
    begin: u32,
    end: u32,
    val: u32,
};

const Value = struct {
    line: u32,
    row: u32,
    value: u32,
    used: bool = false,
};

const Symbol = struct {
    line: u32,
    row: u32,
};

const Map = struct {
    line: u32,
    row: u32,
    part: Part,
};

fn createValue(line: u32, begin: u32, end: u32, value: u32) void {
    var index = begin;
    while (index <= end) : (index += 1) {
        const val = Value{ .line = line, .row = index, .value = value };
        _ = val; // autofix
    }
}

fn parseLine(line_num: u32, line: []const u8, parts: *std.ArrayList(Part), symbols: *std.ArrayList(Symbol)) !void {
    var num: u32 = 0;
    var num_len: u8 = 0;
    for (line, 0..) |char, index| {
        const local_index: u32 = @intCast(index);
        if (ascii.isDigit(char)) {
            num = num * 10 + (char - '0');
            num_len += 1;
        } else {
            // close number
            if (num_len > 0) {
                const begin = local_index - num_len;
                const end = local_index - 1;

                const part = Part{ .line = line_num, .begin = begin, .end = end, .val = num };
                try parts.append(part);
                num = 0;
                num_len = 0;
            }
            if (char == '.') {
                continue;
            } else {
                try symbols.append(Symbol{ .line = line_num, .row = local_index });
            }
        }
    }
}

fn parseInput() !void {
    var iter = try buffIter.iterLines("./data/03-in.txt");
    defer iter.deinit();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var parts = std.ArrayList(Part).init(allocator);
    var symbols = std.ArrayList(Symbol).init(allocator);
    defer parts.deinit();
    defer symbols.deinit();

    var current_line: u32 = 0;

    while (try iter.next()) |line| : (current_line += 1) {
        try parseLine(current_line, line, &parts, &symbols);
    }
    // std.debug.print("PARTS: {any}", .{symbols.items});
    // for (symbols.items) |sym| {
    //     std.debug.print("PART: {any},{any}", .{ sym.row, sym.line });
    // }
    partsToHash(&parts);
}

fn partsToHash(parts: *std.ArrayList(Part)) void {
    // var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // const allocator = gpa.allocator();
    // var map = std.AutoHashMap(Map, Part).init(allocator);
    for (parts.items) |part| {
        // try map.put(key: K, value: V)
        if (part.val == 128) {
            std.debug.print("Found {any}", .{part});
        }
    }
}

pub fn main() !void {
    std.debug.print("P1, \n", .{});
    std.debug.print("P2, \n", .{});
    try parseInput();
}

test "test parseLine" {
    const allocator = testing.allocator;
    var parts = std.ArrayList(Part).init(allocator);
    var symbols = std.ArrayList(Symbol).init(allocator);
    defer parts.deinit();
    defer symbols.deinit();

    //                             012345678901234
    const line = ".....489..*.152...";

    const partsExpected = [_]Part{ Part{ .line = 0, .begin = 5, .end = 7, .val = 489 }, Part{ .line = 0, .begin = 12, .end = 14, .val = 152 } };
    const symbolsExpected = [_]Symbol{
        Symbol{ .line = 0, .row = 10 },
    };

    try parseLine(0, line, &parts, &symbols);

    try testing.expectEqualSlices(Part, &partsExpected, parts.items);
    try testing.expectEqualSlices(Symbol, &symbolsExpected, symbols.items);
}
