//
//  WaterfallLayout.swift
//  WaterfallDemo
//
//  Created by sajiner on 2016/12/6.
//  Copyright © 2016年 sajiner. All rights reserved.
//

import UIKit

protocol WaterfallLayoutDataSource: class {
    // 一共有多少列
    func numberOfCols(_ waterfall: WaterfallLayout) -> Int
    // 每个cell的高度
    func waterfall(_ waterfall: WaterfallLayout, item: Int) -> CGFloat
}

class WaterfallLayout: UICollectionViewFlowLayout {
    weak var dataSource: WaterfallLayoutDataSource?
    
    fileprivate var cellAttrs = [UICollectionViewLayoutAttributes]()
    fileprivate lazy var cols: Int = {
       return self.dataSource?.numberOfCols(self) ?? 2
    }()
    // 所有的高度
    fileprivate lazy var totalHeights: [CGFloat] = Array(repeating: self.sectionInset.top, count: self.cols)
    
}

extension WaterfallLayout {
    //MARK: - 准备布局
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        sectionInset = UIEdgeInsetsMake(0, 10, 10, 10)
        // 获取cell的个数
        let cellCount = collectionView.numberOfItems(inSection: 0)
        
        let cellW = (collectionView.bounds.width - sectionInset.left - sectionInset.right - CGFloat(cols - 1) * minimumInteritemSpacing) / CGFloat(cols)
        
        for i in cellAttrs.count..<cellCount {
            let indexPath = IndexPath(item: i, section: 0)
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            guard let cellH = dataSource?.waterfall(self, item: i) else {
                fatalError("请实现cell的数据源方法")
            }
            let minH = totalHeights.min()!
            let minIndex = totalHeights.index(of: minH)!
            let cellX = sectionInset.left + (cellW + minimumInteritemSpacing) * CGFloat(minIndex)
            let cellY = minH + minimumLineSpacing
            attr.frame = CGRect(x: cellX, y: cellY, width: cellW, height: cellH)
            cellAttrs.append(attr)
            
            totalHeights[minIndex] = minH + minimumLineSpacing + cellH
        }
        
    }
    
    //MARK: - 返回准备好的所有布局
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttrs
    }
    
    //MARK: - 设置contentSize
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: totalHeights.max()! + sectionInset.bottom)
    }
}
