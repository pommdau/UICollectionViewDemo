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
        let layoutGroup = tweetLayoutGroup(withTweet: tweets[0])
        
        // NSCollectionLayoutSection: セクションを表すクラス
        // 最終的に作成したNSCollectionLayoutGroupを適用する
        let section = NSCollectionLayoutSection(group: layoutGroup)
        
        // 最終的にレンダリングされる単位になります。
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func tweetLayoutGroup(withTweet tweet: Tweet) -> NSCollectionLayoutGroup {
        
        var imageSizes = [CGSize]()
        imageSizes.append(calculateImageSize(withImage: tweet.images[0]))
        calculateTwoImageSizes(withImages: [tweet.images[1], tweet.images[2]]).forEach { imageSizes.append($0) }
        imageSizes.append(calculateImageSize(withImage: tweet.images[3]))
        
        // 4枚の画像がある場合
        let uppertItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(imageSizes[0].height))  // 最終的なtweetLayoutの高さの1/3
        )
        uppertItem.contentInsets = imageInsets
        
        // 真ん中に2枚を並べる
        let middleItem_01 = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(imageSizes[1].width),  // 中央に2枚を平行に並べる。middleItemsGroupの高さの1/2
                                               heightDimension: .absolute(imageSizes[1].height))
        )
        middleItem_01.contentInsets = imageInsets
        
        let middleItem_02 = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(imageSizes[2].width),
                                             heightDimension: .absolute(imageSizes[2].height))
        )
        middleItem_02.contentInsets = imageInsets
        
        let middleItemsGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(imageSizes[1].height)
            ),
            subitems: [middleItem_01, middleItem_02]
        )
        
        let bottomItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(imageSizes[3].height)
            )
        )
        bottomItem.contentInsets = imageInsets
                                   
        
        // 最終的なグループ
        // class NSCollectionLayoutGroup: NSCollectionLayoutItem
        // widthは幅いっぱいの1.0
        // 写真の高さは2/3で、さらにメインの写真の高さは2/3なので、合計2/3*2/3=4/9の高さにする必要がある
        // →2/3にすると写真は正方形表示になってしまう
        var totalHeight: CGFloat = 0
        totalHeight += imageSizes[0].height
        totalHeight += imageSizes[1].height
        totalHeight += imageSizes[3].height
        let tweetGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),  // 1:1の正方形に画像を収める
                heightDimension: .absolute(totalHeight)
            ),
            subitems: [uppertItem, middleItemsGroup, bottomItem]
        )
        
        print("DEBUG: \(imageSizes)")
        
        return tweetGroup
    }
    
    // TODO: Refactoring
    
    func calculateImageSize(withImage image: UIImage) -> CGSize {

        let widthOfView = view.frame.width
        let ratio = widthOfView / image.size.width
        
        return CGSize(width: widthOfView, height: image.size.height * ratio)
    }
    
    func calculateTwoImageSizes(withImages images: [UIImage]) -> [CGSize] {
//        let netWidth = view.frame.width - imageInsetsConstant * 2  // いるのかわからん
        let netWidth = view.frame.width
        
        let size1 = images[0].size
        let size2 = images[1].size
        
        // 高さを揃えて幅の割合を計算
        let w2_dash = size1.width * (size1.height / size2.height)
        let w2_dash_dash = netWidth * (w2_dash / (size1.width + w2_dash))
        let resultHeight = size2.height * (w2_dash_dash / size2.width)
        
//        let w1_dash_dash = netWidth * (size1.width / (size1.width + w2_dash))
        let w1_dash_dash = netWidth - w2_dash_dash
        
        return [CGSize(width: w1_dash_dash, height: resultHeight),
                CGSize(width: w2_dash_dash, height: resultHeight)]
    }
    
    
//    func calculateWidthFraction(withImages images: [UIImage], atIndex index: Int) -> CGFloat {
//        var sizes = [CGSize]()
//        images.forEach { image in
//            sizes.append(sizeAspectFittingView(image: image))
//        }
//
//        return sizes[index].width / sizes.reduce(0, { result, element in result + element.width })
//    }
//
//    func calculateHeightFraction(withImages images: [UIImage], atIndex index: Int) -> CGFloat {
//        var sizes = [CGSize]()
//        images.forEach { image in
//            sizes.append(sizeAspectFittingView(image: image))
//        }
//
//        return sizes[index].height / sizes.reduce(0, { result, element in result + element.height })
//    }
    
    func sizeAspectFittingView(image: UIImage) -> CGSize {
        let widthOfView = view.frame.width
        let heightOfView = view.frame.height
        let widthOfImage = image.size.width
        let heightOfImage = image.size.height
        
        guard widthOfView != 0,
              heightOfView != 0,
              widthOfImage != 0,
              heightOfImage != 0 else { return CGSize(width: 100, height: 100) }
        
        let ratio = widthOfView / widthOfImage

        let newWidthOfImage = widthOfView - imageInsetsConstant * 2
        let newHeightOfImage = heightOfImage * ratio - imageInsetsConstant * 2
        
        return CGSize(width: newWidthOfImage, height: newHeightOfImage)
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
