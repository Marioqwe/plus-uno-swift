//
//  LevelsMenu.swift
//  PlusUno
//
//  Created by Mario Solano on 10/27/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import UIKit

class LevelsMenu: UIView {
    
    var controller: HomeViewController?
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = CustomLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    fileprivate lazy var cellSideLength: CGFloat = {
        /// We want this cells to be the same size as the ones in our gameboard.
        /// TODO: It's no good to hard code this numbers but this will do for now. For details of where this
        /// values are coming from, go to GameboardView.swift and look at how the tile dimensions are calculated.
        let gameboardSideLength = UIScreen.main.bounds.width * 0.85
        let padding = gameboardSideLength * 0.025
        let availableSideLengthForTile = gameboardSideLength - padding * 4
        let tileSideLength = CGFloat(floorf(CFloat(availableSideLengthForTile))) / 3
        
        return tileSideLength
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(LevelCell.self, forCellWithReuseIdentifier: LevelCell.identifier)
        addSubview(collectionView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": collectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": collectionView]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollToFirstCell() {
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    func scrollToCell(withValue value: Int, animated: Bool = true) {
        let currIndexPath = IndexPath(row: value - 1, section: 0)
        collectionView.scrollToItem(at: currIndexPath, at: .centeredHorizontally, animated: animated)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    /// The collectionView's scrollView.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = scrollView.contentOffset.x + scrollView.bounds.width / 2
        for cell in collectionView.visibleCells {
            let thresholdX = cellSideLength / 3
            let offsetX = fabs(centerX - cell.center.x)
            cell.transform = CGAffineTransform.identity
            cell.isUserInteractionEnabled = true
            
            if offsetX > thresholdX {
                let offsetPercentage = (offsetX - thresholdX) / bounds.width
                var scaleX = 1 - offsetPercentage
                
                if scaleX < 0.8 {
                    scaleX = 0.8
                }
                
                cell.isUserInteractionEnabled = false
                cell.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)
            }
        }
    }
    
}

extension LevelsMenu: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SessionManager.shared.maxLevel()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LevelCell.identifier, for: indexPath) as! LevelCell
        cell.level = indexPath.row + 1
        return cell
    }
    
}


extension LevelsMenu: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let value = indexPath.row + 1
        SoundManager.playSound(name: "digi_plink")
        controller?.didSelect(cell!, withValue: value, inCollectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSideLength, height: cellSideLength)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let horizonalInset = (collectionView.bounds.width - cellSideLength) / 2
        let verticalInset = (collectionView.bounds.height - cellSideLength) / 2
        return UIEdgeInsets(top: verticalInset, left: horizonalInset, bottom: verticalInset, right: horizonalInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }

}
