//
//  TranslucentView.swift
//  WeatherAt
//
//  Created by 이찬호 on 7/15/24.
//

import UIKit
import SnapKit

final class TranslucentView: UIView {
    
    let contentImageView = {
        let view = UIImageView()
        return view
    }()
    
    let contentTitle = {
        let view = UILabel()
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 16)
        return view
    }()
    
    let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init (title: String? = nil, image: UIImage? = nil, contentView: UIView? = nil, color: UIColor? = nil) {
        self.init()
        self.contentTitle.text = title
        self.contentImageView.image = image
        self.changeContentView(contentView)
        guard let color else { return }
        self.contentTitle.textColor = color
        self.contentImageView.image = image?.withTintColor(color, renderingMode: .alwaysOriginal)
    }
    
    private func configureView() {
        backgroundColor = .clear.withAlphaComponent(0.1)
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.2
        layer.cornerRadius = 8
    }
    
    private func configureHierarchy() {
        addSubview(contentImageView)
        addSubview(contentTitle)
        addSubview(contentView)
    }
    
    private func configureLayout() {
        contentImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.leading.equalTo(self).offset(16)
            $0.top.equalTo(self).offset(8)
        }
        
        contentTitle.snp.makeConstraints {
            $0.leading.equalTo(contentImageView.snp.trailing).offset(4)
            $0.trailing.equalTo(self).inset(4)
            $0.centerY.equalTo(contentImageView)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(contentImageView.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(self).inset(16)
            $0.bottom.equalTo(self).inset(8)
        }
    }
    
    func changeContentView(_ view: UIView?) {
        guard let view else { return }
        contentView.addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }
    
}
