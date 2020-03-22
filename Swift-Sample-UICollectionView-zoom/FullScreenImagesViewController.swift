//
//  FullScreenImagesViewController.swift
//  Swift-Sample-UICollectionView-zoom
//
//  Created by nobuy on 2020/03/21.
//  Copyright © 2020 A10 Lab Inc. All rights reserved.
//

import UIKit

class FullScreenImagesViewController: UIViewController {
    private let collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.sectionInset = .zero
            flowLayout.minimumLineSpacing = 0
            flowLayout.scrollDirection = .horizontal
            return flowLayout
        }()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(FullScreenImageViewCell.self, forCellWithReuseIdentifier: FullScreenImageViewCell.reuseIdentifier)
        return collectionView
    }()
    private let pageCtrl: UIPageControl = {
        let pageCtrl = UIPageControl()
        pageCtrl.currentPage = 0
        pageCtrl.pageIndicatorTintColor = .white
        pageCtrl.currentPageIndicatorTintColor = UIColor.green
        pageCtrl.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        return pageCtrl
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "close"), for: UIControl.State())
        button.addTarget(self, action: #selector(FullScreenImagesViewController.onCloseTapped(_:)), for: .touchUpInside)
        button.contentMode = .center
        return button
    }()

    private let footerView: UIView = {
        let view = UIView()
        return view
    }()

    private let images: [UIImage]
    init(images: [UIImage]) {
        self.images = images
        super.init(nibName: nil, bundle: nil)
        pageCtrl.numberOfPages = images.count
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        initView()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }

    // MARK - Private properties

    private var currentPage: Int {
        let pageWidth = collectionView.bounds.width
        return Int(collectionView.contentOffset.x / pageWidth)
    }

    private var isFooterHidden: Bool = false {
        didSet {
            let nextAlpha: CGFloat = isFooterHidden ? 0.0 : 1.0
            updateFooterAlpha(alpha: nextAlpha)
        }
    }

    // MARK - Private functions

    private func initView() {
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(footerView)
        footerView.addSubview(pageCtrl)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let offset = view.bounds.width / 2.0
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: offset).isActive = true
        footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        pageCtrl.translatesAutoresizingMaskIntoConstraints = false
        pageCtrl.topAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
        pageCtrl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    private func updateFooterAlpha(alpha: CGFloat) {
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveLinear,
                       animations: { [weak self] in
                           self?.footerView.alpha = alpha
                       },
                       completion: nil)
    }

    // MARK: - Event Handlers

    @objc private func onCloseTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate

extension FullScreenImagesViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageCtrl.currentPage = currentPage
        pageCtrl.currentPageIndicatorTintColor = UIColor.green
        isFooterHidden = false
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? FullScreenImageViewCell else {
            return
        }
        cell.reset()
    }
}

// MARK: - UICollectionViewDataSource

extension FullScreenImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FullScreenImageViewCell.reuseIdentifier, for: indexPath) as! FullScreenImageViewCell
        cell.configureCell(with: images[indexPath.item])
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FullScreenImagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: view.bounds.height)
    }
}

// MARK: - FullScreenImageViewCellDelegate

extension FullScreenImagesViewController: FullScreenImageViewCellDelegate {
    func scrollViewDidZoom(_ cell: FullScreenImageViewCell, zoomScale: CGFloat) {
        isFooterHidden = zoomScale != 1.0
    }
}

