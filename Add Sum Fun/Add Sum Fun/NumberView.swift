//
//  NumberCollectionViewCell.swift
//  Add Sum Fun
//
//  Created by SFurlani on 8/26/15.
//  Copyright © 2015 Dig-It! Games. All rights reserved.
//

import UIKit

class NumberView: UIView {
    
    class func newWithNumber(number: Int?) -> NumberView? {
        let nib = UINib(nibName: "NumberView", bundle: nil)
        
        let views = nib.instantiateWithOwner(nil, options: nil)
        
        guard views.count > 0 else {
            return nil
        }
        
        guard let numberView = views[0] as? NumberView else {
            return nil
        }

        numberView.number = number
        return numberView
    }
    
    @IBOutlet var label: UILabel! {
        didSet {
            update()
        }
    }
    
    @IBInspectable var number: Int? {
        didSet {
            update()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 8.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.blackColor().CGColor
    }
    
    private func update() {
        guard let label = label else {
            
            return
        }
        
        if let number = number {
            backgroundColor = UIColor.whiteColor()
            label.text = "\(number)"
        }
        else {
            backgroundColor = UIColor(white: 0.9, alpha: 1.0)
            label.text = nil
        }
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.font = label.font.fontWithSize(bounds.height)
    }
}
