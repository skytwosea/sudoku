import random
# import copy
# import sys

class Sudoku:

    def __init__(self):
        pass

    def generate(self, output="string", order=3, hexa=False):
        # create a new sudoku puzzle from scratch
        if order > 4:
            print("order must be <= 4.")
            return
        board = [[0 for j in range(order*order)] for i in range(order*order)]
        candidates = [k for k in range(1, (order*order)+1)]
        self._backtracker(board, order, candidates)
        match(output):
            case "pretty":
                return self._prettyprint(board, order, hexa)
            case "array":
                return board
            case _:
                return self._to_string(board, hexa)


    def solve(self, board):
        # solve a given sudoku puzzle from its template
        pass

    def _validate_candidate(self, board, order, x, y, candidate):
        for num in board[x]:                   # test row
            if num == candidate:
                return False
        for row in range(order*order):         # test column
            if board[row][y] == candidate:
                return False
        row_start = x - (x % order)
        col_start = y - (y % order)
        for row in range(order):               # test box
            for col in range(order):
               if candidate == board[row + row_start][col + col_start]:
                    return False
        return True

    def _find_blank(self, board, order):
        for x in range(order*order):
            for y in range(order*order):
                if board[x][y] == 0:
                    return (x, y)
        return None

    def _backtracker(self, board, order, candidates):
        random.shuffle(candidates)
        find = self._find_blank(board, order)
        if not find:
            return True
        x, y = find
        for candidate in candidates:
            if self._validate_candidate(board, order, x, y, candidate):
                board[x][y] = candidate
                if self._backtracker(board, order, candidates):
                    return True
                board[x][y] = 0
        return False

    def _perforate(self, board, difficulty):
        # remove cell values, testing for a solution each time, until the desired number of cells is removed
        pass

    def _to_string(self, board, hexa=False):
        if hexa:
            return '\n'.join(' '.join(hex(num)[2:].upper() for num in row) for row in board)
        return '\n'.join(' '.join(str(num) for num in row) for row in board)

    def _prettyprint(self, board, order, hexa=False, marker='\u00B7'):
        out = []
        size = order*order
        separator_length = 1 + sum((4*(i+1)) for i in range(1, size))
        separator = [("-"*((3*order)))+"|",]
        for i in range(1, order):
            separator.append(("-"*((3*order)))+"-"+"|")
        separator = "".join(i for i in separator)[:-1]
        for i in range(size):
            if i != 0 and i % order == 0:
                out.append(separator[:-1]+'\n')
            for j in range(size):
                if j != 0 and j % order == 0:
                    out.append("| ")
                value = board[i][j] if not hexa else hex(board[i][j])[2:].upper()
                out.append(f"{marker if 0 else value} ".zfill(3))
                # out.append(f"{value} ".zfill(3).replace("0", " "))
            out.append('\n')
        # print()
        return ''.join(line for line in out)




def main():
#     template_A = [(0,4,3),(0,5,7),(0,7,9),(0,8,2),(1,0,6),(1,1,3),(2,1,9),(2,5,2),(2,6,3),(2,8,5),(3,0,8),(3,1,7),(3,8,1),(4,1,2),(4,3,9),(4,5,1),(4,7,4),(5,0,9),(5,7,2),(5,8,7),(6,0,1),(6,2,9),(6,3,5),(6,7,7),(7,7,8),(7,8,6),(8,0,3),(8,1,6),(8,3,4),(8,4,1),]
#     template_B = [(0,2,4),(0,3,6),(0,8,3),(1,1,2),(1,4,4),(1,7,5),(2,0,1),(2,5,3),(2,6,4),(3,0,8),(3,5,4),(3,6,6),(4,1,5),(4,4,1),(4,7,9),(5,2,9),(5,3,8),(5,8,2),(6,2,6),(6,3,4),(6,8,9),(7,1,4),(7,4,6),(7,7,7),(8,0,7),(8,5,1),(8,6,5),]

    test = Sudoku()
    print(test.generate("pretty", hexa=True))
    return

if __name__ == "__main__":
    main()
