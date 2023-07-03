//
//  ImagesListCell.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 08.05.2023.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    private var gradientNotAdded = true
    
    func setupGradient() {
        guard gradientNotAdded else {
            return
        }
        let gradient = CAGradientLayer()
        let colorTop = UIColor(named: "gradientTop")?.cgColor ?? UIColor.clear.cgColor
        let colorBottom = UIColor(named: "gradientBottom")?.cgColor ?? UIColor.clear.cgColor
        gradient.colors = [colorTop, colorBottom]
        gradient.locations = [0, 1]
        gradient.frame = CGRect(
            x: 0,
            y: 0,
            width: bounds.size.width,
            height: gradientView.frame.height)
        gradientView.layer.addSublayer(gradient)
        gradientNotAdded = false
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
        
            cellImage.kf.cancelDownloadTask()
        }
}
