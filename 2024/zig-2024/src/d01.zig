const std = @import("std");
const buffIter = @import("buff-iter.zig");


fn calculateDistance(lefts: []const u32, rights: []const u32) u32 {
    var distance: u32 = 0;
    for (lefts, 0..) |left_value, i| {
        const right_value = rights[i];
        const diff2 = @abs(@as(i64, left_value) - @as(i64, right_value));
        distance += @intCast(diff2);
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

pub fn main() !void {
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

    std.debug.print("P1: {d}\n", .{calculateDistance(lefts.items, rights.items)});
    std.debug.print("P2: {d}\n", .{calculateRelevance(lefts.items, rights.items)});
}
