const std = @import("std");
const types = @import("types.zig");
const buffIter = @import("buff-iter.zig");

fn createBlocks(content: []const u8, allocator: std.mem.Allocator) !std.ArrayList(i16) {
    var blocks = std.ArrayList(i16).init(allocator);
    errdefer blocks.deinit();
    var ids: i16 = 0;
    var is_data = true;

    for (content) |c| {
        if (is_data) {
            for (c - '0') |_| {
                try blocks.append(ids);
            }
            ids += 1;
        } else {
            for (c - '0') |_| {
                try blocks.append(-1);
            }
        }
        is_data = !is_data;
    }
    return blocks;
}

fn createSuperBlocks(content: []const u8, allocator: std.mem.Allocator) !struct { data_blocks: std.ArrayList(i16), space_blocks: std.ArrayList(i16) } {
    var data_blocks = std.ArrayList(i16).init(allocator);
    errdefer data_blocks.deinit();
    var space_blocks = std.ArrayList(i16).init(allocator);
    errdefer space_blocks.deinit();

    var is_data = true;

    for (content) |c| {
        if (is_data) {
            try data_blocks.append(c - '0');
        } else {
            try space_blocks.append(c - '0');
        }
        is_data = !is_data;
    }
    return .{ .data_blocks = data_blocks, .space_blocks = space_blocks };
}

fn reorderBlocksBy1(blocks: *std.ArrayList(i16)) void {
    var write_index: usize = 0;
    while (write_index < blocks.items.len) {
        if (blocks.items[write_index] == -1) {
            var tmp: i16 = -1;
            while (blocks.items.len > write_index) {
                tmp = blocks.pop();
                if (tmp != -1) {
                    break;
                }
            }
            if (tmp != -1) {
                blocks.items[write_index] = tmp;
                write_index += 1;
            }
        } else {
            write_index += 1;
        }
    }
}

fn countBlocks(blocks: std.ArrayList(i16)) usize {
    var total: usize = 0;
    for (blocks.items, 0..) |value, idx| {
        total += @as(usize, @intCast(value)) * idx;
    }
    return total;
}

pub fn solve() !types.Solution {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file = try std.fs.cwd().openFile("./data/09-sample.txt", .{});
    // const file = try std.fs.cwd().openFile("./data/09-input.txt", .{});
    defer file.close();

    const file_size = try file.getEndPos();
    var buffer: []u8 = try std.heap.page_allocator.alloc(u8, file_size);
    defer std.heap.page_allocator.free(buffer);

    const bytes_read = try file.readAll(buffer);
    const content = std.mem.trimRight(u8, buffer[0..bytes_read], "\r\n");

    // Create blocks, part 1
    var blocks1 = try createBlocks(content, allocator);
    defer blocks1.deinit();
    // Reorder to compact
    reorderBlocksBy1(&blocks1);

    // Create blocks, part 2
    var blocks = try createSuperBlocks(content, allocator);
    defer {
        blocks.data_blocks.deinit();
        blocks.space_blocks.deinit();
    }

    std.debug.print("Data blocks {any}\n", .{blocks.data_blocks.items});
    std.debug.print("Space blocks  {any}\n", .{blocks.space_blocks.items});

    var i: usize = blocks.data_blocks.items.len;
    while (i > 0) {
        i -= 1;
        const item = blocks.data_blocks.items[i];
        std.debug.print("Block {d} - {any}\n", .{ i, item });
    }

    return .{
        .part1 = .{ .number = countBlocks(blocks1) },
        .part2 = .{ .number = 99 },
    };
}

// 2 3  3  3  13  3  12 14   14   13  14  02
// 00...111...2...333.44.5555.6666.777.888899
