const std = @import("std");
const types = @import("types.zig");

const Room = struct {
    encrypted_name: []const u8,
    checksum: [5]u8,
    sector_id: u32,
};

fn readData(alloc: std.mem.Allocator) !std.array_list.Managed([]u8) {
    const file = try std.fs.cwd().openFile("data/temp.txt", .{});
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

fn parseRooms(alloc: std.mem.Allocator, line: []const u8) !Room {
    const parts = std.mem.split(u8, line, "-");
    var encrypted_name = std.ArrayList(u8).init(alloc);
    var checksum = [5]u8{ 0, 0, 0, 0, 0 };

    while (parts.next()) |part| {
        if (std.mem.startsWith(u8, part, "[") and std.mem.endsWith(u8, part, "]")) {
            std.mem.copy(u8, &checksum, part[1..5]);
            break;
        }
        try encrypted_name.appendSlice(part);
        try encrypted_name.append('-');
    }

    return Room{
        .encrypted_name = encrypted_name.items,
        .checksum = checksum,
    };
}

const User = struct {
    name: []const u8,
    age: u8,
    manager: ?*const User,

    fn levelUp(self: *User) void {
        self.age += 1;
    }
};

fn testing() void {
    const user = User{
        .name = "John",
        .age = 30,
    };

    std.debug.print("User: {s}, Age: {d}\n", .{ user.name, user.age });
}

pub fn solve() !types.Solution {
    const alloc = std.heap.page_allocator;

    const lines = try readData(alloc);
    defer lines.deinit();

    std.debug.print("Read {any} lines\n", .{lines.items});

    // Placeholder for actual logic
    const part1_result: u64 = 0;
    const part2_result: u64 = 0;

    return .{
        .part1 = types.Answer{ .number = part1_result },
        .part2 = types.Answer{ .number = part2_result },
    };
}

fn parseLine(line: []const u8) ![]const u8 {
    var parts = std.mem.splitScalar(u8, line, '-');
    const allocator = std.heap.page_allocator;
    var collected_parts = std.array_list.Managed([]const u8).init(allocator);
    defer collected_parts.deinit();

    var total_len: usize = 0;
    while (parts.next()) |part| {
        try collected_parts.append(part);
    }

    // Calculate total_len, excluding the last part
    // Ensure there's at least one part before trying to exclude the last
    if (collected_parts.items.len > 0) {
        for (collected_parts.items[0 .. collected_parts.items.len - 1]) |part| {
            total_len += part.len;
        }
    }

    // Allocate a new buffer for the concatenated string
    var concatenated_string = try allocator.alloc(u8, total_len);
    var current_offset: usize = 0;

    // Copy all parts except the last one
    if (collected_parts.items.len > 0) {
        for (collected_parts.items[0 .. collected_parts.items.len - 1]) |part| {
            std.mem.copyForwards(u8, concatenated_string[current_offset .. current_offset + part.len], part);
            current_offset += part.len;
        }
    }

    std.debug.print("Collected Parts: {any}\n", .{collected_parts.items});
    std.debug.print("Concatenated String (excluding last): {s}\n", .{concatenated_string});

    return concatenated_string; // Return the heap-allocated string
}

test "day04 simple test" {
    // The test now needs to handle the returned heap-allocated string
    const result_string = try parseLine("aaaaa-bbb-z-y-x-123[abxyz]");
    defer std.heap.page_allocator.free(result_string); // Free the allocated memory

    // Expected string should now exclude "123[abxyz]"
    try std.testing.expectEqualSlices(u8, "aaaaabbbzyx", result_string);
}

test "check array things" {
    const array = [_][]const u8{ "hello", "world" };

    std.debug.print("Array: {any}\n", .{array});
    std.debug.print("Array: {s}\n", .{array[1]});
}

test "check pointers" {
    var user = User{ .name = "John", .age = 30, .manager = null };

    user.levelUp();
    std.debug.print("User: {s}, {d}, {s}\n", .{ user.name, user.age, user.manager.?.name });
    try std.testing.expectEqual(user.age, 31);
}
