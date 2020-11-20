//
//  AlbumCollectionViewController.swift
//  UICollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/11/19.
//
//  Reference: [Modern Collection Views with Compositional Layouts](https://www.raywenderlich.com/5436806-modern-collection-views-with-compositional-layouts)


import UIKit

final class AlbumCollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    enum Section {
        case albumBody
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Photo>! = nil
    var albumDetailCollectionView: UICollectionView! = nil
    private var photos = Photo.allPhotos()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "SampleTitle"
        configureCollectionView()
        configureDataSource()
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
}

extension AlbumCollectionViewController {
    
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds,
                                              collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(AlbumCollectionViewCell.self,
                                forCellWithReuseIdentifier: AlbumCollectionViewCell.reuseIdentifer)
        albumDetailCollectionView = collectionView
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: albumDetailCollectionView) {
            (collectionView: UICollectionView,
             indexPath: IndexPath,
             detailItem: Photo)
            -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: AlbumCollectionViewCell.reuseIdentifer,
                    for: indexPath) as? AlbumCollectionViewCell else { fatalError("Could not create new cell") }
            cell.photo = self.photos[indexPath.item]
            return cell
        }
        
        // load our initial data
        // ポイントは、スナップショットをdataSourceに使用していること
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func generateLayout() -> UICollectionViewLayout {

        // ①: First type. Full
        let fullPhotoItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalWidth(2/3))
        )
        // 各写真周りの余白を設定する
        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        // ②: Second type: Main with pair
        // メインの写真は、幅はグループ幅の2/3、高さは1/3
        let mainItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3),
                                             heightDimension: .fractionalHeight(1.0))
        )
        mainItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        // メイン写真の後続に、縦に2枚の写真を重ねたものを配置する
        let pairItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(0.5))  // 縦に積むので1/2ってことかな
        )
        pairItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let trailingGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),  // スタックの幅は1/3（mainWithPairGroupから見て）
                                             heightDimension: .fractionalHeight(1.0)),
          subitem: pairItem,
          count: 2)
        
        // 最終的なグループ
        // class NSCollectionLayoutGroup: NSCollectionLayoutItem
        // widthは幅いっぱいの1.0
        // 写真の高さは2/3で、さらにメインの写真の高さは2/3なので、合計2/3*2/3=4/9の高さにする必要がある
        // →2/3にすると写真は正方形表示になってしまう
        let mainWithPairGroup = NSCollectionLayoutGroup.horizontal(
          layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalWidth(4/9)),
                                             subitems: [mainItem, trailingGroup])
        
        // ③: Third type. Triplet
        let tripletItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),  // tripletGroupからみて幅1/3
            heightDimension: .fractionalHeight(1.0)))  // tripletGroupからみて高さはそのまま

        tripletItem.contentInsets = NSDirectionalEdgeInsets(top: 2,leading: 2,bottom: 2,trailing: 2)

        let tripletGroup = NSCollectionLayoutGroup.horizontal(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(2/9)),  // 2/3 * 1/3 = 2/9
          subitems: [tripletItem, tripletItem, tripletItem])

        
        // ④: Fourth type. Reversed main with pair
        let mainWithPairReversedGroup = NSCollectionLayoutGroup.horizontal(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(4/9)),
          subitems: [trailingGroup, mainItem])
        
        // ①-④のスタックを作成する
        let nestedGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(16/9)),  // ①-④の高さ = 2/3 + 4/9 + 2/9 + 4/9 = 16/9
          subitems: [
            fullPhotoItem,
            mainWithPairGroup,
            tripletGroup,
            mainWithPairReversedGroup
          ]
        )
        
        // NSCollectionLayoutSection: セクションを表すクラス
        // 最終的に作成したNSCollectionLayoutGroupを適用する
        let section = NSCollectionLayoutSection(group: nestedGroup)
        
        // 最終的にレンダリングされる単位になります。
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, Photo> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapshot.appendSections([Section.albumBody])
        snapshot.appendItems(photos)
        return snapshot
    }
}

extension AlbumCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)")
//        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
//        let photoDetailVC = PhotoDetailViewController(photoURL: item.photoURL)
//        navigationController?.pushViewController(photoDetailVC, animated: true)
    }
}
