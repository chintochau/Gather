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
    
    var items:[HomeCellViewModel] = []
    
    func fetchData(completion:@escaping () -> Void) {
        DatabaseManager.shared.fetchAllEvents { [weak self] events in
            guard let events = events else {return}
            self?.events = events
            self?.createViewModels()
            completion()
        }
        
    }
    
    private func createViewModels(){
        items = events.map({ EventHomeCellViewModel(event: $0) })
        for (index,_) in items.enumerated() {
            if index % 4 == 3 {
                items.insert(AdViewModel(ad: Ad(id: UUID().uuidString)), at: index)
            }
        }
        
        print(items)
    }
}
