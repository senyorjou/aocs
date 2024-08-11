const std = @import("std");
const buffIter = @import("buff-iter.zig");

const Game = struct {
    id: u16,
    red: u8,
    green: u8,
    blue: u8,

    pub fn checkGame(self: Game, other: Game) bool {
        return (self.red <= other.red and self.green <= other.green and self.blue <= other.blue);
    }

    pub fn extractCubes(self: Game) u16 {
        return (@as(u16, self.red) * @as(u16, self.green) * @as(u16, self.blue));
    }
};

pub fn main() !void {
    var iter = try buffIter.iterLines("./data/02-in.txt");
    defer iter.deinit();

    var current_line: u8 = 1;
    const base_game = Game{ .id = 0, .red = 12, .green = 13, .blue = 14 };
    var ids: u16 = 0;
    var mins: u16 = 0;
    while (try iter.next()) |line| : (current_line += 1) {
        const game = try parseLine(line);
        if (game.checkGame(base_game)) {
            ids += game.id;
        }
        mins += game.extractCubes();
    }
    std.debug.print("P1, sum of IDs: {d}\n", .{ids});
    std.debug.print("P2, multiply cubes: {d}\n", .{mins});
}

fn parseLine(line: []const u8) !Game {
    var parts = std.mem.splitAny(u8, line, ":,;");

    var game_and_id = std.mem.splitScalar(u8, parts.next().?, ' ');
    _ = game_and_id.next().?;
    const game_id = try std.fmt.parseInt(u16, game_and_id.next().?, 10);

    // std.debug.print("Game ID: [{!d}]", .{game_id});

    var game = Game{ .id = game_id, .red = 0, .green = 0, .blue = 0 };

    while (parts.next()) |part| {
        var num_colors = std.mem.splitScalar(u8, part, ' ');
        _ = num_colors.next(); // discard space

        const num = try std.fmt.parseInt(u8, num_colors.next().?, 10);
        const color = num_colors.next().?;

        if (std.mem.eql(u8, "red", color)) {
            if (num > game.red) {
                game.red = num;
            }
        } else if (std.mem.eql(u8, "green", color)) {
            if (num > game.green) {
                game.green = num;
            }
        } else if (std.mem.eql(u8, "blue", color)) {
            if (num > game.blue) {
                game.blue = num;
            }
        }
    }

    return game;
}

test "test parseLine" {
    const line = "Game 999: 7 blue, 9 red, 1 green; 8 green; 10 green, 5 blue, 3 red; 11 blue, 5 red, 1 green";
    const expected = Game{ .id = 999, .red = 9, .green = 10, .blue = 11 };
    const actual = parseLine(line);

    try std.testing.expectEqual(expected, actual);
}

test "test checkGame" {
    const base_game = Game{ .id = 1, .red = 10, .green = 10, .blue = 10 };
    const game_1 = Game{ .id = 1, .red = 10, .green = 10, .blue = 10 };
    const game_2 = Game{ .id = 1, .red = 9, .green = 10, .blue = 11 };

    try std.testing.expect(game_1.checkGame(base_game));
    try std.testing.expect(!game_2.checkGame(base_game));
}

test "test extractCubes" {
    const line = "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red";
    const game_1 = try parseLine(line);
    const expected: u16 = 1560;
    try std.testing.expectEqual(expected, game_1.extractCubes());
}
