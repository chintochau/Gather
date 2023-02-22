//
//  EventSectionController.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-20.
//

import UIKit
import IGListKit

class EventSectionController: ListSectionController {
    
    var viewModel: HomeCellViewModel!
    
    override init() {
        super.init()
        inset = .init(top: 2, left: 0, bottom: 2, right: 0)
    }
    
    override func didUpdate(to object: Any) {
        viewModel = object as? any HomeCellViewModel
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: EventCell.self, for: self, at: index) as! EventCell
        cell.bindViewModel(viewModel as! EventHomeCellViewModel)
        return cell
    }
    
    override func didSelectItem(at index: Int) {
        let viewModel = viewModel as! EventHomeCellViewModel
//        let vc = DemoViewController()
        
        let vc = EventViewController(viewModel: EventViewModel(with: viewModel.event, image: nil)!)
        viewController?.navigationController?.pushViewController(vc, animated: true)
        
    }
}
