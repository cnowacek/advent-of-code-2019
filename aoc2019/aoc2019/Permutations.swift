//
//  Permutations.swift
//  aoc2019
//
//  Created by Charles A Nowacek on 12/12/19.
//  Copyright © 2019 kayosmedia. All rights reserved.
//

import Foundation

extension Array {
    func decompose() -> (Iterator.Element, [Iterator.Element])? {
        guard let x = first else { return nil }
        return (x, Array(self[1..<count]))
    }
}

func between<T>(x: T, _ ys: [T]) -> [[T]] {
    guard let (head, tail) = ys.decompose() else { return [[x]] }
    return [[x] + ys] + between(x: x, tail).map { [head] + $0 }
}

//let example = between(x: 0, [1, 2, 3])
// example = [[0, 1, 2, 3], [1, 0, 2, 3], [1, 2, 0, 3], [1, 2, 3, 0]]

func permutations<T>(xs: [T]) -> [[T]] {
    guard let (head, tail) = xs.decompose() else { return [[]] }
    return permutations(xs: tail).flatMap { between(x: head, $0) }
}
