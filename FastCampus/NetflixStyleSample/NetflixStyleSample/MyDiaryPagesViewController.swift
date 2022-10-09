//
//  PageSelectViewController.swift
//  NetflixStyleSample
//
//  Created by DongKyu Kim on 2022/10/07.
//

import SnapKit
import UIKit

class MyDiaryPagesViewController: UIViewController {
    
    // private let device = UIScreen.getDevice()
    let dummyPageCount = Int.random(in: 3...5)
    private var previousOffset: CGFloat = 0
    private var currentPage: Int = 1 {
        didSet {
            if currentPage == 0 {
                currentPage = 1
            } else if currentPage > dummyPageCount {
                currentPage = dummyPageCount
            }
            self.dayLabel.text = "\(currentPage)일차"
        }
    }
    private let itemSpacing: CGFloat = 20
    
    private lazy var myPagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = itemSpacing
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width - 100, height: view.frame.height / 1.61)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .systemGray4
        collectionView.register(MyDiaryPagesViewCollectionViewCell.self, forCellWithReuseIdentifier: "MyDiaryPagesViewCollectionViewCell")
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false
        
        return collectionView
        
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "🌊포항항"
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "1일차"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var previousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var pager: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = dummyPageCount
        pageControl.currentPage = 0
        
        pageControl.pageIndicatorTintColor = UIColor.systemGray
        pageControl.currentPageIndicatorTintColor = UIColor.systemRed
        return pageControl
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemGray4
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        
        let copyButton = UIBarButtonItem(image: UIImage(systemName: "doc.on.doc"), style: .plain, target: self, action: #selector(copyButtonTapped))
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(menuButtonTapped))
        navigationItem.rightBarButtonItems = [copyButton, menuButton]
        
        collectionViewSetup()
        componentsSetup()
        
    }
    
    private func collectionViewSetup() {
        
        view.addSubview(myPagesCollectionView)
        myPagesCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.centerY.equalToSuperview().offset(55)
            $0.height.equalToSuperview().dividedBy(1.6)
        }
    }
    
    private func componentsSetup() {
        [titleLabel, dayLabel, previousButton, nextButton].forEach {
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(myPagesCollectionView)
            $0.bottom.equalTo(dayLabel.snp.top).offset(-20)
        }
        
        dayLabel.snp.makeConstraints {
            $0.leading.equalTo(myPagesCollectionView)
            $0.bottom.equalTo(myPagesCollectionView.snp.top).offset(-30)
        }
        
        previousButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalTo(myPagesCollectionView)
        }
        
        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(myPagesCollectionView)
        }
    }
    
    // MARK: - Actions
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func copyButtonTapped() {
        UIPasteboard.general.string = "복사된 텍스트 입니다."
        
        let ac = UIAlertController(title: "초대코드 복사 완료!", message: "", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    @objc func menuButtonTapped() {
        print("menu Button Tapped!")
    }
    
    @objc func previousButtonTapped() {
        if self.currentPage != 1 {
            let newXPoint = self.myPagesCollectionView.contentOffset.x - self.myPagesCollectionView.frame.width - self.itemSpacing
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .allowUserInteraction, animations: {
                    self.myPagesCollectionView.setContentOffset(CGPoint(x: newXPoint, y: 0), animated: true)
                }, completion: { completed in
                    if completed {self.currentPage -= 1}
                })
            }
        }
    }
    
    @objc func nextButtonTapped() {
        if self.currentPage != self.dummyPageCount {
            let newXPoint = self.myPagesCollectionView.contentOffset.x + self.myPagesCollectionView.frame.width + self.itemSpacing
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .allowUserInteraction, animations: {
                    self.myPagesCollectionView.setContentOffset(CGPoint(x: newXPoint, y: 0), animated: true)
                }, completion: { completed in
                    if completed {self.currentPage += 1}
                })
            }
        }
    }
}

// MARK: - Extensions
extension MyDiaryPagesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyPageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyDiaryPagesViewCollectionViewCell", for: indexPath)
        
        cell.backgroundColor = .systemGray
        return cell
    }
    
}

extension MyDiaryPagesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension MyDiaryPagesViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let point = self.targetContentOffset(scrollView, withVelocity: velocity)
        targetContentOffset.pointee = point
        
        UIView.animate(withDuration: 0.2, delay: 0.2, usingSpringWithDamping: 0, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
            self.myPagesCollectionView.setContentOffset(point, animated: true)
        }, completion: nil)
    }
    
    func targetContentOffset(_ scrollView: UIScrollView, withVelocity velocity: CGPoint) -> CGPoint {
        
        guard let flowLayout = myPagesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        
        if previousOffset > myPagesCollectionView.contentOffset.x && velocity.x < 0 {
            currentPage = currentPage - 1
        } else if previousOffset < myPagesCollectionView.contentOffset.x && velocity.x > 0 {
            currentPage = currentPage + 1
        }
        
        let additional = (flowLayout.itemSize.width + flowLayout.minimumLineSpacing)
        
        let updatedOffset = (flowLayout.itemSize.width + flowLayout.minimumLineSpacing) * CGFloat(currentPage) - additional
        
        previousOffset = updatedOffset
        
        return CGPoint(x: updatedOffset, y: 0)
    }
}
