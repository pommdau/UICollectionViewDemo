//
//  DiffableDatasourceCollectionViewController.swift
//  UICollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/12/06.
//
//  Reference: [iOS Tutorial: Collection View and Diffable Data Source](https://www.raywenderlich.com/8241072-ios-tutorial-collection-view-and-diffable-data-source)


import UIKit

final class DiffableDatasourceCollectionViewController: UICollectionViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<User, Tweet>
    // NSDiffableDataSourceSnapshot: diffable-data-sourceが、
    // 表示するセクションとセルの数の情報を参照するためのクラス
    typealias Snapshot = NSDiffableDataSourceSnapshot<User, Tweet>
    
    // MARK: - Properties
    
    private lazy var dataSource = makeDataSource()  // lazy: ViewControllerの初期化後に呼ぶ必要があるため
    private var sections = User.allUsers
    
    // 文字通りSectionごとのInset
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 5.0, bottom: 20.0, right: 5.0)
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
        guard 0 < sections.count else { return }
        
        sections.remove(at: Int.random(in: 0..<sections.count))
        applySnapshot()  // collectoinViewの更新を行う
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
        snapshot.appendSections(sections)  // セクション情報を伝える
        sections.forEach{ section in
            snapshot.appendItems(section.tweets, toSection: section)
        }
        // dataSouceに最新のsnapshotのことを伝えて更新する
        dataSource.apply(snapshot, animatingDifferences: animationgDifferences)
    }
    
    func generateLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { [self] (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            var numberOfTweets = self.sections[sectionIndex].tweets.count
            if numberOfTweets == 0 { numberOfTweets += 1 }
            let columns = numberOfTweets
            
            
            
            
            
            let section = NSCollectionLayoutSection(group: myCollectionLayoutGroup())
            
//            // The `group` auto-calculates the actual item width to make
//            // the requested number of `columns` fit, so this `widthDimension` will be ignored.
//            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                  heightDimension: .fractionalHeight(1.0))
//            let item = NSCollectionLayoutItem(layoutSize: itemSize)
//            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
//
//            let groupHeight = columns == 1 ?
//                NSCollectionLayoutDimension.fractionalWidth(1.0) :
//                NSCollectionLayoutDimension.fractionalWidth(0.2)
//            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                   heightDimension: groupHeight)
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
//                                                           subitem: item,
//                                                           count: columns)
//            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            return section
        }
        return layout
    }
    
    func myCollectionLayoutGroup() -> NSCollectionLayoutGroup {
        // 4枚の写真を並べる場合の例
        let mainItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1/3))  // 1/3
        )
        mainItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        // メイン写真の後続に、縦に2枚の写真を重ねたものを配置する
        let middleItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2),  // 中央に2枚を平行に並べる
                                             heightDimension: .fractionalHeight(1.0))
        )
        middleItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let trailingGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1/3)),
            subitem: middleItem,
            count: 2)
        
        // 最終的なグループ
        // class NSCollectionLayoutGroup: NSCollectionLayoutItem
        // widthは幅いっぱいの1.0
        // 写真の高さは2/3で、さらにメインの写真の高さは2/3なので、合計2/3*2/3=4/9の高さにする必要がある
        // →2/3にすると写真は正方形表示になってしまう
        let mainWithPairGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),  // 1:1の正方形に画像を収める
                                             heightDimension: .fractionalWidth(1.0)),
                                             subitems: [mainItem, trailingGroup, mainItem])
        
        return mainWithPairGroup
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DiffableDatasourceCollectionViewController : UICollectionViewDelegateFlowLayout {
    
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
