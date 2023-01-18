//
//  NewEventViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import UIKit
import IGListKit

enum newEventPageType:String {
    case photoField = "photo"
    case titleField = "title"
    case desctiptionField = "description"
    case locationField = "location"
    case refundField = "refund"
    case dateField = "date"
    case priceField = "price"
}

class NewEventViewController: UIViewController{
    
    
    private var event = (
        title:"",
        description:"",
        location:"",
        price:0.0,
        refund:"",
        endDate:DateFormatter.formatter.string(from: Date()),
        startDate:DateFormatter.formatter.string(from: Date())
    )
    private var images = [UIImage?](repeating: nil, count: 3)
    private var imageCells = [PhotoCollectionViewCell](repeating: PhotoCollectionViewCell(), count: 3)
    private var currentIndex:Int = 0
    private var observer: NSObjectProtocol?
    private var hideObserver: NSObjectProtocol?
    
    private var tableView:UITableView = {
        let view = UITableView(frame: .zero,style: .grouped)
        return view
    }()
    
    // MARK: - ViewModels
    private let viewModels:[[newEventPageType]] = [
        [.photoField,
         .titleField,
         .desctiptionField
        ],
        [.locationField,
         .dateField,
         .priceField,
         .refundField
        ]
    ]
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "New Event"
        configureTableView()
        observeKeyboardChange()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Preview", style: .plain, target: self, action: #selector(didTapPreview))
    }
    
    private func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .secondarySystemBackground
        tableView.keyboardDismissMode = .interactive
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = UITableView.automaticDimension
        registerCell()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    // MARK: - Register Cell
    private func registerCell(){
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        tableView.register(TextViewTableViewCell.self, forCellReuseIdentifier: TextViewTableViewCell.identifier)
        tableView.register(PhotoGridTableViewCell.self, forCellReuseIdentifier: PhotoGridTableViewCell.identifier)
        tableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: DatePickerTableViewCell.identifier)
    }

    // MARK: - Keyboard Handling
    private func observeKeyboardChange(){
        
        observer = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) { notification in
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                }
            
        }
        
        hideObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
}

// MARK: - Delegate / DataSource
extension NewEventViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModels.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels[section].count
    }
    
    // MARK: - Field Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModels[indexPath.section][indexPath.row] {
        case .titleField:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
            cell.configure(with: "Title", type: .titleField)
            cell.textField.delegate = self
            return cell
            
        case .desctiptionField:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier, for: indexPath) as! TextViewTableViewCell
            cell.configure(with: "Event Detail...",type: .desctiptionField)
            cell.textView.delegate = self
            return cell
            
        case .photoField:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotoGridTableViewCell.identifier, for: indexPath) as! PhotoGridTableViewCell
            cell.delegate = self
            return cell
            
        case .locationField:
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
            cell.configure(with: "Location",type: .locationField)
            cell.textField.delegate = self
            
            return cell
        case .refundField:
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TextViewTableViewCell.identifier, for: indexPath) as! TextViewTableViewCell
            cell.configure(with: "RefundPolicy",type: .refundField)
            cell.textView.delegate = self
            return cell
            
        case .dateField:
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.identifier, for: indexPath) as! DatePickerTableViewCell

            cell.delegate = self
            
            return cell
        case .priceField:
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
            cell.configure(with: "Price",type: .priceField)
            cell.textField.delegate = self
            
            return cell
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Row Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModels[indexPath.section][indexPath.row] {
        case .photoField:
            return (view.width+18)/3
        case .dateField:
            return 88
        default:
            return UITableView.automaticDimension
        }

    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == viewModels.count-1 {
            let buttonView = UIView()
            let publishButton = GAButton(type: .system)
            let previewButton = GAButton(type: .system)
            
            [publishButton,previewButton].forEach{buttonView.addSubview($0)}
            
            previewButton.anchor(
                top: buttonView.topAnchor,
                leading: buttonView.leadingAnchor,
                bottom: buttonView.bottomAnchor,
                trailing: nil,
                padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            )
            previewButton.addTarget(self, action: #selector(didTapPreview), for: .touchUpInside)
            
            previewButton.setTitle("Preview", for: .normal)
            
            publishButton.anchor(
                top: buttonView.topAnchor,
                leading: previewButton.trailingAnchor,
                bottom: nil,
                trailing: buttonView.trailingAnchor,
                padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
            )
            publishButton.widthAnchor.constraint(equalTo: previewButton.widthAnchor, multiplier: 1).isActive = true
            publishButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
            publishButton.setTitle("publish", for: .normal)
            
            return  buttonView
        }
        else {
            return nil
        }
    }
    
 
}

// MARK: - Get Image
extension NewEventViewController:PhotoGridTableViewCellDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    func PhotoGridTableViewCellSelectImage(_ view: PhotoGridTableViewCell, cell: PhotoCollectionViewCell, index:Int) {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        imageCells[index] = cell
        currentIndex = index
        
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage:UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        imageCells[currentIndex].imageView.image = tempImage
        imageCells[currentIndex].imageView.contentMode = .scaleAspectFill
        images[currentIndex] = tempImage
        
        picker.dismiss(animated: true)
        
    }
    
}


// MARK: - Input Data
extension  NewEventViewController:  UITextViewDelegate, UITextFieldDelegate,DatePickerTableViewCellDelegate {
    
    
    /*
     case photoField = "photo"
     case titleField = "title"
     case desctiptionField = "description"
     case locationField = "location"
     case refundField = "refund"
     case dateField = "date"
     case priceField = "price"
     */
    
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
        if let name = textView.layer.name,let text = textView.text {
            switch name {
            case "description":
                event.description = text
                print(event)
            case "refund":
                event.refund = text
            default:
                print("please check type")
            }
            print(text)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let name = textField.layer.name,let text = textField.text, !text.isEmpty {
            switch name {
            case "title":
                event.title = text
            case "location":
                event.location = text
            case "price":
                guard let price = Double(text) else {
                    fatalError("cannot change price to type double")}
                event.price = price
            default:
                print("please check type")
            }
            print(text)
        }
    }
    
    
    func DatePickerTableViewCellDelegateOnDateChanged(_ cell: DatePickerTableViewCell, startDate: Date, endDate: Date) {
        event.startDate = DateFormatter.formatter.string(from: startDate)
        event.endDate = DateFormatter.formatter.string(from: endDate)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let name = textField.layer.name, name == "price" {
            if let _ = string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) {
                return true
            }
            
            return string.isEmpty || string == "."
        }
        
        return true
    }
    
}

extension NewEventViewController {
    // MARK: - Preview/Submit
    
    @objc private func didTapSubmit (){
        view.endEditing(true)
        guard let previewEvent = configurePreviewEvent() else {return}
        publishPost(with: previewEvent) {[weak self] success in
            if success {DispatchQueue.main.async{
                self?.tabBarController?.selectedIndex = 0}
            }
        }
    }
    
    @objc private func didTapPreview(){
        view.endEditing(true)
        guard let previewEvent = configurePreviewEvent() else {return}
        
        let vc = EventMainViewController(event: previewEvent, image: images[0] ?? UIImage(named: "test")!)
        vc.configureExit()
        vc.completion = { [weak self] in
            self?.publishPost(with: previewEvent,completion: { [weak self] success in
                if success {
                    DispatchQueue.main.async{
                        self?.tabBarController!.selectedIndex = 0}
                }
            })
        }
        
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: true)
        
    }
    
    @objc func didDismiss(){
        dismiss(animated: true)
    }
    
    private func configurePreviewEvent (urlString:String = "") -> Event?{
        
        guard let username = UserDefaults.standard.string(forKey: "username") else { return nil }
        
        print(IdManager.shared.createEventId())
        
        return Event(
            id: IdManager.shared.createEventId(),
            title: event.title,
            host: username,
            imageUrlString: urlString,
            organisers: [username],
            eventType: 1,
            price: event.price,
            startDateString: event.startDate,
            endDateString: event.endDate,
            location: event.location,
            tag: [],
            description: event.description,
            refundPolicy: event.refund)
    }
    
    func publishPost(with previewEvent:Event, completion: @escaping (Bool) -> Void){
        guard let image = images[0],
              let data = image.jpegData(compressionQuality: 0.5)
        else {return}
        StorageManager.shared.uploadImage(id: previewEvent.id, data: data) {[weak self] url in
            guard let urlString = url?.absoluteString, let event = self?.configurePreviewEvent(urlString: urlString) else {return}
            DatabaseManager.shared.createEvent(with: event) { done in
                print(done)
                completion(done)
            }
        }
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

