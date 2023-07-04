//
//  ViewController.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 07.05.2023.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private (set) var photos: [Photo] = []

//    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        if imagesListService.photos.count == 0 {
            imagesListService.fetchPhotosNextPage()
        }
        
        imagesListServiceObserver = NotificationCenter.default
                    .addObserver(
                        forName: ImagesListService.DidChangeNotification,
                        object: nil,
                        queue: .main
                    ) { [weak self] _ in
                        guard let self else { return }
                        updateTableViewAnimated()
                    }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let singleImageURLString = imagesListService.photos[indexPath.row].largeImageURL
            viewController.singleImageURLString = singleImageURLString
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard indexPath.row < imagesListService.photos.count else { return 0 }
        
        let imageSize = imagesListService.photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = imageSize.width
        if imageWidth == 0 { return 0 }
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        let photo = imagesListService.photos[indexPath.row]
        
        guard let imageUrl = URL(string: photo.thumbImageURL) else { return }
        
        cell.cellImage.kf.indicatorType = .activity
        
        cell.cellImage.contentMode = .center
        cell.cellImage.backgroundColor = UIColor(named: "YP_White_alfa")
        cell.isUserInteractionEnabled = false
        cell.cellImage.kf.setImage(with: imageUrl,
                                   placeholder: UIImage(named: "stub")) { result in
            switch result {
            case .success(_):
                cell.cellImage.contentMode = .scaleAspectFill
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                print("Ошибка загрузки картинки: \(error)")
            }
            cell.isUserInteractionEnabled = true
        }

        cell.setupGradient()
        cell.dateLabel.text = String(dateFormatter.string(from: photo.createdAt).dropLast(3))
        
//        let buttonState = indexPath.row % 2 == 0 ? "like_button_on" : "like_button_off"
        let buttonState = photo.isLiked ? "like_button_on" : "like_button_off"
        cell.likeButton.setImage(UIImage(named: buttonState), for: .normal)
    }
    
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}


