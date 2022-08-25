//
//  InfiniteCarouselViewController.swift
//  InfiniteCarousel
//
//  Created by Twave on 2022/07/06.
//

import UIKit
import InfiniteLayout

private class BannerView: InfiniteCollectionView {}
enum BannerSize {
    case small
    case medium
    case large
}

class Banner: UIView {
    // MARK: - Views
    private lazy var carouselView: BannerView = {
        let infiniteCollectionView = BannerView()
        infiniteCollectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.cellIdentifier)
        infiniteCollectionView.dataSource = self
        infiniteCollectionView.delegate = self
        infiniteCollectionView.infiniteDelegate = self
        infiniteCollectionView.isItemPagingEnabled = true
        infiniteCollectionView.velocityMultiplier = 1
        infiniteCollectionView.decelerationRate = .fast
        infiniteCollectionView.translatesAutoresizingMaskIntoConstraints = false
        infiniteCollectionView.backgroundColor = .white
        
        // 레이아웃 설정
        infiniteCollectionView.infiniteLayout.scrollDirection = .horizontal
        infiniteCollectionView.infiniteLayout.minimumLineSpacing = spacing
        infiniteCollectionView.infiniteLayout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
        return infiniteCollectionView
    }()

    // MARK: - Properties
    private var images: [UIImage]?
    private var timer: Timer = Timer()
    
    /// 자동 스크롤 설정 시간
    private var timeInterval: TimeInterval = 5
    
    /// 셀 크기와 간격
    private var spacing: CGFloat = 30
    private var bannerSize: BannerSize?

    /// 스크롤 시 시작 지점 - 스크롤 관련 로직에 필요
    private var startOffset: CGFloat?

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
        guard let bannerSize = bannerSize else {
            super.draw(rect)
            return
        }
        switch bannerSize {
        case .small:
            carouselView.infiniteLayout.itemSize = CGSize(width: rect.width * 0.8, height: rect.width * 0.3)
        case .medium:
            carouselView.infiniteLayout.itemSize = CGSize(width: rect.width * 0.8, height: rect.width * 0.5)
        case .large:
            carouselView.infiniteLayout.itemSize = CGSize(width: rect.width * 0.8, height: rect.width * 0.8)
        }
        carouselView.layoutIfNeeded()
        carouselView.enrollCellAnimation()
        super.draw(rect)
    }

    // MARK: - Methods
    /// 셀의 간격을 설정합니다.
    func configureSpacing(with spacing: CGFloat) {
        carouselView.infiniteLayout.minimumLineSpacing = spacing
        carouselView.infiniteLayout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
        layoutIfNeeded()
    }
    
    /// 셀의 크기를 설정합니다.
    /// bannerSize: small, medium. large
    func configureBannerSize(with bannerSize: BannerSize) {
        self.bannerSize = bannerSize
    }

    /// 자동스크롤 시간을 설정합니다.
    /// default: 3초
    func configureTimeInterval(with time: Double) {
        self.timeInterval = time
    }

    /// 셀에 들어갈 이미지 데이터를 초기화 하고, 셀 선택시 콜백 합니다.
    func show(images: [UIImage], completion: @escaping (Int) -> () ) {
        self.images = images
        carouselView.reloadData()
        carouselView.layoutIfNeeded()
        carouselView.enrollCellAnimation()
        bannerMove()
        
        /// 배너 이미지의 개수가 1보다 작을 경우
        /// 1. 스크롤 기능 제거
        /// 2. 앞 뒤 셀을 숨김 처리
        if images.count <= 1 {
            carouselView.isScrollEnabled = false
            guard let preorderCell = carouselView.cellForItem(at: IndexPath(item: carouselView.numberOfItems(inSection: 0) - 1, section: 0)) as? BannerCell,
                  let nextCell = carouselView.cellForItem(at: IndexPath(item: 1, section: 0)) as? BannerCell else { return }
            preorderCell.isHidden = true
            nextCell.isHidden = true
            bannerStop()
        }
        completionHandler = completion
    }

    private func setUpLayout() {
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
    private func bannerMove() {
        guard timer.isValid == false else { return }
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
            guard let self = self,
                  var currentIndexPath = self.carouselView.centeredIndexPath else { return }
            if currentIndexPath.item == self.carouselView.numberOfItems(inSection: 0) - 1 {
                currentIndexPath = IndexPath(item: -1, section: 0)
            }
            let indexPath = IndexPath(item: currentIndexPath.item + 1, section: currentIndexPath.section)
            self.carouselView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    /// 자동 스크롤을 종료합니다.
    private func bannerStop() {
        timer.invalidate()
    }
}

// MARK: - DataSource 구현부
extension Banner: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let datas = images else {
            debugPrint("이미지 데이터가 없습니다.")
            return 0
        }
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BannerCell.cellIdentifier,
            for: indexPath) as? BannerCell,
              let images = images else {
            fatalError()
        }
        let realIndexPath = carouselView.indexPath(from: indexPath)
        cell.configure(with: images[realIndexPath.row])
        return cell
    }
}

// MARK: - Delegate 구현부
extension Banner: UICollectionViewDelegate {

    /// 셀 선택 시 해당 셀로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath != carouselView.centeredIndexPath else {
            // 콜백 해야되는 부분
            let realIndexPath = carouselView.indexPath(from: indexPath)
            self.completionHandler?(realIndexPath.row)
            return
        }
        isUserInteractionEnabled = false
        bannerStop()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.carouselView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.bannerMove()
        }
    }
}

// MARK: - DelegateFlowLayout 구현부
extension Banner: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.frame.width
    }
}

// MARK: - 스크롤 관련 구현부
extension Banner {

    /// 스크롤 시작 할 때 동작
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isUserInteractionEnabled = false
        startOffset = scrollView.contentOffset.x
        bannerStop()
    }
    
    /// 스크롤 끝날 때 동작
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        bannerMove()
        userInteractionEnable()
    }
    
    /// 스크롤이 일정 길이 이상 진행된 경우 스크롤 종료
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let startOffset = startOffset else { return }
        if abs(scrollView.contentOffset.x - startOffset) > UIScreen.main.bounds.maxX * 0.83 {
            scrollView.panGestureRecognizer.isEnabled = false
            scrollView.panGestureRecognizer.isEnabled = true
            userInteractionEnable()
            self.startOffset = nil
        }
    }

    /// 스크롤 애니메이션이 완전히 끝나면 터치 이벤트 허용
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        userInteractionEnable()
    }
    
    /// 스크롤 인디케이터가 동작할 때 터치 이벤트 차단
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        isUserInteractionEnabled = false
    }
    
    private func userInteractionEnable() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            self.isUserInteractionEnabled = true
        }
    }
}

// MARK: - Animation 관련 구현부
extension BannerView {

    /// 셀 크기 커지는 애니메이션 효과 적용
    func enrollCellAnimation() {
        guard let indexPath = centeredIndexPath,
              let cell = cellForItem(at: indexPath) as? BannerCell else { return }
        cell.animationToExpand()
    }
}

// MARK: InfiniteCollectionViewDelegate 구현부
extension Banner: InfiniteCollectionViewDelegate {

    /// 가운데에 위치하는 셀이 바뀔때마다 호출 - 셀 크기 증감 애니메이션 동작
    func infiniteCollectionView(_ infiniteCollectionView: InfiniteCollectionView, didChangeCenteredIndexPath from: IndexPath?, to: IndexPath?) {
        guard let from = from,
        let to = to,
        let prefixCell = infiniteCollectionView.cellForItem(at: from) as? BannerCell,
        let currentCell = infiniteCollectionView.cellForItem(at: to) as? BannerCell else {
            return
        }
        DispatchQueue.main.async {
            prefixCell.animationToShrink()
            currentCell.animationToExpand()
        }
    }
}

// MARK: - Scroll 속도 지연
extension BannerView {
    private func super_scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
       super.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }
    override func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.super_scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
            self?.isUserInteractionEnabled = true
        })
    }
}
