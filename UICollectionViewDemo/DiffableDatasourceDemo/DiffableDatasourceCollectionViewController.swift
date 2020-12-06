//
//  DiffableDatasourceCollectionViewController.swift
//  UICollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/12/06.
//
//  Reference: [iOS Tutorial: Collection View and Diffable Data Source](https://www.raywenderlich.com/8241072-ios-tutorial-collection-view-and-diffable-data-source)


import UIKit

final class DiffableDatasourceCollectionViewController: UICollectionViewController {
    
    enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Tweet>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Tweet>
    
    // MARK: - Properties
    
    private lazy var dataSource = makeDataSource()
    private var tweets = Tweet.demoTweets()
    
    // 文字通りSectionごとのInset
    private let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    private let itemsPerRow: CGFloat = 5
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple  // CollectionViewにより見えない
        
        configureCollectionView()
        configureNavigationBar()
        applySnapshot(animationgDifferences: false)
    }
    
    // MARK: - Selectors
    
    @objc func handleRandomDeletion() {
        guard 0 < tweets.count else { return }
        
        tweets.remove(at: Int.random(in: 0..<tweets.count))
        applySnapshot()
    }
    
    // MARK: - Helpers
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .darkGray
        collectionView.register(SimpleCollectionViewCell.self,
                                forCellWithReuseIdentifier: SimpleCollectionViewCell.reuseIdentifer)
    }
    
    func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(handleRandomDeletion))
    }
    
    func makeDataSource() -> DataSource {
      let dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, tweet) -> UICollectionViewCell? in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimpleCollectionViewCell.reuseIdentifer,
                                                      for: indexPath) as? SimpleCollectionViewCell
        cell?.tweet = tweet
        return cell
      })
      
      return dataSource
    }
    
    func applySnapshot(animationgDifferences: Bool = true) {
      var snapshot = Snapshot()
      snapshot.appendSections([.main])
      snapshot.appendItems(tweets)
      dataSource.apply(snapshot, animatingDifferences: animationgDifferences)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DiffableDatasourceCollectionViewController : UICollectionViewDelegateFlowLayout {
    
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
