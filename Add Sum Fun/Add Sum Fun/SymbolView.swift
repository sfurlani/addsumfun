//
//  SymbolView.swift
//  Add Sum Fun
//
//  Created by SFurlani on 8/26/15.
//  Copyright © 2015 Dig-It! Games. All rights reserved.
//

import UIKit

class SymbolView: UIView {

    class func newWithSymbol(symbol: String?) -> SymbolView? {
        let nib = UINib(nibName: "SymbolView", bundle: nil)
        
        let views = nib.instantiateWithOwner(nil, options: nil)
        
        guard views.count > 0 else {
            return nil
        }
        
        guard let symbolView = views[0] as? SymbolView else {
            return nil
        }
        
        symbolView.symbol = symbol
        return symbolView
    }
    
    @IBOutlet var label: UILabel! {
        didSet {
            update()
        }
    }
    
    @IBInspectable var symbol: String? {
        didSet {
            update()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func update() {
        guard let label = label else {
            
            return
        }
        
        if let symbol = symbol where symbol.characters.count > 0 {
            label.text = symbol
        }
        else {
            label.text = nil
        }
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.font = label.font.fontWithSize(bounds.height)
    }

}
