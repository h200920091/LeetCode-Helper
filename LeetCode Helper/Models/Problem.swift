//
//  Problem.swift
//  LeetCode Helper
//
//  Created by 林稚皓 on 2023/9/2.
//

import Foundation
import SwiftUI

struct Problem: Hashable, Codable {
    var idx: Int
    var title: String
    var url: String
    var difficulty: String
    var description: String
    var tags: String
    
    private var imageName: String
    var image: Image {
        Image(imageName)
    }
}
