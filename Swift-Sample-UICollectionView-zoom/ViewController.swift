//
//  ViewController.swift
//  Swift-Sample-UICollectionView-zoom
//
//  Created by nobuy on 2020/03/21.
//  Copyright © 2020 A10 Lab Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "sample1.jpg"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    // MARk: - Lifc Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(onTapped(_:)))
        imageView.addGestureRecognizer(gesture)
    }

    // MARK: - Handle Event

    @objc private func onTapped(_ sender: Any?) {
        let vc = FullScreenImagesViewController(images: images)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }

    let images = [
        UIImage(named: "sample1.jpg")!,
        UIImage(named: "sample2.jpg")!,
        UIImage(named: "sample3.jpg")!,
        UIImage(named: "sample4.jpg")!,
        UIImage(named: "sample5.jpg")!,
        UIImage(named: "sample6.jpg")!,
        UIImage(named: "sample7.jpg")!
    ]
}

