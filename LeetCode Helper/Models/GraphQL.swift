//
//  GraphQL.swift
//  LeetCode Helper
//
//  Created by 林稚皓 on 2023/9/29.
//

import Foundation

func sendGraphQLRequest(titleSlug: String ,completion: @escaping (String?) -> Void) {
    // Your GraphQL service URL
    let graphqlURL = URL(string: "https://leetcode.com/graphql")!

    // Your GraphQL query and variables
    let query = """
    query questionContent($titleSlug: String!) {
      question(titleSlug: $titleSlug) {
        content
        mysqlSchemas
      }
    }
    """
    
    // Explicitly specify the type of the 'variables' dictionary
    let variables: [String: Any] = ["titleSlug": titleSlug]
    let requestBody: [String: Any] = ["query": query, "variables": variables]

    // Create an HTTP request
    var request = URLRequest(url: graphqlURL)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    do {
        // Convert the request body to JSON data
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        request.httpBody = jsonData

        // Create a URLSession instance
        let session = URLSession.shared

        // Send the request
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }

            do {
                // Parse JSON data
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let dataDict = json["data"] as? [String: Any],
                   let questionDict = dataDict["question"] as? [String: Any],
                   let content = questionDict["content"] as? String {
                    // Handle the JSON response from GraphQL here
                    print(content)
                    completion(content) // 调用闭包并传递 content 值
                } else {
                    print("Failed to parse JSON response")
                    completion(nil)
                }
            } catch {
                print("Error parsing JSON response: \(error)")
                completion(nil)
            }
        }

        // Start the request
        task.resume()
    } catch {
        print("Error creating JSON data: \(error)")
        completion(nil)
    }
}

struct GraphQLResponse: Codable {
    let data: Data?
    
    struct Data: Codable {
        let problemsetQuestionList: ProblemsetQuestionList?
        
        struct ProblemsetQuestionList: Codable {
            let questions: [Question]?
        }
    }
}

enum FetchError: Error {
    case networkError(Error)
    case noData
    case decodingError(Error)
    case missingData
    case fileSaveError(Error)
}

func getAllQuestions(completion: @escaping (Result<[Question], FetchError>) -> Void) {
    // Your GraphQL service URL
    let graphqlURL = URL(string: "https://leetcode.com/graphql")!

    // Your GraphQL query and variables
    let query = """
    query problemsetQuestionList($categorySlug: String, $limit: Int, $skip: Int, $filters: QuestionListFilterInput) {
      problemsetQuestionList: questionList(
        categorySlug: $categorySlug
        limit: $limit
        skip: $skip
        filters: $filters
      ) {
        total: totalNum
        questions: data {
          acRate
          difficulty
          freqBar
          frontendQuestionId: questionFrontendId
          isFavor
          paidOnly: isPaidOnly
          status
          title
          titleSlug
          topicTags {
            name
            id
            slug
          }
          hasSolution
          hasVideoSolution
        }
      }
    }
    """
    
    // Define the variables
    let variables: [String: Any] = [
        "categorySlug": "",
        "limit": 3500,
        "skip": 0,
        "filters": [:] // You may need to define the appropriate structure for filters
    ]
    let requestBody: [String: Any] = ["query": query, "variables": variables]

    // Create an HTTP request
    var request = URLRequest(url: graphqlURL)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    do {
        // Convert the request body to JSON data
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        request.httpBody = jsonData

        // Create a URLSession instance
        let session = URLSession.shared

        // Send the request
        let task: URLSessionDataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network Error: \(error)")
                completion(.failure(.networkError(error)))
                return
            }

            guard let data = data else {
                print("No Data Received")
                completion(.failure(.noData))
                return
            }

            do {
                // Parse JSON data
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(GraphQLResponse.self, from: data)
                
                if let questions = result.data?.problemsetQuestionList?.questions {
                    // Save the fetched data to a file
                    do {
                        try saveDataToFile(questions: questions)
                    } catch {
                        print("File Save Error: \(error)")
                        completion(.failure(.fileSaveError(error)))
                    }
                    completion(.success(questions))
                } else {
                    print("Missing Data in JSON Response")
                    completion(.failure(.missingData))
                }
            } catch {
                print("Decoding Error: \(error)")
                completion(.failure(.decodingError(error)))
            }
        }

        // Start the request
        task.resume()
    } catch {
        print("JSON Serialization Error: \(error)")
        completion(.failure(.networkError(error)))
    }
}

func saveDataToFile(questions: [Question]) throws {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted // If you want the JSON to be formatted nicely
    
    do {
        let jsonData = try encoder.encode(questions)
        
        // 获取应用程序沙盒的 Documents 目录
        let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        // 指定要保存的文件路径
        let fileURL = documentsDirectory.appendingPathComponent("problemsetQuestionList.json")
        
        try jsonData.write(to: fileURL)
        print("Successfully updated problemsetQuestionList.json")
    } catch {
        print("File Save Error: \(error)")
        throw FetchError.fileSaveError(error)
    }
}
