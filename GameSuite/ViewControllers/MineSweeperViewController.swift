//
//  MineSweeperViewController.swift
//  GameSuite
//
//  Created by Josh Hubbard on 7/3/21.
//

import UIKit

class MineSweeperViewController: UIViewController {
    
    var screenDimensions = UIScreen.main.bounds
    
    @IBOutlet weak var mineFieldView: UIView!
    
    var mines = [[UIButton]]()
    
    var mineCountX = 3
    var mineCountY = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMineCount(x: 5, y: 5)
    }
    
    
    func setupMineCount(x: Int, y: Int) {
        mines.removeAll()
        for yy in 0..<y {
            mines.append([])
            for xx in 0..<x {
                mines[yy].append(UIButton())
                mineFieldView.addSubview(mines[yy][xx])
            }
        }
        
        stylizeMines()
    }
    
    func stylizeMines() {
        var mineSize = 0
        
//        if (mines.count >= mines[0].count) {
        mineSize = (Int(mineFieldView.frame.height) / (mines.count)) - 5
        print(mineSize)
//        } else {
//            mineSize = (Int(mineFieldView.frame.width) - (5 * (mines[0].count + 1))) / (5 * (mines[0].count + 1))
//        }
        
        for y in 1..<mines.count + 1 {
            for x in 1..<mines[0].count + 1 {
                let t = UILabel()
                t.text = "\(x + ((y - 1) * 15))"
                t.textColor = UIColor.white
                t.isHidden = false
                t.font = UIFont.systemFont(ofSize: 9.0)
                t.frame = CGRect(x: 0, y: 0, width: mineSize, height: mineSize)
                let xSpace = ((Int(mineFieldView.frame.width) - (mines.count * mineSize)) / (mines.count - 1))
                print(xSpace)
                let xLoc = ((xSpace * (x - 1)) + (mineSize * (x - 1)))
                let yLoc = (xSpace * (y - 1)) + (mineSize * (y - 1))
                
//                print(xLoc)
//                print(yLoc)
                mines[y - 1][x - 1].addSubview(t)
                mines[y - 1][x - 1].backgroundColor = UIColor.black
                mines[y - 1][x - 1].frame = CGRect(x: xLoc, y: yLoc, width: mineSize, height: mineSize)
//                mines[y][x].frame = CGRect(x: xLoc, y: Int(mineFieldView.frame.minY), width: mineSize, height: mineSize)
            }
        }
//        mineFieldView.
    }
}
