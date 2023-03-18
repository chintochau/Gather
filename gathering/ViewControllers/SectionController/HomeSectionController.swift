//
//  HomeSectionController.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-20.
//

import UIKit
import IGListKit


class HomeSectionController: ListSectionController {
    
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
    
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        let height: CGFloat
        switch viewModel {
        case _ as AdViewModel:
            let cell = collectionContext?.dequeueReusableCell(of: AdCollectionViewCell.self, for: self, at: index) as! AdCollectionViewCell
            cell.bindViewModel(viewModel as! AdViewModel)
            let size = cell.systemLayoutSizeFitting(CGSize(width: width, height: 0))
            height = size.height
        case _ as PeopleViewModel:
            let cell = collectionContext?.dequeueReusableCell(of: PeopleCell.self, for: self, at: index) as! PeopleCell
            cell.bindViewModel(viewModel as! EventCellViewModel)
            let size = cell.systemLayoutSizeFitting(CGSize(width: width, height: 0))
            height = size.height
        case _ as PlaceViewModel:
            let cell = collectionContext?.dequeueReusableCell(of: PlaceCell.self, for: self, at: index) as! PlaceCell
            cell.bindViewModel(viewModel as! EventCellViewModel)
            let size = cell.systemLayoutSizeFitting(CGSize(width: width, height: 0))
            height = size.height
        default:
            fatalError("Unsupported view model type")
        }
        
        return CGSize(width: width, height: height)
    }

    
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let viewModel = viewModel
        switch viewModel {
        case let adViewModel as AdViewModel:
            let cell = collectionContext?.dequeueReusableCell(of: AdCollectionViewCell.self, for: self, at: index) as! AdCollectionViewCell
            cell.bindViewModel(adViewModel)
            return cell
        case let peopleViewModel as PeopleViewModel:
            let cell = collectionContext?.dequeueReusableCell(of: PeopleCell.self, for: self, at: index) as! PeopleCell
            cell.bindViewModel(peopleViewModel)
            return cell
        case let placeViewModel as PlaceViewModel:
            let cell = collectionContext?.dequeueReusableCell(of: PlaceCell.self, for: self, at: index) as! PlaceCell
            cell.bindViewModel(placeViewModel)
            return cell
        case let skeletonViewModel as SkeletonViewModel:
            let cell = collectionContext?.dequeueReusableCell(of: SkeletonCollectionViewCell.self, for: self, at: index) as! SkeletonCollectionViewCell
            return cell
        default:
            fatalError()
        }
    }
    
    override func didSelectItem(at index: Int) {
        let viewModel = viewModel
        // Handle cell selection based on the type of view model
    }
}
