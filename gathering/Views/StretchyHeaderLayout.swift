//
//  StretchyHeaderLayout.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-18.
//

import UIKit

class StretchyHeaderLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        layoutAttributes?.forEach({ attributes in
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                
                guard let collectionView = collectionView else {return}
                
                let contentOffsetY = collectionView.contentOffset.y
                let width = collectionView.width
                let height = attributes.frame.height - contentOffsetY
                
                attributes.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: height)
            }
        })
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

}


#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct Preview1: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        EventViewController(viewModel: EventMainViewModel(with: MockData.event, image: UIImage(named: "test")!)!)
            .toPreview()
        
    }
}
#endif

