const std = @import("std");

pub const LineIterator = struct {
    file: std.fs.File,
    reader_wrapper: std.fs.File.Reader,
    buffer: [4096]u8,

    pub fn next(self: *@This()) !?[]u8 {
        return self.reader_wrapper.interface.takeDelimiterExclusive('\n') catch |err| {
            if (err == error.EndOfStream) return null;
            return err;
        };
    }

    pub fn deinit(self: *@This()) void {
        self.file.close();
    }
};

pub fn openFileAndIterateLines(filename: []const u8) !LineIterator {
    const file = try std.fs.cwd().openFile(filename, .{});
    var buffer: [4096]u8 = undefined;
    const reader_wrapper = file.reader(&buffer);

    return LineIterator{
        .file = file,
        .reader_wrapper = reader_wrapper,
        .buffer = buffer,
    };
}

