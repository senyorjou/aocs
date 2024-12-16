const std = @import("std");

pub const Grid = struct {
    data: []u8,
    width: u16,
    height: u16,
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, width: u16, height: u16) !Grid {
        const data = try allocator.alloc(u8, width * height);
        return Grid{
            .data = data,
            .width = width,
            .height = height,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Grid) void {
        self.allocator.free(self.data);
    }

    pub fn get(self: Grid, x: u16, y: u16) u8 {
        const index: usize = @as(usize, y) * @as(usize, self.width) + @as(usize, x);
        return self.data[index];
    }

    pub fn set(self: *Grid, x: u16, y: u16, value: u8) void {
        const index: usize = @as(usize, y) * @as(usize, self.width) + @as(usize, x);
        self.data[index] = value;
    }

    pub fn inGrid(self: Grid, x: i32, y: i32) bool {
        if (x < 0 or y < 0) return false;
        return @as(usize, @intCast(x)) < self.width and @as(usize, @intCast(y)) < self.height;
    }

    pub fn print(self: Grid) void {
        var y: u16 = 0;
        while (y < self.height) : (y += 1) {
            var x: u16 = 0;
            while (x < self.width) : (x += 1) {
                std.debug.print("{c}", .{self.get(x, y)});
            }
            std.debug.print("\n", .{});
        }
    }

    pub fn count(self: Grid, item: u8) u32 {
        var total: u32 = 0;
        var y: u16 = 0;
        while (y < self.height) : (y += 1) {
            var x: u16 = 0;
            while (x < self.width) : (x += 1) {
                if (self.get(x, y) == item) {
                    total += 1;
                }
            }
        }
        return total;
    }

    pub fn fill(self: *Grid, item: u8) void {
        var y: u16 = 0;
        while (y < self.height) : (y += 1) {
            var x: u16 = 0;
            while (x < self.width) : (x += 1) {
                self.set(x, y, item);
            }
        }
    }

    pub fn perimeter(self: Grid, match: u8, x: u16, y: u16) u16 {
        var total: u16 = 0;

        const ix = @as(i32, x);
        const iy = @as(i32, y);

        // Check left
        if (!self.inGrid(ix - 1, iy)) {
            total += 1;
        } else if (self.get(x - 1, y) != match) {
            total += 1;
        }

        // Check right
        if (!self.inGrid(ix + 1, iy)) {
            total += 1;
        } else if (self.get(x + 1, y) != match) {
            total += 1;
        }

        // Check up
        if (!self.inGrid(ix, iy - 1)) {
            total += 1;
        } else if (self.get(x, y - 1) != match) {
            total += 1;
        }

        // Check down
        if (!self.inGrid(ix, iy + 1)) {
            total += 1;
        } else if (self.get(x, y + 1) != match) {
            total += 1;
        }

        return total;
    }
};
