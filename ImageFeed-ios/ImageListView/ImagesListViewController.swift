//
//  ViewController.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 07.05.2023.
//

import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    func updateTableViewAnimated(_ oldCount: Int, _ newCount: Int)
    func setIsLiked(_ isLiked: Bool, _ cell: ImagesListCell)
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    var presenter: ImagesListViewPresenterProtocol?
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        presenter?.viewDidLoad()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier,
           let viewController = segue.destination as? SingleImageViewController,
           let indexPath = sender as? IndexPath,
           let singleImageURLString = presenter?.singleImageURLString(indexPath.row) {
            viewController.singleImageURLString = singleImageURLString
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let imagesListServicePhotosCount = presenter?.imagesListServicePhotosCount(),
              let imageSize = presenter?.imagesListServicePhoto(indexPath.row).size,
              indexPath.row < imagesListServicePhotosCount
        else { return 0 }

        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = imageSize.width
        if imageWidth == 0 { return 0 }
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        presenter?.photosCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        imageListCell.delegate = self
        return imageListCell
    }
}

extension ImagesListViewController {
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let photo = presenter?.imagesListServicePhoto(indexPath.row),
              let imageUrl = URL(string: photo.thumbImageURL) else { return }
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.contentMode = .center
        cell.cellImage.backgroundColor = UIColor(named: "YP_White_alfa")
        cell.isUserInteractionEnabled = false
        cell.cellImage.kf.setImage(with: imageUrl,
                                   placeholder: UIImage(named: "stub")) { result in
            switch result {
            case .success:
                cell.cellImage.contentMode = .scaleAspectFill
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                print("Ошибка загрузки картинки: \(error)")
            }
            cell.isUserInteractionEnabled = true
        }

        cell.setupGradient()
        
        if let date = photo.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: date)
        } else {
            cell.dateLabel.text = ""
        }
        
        setIsLiked(photo.isLiked, cell)
    }
    
    func setIsLiked(_ isLiked: Bool, _ cell: ImagesListCell) {
        let buttonState = isLiked ? "like_button_on" : "like_button_off"
        cell.likeButton.setImage(UIImage(named: buttonState), for: .normal)
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        presenter?.needFetchPhotosNextPage(indexPath.row)
    }
    
    func updateTableViewAnimated(_ oldCount: Int, _ newCount: Int) {
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let index = tableView.indexPath(for: cell)?.row else { return }
        UIBlockingProgressHUD.show()
        presenter?.changeLike(index, cell)
        UIBlockingProgressHUD.dismiss()
    }
}

