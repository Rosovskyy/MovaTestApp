//
//  ImageTableViewCell.swift
//  MovaIoTestTask
//
//  Created by Serhii Rosovskyi on 13.04.2020.
//  Copyright © 2020 Serhii Rosovskyi. All rights reserved.
//

import UIKit
import SDWebImage

class ImageTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var imageResponse: ImageResponse? {
        didSet {
            guard let resp = self.imageResponse else { return }
            tagLabel.text = resp.tag
            pictureImageView.backgroundColor = .white
            pictureImageView.sd_setImage(with: resp.imageURL, placeholderImage: #imageLiteral(resourceName: "no-photo-available"), options: [.waitStoreCache]) { (image, _, _, _) in
                guard let image = image else { return }
                self.pictureImageView.backgroundColor = image.averageColor
            }
        }
    }
    
    // MARK: - Views
    let pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let tagLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let tagMainLabel: UILabel = {
        let label = UILabel()
        label.text = "Tag:"
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func setupUI() {
        addSubview(pictureImageView)
        addSubview(tagMainLabel)
        addSubview(tagLabel)
        addSubview(separatorView)
        
        pictureImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(150)
        }
        
        tagMainLabel.snp.makeConstraints {
            $0.leading.equalTo(self.pictureImageView.snp.leading)
            $0.top.equalTo(self.pictureImageView.snp.bottom).offset(8)
        }
        
        tagLabel.snp.makeConstraints {
            $0.top.equalTo(self.tagMainLabel.snp.top)
            $0.leading.equalTo(self.tagMainLabel.snp.trailing).offset(8)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(self.tagMainLabel.snp.bottom).offset(5)
            $0.leading.equalTo(self.pictureImageView.snp.leading)
            $0.trailing.equalTo(self.pictureImageView.snp.trailing)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
