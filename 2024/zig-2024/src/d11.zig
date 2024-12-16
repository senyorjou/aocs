const std = @import("std");
const types = @import("types.zig");
const buffIter = @import("buff-iter.zig");

const Result = struct { left: u64, right: ?u64 };
const Cache = std.AutoHashMap(u64, Result);

fn isEven(num: u64) bool {
    return num % 2 == 0;
}

fn hasEvenDigits(num: u64) bool {
    var buf: [20]u8 = undefined;
    const numStr = std.fmt.bufPrint(&buf, "{d}", .{num}) catch return false;
    return numStr.len % 2 == 0;
}

fn splitNum(num: u64) !Result {
    var buf: [20]u8 = undefined;
    const numStr = try std.fmt.bufPrint(&buf, "{d}", .{num});
    const mid = numStr.len / 2;
    return .{
        .left = try parseu64(numStr[0..mid]),
        .right = try parseu64(numStr[mid..]),
    };
}

fn parseu64(num: []const u8) !u64 {
    return try std.fmt.parseInt(u64, num, 10);
}

fn process(num: u64, cache: *Cache) !Result {
    // Check if result is in cache
    if (cache.get(num)) |cached_result| {
        return cached_result;
    }

    // Calculate result
    const result = if (num == 0)
        Result{ .left = 1, .right = null }
    else if (hasEvenDigits(num))
        try splitNum(num)
    else
        Result{ .left = num * 2024, .right = null };

    // Store in cache
    try cache.put(num, result);
    return result;
}

pub fn solve() !types.Solution {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    var cache = Cache.init(allocator);
    defer cache.deinit();

    var numbers = std.ArrayList(u64).init(allocator);
    defer numbers.deinit();

    // const input = "125 17";
    const input = "4610211 4 0 59 3907 201586 929 33750";
    var iterator = std.mem.splitScalar(u8, input, ' ');

    while (iterator.next()) |part| {
        const num = try std.fmt.parseInt(u64, part, 10);
        try numbers.append(num);
    }

    var blinks: u8 = 0;
    while (blinks < 50) : (blinks += 1) {
        var index: usize = 0;
        while (index < numbers.items.len) : (index += 1) {
            const nums = try process(numbers.items[index], &cache);
            numbers.items[index] = nums.left;
            if (nums.right) |right| {
                try numbers.insert(index + 1, right);
                index += 1;
            }
        }
    }

    // try numbers.insert(1, 33);

    // std.debug.print("Numbers: {any}", .{numbers});

    return .{
        .part1 = .{ .number = numbers.items.len },
        .part2 = .{ .number = 99 },
    };
}
