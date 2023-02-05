//
//  Extension.swift
//  Instagram
//
//  Created by Jason Chau on 2023-01-02.
//

import Foundation
import UIKit

extension UIView {
    var top: CGFloat {
        frame.origin.y
    }
    var bottom: CGFloat {
        frame.origin.y + height
    }
    var left: CGFloat  {
        frame.origin.x
    }
    var right: CGFloat  {
        frame.origin.x + width
    }
    var width: CGFloat {
        frame.size.width
    }
    var height: CGFloat {
        frame.size.height
    }
    
    
    func fillSuperview() {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
    
    func anchorSize(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero){
        translatesAutoresizingMaskIntoConstraints = false
        
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            let heightConstrant = heightAnchor.constraint(equalToConstant: size.height)
            heightConstrant.priority = .defaultHigh
            heightConstrant.isActive = true
        }
    }
    
    func setAnchors(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            let anchor = topAnchor.constraint(equalTo: top, constant: padding.top)
            anchors.append(anchor)
        }
        
        if let leading = leading {
            let anchor = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
            anchors.append(anchor)
        }
        
        if let bottom = bottom {
            let anchor = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
            anchors.append(anchor)
        }
        
        if let trailing = trailing {
            let anchor = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
            anchors.append(anchor)
        }
        
        if size.width != 0 {
            let anchor = widthAnchor.constraint(equalToConstant: size.width)
            anchors.append(anchor)
        }
        
        if size.height != 0 {
            let anchor = heightAnchor.constraint(equalToConstant: size.height)
            anchors.append(anchor)
        }
        
        return anchors
    }
}


extension Decodable {
    ///Change Dictionary to a decodable Data type
    init?(with dictionary: [String:Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) else {return nil}
        
        guard let result = try? JSONDecoder().decode(Self.self, from: data) else {return nil}
        
        self = result
    }
}


extension Encodable {
    func asDictionary() -> [String:Any]? {
        guard let data = try? JSONEncoder().encode(self) else {return nil}
        let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
        
        return json
    }
}

extension DateFormatter {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

extension String {
    static func date(from date: Date) -> String? {
        let formatter = DateFormatter.formatter
        let string = formatter.string(from: date)
        return string
    }
}

extension Notification.Name {
    static let didPostNotification = Notification.Name("didPostNotification")
}


extension RangeReplaceableCollection where Element: Equatable {
    @discardableResult
    mutating func appendIfNotContains(_ element: Element) -> (appended: Bool, memberAfterAppend: Element) {
        if let index = firstIndex(of: element) {
            return (false, self[index])
        } else {
            append(element)
            return (true, element)
        }
    }
}

extension UIColor {
    convenience init(rgb: UInt) {
       self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgb & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
    }
    
    static let mainColor = UIColor(named: "mainColor")
    static let redColor = UIColor(named: "redColor")
    static let blueColor = UIColor(named: "blueColor")
    static let blackBackground = UIColor(named: "blackBackground")
}
extension UIImage {
    static let personIcon = UIImage(systemName: "person.circle")
}

extension UILabel {
    /// count lines that get drawn
    func countLines() -> Int {
        guard let myText = self.text as NSString? else {
            return 0
        }
        // Call self.layoutIfNeeded() if your view uses auto layout
        let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font as Any], context: nil)
        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }
}

extension UITableViewCell {
  func separator(hide: Bool) {
    separatorInset.left = hide ? bounds.size.width : 0
  }
}



#if DEBUG
import SwiftUI

@available(iOS 13, *)
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        // this variable is used for injecting the current view controller
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }

    func toPreview() -> some View {
        // inject self (the current view controller) for the preview
        Preview(viewController: self)
    }
}
#endif
