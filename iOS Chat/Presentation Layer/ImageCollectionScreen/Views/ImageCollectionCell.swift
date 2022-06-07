//
//  InternetImageCell.swift
//  iOS Chat
//
//  Created by Macbook on 24.04.2022.
//

import UIKit

final class ImageCollectionCell: UICollectionViewCell {
    static let identifier = "InternetImageCell"
    
    private let imageView: InternetImageView = {
        let image = UIImage(systemName: "photo")
        let imageView = InternetImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(imageLink: String) {
        imageView.setImageFromInternet(imageLink: imageLink)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(systemName: "photo")
    }
    
}

// MARK: - Constraints

extension ImageCollectionCell {
    private func setupConstraint() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
