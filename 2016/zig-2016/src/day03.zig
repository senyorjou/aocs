const std = @import("std");
const types = @import("types.zig");

const Triangle = struct {
    a: u32,
    b: u32,
    c: u32,
};

fn isTriangle(a: u32, b: u32, c: u32) bool {
    return a + b > c and a + c > b and b + c > a;
}

fn readData(alloc: std.mem.Allocator) !std.array_list.Managed([]u8) {
    const file = try std.fs.cwd().openFile("data/temp.txt", .{});
    defer file.close();

    var buffer: [1024]u8 = undefined;
    var reader = file.reader(&buffer);

    var lines = std.array_list.Managed([]u8).init(alloc);
    defer lines.deinit();

    var triangles = std.array_list.Managed(Triangle).init(std.heap.page_allocator);
    defer triangles.deinit();

    while (reader.interface.takeDelimiterInclusive('\n')) |line| {
        var token_it = std.mem.splitScalar(u8, line, ' ');
        while (token_it.next()) |number_str| {
            const trimmed = std.mem.trim(u8, number_str, " \t\r\n");
            try triangles.append(trimmed);
        }
    } else |err| switch (err) {
        error.EndOfStream => {},
        else => return err,
    }

    return lines;
}

pub fn solve() !types.Solution {
    const alloc = std.heap.page_allocator;
    _ = alloc; // Suppress unused variable warning if not used immediately

    // Placeholder for reading data
    // const file = try std.fs.cwd().openFile("data/day03.txt", .{});
    // defer file.close();
    // var buffer: [1024]u8 = undefined;
    // var reader = file.reader(&buffer);

    // Placeholder for actual logic
    const part1_result: u64 = 0;
    const part2_result: u64 = 0;

    return .{
        .part1 = types.Answer{ .number = part1_result },
        .part2 = types.Answer{ .number = part2_result },
    };
}

test "day03 simple test" {
    try std.testing.expect(!isTriangle(1, 2, 3));
    try std.testing.expect(isTriangle(2, 3, 4));
}
