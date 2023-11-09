//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////// TODO ////////////////////////////////////
//  read template from file
//  adapt to hex (16x16)
//  create user interface
//////////////////////////////////////////////////////////////////////////////

const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;

const ORDER: u8 = 3;
const SIZE:  u8 = ORDER * ORDER;

pub fn main() !void
{
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const gpallocator = gpa.allocator();
    defer { _ = gpa.deinit();}

    var board: [SIZE][]u8 = try make_board(&gpallocator);
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

    display_board(&board); // board as template with zeros for unfilled cells
    // var res: bool = solver(&board);
    _ = solver(&board);
    display_board(&board); // solved board
}


fn make_board(allocator: *const Allocator) ![SIZE][]u8
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


fn assign(board: *[SIZE][]u8, val: *const [3]u8) void
{
    board[val[0]][val[1]] = val[2];
}


fn display_board(board: *[SIZE][]u8) void
{
    for (board) |row| {
        for (row) |item| {
            print("{} ", .{item});
        }
        print("\n", .{});
    }
    print("\n", .{});
}


fn check_candidate(x:u8, y:u8, candidate:u8, board:*[SIZE][]u8) bool
{
    // test row
    for (0..SIZE-1) |i| {
        if (board.*[x][i] == candidate) {
            return false;
        }
    }

    // test column
    for (0..SIZE-1) |j| {
        if (board.*[j][y] == candidate) {
            return false;
        }
    }

    // test square
    const row_start = x - (x % ORDER);
    const col_start = y - (y % ORDER);
    for (0..ORDER) |row| {
        for (0..ORDER) |col| {
            if (candidate == board.*[row + row_start][col + col_start]) {
                return false;
            }
        }
    }

    return true;

}


fn solver(board:*[SIZE][]u8) bool
{
    // check for empty cells; if there are none, return true
    var x: u8 = undefined;
    var y: u8 = undefined;
    var z: bool = true;
    outer: for (0..SIZE) |i| {
        for (0..SIZE) |j| {
            if (board.*[i][j] == 0) {
                x = @intCast(i);
                y = @intCast(j);
                z = false;
                break :outer;
            }
        }
    }
    if (z == true) {
        return true;
    }

    // recursive solve: iterate through integers, validate the candidate, update the board,
    // and recurse; ensure cell value is zero if candidate is not available.
    const candidates: [9]u8 = [9]u8{1,2,3,4,5,6,7,8,9};
    for (candidates) |candidate| {
        var is_valid: bool = check_candidate(x, y, candidate, board);
        if (is_valid == true) {
            board.*[x][y] = candidate;
            var complete: bool = solver(board);
            if (complete == true) {
                return true;
            }
            board.*[x][y] = 0;
        }
    }
    return false;
}
