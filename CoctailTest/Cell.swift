//
//  Cell.swift
//  CoctailTest
//
//  Created by Виталий on 01.04.2022.
//

import Foundation
import UIKit
import SnapKit
class Cell : UICollectionViewCell{
    
    override var isSelected: Bool {
        didSet {
            let gradient: CAGradientLayer = CAGradientLayer()
            
            gradient.colors = [UIColor.purple.cgColor, UIColor.red.cgColor]
            gradient.locations = [0.0 , 1.0]
            gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
            gradient.frame = CGRect(x: 0.0, y: 0.0, width: contentView.frame.size.width, height: contentView.frame.size.height)
            
            
            if isSelected{
                backgroundColor = .white
                contentView.layer.insertSublayer(gradient, at: 0)
                
            }else {
                contentView.layer.sublayers?.remove(at: 0)
                while contentView.layer.sublayers!.count > 1 {
                    contentView.layer.sublayers?.remove(at: 0)}
                backgroundColor = .gray
            }
            
        }
    }
    
    var textlabel : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let label = UILabel( )
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: contentView.bounds.width, height: contentView.bounds.height))
            make.centerX.equalTo(contentView)
        }
        
    
        
        textlabel = label
        textlabel.textColor = .white
        textlabel.font = UIFont(name: "Helvetica", size: 14)
        contentView.backgroundColor = .gray
        
        textlabel.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
