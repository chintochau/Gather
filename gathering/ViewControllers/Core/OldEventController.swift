//
//  NewEventViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import UIKit

enum newEventPageType:String {
    case photoField = "Photo"
    case titleField = "Title"
    case desctiptionField = "Description"
    case locationField = "Location"
    case refundField = "Refund Policy"
    case dateField = "Date"
    case priceField = "Price"
    case headCount
}

class OldEventController: UIViewController{
    
    deinit{
        print("released")
    }
    
    private var tempEvent = NewPost()
    
    private let picker = UIImagePickerController()
    
    private static let imageCount:Int = 1
    
    private var images = [UIImage?](repeating: nil, count: imageCount)
    private var imageCells = [PhotoCollectionViewCell](repeating: PhotoCollectionViewCell(), count: imageCount)
    private var currentIndex:Int = 0
    private var observer: NSObjectProtocol?
    private var hideObserver: NSObjectProtocol?
    
    private var tableView:UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        return view
    }()
    
    
    private let buttonView = UIView()
    private let publishButton = GAButton(type: .system)
    private let previewButton = GAButton(type: .system)
    private let activatyIndicator:UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.isHidden = true
        view.hidesWhenStopped = true
        return view
    }()
    
    var completion: ((_ event:Event,_ image:UIImage?) -> Void)?
    
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
        ],
        [
            .headCount
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
    
    // MARK: - TableView
    private func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        tableView.keyboardDismissMode = .interactive
        tableView.contentInset = .init(top: 0, left: 0, bottom: 100, right: 0)
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
        tableView.register(HeadcountTableViewCell.self, forCellReuseIdentifier: HeadcountTableViewCell.identifier)
    }

    // MARK: - Keyboard Handling
    private func observeKeyboardChange(){
        
        observer = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) {[weak self] notification in
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                self?.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                }
            
        }
        
        hideObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] _ in
                self?.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
}

// MARK: - Delegate / DataSource
extension OldEventController: UITableViewDataSource,UITableViewDelegate {
    
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
            cell.configure(with: "",type: .desctiptionField)
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
            cell.configure(with: "",type: .refundField)
            cell.textView.delegate = self
            return cell
            
        case .dateField:
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: DatePickerTableViewCell.identifier, for: indexPath) as! DatePickerTableViewCell
            cell.delegate = self
            cell.configure(mode: .dateAndTime)
            
            return cell
        case .priceField:
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as! TextFieldTableViewCell
            cell.configure(with: "Price",type: .priceField)
            cell.textField.delegate = self
            
            return cell
            
        case .headCount:
            let cell = tableView.dequeueReusableCell(withIdentifier: HeadcountTableViewCell.identifier, for: indexPath) as! HeadcountTableViewCell
            cell.delegate = self
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        // MARK: - Bottom View
        
        if section == viewModels.count-1 {
            
            [publishButton,previewButton,activatyIndicator].forEach{buttonView.addSubview($0)}
            
            previewButton.anchor(
                top: buttonView.topAnchor,
                leading: buttonView.leadingAnchor,
                bottom: buttonView.bottomAnchor,
                trailing: nil,
                padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
            )
            
            previewButton.addTarget(self, action: #selector(didTapPreview), for: .touchUpInside)
            previewButton.setTitle("Preview", for: .normal)
            previewButton.backgroundColor = .lightGray
            previewButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            publishButton.anchor(
                top: buttonView.topAnchor,
                leading: previewButton.trailingAnchor,
                bottom: buttonView.bottomAnchor,
                trailing: buttonView.trailingAnchor,
                padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
            )
            
            publishButton.widthAnchor.constraint(equalTo: previewButton.widthAnchor, multiplier: 1).isActive = true
            publishButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
            publishButton.setTitle("publish", for: .normal)
            publishButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            activatyIndicator.anchor(top: publishButton.topAnchor, leading: publishButton.leadingAnchor, bottom: publishButton.bottomAnchor, trailing: publishButton.trailingAnchor)
            
            
            return  buttonView
        }
        else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    
 
}

extension OldEventController:PhotoGridTableViewCellDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    // MARK: - Image
    
    func PhotoGridTableViewCellSelectImage(_ view: PhotoGridTableViewCell, cell: PhotoCollectionViewCell, index:Int) {
        
        picker.delegate = self
        picker.allowsEditing = true
        
        imageCells[index] = cell
        currentIndex = index
        
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let tempImage:UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        
        imageCells[currentIndex].imageView.image = tempImage
        imageCells[currentIndex].imageView.contentMode = .scaleAspectFill
        images[currentIndex] = tempImage
        
        picker.dismiss(animated: true)
        
    }
    
}


extension  OldEventController:  UITextViewDelegate, UITextFieldDelegate,DatePickerTableViewCellDelegate,HeadcountTableViewCellDelegate {
    
    // MARK: - Input Data
    
    /*
     case photoField = "photo"
     case titleField = "title"
     case desctiptionField = "description"
     case locationField = "location"
     case refundField = "refund"
     case dateField = "date"
     case priceField = "price"
     */
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
    }
    
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
        if let name = textView.layer.name,let text = textView.text {
            switch name {
            case newEventPageType.desctiptionField.rawValue:
                tempEvent.description = text
            default:
                print("please check type")
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let name = textField.layer.name,let text = textField.text, !text.isEmpty {
            switch name {
            case newEventPageType.titleField.rawValue:
                tempEvent.title = text
            case newEventPageType.locationField.rawValue:
                tempEvent.location = Location.toronto
            case newEventPageType.priceField.rawValue:
                guard let price = Double(text) else {
                    fatalError("cannot change price to type double")}
            default:
                print("please check type")
            }
        }
    }
    
    
    func DatePickerTableViewCellDelegateOnDateChanged(_ cell: DatePickerTableViewCell, startDate: Date, endDate: Date) {
        tempEvent.startDate = startDate
        tempEvent.endDate = endDate
        
    }
    
    func DatePickerDidTapAddEndTime(_ cell: DatePickerTableViewCell) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let name = textField.layer.name, name == newEventPageType.priceField.rawValue,
           let price = textField.text{
            
            if price.contains(".") && string == "." {
                return false
            }
            
            if let _ = string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) {
                return true
            }
            
            
            return string.isEmpty || string == "."
        }
        
        return true
        
    }
    
    
    func HeadcountTableViewCellDidEndEditing(_ cell: HeadcountTableViewCell, headcount: Headcount) {
        
        tempEvent.headcount = headcount
    }
    
    func HeadcountTableViewCellDidTapExpand(_ cell: HeadcountTableViewCell, headcount: Headcount) {
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
}

extension OldEventController {
    // MARK: - Preview/Submit
    
    @objc private func didTapSubmit (){
        view.endEditing(true)
        
        guard let previewEvent = configurePreviewEvent() else {return}
        
        publishButton.isHidden = true
        activatyIndicator.startAnimating()
        
        publishPost(with: previewEvent) {[weak self] event in
            self?.publishButton.isHidden = false
            self?.activatyIndicator.stopAnimating()
            self?.navigationController?.popToRootViewController(animated: false)
            self?.completion?(event, self?.images[0])
            
        }
    }
    
    @objc private func didTapPreview(){
        view.endEditing(true)
        guard let previewEvent = configurePreviewEvent(),
              let eventVM = OldEventViewModel(with: previewEvent, image:  images[0]) else {return}
        
        let vc = EventViewController(viewModel: eventVM)
        vc.configureExit()
        vc.completion = { [weak self] in
            self?.publishPost(with: previewEvent,completion: { [weak self] event in
                
                DispatchQueue.main.async{
                    //                        self?.tabBarController!.selectedIndex = 0
                    self?.navigationController?.popToRootViewController(animated: false)
                    self?.completion?(previewEvent, self?.images[0])
                    
                    
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
    
    private func configurePreviewEvent (urlStrings:[String] = []) -> Event?{
        
        guard let user = DefaultsManager.shared.getCurrentUser(),
              let gender = user.gender
        else {
            print("user / gender not found")
            return nil
        }
        
        return Event(
            id: IdManager.shared.createEventId(), emojiTitle: nil,
            title: tempEvent.title,
            organisers: [user],
            imageUrlString: urlStrings,
            price: 0,
            startDateTimestamp: tempEvent.startDate.timeIntervalSince1970,
            endDateTimestamp: tempEvent.endDate.timeIntervalSince1970,
            location: tempEvent.location,
            presetTags: [],
            introduction: tempEvent.description,
            additionalDetail: "",
            refundPolicy: "",
            participants: [:],
            headcount: tempEvent.headcount,
            ownerFcmToken: user.fcmToken
        )
    }
    
    func publishPost(with previewEvent:Event, completion: @escaping (Event) -> Void){
        
        var imagesData = [Data?]()
        
        for img in images {
            guard let image = img?.sd_resizedImage(with: CGSize(width: 1024, height: 1024), scaleMode: .aspectFill),
                  let data = image.jpegData(compressionQuality: 0.5)
            else {break}
            
            imagesData.append(data)
        }
        
//        guard let image = images[0]?.sd_resizedImage(with: CGSize(width: 1024, height: 1024), scaleMode: .aspectFill),
//              let data = image.jpegData(compressionQuality: 0.5)
//        else {return}
        
        StorageManager.shared.uploadEventImage(id: previewEvent.id, data: imagesData) {[weak self] urlStrings in
            
            guard let event = self?.configurePreviewEvent(urlStrings: urlStrings),
                  let _ = DefaultsManager.shared.getCurrentUser()
            else {return}
            
            DatabaseManager.shared.createEvent(with: event) { done in
                completion(event)
            }
        }
    }
}

