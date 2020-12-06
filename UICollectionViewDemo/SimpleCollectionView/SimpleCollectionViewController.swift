//
//  SimpleCollectionViewController.swift
//  UICollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/11/12.
//
// Reference: https://www.raywenderlich.com/9334-uicollectionview-tutorial-getting-started

import UIKit

final class SimpleCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    // 文字通りSectionごとのInset。Cell毎の余白ではないので誤解しないように。
    // [余白を変更する](https://qiita.com/takehilo/items/d0e56f88a42fb8ed1185#%E4%BD%99%E7%99%BD%E3%82%92%E5%A4%89%E6%9B%B4%E3%81%99%E3%82%8B)
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private var tweets = Tweet.demoTweets()
    private let itemsPerRow: CGFloat = 4
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .purple  // CollectionViewにより見えない
        collectionView.backgroundColor = .darkGray
        collectionView.register(SimpleCollectionViewCell.self,
                                forCellWithReuseIdentifier: SimpleCollectionViewCell.reuseIdentifer)
    }
    
}

// MARK: - UICollectionViewDataSource

extension SimpleCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SimpleCollectionViewCell.reuseIdentifer,
            for: indexPath) as! SimpleCollectionViewCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SimpleCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    // セルのサイズを指定する
    // 結果としてセル毎の間隔を規定していることになる
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // Rowの間隔
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SimpleCollectionViewCell,
              let tweet = cell.tweet
              else { return }
        print(
            """
*****
id: \(tweet.id)
user: \(tweet.userName)
text: \(tweet.text)
number of medias: \(tweet.images.count)
""")
    }
}
