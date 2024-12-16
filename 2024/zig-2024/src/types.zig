pub const Answer = union(enum) {
    number: u64,
    string: []const u8,
};

pub const Solution = struct {
    part1: Answer,
    part2: Answer,
};
