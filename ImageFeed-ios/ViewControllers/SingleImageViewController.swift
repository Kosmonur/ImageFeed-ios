//
//  SingleImageViewController.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 14.05.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    var singleImageURLString: String = ""
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.05
        scrollView.maximumZoomScale = 1.25
        
        downloadLargeImage()
        
        let singleTap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(onSingleTap(gestureRecognizer:)))
        singleTap.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(singleTap)
        
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(gestureRecognizer:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        
        singleTap.require(toFail: doubleTap)
        singleTap.delaysTouchesBegan = true
        doubleTap.delaysTouchesBegan = true
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let hScale = scrollView.bounds.width / scrollView.contentSize.width
        let vScale = scrollView.bounds.height / scrollView.contentSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
    
    private func onTapZooming(_ scale: CGFloat, _ gestureRecognizer: UITapGestureRecognizer) {
        if scale != scrollView.zoomScale {
            let point = gestureRecognizer.location(in: imageView)
            let scrollSize = scrollView.frame.size
            let size = CGSize(width: scrollSize.width / scale, height: scrollSize.height / scale)
            let origin = CGPoint(x: point.x - size.width / 2, y: point.y - size.height / 2)
            scrollView.zoom(to:CGRect(origin: origin, size: size), animated: true)
        }
    }
    
    private func downloadLargeImage() {
        guard let imageUrl = URL(string: singleImageURLString) else { return }
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageUrl) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
    }
    
    private func showError() {
        var alertModel = AlertTwoButton.repeatOrNot
        alertModel.completion1Button = {
            self.downloadLargeImage()
        }
        alertModel.completion2Button = {
            self.dismiss(animated: true)
        }
        
        let alertPresenter = AlertPresenter(alertController: self)
        alertPresenter.showAlert(alertModel: alertModel)
    }
    
    @IBAction func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton() {
        let share = UIActivityViewController(
            activityItems: [image as Any],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    @objc func onSingleTap(gestureRecognizer: UITapGestureRecognizer) {
        let scale = max(scrollView.zoomScale * 0.5, scrollView.minimumZoomScale)
        onTapZooming(scale, gestureRecognizer)
    }
    
    @objc func onDoubleTap(gestureRecognizer: UITapGestureRecognizer) {
        let scale = min(scrollView.zoomScale * 2, scrollView.maximumZoomScale)
        onTapZooming(scale, gestureRecognizer)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}


