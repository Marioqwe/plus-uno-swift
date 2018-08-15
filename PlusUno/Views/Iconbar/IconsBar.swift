//
//  IconsBar.swift
//  PlusUno
//
//  Created by Mario Solano on 10/29/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import UIKit

enum IconType {
    case Ranking
    case Settings
    case About
    case Tutorial
}

class IconsBar: UIView {
    
    var controller: HomeViewController?

    fileprivate let imageNames = ["trophy-variant", "ic_help", "ic_widgets", "ic_settings"]
    fileprivate let iconTypes = [IconType.Ranking, IconType.Tutorial, IconType.About, IconType.Settings]
    fileprivate let kSideInset: CGFloat = 40
    fileprivate let kCellSideLength: CGFloat = 40
    
    func animateEntrance() {
        topDivider.animateHorizontalExpansion(withDuration: 1.0, delay: 0)

        for (i, cell) in cellViews.enumerated() {
            let delay = TimeInterval(Double(i) / 5.0)
            let duration = TimeInterval(1 - delay)
            cell.animateBounceFromBottom(withDuration: duration, delay: delay)
        }
    }
    
    func animateExit(completion: (() -> Void)? = nil) {
        topDivider.animateHorizontalContraction(withDuration: 0.25, delay: 0, completion: {
            completion?()
        })
        
        for cell in cellViews {
            cell.animateExitBottom(withDuration: 0.25, delay: 0)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCollectionView()
        setUpTopDivider()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var topDivider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.tintColor
        
        return view
    }()
    
    private func setUpTopDivider() {
        addSubview(topDivider)
        topDivider.setHeightConstraint(to: 1)
        topDivider.constraintWidth(to: self, multiplier: 0.85, constant: 0)
        topDivider.pinCenterX(to: self)
        topDivider.constraintBottom(to: collectionView, attribute: .top, multiplier: 1, constant: 0)
    }
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.white
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    private func setUpCollectionView() {
        collectionView.register(IconCell.self, forCellWithReuseIdentifier: IconCell.identifier)
        addSubview(collectionView)
        collectionView.pinCenter(to: self)
        collectionView.constraintWidth(to: self, multiplier: 1, constant: 0)
        collectionView.constraintHeight(to: self, multiplier: 1, constant: 0)
    }
    
    private lazy var cellViews: [UICollectionViewCell] = {
        return collectionView.visibleCells.sorted { (cell_1, cell_2) -> Bool in
            return cell_1.frame.origin.x < cell_2.frame.origin.x
        }
    }()
    
}

extension IconsBar: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCell.identifier, for: indexPath) as! IconCell
        cell.iconType = iconTypes[indexPath.item]
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        cell.tintColor = Theme.tintColor
        
        return cell
    }
    
}

extension IconsBar: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let iconType = iconTypes[indexPath.item]
        switch iconType {
        case .About:
            SoundManager.playSound(name: "digi_plink")
            controller?.showAboutPage()
        case .Settings:
            SoundManager.playSound(name: "digi_plink")
            controller?.showSettingsPage()
        case .Tutorial:
            SoundManager.playSound(name: "digi_plink")
            controller?.showTutorialPage()
        case .Ranking:
            SoundManager.playSound(name: "digi_plink")
            controller?.showRankingPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: kSideInset, bottom: 0, right: kSideInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: kCellSideLength, height: kCellSideLength)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (collectionView.bounds.width - (2 * kSideInset) - (kCellSideLength * CGFloat(iconTypes.count))) / CGFloat(iconTypes.count - 1)
    }
    
}
