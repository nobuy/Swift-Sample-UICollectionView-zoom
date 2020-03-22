//
//  FullScreenImageViewCell.swift
//  Swift-Sample-UICollectionView-zoom
//
//  Created by nobuy on 2020/03/21.
//  Copyright © 2020 A10 Lab Inc. All rights reserved.
//

import UIKit

protocol FullScreenImageViewCellDelegate: class {
    func scrollViewDidEndZooming(_ cell: FullScreenImageViewCell, zoomScale: CGFloat)
}

class FullScreenImageViewCell: UICollectionViewCell {
    static let reuseIdentifier = "FullScreenImageViewCell"
    weak var delegate: FullScreenImageViewCellDelegate?

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        scrollView.delegate = self
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0

        contentView.addSubview(scrollView)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        scrollView.addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let size = imageView.image?.size {
            let widthScale = scrollView.frame.width / size.width
            let heightScale = scrollView.frame.height / size.height
            let scale = min(widthScale, heightScale, 1.0)
            imageView.frame.size = CGSize(width: size.width * scale, height: size.height * scale)
            scrollView.contentSize = imageView.frame.size
            updateScrollViewContentInsets()
        }
    }

    // MARK: - Public functions

    func configureCell(with image: UIImage) {
        imageView.image = image
    }

    func reset() {
        scrollView.setZoomScale(1.0, animated: false)
    }

    // MARK: - Private functions

    private func updateScrollViewContentInsets() {
        let topInset = max((scrollView.frame.height - imageView.frame.height) / 2, 0)
        let leftInset = max((scrollView.frame.width - imageView.frame.width) / 2, 0)
        scrollView.contentInset = UIEdgeInsets(top: topInset, left: leftInset, bottom: 0, right: 0)
    }
}

// MARK: - UIScrollViewDelegate

extension FullScreenImageViewCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateScrollViewContentInsets()
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        updateScrollViewContentInsets()
        delegate?.scrollViewDidEndZooming(self, zoomScale: scale)
    }
}
