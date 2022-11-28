//
//  MoreInfoViewController.swift
//  Marinas Search
//
//  Created by mattesona on 11/26/22.
//

import Foundation
import UIKit

class MoreInfoCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {


    var rawInfo: LocationData
    var cellID = "moreInfoCellID"

    var collectionView: UICollectionView!

    init(rawInfo: LocationData) {
        self.rawInfo = rawInfo

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: createBasicListLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MoreInfoCollectionViewCell.self, forCellWithReuseIdentifier:cellID)
        self.view.addSubview(collectionView)
    }
    

    func createBasicListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MoreInfoCollectionViewCell
        cell.updateInfoCell(using: rawInfo)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}
