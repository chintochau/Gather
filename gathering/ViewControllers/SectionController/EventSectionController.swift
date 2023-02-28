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
        supplementaryViewSource = self
        
    }
    
    override func didUpdate(to object: Any) {
        viewModel = object as? any HomeCellViewModel
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let vm = viewModel as! EventHomeCellViewModel
        
        
        if let _ = vm.imageUrlString {
            
            let cell = collectionContext?.dequeueReusableCell(of: EventWithImageCell.self, for: self, at: index) as! EventWithImageCell
            cell.bindViewModel(vm)
            return cell
            
        } else {
            
            let cell = collectionContext?.dequeueReusableCell(of: EventCell.self, for: self, at: index) as! EventCell
            cell.bindViewModel(vm)
            return cell
            
        }
    
    }
    
    override func didSelectItem(at index: Int) {
        let viewModel = viewModel as! EventHomeCellViewModel
        
        let vc = EventDetailViewController()
        let cell = collectionContext?.cellForItem(at: index, sectionController: self) as! BasicEventCollectionViewCell
        viewModel.image = cell.eventImageView.image
        vc.viewModel = viewModel
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension EventSectionController:ListSupplementaryViewSource {
    func supportedElementKinds() -> [String] {
        [UICollectionView.elementKindSectionHeader]
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        let view = collectionContext?.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: self, class: HomeSectionHeaderReusableView.self, at: index) as! HomeSectionHeaderReusableView
        view.configure(with: SectionHeaderViewModel(title: "Not Configured", buttonText: nil))
        return view
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        
        return .zero
    }
    
    
    
}
