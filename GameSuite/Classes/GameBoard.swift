//
//  GameBoard.swift
//  GameSuite
//
//  Created by Josh Hubbard on 7/11/21.
//

import Foundation
import UIKit

class GameBoard {
    private var columns: Int
    private var rows: Int
    
    private var boardView = UIView()
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        
        self.boardView = getView()
    }
    
    func setBoardDimensions(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
    }
    
    private func setViewSize() {
        let screenDimensions = UIScreen.main.bounds
        
        self.boardView.frame = CGRect(x: 10, y: ((screenDimensions.height / 2) - ((screenDimensions.width - 20) / 2)), width: screenDimensions.width - 20, height: screenDimensions.width - 20)
    }
    
    private func getView() -> UIView {
        setViewSize()
        
        return self.boardView
    }
}
