//
//  PinterestLayout.swift
//  UICollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/11/17.
//


import UIKit

protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}


class PinterestLayout: UICollectionViewLayout {
    
    // MARK: - Properties
    
    weak var delegate: PinterestLayoutDelegate?
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // MARK: - Decleared Methods
    
    /*
     the bounds of the UICollectionView might change when the orientation changes.
     They could also change if items are added or removed from the collection.
     */
    override func prepare() {
        
        // キャッシュがすでに存在するかCollectionViewがない場合はreturn
        guard
            cache.isEmpty,
            let collectionView = collectionView
        else {
            return
        }
        
        // Column数からxオフセットを計算
        // yオフセットを0で初期化
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column_i in 0..<numberOfColumns {
            xOffset.append(CGFloat(column_i) * columnWidth)
        }
        
        var column = 0  // すぐ後のループ内で使用される
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        // 今回は1secitonのみ
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let photoHeight = delegate?.collectionView(
                collectionView,
                heightForPhotoAtIndexPath: indexPath) ?? 180
            let height = cellPadding * 2 + photoHeight  // bottom and height cellPadding
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)  // 新しいアイテムで高さを更新する
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0  // e.g. 3つのcolumnがある場合、0->1->2->0->1->2->...とループするってことかな
        }
    }
    
    // The collection view calls it after prepare()
    // to determine which items are visible in the given rectangle.
    override func layoutAttributesForElements(in rect: CGRect)
    -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath)
    -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    // MARK: - Lifecycle
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
}
