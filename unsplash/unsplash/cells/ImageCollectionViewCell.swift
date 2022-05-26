//
//  ImageCollectionViewCell.swift
//  unsplash
//
//  Created by macOS on 5/26/22.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    // Used to register and dequeue this UICollectionViewCell
    static let identifier = "ImageCollectionViewCell"
    
    // Creat UIImageView by code rather than use Main.storyboard
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    // Init the cell and add it's subViews to it
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    // Prepares a reusable cell for reuse by the collection view's delegate.
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    // Used to FireUp Get Api Call to Unsplash server with an String Query Using URLSession
   func configure(with urlString: String){
    guard let url = URL(string: urlString) else {
        return
    }
   let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
        guard let data = data, error == nil else{
            return
        }
        DispatchQueue.main.async {
            let image = UIImage(data: data)
            self?.imageView.image = image
        }
    }
    task.resume()
  }
}
