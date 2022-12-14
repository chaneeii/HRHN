//
//  TodayViewModel.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/25.
//

import UIKit

final class TodayViewModel {
    
    var todayChallenge: Observable<String?> = Observable(nil)
    
    private var coreDataManager = CoreDataManager.shared
    private let center = UNUserNotificationCenter.current()
    
    init(){}
    
    func fetchTodayChallenge() {
        let challenges = self.coreDataManager.getChallengeOf(Date())
        if challenges.count > 0 {
            self.todayChallenge = Observable(challenges[0].content)
        } else {
            self.todayChallenge = Observable(nil)
        }
    }

    func isPreviousChallengeExist() -> Bool {
        let challenges = coreDataManager.getChallenges()
        if challenges.count > 0 && challenges[0].emoji == .none {
            return true
        } else {
            return false
        }
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        center.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Auth Error: ", error)
            }
        }
    }
    
    func isTodayChallengeExist() -> Bool {
        if todayChallenge.value == nil {
            return false
        } else {
            return true
        }
    }
}
