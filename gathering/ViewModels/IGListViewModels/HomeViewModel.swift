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
    var startDate:Date = Date()
    
    var items:[HomeCellViewModel] = []
    
    func fetchData(page: Int, perPage: Int,completion:@escaping ([Event]) -> Void) {
        DatabaseManager.shared.fetchAllEvents(page: page, perPage: perPage) { [weak self] events in
            guard let events = events, let newDate = events.last?.startDateTimestamp else {return}
            self?.startDate = Date(timeIntervalSince1970: newDate)
            self?.events = events
            self?.createViewModels()
            completion(events)
        }
    }
    
    func fetchMoreData(page: Int, perPage: Int,completion:@escaping ([Event]) -> Void) {
        DatabaseManager.shared.fetchAllEvents(page: page, perPage: perPage, startDate:startDate) { [weak self] events in
            guard let events = events, let newDate = events.last?.startDateTimestamp else {return}
            self?.startDate = Date(timeIntervalSince1970: newDate)
            self?.events.append(contentsOf: events)
            self?.createViewModels()
            completion(events)
        }
    }
    
    
    
    func insertEvent(event:Event, at index:Int, completion:@escaping () -> Void ) {
        events.insert(event, at: index)
        completion()
    }
    
    private func createViewModels(){
        items = events.map({ EventHomeCellViewModel(event: $0) })
        for (index,_) in items.enumerated() {
            if index % 4 == 3 {
                let ad = Ad(id: UUID().uuidString)
                items.insert(AdViewModel(ad: ad), at: index)
            }
        }
        
    }
}
