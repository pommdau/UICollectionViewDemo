//
//  DiffableDatasourceCollectionViewController_2.swift
//  UICollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/12/09.
//


import UIKit

final class DiffableDatasourceCollectionViewController_2: UICollectionViewController {
    
    // 今回は1sectionのみ使用する
    enum Section {
      case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Tweet>
    // NSDiffableDataSourceSnapshot: diffable-data-sourceが、
    // 表示するセクションとセルの数の情報を参照するためのクラス
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Tweet>
    
    // MARK: - Properties
    
    private lazy var dataSource = makeDataSource()  // lazy: ViewControllerの初期化後に呼ぶ必要があるため
    private var tweets = Tweet.demoTweets()
    
    // 文字通りSectionごとのInset
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 5.0, bottom: 20.0, right: 5.0)
    private let imageInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
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
//        guard 0 < sections.count else { return }
//
//        sections.remove(at: Int.random(in: 0..<sections.count))
//        applySnapshot()  // collectoinViewの更新を行う
    }
    
    // MARK: - Helpers
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .systemGreen
        collectionView.register(SimpleCollectionViewCell.self,
                                forCellWithReuseIdentifier: SimpleCollectionViewCell.reuseIdentifer)
        collectionView.collectionViewLayout = generateLayout()
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
        snapshot.appendSections([.main])  // セクション情報を伝える
        snapshot.appendItems(tweets)
        // dataSouceに最新のsnapshotのことを伝えて更新する
        dataSource.apply(snapshot, animatingDifferences: animationgDifferences)
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let layoutGroup = tweetLayoutGroup(withTweet: tweets[0])
        
        // NSCollectionLayoutSection: セクションを表すクラス
        // 最終的に作成したNSCollectionLayoutGroupを適用する
        let section = NSCollectionLayoutSection(group: layoutGroup)
        
        // 最終的にレンダリングされる単位になります。
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func tweetLayoutGroup(withTweet tweet: Tweet) -> NSCollectionLayoutGroup {

        // 4枚の画像がある場合
        let uppertItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1/3))  // 最終的なtweetLayoutの高さの1/3
        )
        uppertItem.contentInsets = imageInsets
        
        // 真ん中に2枚を並べる
        let middleItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2),  // 中央に2枚を平行に並べる。middleItemsGroupの高さの1/2
                                             heightDimension: .fractionalHeight(1.0))
        )
        middleItem.contentInsets = imageInsets
        
        let middleItemsGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1/3)),
            subitem: middleItem,
            count: 2)
        
        let bottomItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1/3))  // 1/3
        )
        bottomItem.contentInsets = imageInsets
                                   
        
        // 最終的なグループ
        // class NSCollectionLayoutGroup: NSCollectionLayoutItem
        // widthは幅いっぱいの1.0
        // 写真の高さは2/3で、さらにメインの写真の高さは2/3なので、合計2/3*2/3=4/9の高さにする必要がある
        // →2/3にすると写真は正方形表示になってしまう
        let tweetGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),  // 1:1の正方形に画像を収める
                                             heightDimension: .fractionalWidth(1.0)),
                                             subitems: [uppertItem, middleItemsGroup, bottomItem])
        
        return tweetGroup
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DiffableDatasourceCollectionViewController_2 : UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // such as "collectionView(_:cellForItemAt:)"
        guard let cell = collectionView.cellForItem(at: indexPath) as? SimpleCollectionViewCell,
              let tweet = cell.tweet
              else { return }
        print(
            """
*****
id: \(tweet.id)
text: \(tweet.text)
number of medias: \(tweet.images.count)
""")
    }
}
