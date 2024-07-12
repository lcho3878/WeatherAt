//
//  BaseCollectionViewCell.swift
//  WeatherAt
//
//  Created by 이찬호 on 7/12/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell, Reusable, Base {
    
    static var id: String {
        return String(describing: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {}
    
    func configureLayout() {}
    
}

class BaseTableViewCell: UITableViewCell, Reusable {
    
    static var id: String {
        return String(describing: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {}
    
    func configureLayout() {}
    
}
