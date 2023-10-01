//
//  Problem.swift
//  LeetCode Helper
//
//  Created by 林稚皓 on 2023/9/2.
//

import Foundation
import SwiftUI

struct TopicTag: Codable, Hashable, Identifiable{
    let name: String
    let id: String
    let slug: String
}

struct Question: Codable, Hashable{
    let acRate: Double
    let difficulty: String
    let frontendQuestionId: String
    let isFavor: Bool
    let paidOnly: Bool
    let title: String
    let titleSlug: String
    let topicTags: [TopicTag]
    let hasSolution: Bool
    let hasVideoSolution: Bool
}

struct ProblemsetQuestionList: Codable, Hashable{
    let total: Int
    let questions: [Question]
}

struct responseData: Codable, Hashable{
    let problemsetQuestionList: ProblemsetQuestionList
}

struct ResponseData: Codable, Hashable{
    let data: responseData
}

func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T{
    do {
        if let jsonFilePath = Bundle.main.path(forResource: filename, ofType: "json") {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: jsonFilePath))
            let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
            return decodedData
        } else {
            fatalError("JSON file not found.")
        }
    } catch {
        fatalError("Error loading JSON")
    }
}


let problemset: ResponseData = load("problemsetQuestionList")
let questions = problemset.data.problemsetQuestionList.questions
