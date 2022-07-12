//
//  InfiniteCarouselViewController.swift
//  InfiniteCarousel
//
//  Created by Twave on 2022/07/06.
//

import UIKit
import InfiniteLayout

class InfiniteCarouselView: UIView {
    
    // MARK: - Views
    private var carouselView: InfiniteCollectionView = {
        let infiniteCollectionView = InfiniteCollectionView()
        infiniteCollectionView.register(InfiniteCarouselCell.self, forCellWithReuseIdentifier: InfiniteCarouselCell.cellIdentifier)
        infiniteCollectionView.isItemPagingEnabled = true
        infiniteCollectionView.velocityMultiplier = 1
        infiniteCollectionView.decelerationRate = .fast
        infiniteCollectionView.translatesAutoresizingMaskIntoConstraints = false
        infiniteCollectionView.backgroundColor = .white
        return infiniteCollectionView
    }()

    // MARK: - Properties
    private var images: [UIImage]?
    private var timer: Timer?
    private var group = DispatchGroup()
    
    /// 자동 스크롤 설정 시간
    private var timeInterval: TimeInterval = 3
    
    /// maximumTimes의 값은 무조건 images.count * 20 이여야 합니다.
    private var maximumTimes: Int {
        get { (images?.count ?? 0) * 20 }
    }
    
    /// 셀 크기와 간격
    private var width: CGFloat = UIScreen.main.bounds.width * 0.75
    private var height: CGFloat = UIScreen.main.bounds.height * 0.2
    private var spacing: CGFloat = 40
    private var currentIndexPath: IndexPath?
    private var completionHandler: ((Int) -> ())?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        bannerMove(by: timeInterval)
    }

    // MARK: - Methods
    /// 셀의 크기를 설정합니다.
    func configureCellSize(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    /// 셀의 간격을 설정합니다.
    func configureSpacing(with spacing: CGFloat) {
        self.spacing = spacing
    }
    
    /// 셀에 들어갈 이미지 데이터를 초기화 하고, 셀 선택시 콜백 합니다.
    func show(images: [UIImage], completion: @escaping (Int) -> () ) {
        self.images = images
        carouselView.reloadData()
        completionHandler = completion
    }
    
    private func setUpLayout() {
        carouselView.dataSource = self
        carouselView.delegate = self
        // 레이아웃 설정
        carouselView.infiniteLayout.itemSize = CGSize(width: width, height: height)
        carouselView.infiniteLayout.scrollDirection = .horizontal
        carouselView.infiniteLayout.minimumLineSpacing = spacing
        carouselView.infiniteLayout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
        backgroundColor = .white
        addSubview(carouselView)
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            carouselView.topAnchor.constraint(equalTo: self.topAnchor),
            carouselView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            carouselView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    /// 자동 스크롤을 시작합니다.
    private func bannerMove(by withTimeinterval: TimeInterval) {
        timer = Timer.scheduledTimer(withTimeInterval: withTimeinterval, repeats: true) { [weak self] _ in
            guard let self = self,
                  var currentIndexPath = self.carouselView.centeredIndexPath else { return }
            if currentIndexPath.item == self.maximumTimes - 1 {
                currentIndexPath = IndexPath(item: -1, section: 0)
            }
            let indexPath = IndexPath(item: currentIndexPath.item + 1, section: currentIndexPath.section)
            self.isUserInteractionEnabled = false
            self.carouselView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }

    /// 자동 스크롤을 종료합니다.
    private func bannerStop() {
        timer?.invalidate()
    }
}

// MARK: - DataSource 구현부
extension InfiniteCarouselView: UICollectionViewDataSource {
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
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }
}

// MARK: - Delegate 구현부
extension InfiniteCarouselView: UICollectionViewDelegate {
    
    /// 셀 선택 시 해당 셀로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath != carouselView.centeredIndexPath else {
            let cell = carouselView.cellForItem(at: indexPath)
            print(cell?.bounds)
            // 콜백 해야되는 부분
            let realIndexPath = carouselView.indexPath(from: indexPath)
            self.completionHandler?(realIndexPath.row)
            return
        }
        isUserInteractionEnabled = false
        bannerStop()
        carouselView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        bannerMove(by: timeInterval)
    }
}

// MARK: - DelegateFlowLayout 구현부
extension InfiniteCarouselView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.frame.width
    }
}

// MARK: - 스크롤시 자동 스크롤 타이머 on/off
extension InfiniteCarouselView {

    /// 터치 할 때 동작
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isUserInteractionEnabled = false
        bannerStop()
        currentIndexPath = carouselView.centeredIndexPath
    }

    /// 터치 끝날 때 동작
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self,
                  let currentIndexPath = self.currentIndexPath,
                  currentIndexPath != self.carouselView.centeredIndexPath else { return }

        }
        bannerMove(by: timeInterval)
    }

    /// 스크롤이 완전히 끝나면 터치 이벤트 허용
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isUserInteractionEnabled = true
    }

    /// 스크롤 애니메이션이 완전히 끝나면 터치 이벤트 허용
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isUserInteractionEnabled = true
    }

    /// 크기 변화에 필요한 메소드
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        carouselView.didScroll(scrollView)
    }
}

// MARK: - Animation 관련 구현부
extension InfiniteCollectionView {

    /// 자동 스크롤 메서드
    open override func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        guard let centeredIndexPath = centeredIndexPath,
              let cell = cellForItem(at: indexPath) as? InfiniteCarouselCell else { return }
        super.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
        }
    }
    
    func didScroll(_ scrollview: UIScrollView) {
        for cell in visibleCells {
            if let infiniteCarouselCell = cell as? InfiniteCarouselCell {
                infiniteCarouselCell.scale()
            }
        }
    }
}
