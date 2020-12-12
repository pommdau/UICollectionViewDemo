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
    private let itemsPerRow = 5
    
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
        let columns = calculateAndArrangeTweets(tweets: tweets)
        // データの更新
        var arrangedTweets = [Tweet]()
        columns.forEach { column in
            arrangedTweets.append(contentsOf: column.tweets)
        }
        self.tweets = arrangedTweets
        
        // DEBUG
        for tweet in self.tweets {
            print("DEBUG: 🐱\(tweet.id)")
        }
        
        var columnLayoutGroups = [NSCollectionLayoutGroup]()
        for column in columns {
            var layoutItems = [NSCollectionLayoutItem]()
            for (tweet_i, _) in column.tweets.enumerated() {
                let upperItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(column.tweetcellImageSizes[tweet_i].heightOfCell))
                )
                
                layoutItems.append(upperItem)
            }
            
            let columnLayoutGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/CGFloat(itemsPerRow)),
                    heightDimension: .absolute(column.columnHeight)
                ),
                subitems: layoutItems
            )
            
            columnLayoutGroups.append(columnLayoutGroup)
        }
        
        
        var maxColumnHeight: CGFloat = 0
        columns.forEach { column in
            if maxColumnHeight < column.columnHeight {
                maxColumnHeight = column.columnHeight
            }
        }
        
        let allColumnsTweetsGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(maxColumnHeight)
            ),
            subitems: columnLayoutGroups
        )
        
        return allColumnsTweetsGroup
    }
    
    // カラム別にツイートを分割する
    private func calculateAndArrangeTweets(tweets: [Tweet]) -> [TweetsColumn] {
        var tweetsColumnList = [TweetsColumn]()
        for _ in 0..<itemsPerRow {
            tweetsColumnList.append(TweetsColumn())
        }
        
        var viewModels = [TweetCellViewModel]()
        for tweet in tweets {
            viewModels.append(TweetCellViewModel(tweet: tweet))
        }
        
        for (viewModel_i, viewModel) in viewModels.enumerated() {
            var minimumHeight = CGFloat.greatestFiniteMagnitude
            var minimumColumnIndex = 0
            for (column_i, tweetColumn) in tweetsColumnList.enumerated() {
                // 現在最も低い高さのカラムを探す
                if tweetColumn.columnHeight < minimumHeight {
                    minimumHeight = tweetColumn.columnHeight
                    minimumColumnIndex = column_i
                }
            }
            
            let cellSize = viewModel.calculateImageSizes(withCellWidth: collectionView.frame.width / CGFloat(itemsPerRow))
            tweetsColumnList[minimumColumnIndex].columnHeight += cellSize.heightOfCell
            tweetsColumnList[minimumColumnIndex].tweetcellImageSizes.append(cellSize)
            tweetsColumnList[minimumColumnIndex].tweets.append(tweets[viewModel_i])
            tweetsColumnList[minimumColumnIndex].viewModels.append(viewModel)
        }
        
        return tweetsColumnList
    }
}

struct TweetsColumn {
    var tweets = [Tweet]()
    var viewModels = [TweetCellViewModel]()
    var tweetcellImageSizes = [TweetCellImageSizes]()
    var columnHeight: CGFloat = 0.0
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
