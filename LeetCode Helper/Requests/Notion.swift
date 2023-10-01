//
//  Notion.swift
//  LeetCode Helper
//
//  Created by 林稚皓 on 2023/9/29.
//

import Foundation
import NotionSwift

func Notion(question: Question) {
    
    
    if let fileURL = Bundle.main.url(forResource: "notionPageProperties", withExtension: "json") {
        do {
            // Read the JSON data from the file
            let jsonData = try Data(contentsOf: fileURL)
            
            // Decode the JSON data into the PageProperties data model
            let decoder = JSONDecoder()
            let pageProperties = try decoder.decode(PageProperties.self, from: jsonData)
            
            print(pageProperties)
            
            let difficultyInfo = findDifficultyProperties(for: question.difficulty, in: pageProperties)
            let tagNames = question.topicTags.map { $0.name }
            let tagProperties = findTagProperties(for: tagNames, in: pageProperties)
            
            let notion = NotionClient(accessKeyProvider: StringAccessKeyProvider(accessKey: "secret_ksRMccGUAuub3ZuiDkpwikOc99kKGe7R9L0O1X0PiNY"))
            let today = Date()
            let dateValue = DateValue.dateOnly(today)
            let deviceTimeZone = TimeZone.current
            var calendar = Calendar.current
            calendar.timeZone = deviceTimeZone
            let adjustedDate = calendar.date(byAdding: .hour, value: 8, to: today)
            let latestFinishDate: DateValue = .dateOnly(adjustedDate ?? today)
            let databaseId = Database.Identifier("eb14de1b338c44808ec1b282753a70c3")
            
            if let difficultyInfo = difficultyInfo {
                let request = PageCreateRequest(
                    parent: .database(databaseId),
                    properties: [
                        "Name": .init(
                            type: .title([
                                RichText.init(plainText: "", href: "", type: .text(.init(content: question.frontendQuestionId+"."+question.title, link: NotionLink(url: "https://leetcode.com/problems/"+question.titleSlug+"/description/"))))])
                        ),
                        "Status": .init(type:.status(PagePropertyType.StatusPropertyValue(id: EntityIdentifier("6dd3d362-a127-43bd-9259-6ecc8f102778") , name: "Done", color: "green"))),
                        "Difficulty": .init(type: .select(
                            PagePropertyType.SelectPropertyValue(
                                id: EntityIdentifier(difficultyInfo.ID),
                                name: question.difficulty,
                                color: difficultyInfo.Color
                            )
                        )),
                        "Tag": .init(type: .multiSelect(
                            tagProperties.map { tagProperty in
                                PagePropertyType.MultiSelectPropertyValue(id: EntityIdentifier(tagProperty.ID), name: tagProperty.Name, color: tagProperty.Color)
                            }
                        )),
                        "Latest Finish": .init(type: .date(DateRange(start: latestFinishDate, end: nil)))
                    ]
                )
                
                let blocks: [WriteBlock] = [
                    .paragraph(["Question"]),
                    .paragraph(["Solution"])
                ]
                
                notion.pageCreate(request: request) {
                    print($0)
                    if case let .success(page) = $0 {
                        let pageID = page.id.rawValue
                        print("Page ID: \(pageID)")
                        
                        notion.blockAppend(blockId: Block.Identifier(pageID), children: blocks) {
                            print($0)
                        }
                        
                    } else {
                        print("Invalid or error result")
                    }
                    
                }
            } else {
                print("Difficulty information not found.")
            }
            
        } catch {
            print("Error reading JSON: \(error)")
        }
    } else {
        print("JSON file not found.")
    }
}
