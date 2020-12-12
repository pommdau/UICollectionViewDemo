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
    
    private let imageInsetsConstant: CGFloat = 2
    private lazy var imageInsets = NSDirectionalEdgeInsets(top: imageInsetsConstant, leading: imageInsetsConstant,
                                                      bottom: imageInsetsConstant, trailing: imageInsetsConstant)
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
        collectionView.register(TweetCell.self,
                                forCellWithReuseIdentifier: TweetCell.reuseIdentifer)
        collectionView.collectionViewLayout = generateLayout()
    }
    
    func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(handleRandomDeletion))
    }
    
    func makeDataSource() -> DataSource {
      let dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, tweet) -> UICollectionViewCell? in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.reuseIdentifer,
                                                      for: indexPath) as? TweetCell
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
        let layoutGroup = tweetsLayoutGroup(withTweets: tweets)
        
        // NSCollectionLayoutSection: セクションを表すクラス
        // 最終的に作成したNSCollectionLayoutGroupを適用する
        let section = NSCollectionLayoutSection(group: layoutGroup)
        
        // 最終的にレンダリングされる単位になります。
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func tweetsLayoutGroup(withTweets tweets: [Tweet]) -> NSCollectionLayoutGroup {
        
        var layoutItems = [NSCollectionLayoutItem]()
        var columnHeight: CGFloat = 0.0
        
        tweets.forEach { tweet in
            let viewModel = TweetCellViewModel(tweet: tweet)
            let imageSizes = viewModel.calculateImageSizes(withCellWidth: collectionView.frame.width)
            
            let upperItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(imageSizes.heightOfCell))
            )
            
            layoutItems.append(upperItem)
            columnHeight += imageSizes.heightOfCell
        }
    
        let tweetGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(columnHeight)
            ),
            subitems: layoutItems
        )
        
        return tweetGroup
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DiffableDatasourceCollectionViewController_2 : UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // such as "collectionView(_:cellForItemAt:)"
        guard let cell = collectionView.cellForItem(at: indexPath) as? TweetCell,
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
