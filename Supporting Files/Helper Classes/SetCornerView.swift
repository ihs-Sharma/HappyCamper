//

//  Created by Desh Raj Thakur on 09/03/17.
//  Copyright © 2017 Desh Raj Thakur. All rights reserved.
//

import UIKit

@IBDesignable
class SetCornerView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            setCorner()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            setCorner()
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            setCorner()
        }
    }
    
    func setCorner() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
    }
    
    override open func prepareForInterfaceBuilder() {
        setCorner()
    }
}
