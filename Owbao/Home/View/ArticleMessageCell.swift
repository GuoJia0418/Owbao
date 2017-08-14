//
//  ArticleMessageCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/1/12.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class ArticleMessageCell: UITableViewCell,LPAutoScrollViewDatasource,LPAutoScrollViewDelegate {

    let DEFAULT_BGCOLOR = UIColorFromRGB(241, green: 241, blue: 241)
    var scrollView:LPAutoScrollView!
    var redIcon:UIImageView!
    
    var articleList: [UrgentNoticeModel] = [] {
        didSet {
            
            if articleList.count == 0 {
                return
            }
            else
            {
                self.scrollView.lp_reloadData()
            }
            
        }
    }

    //点击回调
    var jumpBlock: ((_ article: UrgentNoticeModel)->())?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createUI()
    }
    
    //MARK: - 设置UI
    func createUI()
    {
        self.contentView.backgroundColor = DEFAULT_BGCOLOR
    
        redIcon = UIImageView(frame: CGRect(x: 18, y: (30 - 12) / 2, width: 15 , height: 13))
        redIcon.image = UIImage(named: "ico_trumpet")
        self.contentView.addSubview(redIcon)
        
        
        let delayTime = DispatchTime.now() + Double(Int64(30 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            self.scrollView.lp_reloadData()
        }

        scrollView = LPAutoScrollView.init(style: LPAutoScrollViewStyleVertical)
        scrollView.lp_scrollDataSource = self
        scrollView.lp_scrollDelegate = self
        scrollView.lp_stopForSingleDataSourceCount = true
        //滚动市场
        scrollView.lp_autoScrollInterval = 3
        scrollView.backgroundColor = DEFAULT_BGCOLOR
        scrollView.lp_register(UINib.init(nibName: "ArticleMessageView", bundle: nil))
        self.contentView.addSubview(scrollView)
        
        scrollView.frame = CGRect(x: redIcon.frame.size.width + redIcon.frame.origin.x, y: 0,width: SCREEN_WIDTH, height: 30)
        scrollView.backgroundColor = DEFAULT_BGCOLOR
    }
    //MARK: - LPAutoScrollViewDatasource
    func lp_numberOfNewsData(in scrollView: LPAutoScrollView?) -> Int
    {
        
        if articleList.count != 0
        {
            return articleList.count
            
        }
        else
        {
            return 0
        }
        
    }
    func lp_scrollView(_ scrollView: LPAutoScrollView!, newsDataAt index: Int, for contentView: LPContentView!)
    {
        if contentView != nil
        {
            let contentV =  contentView as! ArticleMessageView
            contentV.titleLabel.text = articleList[index].title
        }
        
    }
    //MARK: - LPAutoScrollViewDelegate
    func lp_scrollView(_ scrollView: LPAutoScrollView?, didTappedContentViewAt index: Int) {
        
        let article = articleList[index]
        if let block  = jumpBlock
        {
            block(article)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
