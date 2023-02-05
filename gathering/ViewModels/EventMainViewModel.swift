//
//  EventMainViewModel.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-18.
//

import UIKit

struct EventMainViewModel {
    let owner:User
    let event:Event
    let image:UIImage
    let title:String
    let date:(
        title:String,
        subTitle:String
    )
    let location :(
        area:String,
        address:String
    )
    let refundPolicy:String
    let about:String
    let price:String
}


extension EventMainViewModel {
    
    init?(with event:Event, image:UIImage) {
        guard  let startDate = DateFormatter.formatter.date(from: event.startDateString),
               let endDate = DateFormatter.formatter.date(from: event.endDateString) else {return nil}
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a" // output format
        let startTime = dateFormatter.string(from: startDate)
        let endTime = dateFormatter.string(from: endDate)
        var timeInterval = "\(startTime) - \(endTime)"
        
        if startTime == endTime {
            timeInterval = "\(startTime)"
        }
        dateFormatter.dateFormat = "dd MMM yyyy"
        let date = dateFormatter.string(from: startDate)
        
        self.event = event
        self.image = image
        self.title = event.title
        self.date = (title:date , subTitle: timeInterval)
        self.location = (area: event.location.name, address: event.location.address ?? "")
        self.refundPolicy = event.refundPolicy
        self.about = event.description
        self.owner = event.organisers[0]
        
        self.price = event.price == 0.0 ? "Free" : "CA$: \(String(event.price))"
        
    }
    
}
