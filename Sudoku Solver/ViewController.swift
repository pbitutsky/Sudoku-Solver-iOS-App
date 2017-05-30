//
//  ViewController.swift
//  Sudoku Solver
//
//  Created by Paul Bitutsky on 5/28/17.
//  Copyright © 2017 Paul Bitutsky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var tfCollection: [UITextField]!
    @IBAction func solve(_ sender: Any) {
        //create a 2D array and store the values of text fields
        var sudoku: [[Int]] = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        var counter = 0
        for i in 0..<9{
            for j in 0..<9{
                sudoku[i][j] = (Int(tfCollection[counter].text!) ?? 0)
                counter += 1
            }
        }
        
        outputSudoku(sudoku: sudoku, tfCollection: tfCollection)
        
        //perform the final calculation and output
        outputSudoku(sudoku: sudokuSolver(sudoku: sudoku).0, tfCollection: tfCollection)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

