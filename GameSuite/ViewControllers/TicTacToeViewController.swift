//
//  TicTacToeViewController.swift
//  GameSuite
//
//  Created by Josh Hubbard on 7/11/21.
//

import UIKit

class TicTacToeViewController: UIViewController {
    
    var screenDimensions = UIScreen.main.bounds
    
    let boardView = UIView()

    @IBOutlet weak var labelsView: UIView!
    
    @IBOutlet weak var xResultsLabel: UILabel!
    var xCount = 0
    
    @IBOutlet weak var oResultsLabel: UILabel!
    var oCount = 0
    
    @IBOutlet weak var drawResultsLabel: UILabel!
    var drawCount = 0
    
    var boardLocations = [[UIButton]]()
    var chosenLocations = [[UILabel]]()
    
    var turnCount = 0
    
    enum player {
        case X
        case O
    }
    @IBOutlet weak var currentPlayerLabel: UILabel!
    
    var currentPlayer = player.X
    var gameFinished = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelsView.layer.cornerRadius = 5

        instantiateBoard()
        instantiateBoardLocations()
        adjustResultsLabels()
    }
    
    func instantiateBoard() {
        boardView.layer.cornerRadius = 3
        boardView.center = self.view.center
        boardView.backgroundColor = UIColor.blue
        boardView.isHidden = false
        boardView.frame = CGRect(x: 10, y: ((screenDimensions.height / 2) - ((screenDimensions.width - 20) / 2)) + 50, width: screenDimensions.width - 20, height: screenDimensions.width - 20)
        self.view.addSubview(boardView)
    }
    
    func instantiateBoardLocations() {
        gameFinished = false
        turnCount = 0
        
        if (boardLocations.count > 0) {
            for sViews in boardView.subviews {
                sViews.removeFromSuperview()
            }
            
            boardLocations.removeAll()
            chosenLocations.removeAll()
        }
        
        for y in 0..<3 {
            boardLocations.append([])
            chosenLocations.append([])
            for x in 0..<3 {
                boardLocations[y].append(UIButton())
                chosenLocations[y].append(UILabel())
                
                boardLocations[y][x].tag = (y + x)
                boardLocations[y][x].layer.cornerRadius = 3
                boardLocations[y][x].isEnabled = true
                
                chosenLocations[y][x].text = ""
                chosenLocations[y][x].font = UIFont.systemFont(ofSize: 36.0, weight: .bold)
                chosenLocations[y][x].textAlignment = .center
                chosenLocations[y][x].textColor = UIColor.black
                chosenLocations[y][x].isHidden = false
                
                
                boardView.addSubview(boardLocations[y][x])
                boardLocations[y][x].addSubview(chosenLocations[y][x])
            }
        }
        
        stylizeBoardLocations()
    }
    
    func stylizeBoardLocations() {
        var squareSizeX = 0
        var squareSizeY = 0
        
        squareSizeX = (Int(boardView.frame.width) / (boardLocations[0].count)) - 3
        squareSizeY = (Int(boardView.frame.height) / (boardLocations.count)) - 3
        
        for y in 0..<3 {
            for x in 0..<3 {
                boardLocations[y][x].layer.cornerRadius = 1
                boardLocations[y][x].tag = ((x + 1) + (y * boardLocations[0].count))
                boardLocations[y][x].addTarget(self, action: #selector(boardLocationTapped(_:)), for: .touchUpInside)
                
                let xLoc = (5.0 * (Double(x + 1) - 1.0)) + (Double(squareSizeX) * (Double(x + 1) - 1.0))
                let yLoc = (5.0 * (Double(y + 1) - 1.0)) + (Double(squareSizeY) * (Double(y + 1) - 1.0))
                
                boardLocations[y][x].frame = CGRect(x: xLoc, y: yLoc, width: Double(squareSizeX), height: Double(squareSizeY))
                boardLocations[y][x].backgroundColor = UIColor.lightGray
                
                chosenLocations[y][x].frame = CGRect(x: 0.0, y: 0.0, width: (chosenLocations[y][x].superview?.frame.width)!, height: (chosenLocations[y][x].superview?.frame.height)!)
            }
        }
    }
    
    func changeCurrentPlayer(p: player) {
        if (p == player.X) {
            self.currentPlayer = player.O
        } else {
            self.currentPlayer = player.X
        }
        
        currentPlayerLabel.text = "\(currentPlayer)'s Turn"
    }
    
    func incrementWin() {
        if (currentPlayer == player.X) {
            xCount += 1
        } else {
            oCount += 1
        }
    }
    
    func adjustResultsLabels() {
        xResultsLabel.text = "X Wins:\t\(xCount)"
        oResultsLabel.text = "O Wins:\t\(oCount)"
        drawResultsLabel.text = "Draws:\t\(drawCount)"
        currentPlayerLabel.text = "\(currentPlayer)'s Turn"
        
        instantiateBoardLocations()
    }
    
    func checkEnd() {
        if (chosenLocations[0][0].text == chosenLocations[0][1].text && chosenLocations[0][0].text == chosenLocations[0][2].text && chosenLocations[0][0].text != "") {
            /**
             X X X
             = = =
             = = =
             */
            gameFinished = true
            incrementWin()
            adjustResultsLabels()
            print("top")
            print("Player \(currentPlayer) wins")
        } else if (chosenLocations[1][0].text == chosenLocations[1][1].text && chosenLocations[1][0].text == chosenLocations[1][2].text && chosenLocations[1][0].text != "") {
            /**
             = = =
             X X X
             = = =
             */
            gameFinished = true
            incrementWin()
            adjustResultsLabels()
            print("middle row")
            print("Player \(currentPlayer) wins")
        } else if (chosenLocations[2][0].text == chosenLocations[2][1].text && chosenLocations[2][0].text == chosenLocations[2][2].text && chosenLocations[2][0].text != "") {
            /**
             = = =
             = = =
             X X X
             */
            gameFinished = true
            incrementWin()
            adjustResultsLabels()
            print("bottom")
            print("Player \(currentPlayer) wins")
        } else if (chosenLocations[0][0].text == chosenLocations[1][0].text && chosenLocations[0][0].text == chosenLocations[2][0].text && chosenLocations[0][0].text != "") {
            /**
             X = =
             X = =
             X = =
             */
            gameFinished = true
            incrementWin()
            adjustResultsLabels()
            print("left")
            print("Player \(currentPlayer) wins")
        } else if (chosenLocations[0][1].text == chosenLocations[1][1].text && chosenLocations[0][1].text == chosenLocations[2][1].text && chosenLocations[0][1].text != "") {
            /**
             = X =
             = X =
             = X =
             */
            gameFinished = true
            incrementWin()
            adjustResultsLabels()
            print("middle column")
            print("Player \(currentPlayer) wins")
        } else if (chosenLocations[0][2].text == chosenLocations[1][2].text && chosenLocations[0][2].text == chosenLocations[2][2].text && chosenLocations[0][2].text != "") {
            /**
             = = X
             = = X
             = = X
             */
            gameFinished = true
            incrementWin()
            adjustResultsLabels()
            print("right")
            print("Player \(currentPlayer) wins")
        } else if (chosenLocations[0][0].text == chosenLocations[1][1].text && chosenLocations[0][0].text == chosenLocations[2][2].text && chosenLocations[0][0].text != "") {
            /**
             X = =
             = X =
             = = X
             */
            gameFinished = true
            incrementWin()
            adjustResultsLabels()
            print("tl -> br")
            print("Player \(currentPlayer) wins")
        } else if (chosenLocations[2][0].text == chosenLocations[1][1].text && chosenLocations[2][0].text == chosenLocations[0][2].text && chosenLocations[2][0].text != "") {
            /**
             = = X
             = X =
             X = =
             */
            gameFinished = true
            incrementWin()
            adjustResultsLabels()
            print("bl -> tr")
            print("Player \(currentPlayer) wins")
        } else {
            if (turnCount == 9) {
                drawCount += 1
                adjustResultsLabels()
                print("Draw")
            } else {
                changeCurrentPlayer(p: currentPlayer)
            }
            
//            for y in 0..<3 {
//                for x in 0..<3 {
//
//                }
//            }
            
        }
    }
    
    @objc func boardLocationTapped(_ sender:UIButton!) {
        if (!gameFinished) {
            for y in 0..<3 {
                for x in 0..<3 {
                    if (boardLocations[y][x].tag == sender.tag && chosenLocations[y][x].text == "") {
                        print("tapped: \(sender.tag)")
                        print("tapped: \(boardLocations[y][x].tag)")
                        print()
                        if (currentPlayer == player.X) {
                            chosenLocations[y][x].text = "X"
                        } else {
                            chosenLocations[y][x].text = "O"
                        }
                        boardLocations[y][x].isEnabled = false
                    }
                }
            }
            turnCount += 1
        }
        
        checkEnd()
    }

}
