//
//  SheetBannerView.swift
//  InfiniteCarousel
//
//  Created by Twave on 2022/07/14.
//

import UIKit
import InfiniteLayout

private class SheetBannerView: InfiniteCollectionView {}

class SheetBanner: UIView {

    // MARK: - Views
    private lazy var carouselView: SheetBannerView = {
        let infiniteCollectionView = SheetBannerView()
        infiniteCollectionView.register(SheetBannerCell.self, forCellWithReuseIdentifier: SheetBannerCell.cellIdentifier)
        infiniteCollectionView.dataSource = self
        infiniteCollectionView.delegate = self
        infiniteCollectionView.infiniteDelegate = self
        infiniteCollectionView.isItemPagingEnabled = false
        infiniteCollectionView.velocityMultiplier = 1
        infiniteCollectionView.decelerationRate = .fast
        infiniteCollectionView.translatesAutoresizingMaskIntoConstraints = false
        infiniteCollectionView.backgroundColor = .white
        infiniteCollectionView.layer.masksToBounds = true
        infiniteCollectionView.layer.cornerRadius = 20
        infiniteCollectionView.layer.maskedCorners = [CACornerMask.layerMinXMinYCorner, CACornerMask.layerMaxXMinYCorner]
        infiniteCollectionView.isScrollEnabled = false

        leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
        leftSwipeRecognizer.direction = .left
        rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
        infiniteCollectionView.addGestureRecognizer(leftSwipeRecognizer)
        infiniteCollectionView.addGestureRecognizer(rightSwipeRecognizer)

        // 레이아웃 설정
        infiniteCollectionView.infiniteLayout.itemSize = CGSize(width: width, height: height)
        infiniteCollectionView.infiniteLayout.scrollDirection = .horizontal
        infiniteCollectionView.infiniteLayout.minimumLineSpacing = spacing
        infiniteCollectionView.infiniteLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return infiniteCollectionView
    }()
    
    private lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = UIColor.lightGray
        label.font = UIFont(name: "Helvetica Neue Medium", size: 12)
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    private var images: [UIImage]?
    private var timer: Timer = Timer()
    
    /// 자동 스크롤 설정 시간
    private var timeInterval: TimeInterval = 3
    
    /// Sheet Banner에서 maximumTimes의 값은 무조건 images.count * 17 이여야 합니다.
    private var maximumTimes: Int {
        get { (images?.count ?? 0) * 10}
    }

    /// 셀 크기와 간격
    private var width: CGFloat = UIScreen.main.bounds.width
    private var height: CGFloat = UIScreen.main.bounds.height * 0.4
    private var spacing: CGFloat = 0

    private var currentIndexPath: IndexPath?
    private var completionHandler: ((Int) -> ())?
    private var startOffset: CGFloat?
    private var leftSwipeRecognizer = UISwipeGestureRecognizer()
    private var rightSwipeRecognizer = UISwipeGestureRecognizer()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        carouselView.infiniteLayout.itemSize = CGSize(width: rect.width, height: rect.height)
        carouselView.layoutIfNeeded()
        carouselView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
        super.draw(rect)
        bannerStop()
        bannerMove()
    }
    
    // MARK: - Methods
    /// 셀의 간격을 설정합니다.
    func configureSpacing(with spacing: CGFloat) {
        carouselView.infiniteLayout.minimumLineSpacing = spacing
        carouselView.infiniteLayout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
        carouselView.layoutIfNeeded()
    }
    
    /// 자동 스크롤 시간을 설정합니다.
    /// default: 3초
    func configureTimeInterval(with timeInterval: Double) {
        self.timeInterval = timeInterval
    }
    
    /// 셀에 들어갈 이미지 데이터를 초기화 하고, 셀 선택시 콜백 합니다.
    func show(images: [UIImage], completion: @escaping (Int) -> () ) {
        self.images = images
        carouselView.reloadData()
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
            indexLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            indexLabel.widthAnchor.constraint(equalToConstant: 46),
            indexLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    /// 자동 스크롤을 시작합니다.
    private func bannerMove() {
        guard timer.isValid == false else { return }
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
        timer.invalidate()
    }
    
    @objc private func swipeHandler(_ gestureRecognizer : UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            bannerMove()
            switch gestureRecognizer.direction {
            case .right:
                guard var indexPath = carouselView.centeredIndexPath else { return }
                if indexPath.item == 0 {
                    indexPath = IndexPath(item: maximumTimes, section: 0)
                }
                let targetIndexPath = IndexPath(item: indexPath.item - 1, section: 0)
                carouselView.scrollToItem(at: targetIndexPath, at: .centeredHorizontally, animated: true)
            case .left:
                guard var indexPath = carouselView.centeredIndexPath else { return }
                if indexPath.item == maximumTimes - 1 {
                    indexPath = IndexPath(item: -1, section: 0)
                }
                let targetIndexPath = IndexPath(item: indexPath.item + 1, section: 0)
                carouselView.scrollToItem(at: targetIndexPath, at: .centeredHorizontally, animated: true)
            default:
                return
            }
        }
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
        
        /// maximumTimes: 임의의 SheetBanner의 데이터소스 최대값
        /// maximumTimes에 도달하면 최초의 인덱스패스로 바꿔줍니다.
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath != carouselView.centeredIndexPath else {
            // 콜백 해야되는 부분
            let realIndexPath = carouselView.indexPath(from: indexPath)
            self.completionHandler?(realIndexPath.row)
            return
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
    /// 스크롤 중에 타이머 중단
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        bannerStop()
    }

    /// 스크롤 애니메이션이 완전히 끝나면 배너 시작
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        bannerMove()
    }
}

// MARK: - 보여지는 배너가 변경될 경우 호출하는 메서드
extension SheetBanner: InfiniteCollectionViewDelegate {
    func infiniteCollectionView(_ infiniteCollectionView: InfiniteCollectionView, didChangeCenteredIndexPath from: IndexPath?, to: IndexPath?) {
        guard let to = to,
              let images = images else { return }
        let realIndexPath = carouselView.indexPath(from: to)
        indexLabel.text = "\(realIndexPath.item + 1) / \(images.count)"
    }
}
