const std = @import("std");
const types = @import("types.zig");
const buffIter = @import("buff-iter.zig");

fn calculateDistance(lefts: []const u32, rights: []const u32) u32 {
    var distance: u32 = 0;
    for (lefts, 0..) |left_value, i| {
        const right_value = rights[i];
        const diff = @abs(@as(i64, left_value) - @as(i64, right_value));
        distance += @intCast(diff);
    }
    return distance;
}

fn calculateRelevance(lefts: []const u32, rights: []const u32) u32 {
    var relevance: u32 = 0;
    for (lefts) |curr_left| {
        var count: u32 = 0;
        for (rights) |curr_right| {
            if (curr_left == curr_right) {
                count += 1;
            }
        }

        relevance += curr_left * count;
    }
    return relevance;
}

pub fn solve() !types.Solution {
    var iter = try buffIter.iterLines("./data/01-input.txt");
    defer iter.deinit();

    var lefts = std.ArrayList(u32).init(std.heap.page_allocator);
    defer lefts.deinit();
    var rights = std.ArrayList(u32).init(std.heap.page_allocator);
    defer rights.deinit();

    while (try iter.next()) |line| {
        var token_it = std.mem.tokenizeScalar(u8, line, ' ');
        if (token_it.next()) |left_str| {
            const left_value = try std.fmt.parseInt(u32, left_str, 10);
            try lefts.append(left_value);
        }
        if (token_it.next()) |right_str| {
            const right_value = try std.fmt.parseInt(u32, right_str, 10);
            try rights.append(right_value);
        }
    }

    std.mem.sort(u32, lefts.items, {}, std.sort.asc(u32));
    std.mem.sort(u32, rights.items, {}, std.sort.asc(u32));

    return .{
        .part1 = .{ .number = calculateDistance(lefts.items, rights.items) },
        .part2 = .{ .number = calculateRelevance(lefts.items, rights.items) },
    };
}
