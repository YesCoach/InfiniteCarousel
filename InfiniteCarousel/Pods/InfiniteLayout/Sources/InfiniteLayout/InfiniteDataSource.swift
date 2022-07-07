//
//  InfiniteDataSources.swift
//  InfiniteLayout
//
//  Created by Arnaud Dorgans on 03/01/2018.
//

import UIKit

open class InfiniteDataSources {
    public static var originCount: Int = 0
    public static func section(from infiniteSection: Int, numberOfSections: Int) -> Int {
        return infiniteSection % numberOfSections
    }

    public static func indexPath(from infiniteIndexPath: IndexPath, numberOfSections: Int, numberOfItems: Int) -> IndexPath {
        return IndexPath(item: infiniteIndexPath.item % numberOfItems, section: self.section(from: infiniteIndexPath.section, numberOfSections: numberOfSections))
    }

    public static func multiplier(estimatedItemSize: CGSize, enabled: Bool) -> Int {
        guard enabled else {
            return 1
        }
        let min = Swift.min(estimatedItemSize.width, estimatedItemSize.height)
        let count = ceil(InfiniteLayout.minimumContentSize / min)
        // multiplier 값을 늘려서 배너 최대 인덱스 수 조절 가능
        return Int(count)
    }

    public static func numberOfSections(numberOfSections: Int, multiplier: Int) -> Int {
        return numberOfSections > 1 ? numberOfSections * multiplier : numberOfSections
    }
    
    public static func numberOfItemsInSection(numberOfItemsInSection: Int, numberOfSections: Int, multiplier: Int) -> Int {
        originCount = numberOfItemsInSection
        return numberOfSections > 1 ? numberOfItemsInSection : numberOfItemsInSection * multiplier
    }
}
