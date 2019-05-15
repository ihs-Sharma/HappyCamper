//
//  Extensions.swift

//  Created by Desh Raj Thakur on 11/04/17.
//  Copyright © 2017 Desh Raj . All rights reserved.
//

import Foundation
import UIKit

private var kAssociationKeyMaxLength: Int = 0
extension UITextField {
    
    //varinder7
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        
        selectedTextRange = selection
    }
    
    
    var isBlank : Bool {
        return (self.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
    }
    var trimmedValue : String {
        return (self.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
    }
    func rightImage(_ image:UIImage,imgW:Int,imgH:Int)  {
        self.rightViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imgW, height: imgH))
        imageView.image = image
        self.rightView = imageView
    }
    func lefttImage(_ image:UIImage,imgW:Int,imgH:Int)  {
        self.rightViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imgW, height: imgH))
        imageView.image = image
        self.leftView = imageView
    }
    func setPlaceHolderColor(_ txtString: String) {
        self.attributedPlaceholder = NSAttributedString(string: txtString, attributes: [NSAttributedString.Key.foregroundColor : AppInfo.AppColor])
    }
}

extension UITextView {
    var isBlankTextView : Bool {
        return (self.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
    }
}

extension UIView {
    func showAnimations(_ completion: ((Bool) -> Swift.Void)? = nil) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.layoutIfNeeded()
            self.layoutSubviews()
        }, completion: completion)
    }
}


extension UITableView {
    func animate( ) {
        let cells = self.visibleCells
        let tableHeight: CGFloat = self.bounds.size.height
        for i in cells {
            let cell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        var index = 0
        for a in cells {
            let cell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .allowAnimatedContent, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            index += 1
        }
    }
}

extension String {
    var isNumeric: Bool {
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
    
    var isValidName : Bool {
        let emailRegEx = "^[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]+$"
        let range = self.range(of: emailRegEx, options:.regularExpression)
        return range != nil ? true : false
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


@IBDesignable class GradientView: UIView {
    @IBInspectable var firstColor: UIColor = UIColor.white
    @IBInspectable var secondColor: UIColor = UIColor.white.withAlphaComponent(0)
    
    @IBInspectable var vertical: Bool = false
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [firstColor.cgColor, secondColor.cgColor]
        layer.startPoint = CGPoint.zero
        return layer
    }()
    
    //MARK: -
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        applyGradient()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        applyGradient()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
    
    //MARK: -
    
    func applyGradient() {
        updateGradientDirection()
        layer.sublayers = [gradientLayer]
    }
    
    func updateGradientFrame() {
        gradientLayer.frame = bounds
    }
    
    func updateGradientDirection() {
        gradientLayer.endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
    }
}

@IBDesignable class ThreeColorsGradientView: UIView {
    @IBInspectable var firstColor: UIColor = UIColor.red
    @IBInspectable var secondColor: UIColor = UIColor.green
    @IBInspectable var thirdColor: UIColor = UIColor.blue
    
    @IBInspectable var vertical: Bool = true {
        didSet {
            updateGradientDirection()
        }
    }
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor]
        layer.startPoint = CGPoint.zero
        return layer
    }()
    
    //MARK: -
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        applyGradient()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        applyGradient()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
    
    //MARK: -
    
    func applyGradient() {
        updateGradientDirection()
        layer.sublayers = [gradientLayer]
    }
    
    func updateGradientFrame() {
        gradientLayer.frame = bounds
    }
    
    func updateGradientDirection() {
        gradientLayer.endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
    }
}

@IBDesignable class RadialGradientView: UIView {
    
    @IBInspectable var outsideColor: UIColor = UIColor.red
    @IBInspectable var insideColor: UIColor = UIColor.green
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyGradient()
    }
    
    func applyGradient() {
        let colors = [insideColor.cgColor, outsideColor.cgColor] as CFArray
        let endRadius = sqrt(pow(frame.width/2, 2) + pow(frame.height/2, 2))
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil)
        let context = UIGraphicsGetCurrentContext()
        
        context?.drawRadialGradient(gradient!, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: endRadius, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        #if TARGET_INTERFACE_BUILDER
        applyGradient()
        #endif
    }
}

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

//Set Multiplier for any constraint
extension NSLayoutConstraint {
    
    static func setMultiplier(_ multiplier: CGFloat, of constraint: inout NSLayoutConstraint) {
        NSLayoutConstraint.deactivate([constraint])
        
        let newConstraint = NSLayoutConstraint(item: constraint.firstItem!, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: constraint.secondItem, attribute: constraint.secondAttribute, multiplier: multiplier, constant: constraint.constant)
        
        newConstraint.priority = constraint.priority
        newConstraint.shouldBeArchived = constraint.shouldBeArchived
        newConstraint.identifier = constraint.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        constraint = newConstraint
    }
    
}

//MARK:- Models
//* Get ads Data here *//
public struct Advertisement {
    var ad_title:String!
    var type:String!
    var title:String!
    var id:Int!
    var status:String!
    var url: String!
    var banners:String
    init(_adTitle:String,_id:Int,_status:String,_url:String,_title:String,_type:String,_banners:String) {
        ad_title=_adTitle
        type=_type
        title=_title
        id=_id
        status=_status
        url=_url
        banners = _banners
    }
}

//* Get ads Data here *//
public struct AdvertisementModelArray {

    var title:String!
    var url: String!
    var banners:String
    init(_url:String,_title:String,_banners:String) {
        title=_title
        url=_url
        banners = _banners
    }
}

// Get Campfire New and Featured Items
public struct FeaturedItems: Codable {
    var id:String
    var title:String
    var desc:String
    var isFeatured: Bool
    var video_Url:String
    var isLiked:Bool
    var totalViews:Int
    var totalLikes:Int

    init(_id:String,_url:String,_title:String,_isFeatured:Bool,_desc:String,_like:Bool,_views:Int,_likes:Int) {
        id=_id
        title=_title
        desc = _desc
        video_Url=_url
        isFeatured = _isFeatured
        isLiked = _like
        totalViews=_views
        totalLikes=_likes
    }
}


