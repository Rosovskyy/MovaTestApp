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
            pictureImageView.sd_setImage(with: resp.imageURL, placeholderImage: #imageLiteral(resourceName: "no-photo-available"), options: []) { (image, _, _, _) in
                guard let image = image else { return }
                self.pictureImageView.backgroundColor = image.averageColor
            }
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var tagLabel: UILabel!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
