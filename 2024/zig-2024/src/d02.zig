const std = @import("std");
const types = @import("types.zig");
const buffIter = @import("buff-iter.zig");

fn isAlmostValidLine(numbers: []const u32) bool {
    const is_increasing = numbers[1] > numbers[0];

    var max_errors: u8 = 0;
    for (numbers[1..], 0..) |curr, i| {
        const prev = numbers[i];
        const diff = @as(i64, curr) - @as(i64, prev);

        // Check direction
        if (is_increasing and diff <= 0) {
            max_errors += 1;
            continue;
        }
        if (!is_increasing and diff >= 0) {
            max_errors += 1;
            continue;
        }

        //   Check difference magnitude
        const abs_diff = @abs(diff);
        if (abs_diff < 1 or abs_diff > 3) {
            max_errors += 1;
            continue;
        }
    }

    return max_errors < 2;
}

fn isValidLine(numbers: []const u32) bool {
    const is_increasing = numbers[1] > numbers[0];

    for (numbers[1..], 0..) |curr, i| {
        const prev = numbers[i];
        const diff = @as(i64, curr) - @as(i64, prev);

        // Check direction
        if (is_increasing and diff <= 0) return false;

        if (!is_increasing and diff >= 0) return false;

        //   Check difference magnitude
        const abs_diff = @abs(diff);
        if (abs_diff < 1 or abs_diff > 3) return false;
    }

    return true;
}

pub fn solve() !types.Solution {
    // var iter = try buffIter.iterLines("./data/02-input.txt");
    var iter = try buffIter.iterLines("./data/02-sample.txt");
    defer iter.deinit();

    var all_numbers = std.ArrayList(std.ArrayList(u32)).init(std.heap.page_allocator);
    defer {
        for (all_numbers.items) |*number_list| {
            number_list.deinit();
        }
        all_numbers.deinit();
    }

    while (try iter.next()) |line| {
        var numbers = std.ArrayList(u32).init(std.heap.page_allocator);
        var token_it = std.mem.splitScalar(u8, line, ' ');
        while (token_it.next()) |number_str| {
            const number = try std.fmt.parseInt(u32, number_str, 10);
            try numbers.append(number);
        }
        try all_numbers.append(numbers);
    }

    var is_valid_count: u32 = 0;
    var is_almost_valid: u32 = 0;

    for (all_numbers.items) |number_list| {
        if (isValidLine(number_list.items)) {
            is_valid_count += 1;
        }
        if (isAlmostValidLine(number_list.items)) {
            is_almost_valid += 1;
        }
    }

    return .{
        .part1 = .{ .number = is_valid_count },
        .part2 = .{ .number = is_almost_valid },
    };
}
