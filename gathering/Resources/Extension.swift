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
    
    func flexibleAnchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero){
        translatesAutoresizingMaskIntoConstraints = false
        
        
        if let top = top {
            let topConstraint = topAnchor.constraint(equalTo: top, constant: padding.top)
            topConstraint.priority = .defaultHigh
            topConstraint.isActive = true
        }
        
        if let leading = leading {
            let leadingConstraint = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
            leadingConstraint.priority = .defaultHigh
            leadingConstraint.isActive = true
        }
        
        if let bottom = bottom {
            let bottomConstraint = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
            bottomConstraint.priority = .defaultHigh
            bottomConstraint.isActive = true
        }
        
        if let trailing = trailing {
            let trailConstraint = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
            trailConstraint.priority = .defaultHigh
            trailConstraint.isActive = true
        }
        
        if size.width != 0 {
            let widthConstrant = widthAnchor.constraint(equalToConstant: size.width)
            widthConstrant.priority = .defaultHigh
            widthConstrant.isActive = true
        }
        
        if size.height != 0 {
            let heightConstrant = heightAnchor.constraint(equalToConstant: size.height)
            heightConstrant.priority = .defaultHigh
            heightConstrant.isActive = true
        }
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
    
    static func localeDate(from date:String,_ identifier: LocaleIdentifier) -> (date:String?,dayOfWeek:String?,time:String?) {
        
        let formatter = DateFormatter.formatter
        guard let date = formatter.date(from: date) else {return (nil,nil,nil)}
        
        let fullDateString = localeDate(from: date, identifier)
        
        return (fullDateString.date,fullDateString.dayOfWeek,fullDateString.time)
    }
    
    static func localeDate(from date:Date,_ identifier: LocaleIdentifier) -> (date:String?,dayOfWeek:String?,time:String?) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: identifier.rawValue)

        // Date
        dateFormatter.dateFormat = "d MMM"
        let dateString = dateFormatter.string(from: date)

        // Day of the week
        dateFormatter.dateFormat = "EEEE"
        let dayString = dateFormatter.string(from: date)

        // Time
        dateFormatter.dateFormat = "HH:mm a"
        let timeString = dateFormatter.string(from: date)
        
        return (dateString,dayString,timeString)
    }
    
    
}

extension Double {
    static func todayAtMidnightTimestamp() -> Double {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd 00:00:00"
        let dateString = dateFormatter.string(from: Date())
        let todayAtMidnight = dateFormatter.date(from: dateString)
        
        return todayAtMidnight!.timeIntervalSince1970
    }
}


enum LocaleIdentifier: String {
    case enUS = "en_US"
    case esES = "es_ES"
    case frFR = "fr_FR"
    case deDE = "de_DE"
    case jaJP = "ja_JP"
    case zhHansCN = "zh_Hans_CN"
    case zhHantTW = "zh_Hant_TW"
    case arAE = "ar_AE"
    case ruRU = "ru_RU"
    case hiIN = "hi_IN"
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
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(
            red: r / 255,
            green: g / 255,
            blue: b / 255,
            alpha: 1
        )
    }

    convenience init(red: Int, green: Int, blue: Int) {
        self.init(
            r: CGFloat(red),
            g: CGFloat(green),
            b: CGFloat(blue)
        )
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xff,
            green: (rgb >> 8) & 0xff,
            blue: rgb & 0xff
        )
    }
    
    static let mainColor = UIColor(named: "mainColor")
    static let redColor = UIColor(named: "redColor")
    static let blueColor = UIColor(named: "blueColor")
    static let blackBackground = UIColor(named: "blackBackground")
}

extension UIColor {
    /// This is color palette used by design team.
    /// If you see any color not from this list in figma, point it out to anyone in design team.
    static let streamBlack = mode(0x000000, 0xffffff)
    static let streamGray = mode(0x7a7a7a, 0x7a7a7a)
    static let streamGrayGainsboro = mode(0xdbdbdb, 0x2d2f2f)
    static let streamGrayWhisper = mode(0xecebeb, 0x1c1e22)
    static let streamDarkGray = mode(0x7a7a7a, 0x7a7a7a)
    static let streamWhiteSmoke = mode(0xf2f2f2, 0x13151b)
    static let streamWhiteSnow = mode(0xfcfcfc, 0x070a0d)
    static let streamOverlayLight = mode(0xfcfcfc, lightAlpha: 0.9, 0x070a0d, darkAlpha: 0.9)
    static let streamWhite = mode(0xffffff, 0x101418)
    static let streamBlueAlice = mode(0xe9f2ff, 0x00193d)
    static let streamAccentBlue = mode(0x005fff, 0x005fff)
    static let streamAccentRed = mode(0xff3742, 0xff3742)
    static let streamAccentGreen = mode(0x20e070, 0x20e070)
    static let streamGrayDisabledText = mode(0x72767e, 0x72767e)
    
    // Currently we are not using the correct shadow color from figma's color palette. This is to avoid
    // an issue with snapshots inconsistency between Intel vs M1. We can't use shadows with transparency.
    // So we apply a light gray color to fake the transparency.
    static let streamModalShadow = mode(0xd6d6d6, lightAlpha: 1, 0, darkAlpha: 1)

    static let streamWhiteStatic = mode(0xffffff, 0xffffff)

    static let streamBGGradientFrom = mode(0xf7f7f7, 0x101214)
    static let streamBGGradientTo = mode(0xfcfcfc, 0x070a0d)
    static let streamOverlay = mode(0x000000, lightAlpha: 0.2, 0x000000, darkAlpha: 0.4)
    static let streamOverlayDark = mode(0x000000, lightAlpha: 0.6, 0xffffff, darkAlpha: 0.8)
    static let streamOverlayDarkStatic = mode(0x000000, lightAlpha: 0.6, 0x000000, darkAlpha: 0.6)

    static func mode(_ light: Int, lightAlpha: CGFloat = 1.0, _ dark: Int, darkAlpha: CGFloat = 1.0) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark
                    ? UIColor(rgb: dark).withAlphaComponent(darkAlpha)
                    : UIColor(rgb: light).withAlphaComponent(lightAlpha)
            }
        } else {
            return UIColor(rgb: light).withAlphaComponent(lightAlpha)
        }
    }
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
