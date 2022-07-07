//
//  InfiniteCarouselViewController.swift
//  InfiniteCarousel
//
//  Created by Twave on 2022/07/06.
//

import UIKit
import InfiniteLayout

class InfiniteCarouselViewController: UIViewController {

    // MARK: - Views
    private lazy var carouselView: InfiniteCollectionView = {
        let infiniteCollectionView = InfiniteCollectionView()
        infiniteCollectionView.register(InfiniteCarouselCell.self, forCellWithReuseIdentifier: InfiniteCarouselCell.cellIdentifier)
        infiniteCollectionView.dataSource = self
        infiniteCollectionView.delegate = self
        infiniteCollectionView.isItemPagingEnabled = true
        
        // 레이아웃 설정
        infiniteCollectionView.infiniteLayout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.2)
        infiniteCollectionView.infiniteLayout.scrollDirection = .horizontal
        infiniteCollectionView.infiniteLayout.minimumLineSpacing = 20
        infiniteCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return infiniteCollectionView
    }()

    // MARK: - Properties
    private var datas: [UIImage]? = (1...5).map{UIImage(named: "\($0).png")!}
    private var timer: Timer?
    private var timeInterval: TimeInterval = 3
    
    // MARK: - Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bannerMove(by: timeInterval)
    }

    // MARK: - Methods
    private func setUpLayout() {
        view.backgroundColor = .white
        view.addSubview(carouselView)
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            carouselView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            carouselView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
    }
    
    func configure(with datas: [UIImage]) {
        self.datas = datas
        carouselView.reloadData()
    }
    
    private func bannerMove(by withTimeinterval: TimeInterval) {
        timer = Timer.scheduledTimer(withTimeInterval: withTimeinterval, repeats: true) { [weak self] _ in
            guard let self = self,
                  let currentIndexPath = self.carouselView.centeredIndexPath else { return }
            let indexPath = IndexPath(item: currentIndexPath.item + 1, section: currentIndexPath.section)
            self.carouselView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }

    private func bannerStop() {
        timer?.invalidate()
    }
}

extension InfiniteCarouselViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let datas = datas else {
            debugPrint("data가 없습니다.")
            return 0
        }
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: InfiniteCarouselCell.cellIdentifier,
            for: indexPath) as? InfiniteCarouselCell,
              let datas = datas
        else {
            fatalError()
        }
        let realIndexPath = carouselView.indexPath(from: indexPath)
        cell.configure(with: datas[realIndexPath.row])
        debugPrint(indexPath)
        return cell
    }
}

extension InfiniteCarouselViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        bannerStop()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        bannerMove(by: timeInterval)
    }
}

extension InfiniteCarouselViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.frame.width
    }
}

extension InfiniteCarouselViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        bannerStop()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        bannerMove(by: timeInterval)
    }
}
