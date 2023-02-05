//
//  PreviewViewViewModel.swift
//  gathering
//
//  Created by Jason Chau on 2023-02-05.
//

import Foundation

struct PreviewViewModel{
    let event:Event
    var eventString:String {
        
        
        let title:String = event.title
        
        let startString:String = {
            return "\nTime: " + event.startDateString
        }()
        
        let location:String = {
            return "\nLocation: " + event.location.name
        }()
        
        let address:String = {
            if let address = event.location.address {
                return "\nAddress: " + address
            }
            return ""
        }()
        
        let participants:String = {
            
            var counter:Int = 1
            
            var namelist = "\nNamelist: "
            for participant in event.participants {
                namelist += "\n\(counter). " + participant.key
                counter += 1
            }
            
            return namelist
        }()
        
        let string = title + startString + location + address + participants
        
        
        return string
    }
    
}
