//
//  HomeViewModel.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-20.
//

import Foundation

class HomeViewModel {
    var events = [Event]()
    var users = [User]()
    var ad = [Ad]()
    var header = [Header]()
    var startDate:Date = Double.todayAtMidnightTimestamp() // Start with today at midnight
    
    var items:[HomeCellViewModel] = []
    
    
    func fetchInitialData(page: Int, perPage: Int,completion:@escaping ([Event]) -> Void) {
        DatabaseManager.shared.fetchAllEvents(page: page, perPage: perPage) { [weak self] events in
            guard let events = events, let newDate = events.last?.endDateTimestamp else {
                completion([])
                return}
            self?.startDate = Date(timeIntervalSince1970: newDate)
            self?.events = events
            self?.createViewModels()
            completion(events)
        }
    }
    
    func fetchMoreData(page: Int, perPage: Int,completion:@escaping ([Event]) -> Void) {
        DatabaseManager.shared.fetchAllEvents(page: page, perPage: perPage, startDate:startDate) { [weak self] events in
            
            guard let events = events, let newDate = events.last?.endDateTimestamp else {
                completion([])
                return}
            
            self?.startDate = Date(timeIntervalSince1970: newDate)
            self?.insertViewModels(with: events)
            completion(events)
        }
    }
    
    func insertEvent(event:Event, at index:Int, completion:@escaping () -> Void ) {
        events.insert(event, at: index)
        completion()
    }
    
    private func insertViewModels(with events:[Event]) {
        var newVM:[HomeCellViewModel] = events.compactMap({
            
            if let _ = $0.emojiTitle {
                return PostViewModel(event: $0)
            }else {
                return EventHomeCellViewModel(event: $0)}
            }
                                                          
        )
        
        [0,5].forEach({
            guard newVM.count > 4 else {return}
            let ad = AdViewModel(ad: Ad(id: UUID().uuidString))
            print("Inserted AD ID: \(ad.id)")
            newVM.insert(ad, at: newVM.count - $0)
        })
        
        items.append(contentsOf: newVM)
        
    }
    
    private func createViewModels(){
        items = events.map({
            
            if let _ = $0.emojiTitle {
                return PostViewModel(event: $0)
            }else {
                return EventHomeCellViewModel(event: $0)}
            }
               )
        for (index,_) in items.enumerated() {
            if index % 4 == 3 {
                let ad = Ad(id: UUID().uuidString)
                items.insert(AdViewModel(ad: ad), at: index)
            }
        }
        
    }
    
}
