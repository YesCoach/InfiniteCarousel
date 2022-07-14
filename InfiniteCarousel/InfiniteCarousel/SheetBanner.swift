//
//  SheetBannerView.swift
//  InfiniteCarousel
//
//  Created by Twave on 2022/07/14.
//

import UIKit
import InfiniteLayout

private class SheetBannerView: InfiniteCollectionView {
    
}

class SheetBanner: UIView {
    // MARK: - Views
    private lazy var carouselView: SheetBannerView = {
        let infiniteCollectionView = SheetBannerView()
        infiniteCollectionView.register(SheetBannerCell.self, forCellWithReuseIdentifier: SheetBannerCell.cellIdentifier)
        infiniteCollectionView.dataSource = self
        infiniteCollectionView.delegate = self
        infiniteCollectionView.infiniteDelegate = self
        infiniteCollectionView.isItemPagingEnabled = true
        infiniteCollectionView.velocityMultiplier = 1
        infiniteCollectionView.decelerationRate = .fast
        infiniteCollectionView.translatesAutoresizingMaskIntoConstraints = false
        infiniteCollectionView.backgroundColor = .white
        
        // 레이아웃 설정
        infiniteCollectionView.infiniteLayout.itemSize = CGSize(width: width, height: height)
        infiniteCollectionView.infiniteLayout.scrollDirection = .horizontal
        infiniteCollectionView.infiniteLayout.minimumLineSpacing = spacing
        infiniteCollectionView.infiniteLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return infiniteCollectionView
    }()
    
    private lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.layer.cornerRadius = 30
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    private var width: CGFloat = UIScreen.main.bounds.width
    private var height: CGFloat = UIScreen.main.bounds.height * 0.2
    private var spacing: CGFloat = 35
    private var currentIndexPath: IndexPath?
    private var completionHandler: ((Int) -> ())?
    private var startOffset: CGFloat?
    
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
        bannerStop()
        bannerMove()
        carouselView.enrollCellAnimation()
    }
    
    // MARK: - Methods
    /// 셀의 크기를 설정합니다.
    func configureCellSize(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
        carouselView.infiniteLayout.itemSize = CGSize(width: width, height: height)
    }
    
    /// 셀의 간격을 설정합니다.
    func configureSpacing(with spacing: CGFloat) {
        self.spacing = spacing
        carouselView.infiniteLayout.minimumLineSpacing = spacing
    }
    
    /// 셀에 들어갈 이미지 데이터를 초기화 하고, 셀 선택시 콜백 합니다.
    func show(images: [UIImage], completion: @escaping (Int) -> () ) {
        self.images = images
        carouselView.reloadData()
        indexLabel.text = "1 / \(images.count)"
        completionHandler = completion
    }
    
    private func setUpLayout() {
        backgroundColor = .white
        addSubview(carouselView)
        addSubview(indexLabel)
        NSLayoutConstraint.activate([
            carouselView.topAnchor.constraint(equalTo: self.topAnchor),
            carouselView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            carouselView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            indexLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            indexLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    /// 자동 스크롤을 시작합니다.
    private func bannerMove() {
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
            guard let self = self,
                  var currentIndexPath = self.carouselView.centeredIndexPath else { return }
            if currentIndexPath.item == self.maximumTimes - 1 {
                currentIndexPath = IndexPath(item: -1, section: 0)
            }
            let indexPath = IndexPath(item: currentIndexPath.item + 1, section: currentIndexPath.section)
            self.carouselView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    /// 자동 스크롤을 종료합니다.
    private func bannerStop() {
        timer?.invalidate()
    }
}

// MARK: - DataSource 구현부
extension SheetBanner: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let datas = images else {
            debugPrint("이미지 데이터가 없습니다.")
            return 0
        }
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SheetBannerCell.cellIdentifier,
            for: indexPath) as? SheetBannerCell,
              let images = images else {
            fatalError()
        }
        var possibleIndexPath = indexPath
        if indexPath.item >= maximumTimes {
            possibleIndexPath = IndexPath(item: 0, section: 0)
        }
        let realIndexPath = carouselView.indexPath(from: possibleIndexPath)
        cell.configure(with: images[realIndexPath.row])
        return cell
    }
}

// MARK: - Delegate 구현부
extension SheetBanner: UICollectionViewDelegate {

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
extension SheetBanner: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - 스크롤 관련 구현부
extension SheetBanner {

    /// 스크롤 시작 할 때 동작
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isUserInteractionEnabled = false
        startOffset = scrollView.contentOffset.x
        bannerStop()
        currentIndexPath = carouselView.centeredIndexPath
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
     
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let images = images else { return }
        guard let indexPath = carouselView.centeredIndexPath else { return }
        let realIndexPath = carouselView.indexPath(from: indexPath)
        indexLabel.text = "\(realIndexPath.item + 1) / \(images.count)"
    }

    private func userInteractionEnable() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            self.isUserInteractionEnabled = true
        }
    }
}

// MARK: - Animation 관련 구현부
extension SheetBannerView {

    /// 자동 스크롤 메서드
    /// enrollCellAnimation() 사용하면 안됨
    open override func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        guard let centeredIndexPath = centeredIndexPath,
              let cell = cellForItem(at: indexPath) as? BannerCell else { return }
        super.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.removePrefixCellAnimation(indexPath: centeredIndexPath)
            cell.animationToExpand()
        }
    }

    /// 셀 크기 커지는 애니메이션 효과 적용
    func enrollCellAnimation() {
        guard let indexPath = centeredIndexPath,
              let cell = cellForItem(at: indexPath) as? BannerCell else { return }
        cell.animationToExpand()
    }
    
    /// 이전 셀의 크기 효과 제거
    func removePrefixCellAnimation(indexPath: IndexPath) {
        guard let cell = cellForItem(at: indexPath) as? BannerCell else { return }
        cell.animationToShrink()
    }
}

extension SheetBanner: InfiniteCollectionViewDelegate {
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
