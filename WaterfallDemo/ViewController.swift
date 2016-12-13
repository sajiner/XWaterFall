//
//  ViewController.swift
//  WaterfallDemo
//
//  Created by sajiner on 2016/12/6.
//  Copyright © 2016年 sajiner. All rights reserved.
//

import UIKit

fileprivate let kWaterfallCellID = "kWaterfallCellID"
class ViewController: UIViewController {

    fileprivate var models = Array(repeating: "hello", count: 50)
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = WaterfallLayout()
        layout.dataSource = self
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kWaterfallCellID)
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        view.addSubview(collectionView)
    }
}

extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kWaterfallCellID, for: indexPath)
        cell.backgroundColor = UIColor.getRandomColor()
        if indexPath.row == models.count - 1 {
            models += models
            collectionView.reloadData()
        }
        return cell
    }
}

extension ViewController: WaterfallLayoutDataSource {
    func numberOfCols(_ waterfall: WaterfallLayout) -> Int {
        return 4
    }
    
    func waterfall(_ waterfall: WaterfallLayout, item: Int) -> CGFloat {
        return CGFloat(arc4random_uniform(150) + 100)
    }
}
