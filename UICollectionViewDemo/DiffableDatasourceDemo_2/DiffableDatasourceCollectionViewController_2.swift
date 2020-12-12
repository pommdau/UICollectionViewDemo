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
        var firstColumnTweets = [Tweet]()
        var secondColumnTweets = [Tweet]()
        
        for (tweet_i, tweet) in tweets.enumerated() {
            if tweet_i % 2 == 0 {
                firstColumnTweets.append(tweet)
            } else {
                secondColumnTweets.append(tweet)
            }
        }
        var arrangedTweets = [Tweet]()  // Column別にレイアウトするために並び替えられたツイート
        arrangedTweets.append(contentsOf: firstColumnTweets)
        arrangedTweets.append(contentsOf: secondColumnTweets)
        self.tweets = arrangedTweets
        
        var firstLayoutItems = [NSCollectionLayoutItem]()
        var firstColumnHeight: CGFloat = 0
        for tweet in firstColumnTweets {
            let viewModel = TweetCellViewModel(tweet: tweet)
            let imageSizes = viewModel.calculateImageSizes(withCellWidth: collectionView.frame.width / 2)
            
            let upperItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(imageSizes.heightOfCell))
            )
            
            firstLayoutItems.append(upperItem)
            firstColumnHeight += imageSizes.heightOfCell
        }
        
        let firstColumnTweetsGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/2),
                heightDimension: .absolute(firstColumnHeight)
            ),
            subitems: firstLayoutItems
        )
        
        var secondLayoutItems = [NSCollectionLayoutItem]()
        var secondColumnHeight: CGFloat = 0
        for tweet in secondColumnTweets {
            let viewModel = TweetCellViewModel(tweet: tweet)
            let imageSizes = viewModel.calculateImageSizes(withCellWidth: collectionView.frame.width / 2)
            
            let upperItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(imageSizes.heightOfCell))
            )
            
            secondLayoutItems.append(upperItem)
            secondColumnHeight += imageSizes.heightOfCell
        }
        
        let secondColumnTweetsGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/2),
                heightDimension: .absolute(secondColumnHeight)
            ),
            subitems: secondLayoutItems
        )
        
        
        let allColumnsTweetsGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(max(firstColumnHeight, secondColumnHeight))
            ),
            subitems: [firstColumnTweetsGroup, secondColumnTweetsGroup]
        )
        
        return allColumnsTweetsGroup
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
