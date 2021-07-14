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
    
    var boardLocations = [[UIButton]]()
    var chosenLocations = [[String]]()
    
    var turnCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        instantiateBoard()
        instantiateBoardLocations()
    }
    
    func instantiateBoard() {
        boardView.center = self.view.center
        boardView.backgroundColor = UIColor.blue
        boardView.isHidden = false
        boardView.frame = CGRect(x: 10, y: ((screenDimensions.height / 2) - ((screenDimensions.width - 20) / 2)), width: screenDimensions.width - 20, height: screenDimensions.width - 20)
        self.view.addSubview(boardView)
    }
    
    func instantiateBoardLocations() {
        if (boardLocations.count > 0) {
            boardLocations.removeAll()
            for sViews in boardView.subviews {
                sViews.removeFromSuperview()
            }
        }
        
        for y in 0..<3 {
            boardLocations.append([])
            for x in 0..<3 {
                boardLocations[y].append(UIButton())
                
                boardView.addSubview(boardLocations[y][x])
            }
        }
        
        stylizeBoardLocations()
    }
    
    func stylizeBoardLocations() {
        var squareSizeX = 0
        var squareSizeY = 0
        
        squareSizeX = (Int(boardView.frame.width) / (boardLocations[0].count))
        squareSizeY = (Int(boardView.frame.height) / (boardLocations.count))
        
        for y in 0..<3 {
            for x in 0..<3 {
                boardLocations[y][x].layer.cornerRadius = 1
                boardLocations[y][x].tag = ((x + 1) + (y * boardLocations[0].count))
                boardLocations[y][x].addTarget(self, action: #selector(boardLocationTapped(_:)), for: .touchUpInside)

                var xSpace = ((Double(boardView.frame.width) - (Double(boardLocations[0].count) * Double(squareSizeX))) / (Double(boardLocations[0].count) - 1.0))
                var ySpace = ((Double(boardView.frame.width) - (Double(boardLocations.count) * Double(squareSizeY))) / (Double(boardLocations.count) - 1.0))
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
                
                let xLoc = (xSpace * (Double(x + 1) - 1.0)) + (Double(squareSizeX) * (Double(x + 1) - 1.0))
                let yLoc = (ySpace * (Double(y + 1) - 1.0)) + (Double(squareSizeY) * (Double(y + 1) - 1.0))
                
                boardLocations[y][x].frame = CGRect(x: xLoc, y: yLoc, width: Double(squareSizeX), height: Double(squareSizeY))
                boardLocations[y][x].backgroundColor = UIColor.lightGray
                
                squareSizeX += Int(xAlt)
                squareSizeY += Int(yAlt)
            }
        }
    }
    
    @objc func boardLocationTapped(_ sender:UIButton!) {
        
    }

}
