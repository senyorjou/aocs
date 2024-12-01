pub const Answer = union(enum) {
    number: u32,
    string: []const u8,
};

pub const Solution = struct {
    part1: Answer,
    part2: Answer,
};
