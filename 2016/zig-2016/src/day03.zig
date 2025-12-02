const std = @import("std");
const types = @import("types.zig");
const file_reader = @import("file_reader.zig");

const Triangle = struct {
    a: u32,
    b: u32,
    c: u32,
};

fn isTriangle(a: u32, b: u32, c: u32) bool {
    return a + b > c and a + c > b and b + c > a;
}

// Reads the input file and returns an ArrayList of ArrayLists of u32,
// where each inner ArrayList represents the numbers on a single line.
fn readRawNumbers(alloc: std.mem.Allocator) !std.array_list.Managed([]u32) {
    const file = try std.fs.cwd().openFile("data/day03.txt", .{});
    defer file.close();

    var buffer: [1024]u8 = undefined;
    var reader = file.reader(&buffer);

    var all_numbers_per_line = std.array_list.Managed([]u32).init(alloc);

    while (reader.interface.takeDelimiterInclusive('\n')) |line| {
        var numbers_on_line = std.array_list.Managed(u32).init(alloc);
        defer numbers_on_line.deinit(); // Deinit the temporary list for this line

        var it = std.mem.tokenizeScalar(u8, line, ' ');
        while (it.next()) |token| {
            const trimmed = std.mem.trim(u8, token, " \t\r\n");
            if (trimmed.len == 0) continue;

            const num = try std.fmt.parseUnsigned(u32, trimmed, 10);
            try numbers_on_line.append(num);
        }

        if (numbers_on_line.items.len != 3) {
            std.debug.print("Warning: Line did not contain 3 numbers: {s}\n", .{line});
            continue;
        }

        // Append a *copy* of the numbers for this line to the main list
        const line_numbers_copy = try alloc.dupe(u32, numbers_on_line.items);
        try all_numbers_per_line.append(line_numbers_copy);
    } else |err| switch (err) {
        error.EndOfStream => {},
        else => return err,
    }

    return all_numbers_per_line;
}

pub fn solve() !types.Solution {
    const alloc = std.heap.page_allocator;

    // Read all raw numbers from the file
    var raw_numbers_per_line = try readRawNumbers(alloc);
    defer {
        // Deallocate each inner slice (numbers for a line)
        for (raw_numbers_per_line.items) |line_numbers| {
            alloc.free(line_numbers);
        }
        // Deallocate the outer ArrayList itself
        raw_numbers_per_line.deinit();
    }

    // --- Part 1 Logic (Row by Row) ---
    var part1_triangles = std.array_list.Managed(Triangle).init(alloc);
    defer part1_triangles.deinit();

    for (raw_numbers_per_line.items) |line_numbers| {
        const triangle = Triangle{
            .a = line_numbers[0],
            .b = line_numbers[1],
            .c = line_numbers[2],
        };
        try part1_triangles.append(triangle);
    }

    var filtered_part1 = std.array_list.Managed(Triangle).init(alloc);
    defer filtered_part1.deinit();

    for (part1_triangles.items) |triangle| {
        if (isTriangle(triangle.a, triangle.b, triangle.c)) {
            try filtered_part1.append(triangle);
        }
    }
    const part1_result: u64 = filtered_part1.items.len;

    // --- Part 2 Logic (Column by Column) ---
    var part2_triangles = std.array_list.Managed(Triangle).init(alloc);
    defer part2_triangles.deinit();

    // Process in groups of 3 lines
    var i: usize = 0;
    while (i + 2 < raw_numbers_per_line.items.len) : (i += 3) {
        const line1 = raw_numbers_per_line.items[i];
        const line2 = raw_numbers_per_line.items[i + 1];
        const line3 = raw_numbers_per_line.items[i + 2];

        // First column forms a triangle
        try part2_triangles.append(.{ .a = line1[0], .b = line2[0], .c = line3[0] });
        // Second column forms a triangle
        try part2_triangles.append(.{ .a = line1[1], .b = line2[1], .c = line3[1] });
        // Third column forms a triangle
        try part2_triangles.append(.{ .a = line1[2], .b = line2[2], .c = line3[2] });
    }

    var filtered_part2 = std.array_list.Managed(Triangle).init(alloc);
    defer filtered_part2.deinit();

    for (part2_triangles.items) |triangle| {
        if (isTriangle(triangle.a, triangle.b, triangle.c)) {
            try filtered_part2.append(triangle);
        }
    }
    const part2_result: u64 = filtered_part2.items.len;

    return .{
        .part1 = types.Answer{ .number = part1_result },
        .part2 = types.Answer{ .number = part2_result },
    };
}

test "day03 simple test" {
    try std.testing.expect(isTriangle(2, 3, 4));
    try std.testing.expect(!isTriangle(1, 2, 3)); // Add a failing triangle test
}
