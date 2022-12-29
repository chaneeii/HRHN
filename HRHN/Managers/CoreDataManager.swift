//
//  CoreDataManager.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/15.
//  ref: https://velog.io/@leeesangheee/Core-Data-%EC%82%AC%EC%9A%A9%ED%95%B4-CRUD-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0

import CoreData
import Foundation
import UIKit

class CoreDataManager {
    
    static var shared: CoreDataManager = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer = {
        let appGroundID = "group.com.chanheejeong.HRHN"
        let storeURL = URL.storeURL(for: appGroundID, databaseName: "HRHN")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        let container = NSPersistentContainer(name: "HRHN")
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    private lazy var context = persistentContainer.viewContext
    
    func insertChallenge(_ challenge: Challenge) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Challenge", in: context) else { return }
        
        let existing = getChallengeOf(challenge.date)
        if existing.isEmpty {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            managedObject.setValue(challenge.id, forKey: "id")
            managedObject.setValue(challenge.date, forKey: "date")
            managedObject.setValue(challenge.emoji.rawValue, forKey: "emoji")
            managedObject.setValue(challenge.content, forKey: "content")
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("이미 등록된 내용이 있습니다")
        }
    }
    
    private func fetchChallenges() -> [ChallengeMO] {
        
        let fetchRequest = NSFetchRequest<ChallengeMO>(entityName: "Challenge")
        let sort = NSSortDescriptor(key: #keyPath(ChallengeMO.date), ascending: false) // by latest
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    func getChallenges() -> [Challenge] {
        var challenges: [Challenge] = []
        let fetchResults = fetchChallenges()
        for result in fetchResults {
            let challenge = Challenge(id: result.id,
                                      date: result.date,
                                      content: result.content,
                                      emoji: Emoji(rawValue:
                                                    result.emoji)!)
            challenges.append(challenge)
        }
        return challenges
    }
    
    func updateChallenge(_ challenge: Challenge) {
        let fetchResults = fetchChallenges()
        for result in fetchResults {
            if isSameDay(date1: result.date, date2: challenge.date) {
                result.emoji = challenge.emoji.rawValue
                result.content = challenge.content
            }
        }
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func getChallengeOf(_ date: Date) -> [Challenge] {
        var challenges: [Challenge] = []
        let fetchResults = fetchChallenges()
        if fetchResults.count > 0 {
            let resultsByDate = fetchResults.filter({ isSameDay(date1: date, date2: $0.date)})
            for result in resultsByDate {
                let challenge = Challenge(id: result.id,
                                          date: result.date,
                                          content: result.content,
                                          emoji: Emoji(rawValue:
                                                        result.emoji)!)
                challenges.append(challenge)
            }
            return challenges
        } else {
            return []
        }
    }
    
    func deleteChallenge(_ date: Date) {
        let fetchResults = fetchChallenges()
        if fetchResults.count > 0 {
            let challenge = fetchResults.filter({ isSameDay(date1: date, date2: $0.date) })[0]
            context.delete(challenge)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        } else {
            // TODO: - 에러처리
            print("삭제할 데이터가 없습니다.")
        }
    }
    
    func deleteAllChallenges() {
        let fetchResults = fetchChallenges()
        if fetchResults.count > 0 {
            for result in fetchResults {
                context.delete(result)
            }
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        } else {
            // TODO: - 에러처리
            print("삭제할 데이터가 없습니다.")
        }
    }
    
}

extension CoreDataManager {
    private func isSameDay(date1: Date, date2: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.day], from: date1, to: date2)
        if diff.day == 0 {
            return true
        } else {
            return false
        }
    }
}
