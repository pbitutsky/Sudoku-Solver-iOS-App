//
//  util.swift
//  Sudoku Solver
//
//  Created by Paul Bitutsky on 5/29/17.
//  Copyright © 2017 Paul Bitutsky. All rights reserved.
//

import Foundation
import UIKit

func printSudoku(sudoku: [[Int]]){
    for row in sudoku{
        print(String(format:"%2d %2d %2d %2d %2d %2d %2d %2d %2d", row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8]))
    }
    print("")
}

func outputSudoku(sudoku:[[Int]], tfCollection: [UITextField]){
    DispatchQueue.main.async {
    var counter = 0
    for i in 0..<9{
        for j in 0..<9{
            let value = sudoku[i][j]
            if (value != 0){
                    tfCollection[counter].text = String(value)
                
            }
            counter += 1
        }
    }
    }
}

func arrayEqual(a1: [[Int]], a2: [[Int]]) -> Bool{
    if a1.count != a2.count || a1[0].count != a2[0].count{
        return false
    }
    
    for i in 0..<a1.count{
        for j in 0..<a1[0].count{
            if a1[i][j] != a2[i][j]{
                return false
            }
        }
    }
    return true
}


func validSudoku(sudoku: [[Int]]) -> Bool{
    for row in 0..<9{
        for col in 0..<9{
            print("checking \(row), \(col)")
            if !possibleMove(sudoku: sudoku, row: row, col: col, val: sudoku[row][col]){
                return false
            }
        }
    }
    return true
}

func completeSudoku(sudoku: [[Int]]) -> Bool{
    for row in sudoku{
        for col in row{
            if col == 0{
                return false
            }
        }
    }
    return true
}

func possibleMove(sudoku: [[Int]], row: Int, col: Int, val: Int) -> Bool{
    //check the row
    for i in 0..<9{
        if sudoku[row][i] == val && val != 0 && i != col{ //remove last clause
            return false
        }
    }
    
    //check the column
    for j in 0..<9{
        if sudoku[j][col] == val && val != 0 && j != row{ //remove last clause
            return false
        }
    }
    
    //check the box
    let boxSize: Int = Int(sqrt(9))
    outerLoop: for i in 0...9 where (i) % boxSize == 0{
        for j in 0...9 where (j) % boxSize == 0{
            if row < i && col < j{
                for x in (i-boxSize)..<i{
                    for y in (j-boxSize)..<j{
                        if sudoku[x][y] == val && val != 0 && x != row && y != col{
                            return false
                        }
                    }
                }
                break outerLoop;
            }
        }
    }
    
    return true
}

//this was my first attempt: Depth-first search. It was computationally inferior

/*class SearchNode: Equatable{
    var sudoku: [[Int]]
    init(sudoku: [[Int]]){
        self.sudoku = sudoku
    }
    func possibleChildren() -> [SearchNode]{
        var children = [SearchNode]()
        for row in 0..<9{
            for col in 0..<9{
                let val = sudoku[row][col]
                if (val == 0){
                    for k in 1...9{
                        if (possibleMove(sudoku: self.sudoku, row: row, col: col, val: k)){
                            var newSudoku = sudoku
                            newSudoku[row][col] = k
                            children.append(SearchNode(sudoku: newSudoku))
                        }
                    }
                }
            }
        }
        return children
    }
    
    
    func printMe(){
        printSudoku(sudoku: self.sudoku)
    }
    
    static func == (lhs: SearchNode, rhs: SearchNode) -> Bool {
        return arrayEqual(a1: lhs.sudoku, a2: rhs.sudoku)
    }
}

//modified from apple
struct Stack<Element> {
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    func empty() -> Bool{
        return items.isEmpty
    }
}

func dfs(sn: SearchNode, tfCollection: [UITextField]) -> SearchNode{
    var s = Stack<SearchNode>()
    var discovered = [SearchNode]()
    
    s.push(sn)
    while !s.empty(){
        let v = s.pop()
        print("This is v")
        printSudoku(sudoku: v.sudoku)
        outputSudoku(sudoku: v.sudoku, tfCollection: tfCollection)
        
        //check if we are done
        if (completeSudoku(sudoku: v.sudoku)){
            return v
        }
        
        if !discovered.contains(v){ //v has not been visited yet
            print("v has not yet been visited.")
            discovered.append(v)
            for w in v.possibleChildren(){
                s.push(w)
            }
        }else{
            print("v has already been visited")
        }
    }
    print("ERROR")
    return SearchNode(sudoku: [])
}
 */

func sudokuSolver(sudoku: [[Int]]) -> ([[Int]], Bool){
    printSudoku(sudoku: sudoku)
    var i = 0
    var j = 0
    var board = sudoku
    if completeSudoku(sudoku: board){
        return (sudoku, true);
    }else{
        for x in 0..<9{
            for y in 0..<9{
                if board[x][y]==0{
                    i = x
                    j = y
                    break
                }
            }
        }
        
        for x in 1...9{
            if possibleMove(sudoku: board, row: i, col: j, val: x){
                board[i][j] = x
                let recursiveResult = sudokuSolver(sudoku: board)
                if recursiveResult.1{
                    return (recursiveResult.0, true)
                }
            }
        }
        
        //backtracking
        board[i][j] = 0
        return (sudoku, false)
    }
}

//TODO: Make the UI update during each recursive call

//func sudokuSolver1(sudoku: [[Int]], tfCollection: [UITextField]) -> Bool{
//    outputSudoku(sudoku: sudoku, tfCollection: tfCollection)
//    var i = 0
//    var j = 0
//    var board = sudoku
//    if completeSudoku(sudoku: board){
//        return true;
//    }else{
//        for x in 0..<9{
//            for y in 0..<9{
//                if board[x][y]==0{
//                    i = x
//                    j = y
//                    break
//                }
//            }
//        }
//        
//        for x in 1...9{
//            if possibleMove(sudoku: board, row: i, col: j, val: x){
//                board[i][j] = x
//                let recursiveResult = sudokuSolver1(sudoku: board, tfCollection: tfCollection)
//                if recursiveResult{
//                    return true
//                }
//            }
//        }
//        
//        //backtracking
//        board[i][j] = 0
//        return false
//    }
//}
