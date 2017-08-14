//
//  SwitchTitleView.h
//  切换视图
//
//  Created by guojia on 8/6/15.
//  Copyright (c) 2015 guojia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwitchTitleViewDelegate;

@interface SwitchTitleView : UIView<UIScrollViewDelegate>

/** 按钮之间的间隔,如果不设置默认是15,若按钮比较少并且不设置间隔的话，会有自动排版的效果，最好别设置 */
@property(nonatomic,assign)NSUInteger titleBtnMargin;

/** 顶部bar的高度,如果不设置默认是30(如果低于30无效)，假设需要更低，自行修改 */
@property(nonatomic,assign)CGFloat titleBarHeight;

/** 顶部bar的颜色,如果不设置模式是[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:0.5f] */
@property(nonatomic,retain)UIColor *titleBarColor;

/** 按钮的字体大小,如果不设置默认是15 */
@property(nonatomic,assign)CGFloat btnTitlefont;

/** 按钮的字体颜色,如果不设置默认是黑色 */
@property(nonatomic,retain)UIColor *btnNormalColor;

/** 按钮选中字体颜色,如果不设置默认是绿色 */
@property(nonatomic,retain)UIColor *btnSelectedColor;

/** 按钮选中背景图片*/
@property(nonatomic,retain)UIImage *btnSelectedBgImage;

/** 按钮正常背景图片*/
@property(nonatomic,retain)UIImage *btnNormalBgImage;


@property (nonatomic, weak) IBOutlet id<SwitchTitleViewDelegate> titleViewDelegate;

/**
 * 若想创建左边特殊按钮,比如一起动左边的国旗,需要用该特殊方法,调用其他的方法不创建特殊按钮
 */
- (instancetype)initWithFrame:(CGRect)frame createLeftSpecialBtn:(BOOL)iscreate;

/** 这个方法要在设置好控制器后在调用 */
- (void)reloadData;

- (UIButton *)leftButton;

@end

@protocol SwitchTitleViewDelegate <NSObject>

@required

- (NSUInteger)numberOfTitleBtn:(SwitchTitleView *)View;

- (UIViewController *)titleView:(SwitchTitleView *)View viewControllerSetWithTilteIndex:(NSUInteger)index;

@optional

- (void)titleView:(SwitchTitleView *)View didselectTitle:(NSUInteger)number;

- (void)titleView:(SwitchTitleView *)View specialBtnDidSelect:(UIButton *)btn;

@end


/*** 如果想在titleBtn下面弄个下滑线,给titleBtn设置一个背景图片就行了 */

/**
 
 1.例子:
SwitchTitleView *view = [[SwitchTitleView alloc] init];
view.titleViewDelegate = self;
view.frame = CGRectMake(0, 0, 320,300);
[self.view addSubview:view];
 
UIViewController *ctrl = [[UIViewController alloc] init];
ctrl.title = @"xxxx";
[self addChildViewController:ctrl.title];//如果想要push效果 需加上
[view reloadData];//要放在最下面调用

 #pragma delegate
 - (NSUInteger)numberOfTitleBtn:(SwitchTitleView *)View
 {
 return 1;
 }
 - (UIViewController *)titleView:(SwitchTitleView *)View viewControllerSetWithTilteIndex:(NSUInteger)index
 {
 if (index == 0) {
 return self.ctrl1;
 
 }
 return nil;
 }
 
 2.或者用xib和storyboard直接约束,然后需要调用下reloadData,完成代理.
 3.IOS7以上(且使用autolayout的）需要在控制器里面将automaticallyAdjustsScrollViewInsets属性设置为NO。[原因是标题滚动按钮没进行约束]
 4.如果有bug,自行调调约束
*/
