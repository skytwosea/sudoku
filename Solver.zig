const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;

const ORDER: u8 = 3;
const SIZE: u8  = ORDER * ORDER;

pub fn main() !void
{

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const gpallocator = gpa.allocator();
    defer { _ = gpa.deinit();}

    var board: [SIZE][]u8 = try makeboard(&gpallocator);
    defer {
        for (board) |row| {
            gpallocator.free(row);
        }
    }

    const template = [_][3]u8{
        [3]u8{ 0, 4, 3 },
        [3]u8{ 0, 5, 7 },
        [3]u8{ 0, 7, 9 },
        [3]u8{ 0, 8, 2 },
        [3]u8{ 1, 0, 6 },
        [3]u8{ 1, 1, 3 },
        [3]u8{ 2, 1, 9 },
        [3]u8{ 2, 5, 2 },
        [3]u8{ 2, 6, 3 },
        [3]u8{ 2, 8, 5 },
        [3]u8{ 3, 0, 8 },
        [3]u8{ 3, 1, 7 },
        [3]u8{ 3, 8, 1 },
        [3]u8{ 4, 1, 2 },
        [3]u8{ 4, 3, 9 },
        [3]u8{ 4, 5, 1 },
        [3]u8{ 4, 7, 4 },
        [3]u8{ 5, 0, 9 },
        [3]u8{ 5, 7, 2 },
        [3]u8{ 5, 8, 7 },
        [3]u8{ 6, 0, 1 },
        [3]u8{ 6, 2, 9 },
        [3]u8{ 6, 3, 5 },
        [3]u8{ 6, 7, 7 },
        [3]u8{ 7, 7, 8 },
        [3]u8{ 7, 8, 6 },
        [3]u8{ 8, 0, 3 },
        [3]u8{ 8, 1, 6 },
        [3]u8{ 8, 3, 4 },
        [3]u8{ 8, 4, 1 },
    };

    for (template) |assignment| {
        assign(&board, &assignment);
    }

    display_board(&board);
}

fn makeboard(allocator: *const Allocator) ![SIZE][]u8
{
    var matrix: [SIZE][]u8 = undefined;
    for (&matrix) |*row| {
        row.* = try allocator.alloc(u8, SIZE);
        for (row.*, 0..) |val, i| {
            _ = val;
            row.*[i] = 0;
        }
    }
    return matrix;
}

fn assign(square: *[SIZE][]u8, val: *const [3]u8) void
{
    square[val[0]][val[1]] = val[2];
}

fn display_board(matrix: *[SIZE][]u8) void
{
    for (matrix) |row| {
        for (row) |item| {
            print("{} ", .{item});
        }
        print("\n", .{});
    }
    print("\n", .{});
}
