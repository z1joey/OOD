enum GridPosition: Int {
    case empty, yellow, red
}

class Grid {
    private let rows: Int
    private let cols: Int
    private var grid: [[GridPosition]]

    init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        self.grid = [[GridPosition]](repeating: [GridPosition](repeating: .empty, count: cols), count: rows)
    }

    func getGrid() -> [[GridPosition]] {
        return grid
    }
    
    func getColCount() -> Int {
        return cols
    }
    
    func placePiece(_ piece: GridPosition, atCol col: Int) -> Int {
        if col < 0 || col >= cols {
            print("Invalid Colum")
        }
        if piece == .empty {
            print("Invalid Piece")
        }
        for row in (0..<rows).reversed() {
            if grid[row][col] == .empty {
                grid[row][col] = piece
                return row
            }
        }

        return -1
    }
    
    func checkWin(targetScore: Int, row: Int, col: Int, piece: GridPosition) -> Bool {
        // check cols
        var count = 0

        for c in 0..<cols {
            if grid[row][c] == piece {
                count += 1
            } else {
                count = 0
            }
            
            if count == targetScore {
                return true
            }
        }
        
        // check rows
        count = 0

        for r in 0..<rows {
            if grid[r][col] == piece {
                count += 1
            } else {
                count = 0
            }
            
            if count == targetScore {
                return true
            }
        }
        
        // check diagonal
        count = 0

        for r in 0..<rows {
            var c = row + col - r

            if grid[r].indices.contains(c), grid[r][c] == piece {
                count += 1
            } else {
                count = 0
            }
            
            if count == targetScore {
                return true
            }
        }
        
        // check anti-diagonal
        count = 0

        for r in 0..<rows {
            var c = col - row + r

            if grid[r].indices.contains(c), grid[r][c] == piece {
                count += 1
            } else {
                count = 0
            }

            if count == targetScore {
                return true
            }
        }

        return false
    }
}

class Player {
    private var name: String
    private var color: GridPosition

    init(name: String, color: GridPosition) {
        self.name = name
        self.color = color
    }

    func getName() -> String {
        return name
    }

    func getPieceColor() -> GridPosition {
        return color
    }
}

class Game {
    private let grid: Grid
    private let targetScore: Int
    private let players: [Player]
    private var score: [String: Int]

    init(grid: Grid, targetScore: Int, players: [Player]) {
        self.grid = grid
        self.targetScore = targetScore
        self.players = players
        
        self.score = [:]
        for player in players {
            self.score[player.getName()] = 0
        }
    }
    
    func printBoard() {
        let grid = grid.getGrid()

        for r in 0..<grid.count {
            var row = ""
            for piece in grid[r] {
                switch piece {
                case .empty:
                    row += "⚪️ "
                case .yellow:
                    row += "🟡 "
                case .red:
                    row += "🔴 "
                }
            }
            
            print(row)
        }
    }
    
    func playerMove(_ player: Player, col: Int) {
        print("\(player.getName())'s turn")
        let piece = player.getPieceColor()
        let row = grid.placePiece(piece, atCol: col)
        let win = grid.checkWin(targetScore: targetScore, row: row, col: col, piece: piece)
        
        if win {
            score[player.getName(), default: 0] += 1
            print(player.getName(), "won ! 🎉")
        }

        printBoard()
        print("")
    }
}

let grid = Grid(rows: 6, cols: 6)
let player1 = Player(name: "Sam", color: .red)
let player2 = Player(name: "Janice", color: .yellow)
let game = Game(grid: grid, targetScore: 3, players: [player1, player2])
game.playerMove(player1, col: 1)
game.playerMove(player2, col: 0)
game.playerMove(player1, col: 2)
game.playerMove(player2, col: 0)
game.playerMove(player1, col: 3)
game.playerMove(player2, col: 0)
