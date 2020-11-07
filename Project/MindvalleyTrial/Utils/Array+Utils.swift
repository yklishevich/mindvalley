//
//  Array+Utils.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 27.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation

extension Array {
    public subscript(indeces: [Int]) -> [Element] {
        var ret = [Element]()
        indeces.forEach { ret.append(self[$0]) }
        return ret
    }
}
