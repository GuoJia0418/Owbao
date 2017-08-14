//
//  NoticeCell.swift
//  hyq2.0
//
//  Created by iOS on 15/8/31.
//  Copyright © 2015年 HYQ. All rights reserved.
//

import UIKit

class NoticeCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let layout = flowLayout()
    var jumpBlock: ((_ article: UrgentNoticeModel)->())?
    var currentIndex: Int = 0
    var timer: Timer?
    var articleList: [UrgentNoticeModel] = [] {
        didSet {

            if articleList.count == 0 {
                return
            }
            if articleList.count == 1 {
                return
            
            }
            // 滚动到第一cell
            collectionView.scrollToItem(at: IndexPath(item:  1, section: 0), at: UICollectionViewScrollPosition.centeredVertically, animated: false)
            startTimer()
            
        }
    }
    
    class func nib() -> UINib {
        return UINib(nibName: "NoticeCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = UITableViewCellSelectionStyle.none
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CycleViewCell.nib(), forCellWithReuseIdentifier: "CycleViewCell")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.collectionViewLayout = layout
    }

    // MARK: - 数据源方法
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return articleList.count

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
//        print("输出点击的item \(indexPath.item)")
        let article = articleList[indexWithOffset(indexPath.item)]
        if let block  = jumpBlock
        {
            block(article)
        }  
    }
    func indexWithOffset(_ offset: Int) -> Int {
        return (currentIndex + offset - 1 + articleList.count) % articleList.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CycleViewCell", for: indexPath) as! CycleViewCell
        
        cell.article = articleList[indexWithOffset(indexPath.item)]

        return cell;
        
    }
    // MARK: - scrollview的代理方法
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = Int(scrollView.contentOffset.y / scrollView.bounds.size.height)
        currentIndex = indexWithOffset(offset)
        // 滚动到第一cell
        let indexPath  = IndexPath(item: 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredVertically, animated: false)
        UIView.setAnimationsEnabled(false)
        collectionView.reloadItems(at: [indexPath])
        UIView.setAnimationsEnabled(true)
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    // MARK: - 时钟方法
    func startTimer() {
        if let _ = timer {
            return
        }
        timer =  Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(NoticeCell.fire), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    /** 时钟触发方法 */
    func fire() {
    // 取出当前显示cell
        let indexPath = collectionView.indexPathsForVisibleItems.last
    // 显示下一张
        if articleList.count >= 3 {
               
            let item = (((indexPath?.item)! + 1) == articleList.count) ?  (articleList.count - 1) : ((indexPath?.item)! + 1)
            collectionView.scrollToItem(at: IndexPath(item: item, section: 0), at: UICollectionViewScrollPosition.centeredVertically, animated: true)
            
        } else {
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionViewScrollPosition.centeredVertically, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
                self.scrollViewDidEndDecelerating(self.collectionView)
        })
    }
    func stopTimer() {
        timer!.invalidate()
        timer = nil;
    }
}

// 自定义流水布局
private class flowLayout: UICollectionViewFlowLayout {
    
    // 2. 如果还没有设置 layout，获取数量之后，准备cell之前，会被调用一次
    // 准备布局属性
    fileprivate override func prepare() {
        itemSize = collectionView!.bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.vertical
        
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.bounces = false
    }
    
    //    func jumpBtnAction(btn: UIButton) {
    //        let article = articleList[btn.tag]
    //
    //        print("**())**-\(btn.tag)")
    //        print("**())**-\(btn.tag)")
    //        dump(article)
    //        if let block  = jumpBlock {
    //            block(article: article)
    //        }
    //
    //    }

    
}
