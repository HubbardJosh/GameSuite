//
//  MineSweeperViewController.swift
//  GameSuite
//
//  Created by Josh Hubbard on 7/3/21.
//

import UIKit

class MineSweeperViewController: UIViewController {
    
    var screenDimensions = UIScreen.main.bounds
    
    let v = UIView()
    
    var squares = [[UIButton]]()
    var xSquareCount = 10
    var ySquareCount = 10
    
    var mineCount = 5
    var mineLocations = [[Bool]]()
    var surroundingMines = [[Int]]()
    
    var firstGuess = true
    
    @IBOutlet weak var endgameView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        instantiateSquares()
        setupMineFieldCount(x: xSquareCount, y: ySquareCount)
//        setMineCount(count: 5)
    }
    
    func instantiateSquares() {
        v.center = self.view.center
        v.backgroundColor = UIColor.blue
        v.isHidden = false
        v.frame = CGRect(x: 10, y: ((screenDimensions.height / 2) - ((screenDimensions.width - 20) / 2)), width: screenDimensions.width - 20, height: screenDimensions.width - 20)
        self.view.addSubview(v)
    }
    
    
    @IBAction func newGameButtonPressed(_ sender: Any) {
        instantiateSquares()
        resetSquares()
        setupMineFieldCount(x: xSquareCount, y: ySquareCount)
//        countSurrounding()
        v.isHidden = false
    }
    func setupMineFieldCount(x: Int, y: Int) {
        squares.removeAll()
        for yy in 0..<y {
            squares.append([])
            mineLocations.append([])
            surroundingMines.append([])
            for xx in 0..<x {
                squares[yy].append(UIButton())
                v.addSubview(squares[yy][xx])
                
                mineLocations[yy].append(false)
                surroundingMines[yy].append(0)
            }
        }
        
        stylizeSquares()
        setMinePositions(numMines: mineCount)
    }
    
    func stylizeSquares() {
        var squareSizeX = 0
        var squareSizeY = 0
        
        squareSizeX = (Int(v.frame.height) / (squares[0].count + 1))
        squareSizeY = (Int(v.frame.height) / (squares.count + 1))
        
        for y in 1..<squares.count + 1 {
            for x in 1..<squares[0].count + 1 {
                squares[y - 1][x - 1].tag = (x + ((y - 1) * squares[0].count))
                squares[y - 1][x - 1].addTarget(self, action: #selector(minePressed(_:)), for: .touchUpInside)

                let xSpace = ((Double(v.frame.width) - (Double(squares[0].count) * Double(squareSizeX))) / (Double(squares[0].count) - 1.0))
                let ySpace = ((Double(v.frame.width) - (Double(squares.count) * Double(squareSizeY))) / (Double(squares.count) - 1.0))
                let xLoc = (xSpace * (Double(x) - 1.0)) + (Double(squareSizeX) * (Double(x) - 1.0))
                let yLoc = (ySpace * (Double(y) - 1.0)) + (Double(squareSizeY) * (Double(y) - 1.0))
                
                squares[y - 1][x - 1].frame = CGRect(x: xLoc, y: yLoc, width: Double(squareSizeX), height: Double(squareSizeY))
                squares[y - 1][x - 1].backgroundColor = UIColor.yellow
            }
        }
    }
    
    func setMineCount(count: Int) {
        if (count >= (squares.count * squares[0].count)) {
            mineCount = (squares.count * squares[0].count) - 1
//            print(mineCount)
        } else if (count < 1) {
            mineCount = 1
        } else {
            mineCount = count
        }
                
        setMinePositions(numMines: mineCount)
    }
    
    func resetSquares() {
        firstGuess = true
        for y in 0..<squares.count {
            for x in 0..<squares[0].count {
                squares[y][x].backgroundColor = UIColor.yellow
                mineLocations[y][x] = false
                surroundingMines[y][x] = 0
            }
        }
    }
    
    func setMinePositions(numMines: Int) {

        var mineLocs = [Int]()
        
        for _ in 0..<numMines {
            var y = squares.randomElement()
            var x = y!.randomElement()
            
            while(true) {
                if (!mineLocs.contains(x!.tag)) {
                    mineLocs.append(x!.tag)
                    break
                } else {
                    y = squares.randomElement()
                    x = y!.randomElement()
                }
            }
        }
        mineLocs.sort()
        populateMineLocations(arr: mineLocs)

//        print(mineLocs)
        markMines()
        countSurrounding()
    }
    
    func populateMineLocations(arr: [Int]) {
        resetSquares()
        for i in arr {
            for y in 0..<squares.count {
                for x in 0..<squares[0].count {
                    if (squares[y][x].tag == i) {
                        mineLocations[y][x] = true
                    }
                }
            }
        }
    }
    
    func markMines() {
        for y in 0..<squares.count {
            for x in 0..<squares[0].count {
                if (mineLocations[y][x]) {
                    squares[y][x].backgroundColor = UIColor.red
                }
            }
        }
    }
    var neighbors = [[Int]]()
    func getNeighborSquares(xx: Int, yy: Int) {
        var nextNeighbors = [[Int]]()
        
        if (xx == 0 && (yy != 0 && yy != (squares.count - 1))) {   // left wall, not a corner
            nextNeighbors.append([yy - 1, xx])
//            nextNeighbors.append([yy - 1, xx + 1])
            nextNeighbors.append([yy, xx + 1])
//            nextNeighbors.append([yy + 1, xx + 1])
            nextNeighbors.append([yy + 1, xx])
        } else if (xx == (squares[0].count - 1) && (yy != 0 && yy != (squares.count - 1))) {   // right wall, not a corner
            nextNeighbors.append([yy - 1, xx])
//            nextNeighbors.append([yy - 1, xx - 1])
            nextNeighbors.append([yy, xx - 1])
//            nextNeighbors.append([yy + 1, xx - 1])
            nextNeighbors.append([yy + 1, xx])
        } else if (yy == 0 && (xx != 0 && xx != (squares[0].count - 1))) {     // top wall, not a corner
            nextNeighbors.append([yy, xx - 1])
//            nextNeighbors.append([yy + 1, xx - 1])
            nextNeighbors.append([yy + 1, xx])
//            nextNeighbors.append([yy + 1, xx + 1])
            nextNeighbors.append([yy, xx + 1])
        } else if (yy == (squares.count - 1) && (xx != 0 && xx != (squares[0].count - 1))) {   // bottom wall, not a corner
            nextNeighbors.append([yy, xx - 1])
//            nextNeighbors.append([yy - 1, xx - 1])
            nextNeighbors.append([yy - 1, xx])
//            nextNeighbors.append([yy - 1, xx + 1])
            nextNeighbors.append([yy, xx + 1])
        } else if (yy == 0 && xx == 0) { // top left corner
            nextNeighbors.append([yy, xx + 1])
            nextNeighbors.append([yy + 1, xx])
//            nextNeighbors.append([yy + 1, xx + 1])
        } else if (yy == 0 && xx == (squares[0].count - 1)) { // top right corner
            nextNeighbors.append([yy, xx - 1])
            nextNeighbors.append([yy + 1, xx])
//            nextNeighbors.append([yy + 1, xx - 1])
        } else if (yy == (squares.count - 1) && xx == 0) { // bottom left corner
            nextNeighbors.append([yy, xx + 1])
            nextNeighbors.append([yy - 1, xx])
//            nextNeighbors.append([yy - 1, xx + 1])
        } else if (yy == (squares.count - 1) && xx == (squares[0].count - 1)) {  // bottom right corner
            nextNeighbors.append([yy, xx - 1])
            nextNeighbors.append([yy - 1, xx])
//            nextNeighbors.append([yy - 1, xx - 1])
        } else {
//            nextNeighbors.append([yy - 1, xx - 1])
            nextNeighbors.append([yy - 1, xx])
//            nextNeighbors.append([yy - 1, xx + 1])
            nextNeighbors.append([yy, xx - 1])
            nextNeighbors.append([yy, xx + 1])
//            nextNeighbors.append([yy + 1, xx - 1])
            nextNeighbors.append([yy + 1, xx])
//            nextNeighbors.append([yy + 1, xx + 1])
        }
        
        for n in nextNeighbors {
            
            if (!neighbors.contains(n)) {
                neighbors.append(n)

                if (surroundingMines[n[0]][n[1]] == 0) {
                    if (squares[n[0]][n[1]].backgroundColor != UIColor.black) {
                        getNeighborSquares(xx: n[1], yy: n[0])
                    }
                }
            }

        }
        

//        print(neighbors.count)
    }
    
    func changeBombLoc(yy: Int, xx: Int) {
        var found = false

        while (!found) {
            var y = squares.randomElement()
            var x = y!.randomElement()
            
            for yyy in 0..<squares.count {
                for xxx in 0..<squares[0].count {
                    if (surroundingMines[yyy][xxx] > 0) {
                        surroundingMines[yyy][xxx] = 0
                    }
                    
                    if (squares[yyy][xxx].tag == x!.tag) {
                        if (!mineLocations[yyy][xxx]) {
                            mineLocations[yyy][xxx] = true
                            squares[yyy][xxx].backgroundColor = UIColor.red
                            mineLocations[yy][xx] = false
                            squares[yy][xx].backgroundColor = UIColor.black
                            found = true
                        }
                    }
//                    if (found) {
//                        break
//                    }
                }
//                if (found) {
//                    break
//                }
            }
        }
        
        countSurrounding()
        getNeighborSquares(xx: xx, yy: yy)
    }
    
    func countSurrounding() {
        for y in 0..<((xSquareCount * ySquareCount) / xSquareCount) {
            for x in 0..<((xSquareCount * ySquareCount) / ySquareCount) {
                if (mineLocations[y][x]) {
                    
                    if (x == 0 && (y != 0 && y != (squares.count - 1))) {   // left wall, not a corner
                        surroundingMines[y - 1][x] += 1
                        surroundingMines[y - 1][x + 1] += 1
                        surroundingMines[y][x + 1] += 1
                        surroundingMines[y + 1][x + 1] += 1
                        surroundingMines[y + 1][x] += 1
                    } else if (x == (squares[0].count - 1) && (y != 0 && y != (squares.count - 1))) {   // right wall, not a corner
                        surroundingMines[y - 1][x] += 1
                        surroundingMines[y - 1][x - 1] += 1
                        surroundingMines[y][x] += 1
                        surroundingMines[y + 1][x - 1] += 1
                        surroundingMines[y + 1][x] += 1
                    } else if (y == 0 && (x != 0 && x != (squares[0].count - 1))) {     // top wall, not a corner
                        surroundingMines[y][x - 1] += 1
                        surroundingMines[y + 1][x - 1] += 1
                        surroundingMines[y + 1][x] += 1
                        surroundingMines[y + 1][x + 1] += 1
                        surroundingMines[y][x + 1] += 1
                    } else if (y == (squares.count - 1) && (x != 0 && x != (squares[0].count - 1))) {   // bottom wall, not a corner
                        surroundingMines[y][x - 1] += 1
                        surroundingMines[y - 1][x - 1] += 1
                        surroundingMines[y - 1][x] += 1
                        surroundingMines[y - 1][x + 1] += 1
                        surroundingMines[y][x + 1] += 1
                    } else if (y == 0 && x == 0) { // top left corner
                        surroundingMines[y][x + 1] += 1
                        surroundingMines[y + 1][x] += 1
                        surroundingMines[y + 1][x + 1] += 1
                    } else if (y == 0 && x == (squares[0].count - 1)) { // top right corner
                        surroundingMines[y][x - 1] += 1
                        surroundingMines[y + 1][x] += 1
                        surroundingMines[y + 1][x - 1] += 1
                    } else if (y == (squares.count - 1) && x == 0) { // bottom left corner
                        surroundingMines[y][x + 1] += 1
                        surroundingMines[y - 1][x] += 1
                        surroundingMines[y - 1][x + 1] += 1
                    } else if (y == (squares.count - 1) && x == (squares[0].count - 1)) {  // bottom right corner
                        surroundingMines[y][x - 1] += 1
                        surroundingMines[y - 1][x] += 1
                        surroundingMines[y - 1][x - 1] += 1
                    } else {
                        surroundingMines[y - 1][x - 1] += 1
                        surroundingMines[y - 1][x] += 1
                        surroundingMines[y - 1][x + 1] += 1
                        surroundingMines[y][x - 1] += 1
                        surroundingMines[y][x + 1] += 1
                        surroundingMines[y + 1][x - 1] += 1
                        surroundingMines[y + 1][x] += 1
                        surroundingMines[y + 1][x + 1] += 1
                    }
                }
            }
        }
        
        var squareSizeX = 0
        var squareSizeY = 0
        
        squareSizeX = (Int(v.frame.height) / (squares[0].count + 1))
        squareSizeY = (Int(v.frame.height) / (squares.count + 1))
        for y in 0..<squares.count {
            for x in 0..<squares[0].count {
                let t = UILabel()
                t.text = "\((x + 1) + ((y) * squares[0].count)) : \(surroundingMines[y][x])"
                
                if (squares[y][x].backgroundColor == UIColor.red) {
                    t.textColor = UIColor.white
                } else {
                    t.textColor = UIColor.red
                }

                t.isHidden = false
                t.font = UIFont.systemFont(ofSize: 9.0)
                t.frame = CGRect(x: 0, y: 0, width: squareSizeX, height: squareSizeY)
                if (squares[y][x].subviews.count > 0) {
                    for sView in squares[y][x].subviews {
                        sView.removeFromSuperview()
                    }
                    squares[y][x].addSubview(t)
                } else {
//                    print(false)
                    squares[y][x].addSubview(t)
                }
            }
        }
    }
    
    func checkEnd() {
        var count = 0
        for y in 0..<squares.count {
            for x in 0..<squares[0].count {
                if (squares[y][x].backgroundColor == UIColor.black || squares[y][x].backgroundColor == UIColor.red) {
                    count += 1
                }
            }
        }
        
        print(count)
        if (count == (squares.count * squares[0].count)) {
            v.isHidden = true
            v.removeFromSuperview()
            resultLabel.text = "!!! YOU WIN !!!"
        }
        
    }
    
    @objc func minePressed(_ sender:UIButton!) {
//        var pressed = [Int]()
        for y in 0..<squares.count {
            for x in 0..<squares[0].count {
                if (sender.tag == squares[y][x].tag) {
                    if (!mineLocations[y][x]) {
//                        pressed.append(y)
//                        pressed.append(x)
                        if (surroundingMines[y][x] == 0) {
                            getNeighborSquares(xx: x, yy: y)
                            
                        }
//                        v.isHidden = true
                        sender.backgroundColor = UIColor.black
                    } else {
                        if (firstGuess) {

                            changeBombLoc(yy: y, xx: x)
                        } else {
                            v.isHidden = true
                            v.removeFromSuperview()
                            resultLabel.text = "YOU LOSE"
                        }
                    }
                }
            }
        }
        
        if (firstGuess) {
            firstGuess = false
        }
        
        for x in neighbors {
            if (!mineLocations[x[0]][x[1]]) {
                if (surroundingMines[x[0]][x[1]] == 0) {
                    squares[x[0]][x[1]].backgroundColor = UIColor.black
                } else {
//                    if (pressed.count > 0) {
//                        if (x[0] != pressed[0] && x[1] != pressed[1]) {
                            squares[x[0]][x[1]].backgroundColor = UIColor.green
//                        }
//                    }

                    
                }
            }


        }
        neighbors.removeAll()
        
        checkEnd()
//        print(sender.tag)
    }
}
