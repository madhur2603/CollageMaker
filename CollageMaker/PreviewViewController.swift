//
//  PreviewViewController.swift
//  CollageMaker
//
//  Created by Madhu on 04/02/24.
//

import UIKit

class PreviewViewController: UIViewController {

    var previewImage: UIImage?
    let collageView = UIView()
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        collageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collageView)
        
        NSLayoutConstraint.activate([
            collageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 50),
            collageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            collageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            collageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50)
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = previewImage
        collageView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: collageView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: collageView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: collageView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: collageView.trailingAnchor)
        ])
    }
}
