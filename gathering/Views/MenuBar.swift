//
//  MenuBar.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-03-18.
//

import UIKit

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    

    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.estimatedItemSize = .init(width: 50, height: 30)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(MenuBarCell.self, forCellWithReuseIdentifier: MenuBarCell.identifier)
        view.delegate = self
        view.dataSource = self
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        return view
    }()
    
    private let indicatorView:UIView = {
        let view = UIView()
        view.backgroundColor = .label
        return view
    }()
    
    
    var items:[String] = ["全部"] {
        didSet{
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(collectionView)
        collectionView.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.selectItem(at: .init(row: 0, section: 0), animated: false, scrollPosition: [])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuBarCell.identifier, for: indexPath) as! MenuBarCell
        cell.heightAnchor.constraint(equalToConstant: height-10).isActive = true
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        
    }
    

}


class MenuBarCell:UICollectionViewCell {
    static let identifier = "MenuBarCell"
    
    override var isSelected: Bool {
        didSet {
            itemLabel.textColor = isSelected ? .label: .darkGray
        }
    }
    
    private let itemLabel:UILabel = {
        let view = UILabel()
        view.font = .righteousFont(ofSize: 16)
        view.textColor = .darkGray
        
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(itemLabel)
        self.layer.cornerRadius = 10
        itemLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 10, bottom: 0, right: 10))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func configure(with name:String) {
        itemLabel.text = name
    }
    
}
