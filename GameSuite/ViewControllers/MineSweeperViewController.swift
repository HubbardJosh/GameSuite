//
//  MineSweeperViewController.swift
//  GameSuite
//
//  Created by Josh Hubbard on 7/3/21.
//

import UIKit

class MineSweeperViewController: UIViewController, UITextFieldDelegate {
    
    var screenDimensions = UIScreen.main.bounds
    
    let v = UIView()
    
    var squares = [[UIButton]]()
    var squareLabels = [[UILabel]]()
    var xSquareCount = 3
    var ySquareCount = 3
    
    var mineCount = 3
    var mineLocations = [[Bool]]()
    var surroundingMines = [[Int]]()
    
    var firstGuess = true
    
    var oneSurround = UIColor(red: 123.0/255.0, green: 240.0/255.0, blue: 75.0/255.0, alpha: 1.0)
    var twoSurround = UIColor(red: 226.0/255.0, green: 100.0/255.0, blue: 25.0/255.0, alpha: 1.0)
    var threeSurround = UIColor(red: 221.0/255.0, green: 15.0/255.0, blue: 47.0/255.0, alpha: 1.0)
    var fourSurround = UIColor(red: 224.0/255.0, green: 15.0/255.0, blue: 224.0/255.0, alpha: 1.0)
    var fiveSurround = UIColor(red: 48.0/255.0, green: 15.0/255.0, blue: 229.0/255.0, alpha: 1.0)
    var sixSurround = UIColor(red: 12.0/255.0, green: 64.0/255.0, blue: 125.0/255.0, alpha: 1.0)
    var sevenSurround = UIColor(red: 48.0/255.0, green: 7.0/255.0, blue: 85.0/255.0, alpha: 1.0)
    var eightSurround = UIColor(red: 49.0/255.0, green: 5.0/255.0, blue: 24.0/255.0, alpha: 1.0)
    
    @IBOutlet weak var flagMineSwitch: UISwitch!
    @IBOutlet weak var questionMineSwitch: UISwitch!
    @IBOutlet weak var endgameView: UIView!
    @IBOutlet weak var blockGameView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var colMineCountLabel: UILabel!
    @IBOutlet weak var colMineCountTextField: UITextField!
    @IBOutlet weak var rowCountLabel: UILabel!
    @IBOutlet weak var rowCountTextField: UITextField!
    @IBOutlet weak var colRowMineTextFieldStack: UIStackView!
    @IBOutlet weak var rowCountTextFieldStack: UIStackView!
    @IBOutlet weak var mineCountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        endgameView.layer.cornerRadius = 3
        v.layer.cornerRadius = 3
        rowCountTextField.delegate = self
        colMineCountTextField.delegate = self
        addDoneButtonOnKeyboard()
        
        blockGameView.isHidden = true
        endgameView.isHidden = true
        newGameButton.isHidden = true
        exitButton.isHidden = true
        questionMineSwitch.isOn = false
        flagMineSwitch.isOn = false
        instantiateSquares()
        setupMineFieldCount(x: xSquareCount, y: ySquareCount)
    }
    
    func instantiateSquares() {
        v.center = self.view.center
        v.backgroundColor = UIColor.blue
        v.isHidden = false
        v.frame = CGRect(x: 10, y: ((screenDimensions.height / 2) - ((screenDimensions.width - 20) / 2)), width: screenDimensions.width - 20, height: screenDimensions.width - 20)
        self.view.addSubview(v)
    }
    
    @IBAction func newGameButtonPressed(_ sender: Any) {
        resetSquares()
        setupMineFieldCount(x: xSquareCount, y: ySquareCount)
        questionMineSwitch.isOn = false
        flagMineSwitch.isOn = false
        blockGameView.isHidden = true
        endgameView.isHidden = true
        newGameButton.isHidden = true
        exitButton.isHidden = true
        endgameView.layer.zPosition = 0
        blockGameView.layer.zPosition = 0
        newGameButton.layer.zPosition = 0
        exitButton.layer.zPosition = 0
        self.view.bringSubviewToFront(v)
    }
    
    func setupMineFieldCount(x: Int, y: Int) {
        squares.removeAll()
        squareLabels.removeAll()
        mineLocations.removeAll()
        surroundingMines.removeAll()
        
        if (v.subviews.count > 0) {
            for z in v.subviews {
                z.removeFromSuperview()
            }
        }
        
        for yy in 0..<y {
            squares.append([])
            squareLabels.append([])
            mineLocations.append([])
            surroundingMines.append([])
            for xx in 0..<x {
                let t = UILabel()

                t.isHidden = true
                t.font = UIFont.systemFont(ofSize: 12.0, weight: .bold)
                
                squares[yy].append(UIButton())
                squareLabels[yy].append(t)
                v.addSubview(squares[yy][xx])
                
                mineLocations[yy].append(false)
                surroundingMines[yy].append(0)
                squares[yy][xx].addSubview(t)
            }
        }
        
        stylizeSquares()
        setMinePositions(numMines: mineCount)
    }
    
    func stylizeSquares() {
        var squareSizeX = 0
        var squareSizeY = 0
        
        squareSizeX = (Int(v.frame.width) / (squares[0].count))
        squareSizeY = (Int(v.frame.height) / (squares.count))
        
        for y in 1..<squares.count + 1 {
            for x in 1..<squares[0].count + 1 {
                squares[y - 1][x - 1].layer.cornerRadius = 1
                squares[y - 1][x - 1].tag = (x + ((y - 1) * squares[0].count))
                squares[y - 1][x - 1].addTarget(self, action: #selector(minePressed(_:)), for: .touchUpInside)

                var xSpace = ((Double(v.frame.width) - (Double(squares[0].count) * Double(squareSizeX))) / (Double(squares[0].count) - 1.0))
                var ySpace = ((Double(v.frame.width) - (Double(squares.count) * Double(squareSizeY))) / (Double(squares.count) - 1.0))
                var xAlt = 0.0
                var yAlt = 0.0
                if (Double(xSpace) > 5.0) {
                    xAlt = Double(xSpace) - 5.0
                    squareSizeX -= Int(xAlt)
                    xSpace = 5
                }
                if (Double(ySpace) > 5.0) {
                    yAlt = Double(ySpace) - 5.0
                    squareSizeY -= Int(yAlt)
                    ySpace = 5
                }
                
                let xLoc = (xSpace * (Double(x) - 1.0)) + (Double(squareSizeX) * (Double(x) - 1.0))
                let yLoc = (ySpace * (Double(y) - 1.0)) + (Double(squareSizeY) * (Double(y) - 1.0))
                
                squares[y - 1][x - 1].frame = CGRect(x: xLoc, y: yLoc, width: Double(squareSizeX), height: Double(squareSizeY))
                squares[y - 1][x - 1].backgroundColor = UIColor.lightGray
                
                squareSizeX += Int(xAlt)
                squareSizeY += Int(yAlt)
            }
        }
    }
    
    func setMineCount(count: Int) {
        if (count >= (squares.count * squares[0].count)) {
            mineCount = (squares.count * squares[0].count) - 1
        } else if (count < 1) {
            mineCount = 1
        } else {
            mineCount = count
        }
    }
    
    func setBoardDimensions(cols: Int, rows: Int) {
        if ((cols > 2 && cols < 16) && (rows > 2 && rows < 16)) {
            xSquareCount = cols
            ySquareCount = rows
        } else {
            if (cols > 15) {
                xSquareCount = 15
            } else if (cols < 3) {
                xSquareCount = 3
            } else {
                xSquareCount = cols
            }
            
            if (rows > 15) {
                ySquareCount = 15
            } else if (rows < 3) {
                ySquareCount = 3
            } else {
                ySquareCount = rows
            }
        }
    }
    
    func resetSquares() {
        firstGuess = true
        for y in 0..<squares.count {
            for x in 0..<squares[0].count {
                squares[y][x].backgroundColor = UIColor.lightGray
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
        countSurrounding(yCount: ySquareCount, xCount: xSquareCount)
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
        if (squareLabels[yy][xx].text != "?" || squareLabels[yy][xx].text != "X") {
            if (xx == 0 && (yy != 0 && yy != (squares.count - 1))) {   // left wall, not a corner
                nextNeighbors.append([yy - 1, xx])
                nextNeighbors.append([yy - 1, xx + 1])
                nextNeighbors.append([yy, xx + 1])
                nextNeighbors.append([yy + 1, xx + 1])
                nextNeighbors.append([yy + 1, xx])
                
                
            } else if (xx == (squares[0].count - 1) && (yy != 0 && yy != (squares.count - 1))) {   // right wall, not a corner
                nextNeighbors.append([yy - 1, xx])
                nextNeighbors.append([yy - 1, xx - 1])
                nextNeighbors.append([yy, xx - 1])
                nextNeighbors.append([yy + 1, xx - 1])
                nextNeighbors.append([yy + 1, xx])
            } else if (yy == 0 && (xx != 0 && xx != (squares[0].count - 1))) {     // top wall, not a corner
                nextNeighbors.append([yy, xx - 1])
                nextNeighbors.append([yy + 1, xx - 1])
                nextNeighbors.append([yy + 1, xx])
                nextNeighbors.append([yy + 1, xx + 1])
                nextNeighbors.append([yy, xx + 1])
            } else if (yy == (squares.count - 1) && (xx != 0 && xx != (squares[0].count - 1))) {   // bottom wall, not a corner
                nextNeighbors.append([yy, xx - 1])
                nextNeighbors.append([yy - 1, xx - 1])
                nextNeighbors.append([yy - 1, xx])
                nextNeighbors.append([yy - 1, xx + 1])
                nextNeighbors.append([yy, xx + 1])
            } else if (yy == 0 && xx == 0) { // top left corner
                nextNeighbors.append([yy, xx + 1])
                nextNeighbors.append([yy + 1, xx])
                nextNeighbors.append([yy + 1, xx + 1])
            } else if (yy == 0 && xx == (squares[0].count - 1)) { // top right corner
                nextNeighbors.append([yy, xx - 1])
                nextNeighbors.append([yy + 1, xx])
                nextNeighbors.append([yy + 1, xx - 1])
            } else if (yy == (squares.count - 1) && xx == 0) { // bottom left corner
                nextNeighbors.append([yy, xx + 1])
                nextNeighbors.append([yy - 1, xx])
                nextNeighbors.append([yy - 1, xx + 1])
            } else if (yy == (squares.count - 1) && xx == (squares[0].count - 1)) {  // bottom right corner
                nextNeighbors.append([yy, xx - 1])
                nextNeighbors.append([yy - 1, xx])
                nextNeighbors.append([yy - 1, xx - 1])
            } else {
                nextNeighbors.append([yy - 1, xx - 1])
                nextNeighbors.append([yy - 1, xx])
                nextNeighbors.append([yy - 1, xx + 1])
                nextNeighbors.append([yy, xx - 1])
                nextNeighbors.append([yy, xx + 1])
                nextNeighbors.append([yy + 1, xx - 1])
                nextNeighbors.append([yy + 1, xx])
                nextNeighbors.append([yy + 1, xx + 1])
            }
            
            for n in nextNeighbors {
                
                if (!neighbors.contains(n)) {
                    neighbors.append(n)

                    if (surroundingMines[n[0]][n[1]] == 0) {
                        if (squares[n[0]][n[1]].backgroundColor != UIColor.darkGray) {
                            getNeighborSquares(xx: n[1], yy: n[0])
                        }
                    }
                }
            }
        }
    }
    
    func changeBombLoc(yy: Int, xx: Int) {
        var found = false

        while (!found) {
            let y = squares.randomElement()
            let x = y!.randomElement()
            
            for yyy in 0..<squares.count {
                for xxx in 0..<squares[0].count {
                    if (surroundingMines[yyy][xxx] > 0) {
                        surroundingMines[yyy][xxx] = 0
                    }
                    
                    if (squares[yyy][xxx].tag == x!.tag) {
                        if (!mineLocations[yyy][xxx]) {
                            mineLocations[yyy][xxx] = true
                            squares[yyy][xxx].backgroundColor = UIColor.lightGray
                            mineLocations[yy][xx] = false
                            squares[yy][xx].backgroundColor = UIColor.darkGray
                            found = true
                        }
                    }
                }
            }
        }
        
        countSurrounding(yCount: ySquareCount, xCount: xSquareCount)
        squareLabels[yy][xx].isHidden = false
        changeTextColor(y: yy, x: xx)
        
        if (surroundingMines[yy][xx] == 0) {
            getNeighborSquares(xx: xx, yy: yy)
        }
        
    }
    
    func countSurrounding(yCount: Int, xCount: Int) {
        for y in 0..<yCount {
            for x in 0..<xCount {
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
                        surroundingMines[y][x - 1] += 1
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
        
        squareSizeX = (Int(v.frame.width) / (squares[0].count))
        squareSizeY = (Int(v.frame.height) / (squares.count))
        for y in 0..<squares.count {
            for x in 0..<squares[0].count {
                if (surroundingMines[y][x] == 0 || mineLocations[y][x]) {
                    squareLabels[y][x].text = ""
                } else {
                    squareLabels[y][x].text = "\(surroundingMines[y][x])"
                }

                squareLabels[y][x].textAlignment = .center
                squareLabels[y][x].center = squares[y][x].center
                squareLabels[y][x].frame = CGRect(x: 0, y: 0, width: squareSizeX, height: squareSizeY)
            }
        }
    }
    
    func checkEnd() {
        var count = 0
        for y in 0..<squares.count {
            for x in 0..<squares[0].count {
                if (squares[y][x].backgroundColor == UIColor.lightGray || squareLabels[y][x].text == "X") {
                    count += 1
                }
            }
        }
        
        if (count == mineCount) {
            blockGameView.isHidden = false
            endgameView.isHidden = false
            newGameButton.isHidden = false
            exitButton.isHidden = false
            endgameView.layer.zPosition = 10
            blockGameView.layer.zPosition = 10
            newGameButton.layer.zPosition = 10
            exitButton.layer.zPosition = 10
            self.view.sendSubviewToBack(v)
            resultLabel.text = "!!! YOU WIN !!!"
        }
        
    }
    
    func changeTextColor(y: Int, x: Int) {
        if (squareLabels[y][x].text != "?" && squareLabels[y][x].text != "X" && squareLabels[y][x].text != "") {
            switch surroundingMines[y][x] {
                case 1:
                    squareLabels[y][x].textColor = oneSurround
                case 2:
                    squareLabels[y][x].textColor = twoSurround
                case 3:
                    squareLabels[y][x].textColor = threeSurround
                case 4:
                    squareLabels[y][x].textColor = fourSurround
                case 5:
                    squareLabels[y][x].textColor = fiveSurround
                case 6:
                    squareLabels[y][x].textColor = sixSurround
                case 7:
                    squareLabels[y][x].textColor = sevenSurround
                case 8:
                    squareLabels[y][x].textColor = eightSurround
                default:
                    squareLabels[y][x].textColor = UIColor.black
            }
        } else {
            if (squareLabels[y][x].text == "X") {
                squareLabels[y][x].textColor = UIColor.red
            } else if (squareLabels[y][x].text == "?") {
                squareLabels[y][x].textColor = UIColor.white
            }

        }

    }
    
    @objc func minePressed(_ sender:UIButton!) {
        if (!questionMineSwitch.isOn && !flagMineSwitch.isOn) {
            for y in 0..<squares.count {
                for x in 0..<squares[0].count {
                    if (sender.tag == squares[y][x].tag) {
                        if (squares[y][x].backgroundColor != UIColor.darkGray && squareLabels[y][x].text != "?" && squareLabels[y][x].text != "X") {
                            if (!mineLocations[y][x]) {
                                if (surroundingMines[y][x] == 0 && squares[y][x].backgroundColor == UIColor.lightGray) {
                                    getNeighborSquares(xx: x, yy: y)
                                }
                                changeTextColor(y: y, x: x)
                                squareLabels[y][x].isHidden = false
                                sender.backgroundColor = UIColor.darkGray
                            } else {
                                if (firstGuess) {
                                    changeBombLoc(yy: y, xx: x)
                                } else {
                                    blockGameView.isHidden = false
                                    endgameView.isHidden = false
                                    newGameButton.isHidden = false
                                    exitButton.isHidden = false
                                    endgameView.layer.zPosition = 10
                                    blockGameView.layer.zPosition = 10
                                    newGameButton.layer.zPosition = 10
                                    exitButton.layer.zPosition = 10
                                    self.view.sendSubviewToBack(v)
                                    resultLabel.text = "YOU LOSE"
                                }
                            }
                        }
                    }
                }
            }
            
            if (firstGuess) {
                firstGuess = false
            }
            
            for x in neighbors {
                if (!mineLocations[x[0]][x[1]] && squareLabels[x[0]][x[1]].text != "X" && squareLabels[x[0]][x[1]].text != "?") {
                    squareLabels[x[0]][x[1]].isHidden = false
                    squares[x[0]][x[1]].backgroundColor = UIColor.darkGray
                    changeTextColor(y: x[0], x: x[1])
                }
            }
            neighbors.removeAll()
            
        } else {
            if (questionMineSwitch.isOn) {
                flagMineSwitch.isOn = false
                for y in 0..<squares.count {
                    for x in 0..<squares[0].count {
                        if (squares[y][x].tag == sender.tag) {
                            if (squares[y][x].backgroundColor != UIColor.darkGray) {
                                if (squareLabels[y][x].text == "?") {
                                    squareLabels[y][x].text = ""
                                    squareLabels[y][x].isHidden = true
                                } else {
                                    squareLabels[y][x].textColor = UIColor.white
                                    squareLabels[y][x].text = "?"
                                    squareLabels[y][x].isHidden = false
                                }
                            }
                        }
                    }
                }
            } else {
                questionMineSwitch.isOn = false
                for y in 0..<squares.count {
                    for x in 0..<squares[0].count {
                        if (squares[y][x].tag == sender.tag) {
                            if (squares[y][x].backgroundColor != UIColor.darkGray) {
                                if (squareLabels[y][x].text == "X") {
                                    squareLabels[y][x].text = ""
                                    squareLabels[y][x].isHidden = true
                                } else {
                                    squareLabels[y][x].textColor = UIColor.red
                                    squareLabels[y][x].text = "X"
                                    squareLabels[y][x].isHidden = false
                                }
                            }
                        }
                    }
                }
            }
        }

        checkEnd()
    }
    
    @IBAction func questionMineSwitchTapped(_ sender: Any) {
        if (flagMineSwitch.isOn) {
            flagMineSwitch.isOn = false
        }
    }
    
    @IBAction func flagMineSwitchTapped(_ sender: Any) {
        if (questionMineSwitch.isOn) {
            questionMineSwitch.isOn = false
        }
    }
    
    @IBAction func boardSizeTapped(_ sender: Any) {
        colRowMineTextFieldStack.isHidden = false
        rowCountTextFieldStack.isHidden = false
        colMineCountLabel.text = "Cols:"
        colMineCountTextField.placeholder = "3 - 15"
        rowCountLabel.text = "Rows:"
        rowCountTextField.placeholder = "3 - 15"
    }
    
    @IBAction func mineCountTapped(_ sender: Any) {
        colRowMineTextFieldStack.isHidden = false
        rowCountTextFieldStack.isHidden = true
        colMineCountLabel.text = "Mines:"
        colMineCountTextField.placeholder = "1 - \((xSquareCount * ySquareCount) - 1)"
        self.colMineCountTextField.becomeFirstResponder()
    }
    
    @IBAction func doneColRowMineCountTapped(_ sender: Any) {
        if (rowCountTextFieldStack.isHidden) {  // changing mine count
            if (colMineCountTextField.hasText) {
                let newCount = Int(colMineCountTextField.text!)

                setMineCount(count: newCount!)
                colRowMineTextFieldStack.isHidden = true
                newGameButton.sendActions(for: .touchUpInside)
            }
        } else {    // changing cols and rows
            if (colMineCountTextField.hasText && rowCountTextField.hasText) {
                let newCol = Int(colMineCountTextField.text!)
                let newRow = Int(rowCountTextField.text!)
                print("newC \(newCol!)")
                print(newRow!)
                
                setBoardDimensions(cols: newCol!, rows: newRow!)
                
                mineCountButton.sendActions(for: .touchUpInside)
            }
        }
        colMineCountTextField.text?.removeAll()
        rowCountTextField.text?.removeAll()
        
        doneButtonAction()
    }
        
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(MineSweeperViewController.doneButtonAction))

        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)

        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.colMineCountTextField.inputAccessoryView = doneToolbar
        self.rowCountTextField.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {
        if (self.colMineCountTextField.isFirstResponder) {
            self.colMineCountTextField.resignFirstResponder()
        } else {
            self.rowCountTextField.resignFirstResponder()
        }
        
        /* Or:
        self.view.endEditing(true);
        */
    }
    
    @IBAction func exitPressed(_ sender: Any) {
        performSegue(withIdentifier: "gameSelect", sender: self)
    }
}
