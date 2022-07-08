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
        infiniteCollectionView.velocityMultiplier = 1
        infiniteCollectionView.decelerationRate = .fast
        infiniteCollectionView.translatesAutoresizingMaskIntoConstraints = false

        // 레이아웃 설정
        infiniteCollectionView.infiniteLayout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.2)
        infiniteCollectionView.infiniteLayout.scrollDirection = .horizontal
        infiniteCollectionView.infiniteLayout.minimumLineSpacing = spacing
        infiniteCollectionView.infiniteLayout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
        return infiniteCollectionView
    }()

    // MARK: - Properties
    private var images: [UIImage]? = (1...5).map{UIImage(named: "\($0).png")!}
    private var timer: Timer?
    /// 자동 스크롤 설정 시간
    private var timeInterval: TimeInterval = 3
    /// maximumTimes의 값은 항상 images.count * 20
    private var maximumTimes: Int {
        get { (images?.count ?? 0) * 20 }
    }
    /// 카드 간 간격
    private var spacing: CGFloat = 15

    // MARK: - Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bannerMove(by: timeInterval)
        carouselView.enrollCellAnimation()
    }

    // MARK: - Methods
    /// 배너에 들어갈 이미지 데이터를 초기화 합니다.
    func configure(with images: [UIImage]) {
        self.images = images
        carouselView.reloadData()
    }

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

    private func bannerMove(by withTimeinterval: TimeInterval) {
        timer = Timer.scheduledTimer(withTimeInterval: withTimeinterval, repeats: true) { [weak self] _ in
            guard let self = self,
                  var currentIndexPath = self.carouselView.centeredIndexPath else { return }
            if currentIndexPath.item == self.maximumTimes - 1 {
                currentIndexPath = IndexPath(item: -1, section: 0)
            }
            let indexPath = IndexPath(item: currentIndexPath.item + 1, section: currentIndexPath.section)
            self.carouselView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }

    private func bannerStop() {
        timer?.invalidate()
    }
}

// MARK: - DataSource 구현부
extension InfiniteCarouselViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let datas = images else {
            debugPrint("이미지 데이터가 없습니다.")
            return 0
        }
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: InfiniteCarouselCell.cellIdentifier,
                            for: indexPath) as? InfiniteCarouselCell,
              let images = images else {
            fatalError()
        }
        var possibleIndexPath = indexPath
        if indexPath.item >= maximumTimes {
            possibleIndexPath = IndexPath(item: 0, section: 0)
        }
        let realIndexPath = carouselView.indexPath(from: possibleIndexPath)
        cell.configure(with: images[realIndexPath.row])
        debugPrint("셀 생성 \(indexPath)")
        return cell
    }
}

// MARK: - Delegate 구현부
extension InfiniteCarouselViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        bannerStop()
        carouselView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        bannerMove(by: timeInterval)
    }
}

// MARK: - DelegateFlowLayout 구현부
extension InfiniteCarouselViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.frame.width
    }
}

// MARK: - 스크롤시 자동 스크롤 타이머 on/off
extension InfiniteCarouselViewController {
    
    // 터치할때 동작
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        bannerStop()
    }
    
    // 스크롤 움직일때 동작
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        debugPrint(#function)
        carouselView.removeCurrentCellAnimation()
    }

    // 터치 끝날때 동작
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        debugPrint(#function)
//        bannerMove(by: timeInterval)
//        carouselView.enrollCellAnimation()
    }
    // 스크롤 완전히 끝나고 동작
    // 문제점: 애니메이션이 너무 늦게 터짐
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        debugPrint(#function)
        bannerMove(by: timeInterval)
        carouselView.enrollCellAnimation()
    }
}

// MARK: - Animation 관련 구현부
extension InfiniteCollectionView {
    open override func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        removeCurrentCellAnimation()
        super.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        let cell = cellForItem(at: indexPath) as? InfiniteCarouselCell
        cell?.animation(completion: nil)
    }

    func enrollCellAnimation() {
        guard let indexPath = centeredIndexPath,
              let cell = cellForItem(at: indexPath) as? InfiniteCarouselCell else {
            return
        }
        cell.animation(completion: nil)
    }
    
    func removeCurrentCellAnimation() {
        guard let indexPath = centeredIndexPath else { return }
        let cell = cellForItem(at: indexPath) as? InfiniteCarouselCell
        cell?.removeAnimation()
    }
    
    func removePrePostCellAnimation() {
        guard let indexPath = centeredIndexPath else { return }
        let prefixIndexPath = IndexPath(item: indexPath.row - 1, section: indexPath.section)
        let postfixIndexPath = IndexPath(item: indexPath.row + 1, section: indexPath.section)
        let prefixCell = cellForItem(at: prefixIndexPath) as? InfiniteCarouselCell
        let postfixCell = cellForItem(at: postfixIndexPath) as? InfiniteCarouselCell
        [prefixCell, postfixCell].forEach {$0?.removeAnimation()}
    }
}
