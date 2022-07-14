//
//  InfiniteCarouselDataSource.swift
//  InfiniteCarousel
//
//  Created by Twave on 2022/07/06.
//

import UIKit

class InfiniteCarouselDataSource: NSObject, UICollectionViewDataSource {
    private var data: [UIImage] = []
    
    init(withData data: [UIImage]) {
        self.data = data
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.cellIdentifier, for: indexPath) as? BannerCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: data[indexPath.row])
        return cell
    }
}

//extension InfiniteCarouselDataSource: InfiniteCarouselViewDelegate {
//    func dataChanged(data: [UIImage]) {
//        self.data = data
//    }
//}
