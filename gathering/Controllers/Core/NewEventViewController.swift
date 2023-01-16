//
//  NewEventViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import UIKit
import IGListKit

enum newEventPageType {
    case titleField
    case desctiptionField
}

class NewEventViewController: UIViewController {
    
    
    private var tableView:UITableView = {
        let view = UITableView(frame: .zero,style: .grouped)
        return view
    }()
    
    private let viewModels:[[newEventPageType]] = [
        [
            .titleField,
            .desctiptionField
        ],
        [.titleField
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "New Event"
        configureTableView()
    }
    
    
    private func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .secondarySystemBackground
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = UITableView.automaticDimension
        registerCell()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func registerCell(){
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        tableView.register(TextViewTableViewCell.self, forCellReuseIdentifier: TextViewTableViewCell.identifier)
    }

    
}

extension NewEventViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModels.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModels[indexPath.section][indexPath.row] {
        case .titleField:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
            cell.configure(with: "Title")
            
            return cell
            
        case .desctiptionField:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier, for: indexPath) as! TextViewTableViewCell
            cell.textView.delegate = self
            return cell
            
        }
    }
}

extension  NewEventViewController:  UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}


#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct Previewne: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        NewEventViewController().toPreview()
    }
}
#endif

