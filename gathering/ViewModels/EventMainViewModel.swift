//
//  EventMainViewModel.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-18.
//

import UIKit

struct EventMainViewModel {
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
}


extension EventMainViewModel {
    static func configure(with event:Event,image:UIImage) -> EventMainViewModel? {
        
        print("createVM")
        guard  let startDate = DateFormatter.formatter.date(from: event.startDateString),
               let endDate = DateFormatter.formatter.date(from: event.endDateString) else {return nil}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a" // output format
        let startTime = dateFormatter.string(from: startDate)
        let endTime = dateFormatter.string(from: endDate)
        var timeInterval = "\(startTime)-\(endTime)"
        if startTime == endTime {
            timeInterval = "\(startTime)"
        }
        dateFormatter.dateFormat = "dd MMM yyyy"
        let date = dateFormatter.string(from: startDate)
        
        return EventMainViewModel(
            event: event,
            image: image,
            title: event.title,
            date: (title:date , subTitle: timeInterval) ,
            location: (area: event.location, address: event.location),
            refundPolicy: event.refundPolicy,
            about: event.description)
    }
}
