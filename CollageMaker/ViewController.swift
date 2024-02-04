//
//  ViewController.swift
//  CollageMaker
//
//  Created by Madhu on 04/02/24.
//

import UIKit
import PhotosUI
import AVFoundation

class ViewController: UIViewController {

    let collageView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 3
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
        
        collageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collageView)
        
        NSLayoutConstraint.activate([
            collageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
            collageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            collageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
        
        self.navigationItem.title = "Preview"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(exportCollage))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
    }
    
    @objc func exportCollage() {
        UIGraphicsBeginImageContextWithOptions(collageView.bounds.size, false, UIScreen.main.scale)
           collageView.layer.render(in: UIGraphicsGetCurrentContext()!)
           guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
           UIGraphicsEndImageContext()
        
        let vc = PreviewViewController()
        vc.previewImage = image
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func selectedImages(images: [UIImage]?) {
        guard let images = images, images.count > 0 else { return }
        hostTopAndBottomPhotos(withImages: images)
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    private func hostTopAndBottomPhotos(withImages images: [UIImage]) {
        guard images.count >= 3 else { return }
        
        let topPhotoView = UIImageView()
        topPhotoView.image = images[0]
        topPhotoView.contentMode = .scaleAspectFill
        topPhotoView.translatesAutoresizingMaskIntoConstraints = false
        collageView.addSubview(topPhotoView)

        let centerPhotoView = UIImageView()
        centerPhotoView.image = images[1]
        centerPhotoView.contentMode = .scaleAspectFill
        centerPhotoView.translatesAutoresizingMaskIntoConstraints = false
        collageView.addSubview(centerPhotoView)

        let bottomPhotoView = UIImageView()
        bottomPhotoView.image = images[2]
        bottomPhotoView.contentMode = .scaleAspectFill
        bottomPhotoView.translatesAutoresizingMaskIntoConstraints = false
        collageView.addSubview(bottomPhotoView)

        // Set up constraints for topPhotoView
        NSLayoutConstraint.activate([
            topPhotoView.topAnchor.constraint(equalTo: collageView.topAnchor),
            topPhotoView.leadingAnchor.constraint(equalTo: collageView.leadingAnchor),
            topPhotoView.trailingAnchor.constraint(equalTo: collageView.trailingAnchor),
            topPhotoView.heightAnchor.constraint(equalTo: collageView.heightAnchor, multiplier: 1/3) // Set to cover the top third
        ])

        // Set up constraints for centerPhotoView
        NSLayoutConstraint.activate([
            centerPhotoView.topAnchor.constraint(equalTo: topPhotoView.bottomAnchor, constant: 1),
            centerPhotoView.leadingAnchor.constraint(equalTo: collageView.leadingAnchor),
            centerPhotoView.trailingAnchor.constraint(equalTo: collageView.trailingAnchor),
            centerPhotoView.heightAnchor.constraint(equalTo: collageView.heightAnchor, multiplier: 1/3) // Set to cover the middle third
        ])

        // Set up constraints for bottomPhotoView
        NSLayoutConstraint.activate([
            bottomPhotoView.topAnchor.constraint(equalTo: centerPhotoView.bottomAnchor, constant: 1),
            bottomPhotoView.leadingAnchor.constraint(equalTo: collageView.leadingAnchor),
            bottomPhotoView.trailingAnchor.constraint(equalTo: collageView.trailingAnchor),
            bottomPhotoView.bottomAnchor.constraint(equalTo: collageView.bottomAnchor)
        ])

        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
}

extension ViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        if results.isEmpty {
            picker.dismiss(animated: true)
            return
        }
        
        let imageItems = results
            .map { $0.itemProvider }
            .filter { $0.canLoadObject(ofClass: UIImage.self) }
        
        if imageItems.count == 3 {
            picker.dismiss(animated: true) // dismiss a picker
            
            let dispatchGroup = DispatchGroup()
            var images = [UIImage]()
            
            for imageItem in imageItems {
                dispatchGroup.enter()
                
                imageItem.loadObject(ofClass: UIImage.self) { image, _ in
                    if let image = image as? UIImage {
                        images.append(image)
                    }
                    dispatchGroup.leave()
                }
            }
            
            // This is called at the end; after all signals are matched (IN/OUT)
            dispatchGroup.notify(queue: .main) {
                self.selectedImages(images: images)
            }
        }
    }
}

