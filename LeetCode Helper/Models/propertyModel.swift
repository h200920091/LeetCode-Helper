//
//  propertyModel.swift
//  LeetCode Helper
//
//  Created by 林稚皓 on 2023/9/30.
//

import Foundation

struct PageProperties: Codable {
    struct Item: Codable {
        let ID: String
        let Name: String
        let Color: String
    }
    
    let Difficulty: [Item]
    let Tag: [Item]
    let Status: [Item]
}

func findDifficultyProperties(for difficulty: String, in pageProperties: PageProperties) -> (ID: String, Color: String)? {

    for item in pageProperties.Difficulty {
        if item.Name == difficulty {
            return (item.ID, item.Color)
        }
    }
    return nil
}

func findTagProperties(for tagNames: [String], in pageProperties: PageProperties) -> [PageProperties.Item] {
    var tagProperties: [PageProperties.Item] = []
    
    for tagName in tagNames {
        if let matchingTag = pageProperties.Tag.first(where: { $0.Name == tagName }) {
            tagProperties.append(matchingTag)
        }
    }
    
    return tagProperties
}
