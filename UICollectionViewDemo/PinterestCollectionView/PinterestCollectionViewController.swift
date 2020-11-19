//
//  PinterestCollectionViewController.swift
//  UICollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/11/17.
//
//  Reference: [UICollectionView Custom Layout Tutorial: Pinterest](https://www.raywenderlich.com/4829472-uicollectionview-custom-layout-tutorial-pinterest)


import UIKit

final class PinterestCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    private let reuseIdentifier = "PinterestCollectionViewCell"
    // 文字通りSectionごとのInset。Cell毎の余白ではないので誤解しないように。
    // [余白を変更する](https://qiita.com/takehilo/items/d0e56f88a42fb8ed1185#%E4%BD%99%E7%99%BD%E3%82%92%E5%A4%89%E6%9B%B4%E3%81%99%E3%82%8B)
    private let sectionInsets =  UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    private var photos = Photo.allPhotos()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    private func configureUI() {
        collectionView.collectionViewLayout = PinterestLayout()
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
                
        view.backgroundColor = .purple
        collectionView.backgroundColor = .darkGray
        collectionView.contentInset = sectionInsets
        collectionView.register(PinterestCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
}

// MARK: - UICollectionViewDataSource

extension PinterestCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! PinterestCollectionViewCell
        cell.photo = photos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
}

// MARK: - PinterestLayoutDelegate

extension PinterestCollectionViewController: PinterestLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return photos[indexPath.item].image.size.height
    }
}
