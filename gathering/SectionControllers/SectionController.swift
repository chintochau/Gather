//
//  SectionController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-12.
//

import IGListKit


final class LabelSectionController : ListSectionController {
    
    private var text:String?
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: EventSmallCollectionViewCell.self, for: self, at: index) as! EventSmallCollectionViewCell
        cell.configure(with: EventCollectionViewCellViewModel(imageUrlString: MockData.event.imageUrlString, title: "123", date: "NOW", location: "HK", tag: nil, isLiked: true))
        
        return cell
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width-10, height: 100)
    }
    
    override func didUpdate(to object: Any) {
        self.text = object as? String
    }
    
    override func didSelectItem(at index: Int) {
        print(123)
    }
    
    
    
}
