title: Android/iOS/Web布局对比解析
date: 2019-01-01 00:00:00
categories: Tips
tags: [iOS, Android, Web]

---

## Github

代码参考 [GitHub-LayoutSample](https://github.com/AlanLi7991/LayoutSample)

## 布局

| 界面    | 要求    |
| :------------ | :------------ |
| Red      |   1. 与屏幕等宽<br>2. 高度100px(dp)<br>3. 位于底部    |
| Yellow   |   1. 与屏幕等宽<br>2. 高度占比20%<br>3. 位于Red上方    |
| Blue     |   1. 与屏幕等宽<br>2. 高度可拉伸至填满屏幕<br>3. 位于Yellow上方    |
| Fix      |   1. 固定宽高<br>2. 水平分布于Red<br>3. 四个水平间距自由拉伸、相等、填满屏幕宽度    |
| Stretch  |   1. 宽高都可以拉伸<br>2. 水平分布于Yellow<br>3. 四个水平间距、两个上下间距固定    |
| Image    |   1. 宽高都是Blue的50%<br>2. 位于Blue水平垂直中心<br>3. 两个水平间距、两个上下间距拉伸 |


## 代码组成

根据不停的平台，尽量尝试了不同的功能模块来实现进行对比

| 平台    | 功能模块    |
| :------------ | :------------ |
| iOS      |   1. AutoLayout(Anchor) |
| Android  |   1. ConstraintLayout <br> 2. LinearLayout <br> 3. RelativeLayout   |
| Web      |   1. FlexLayout    |

## iOS

### 细节特点

核心公式  **first = second × Multiple + Constant**

在iOS的 AutoLayout 中，大部分间距计算依赖于屏幕尺寸，无法在ViewDidLoad完成，例如Red+Fix

但是使用了 StackView 或者使用一个 Container 来处理，就可以规避这个问题

### 基本界面思路

1. 约束RedView的高为100，并且左、右、下三个边距贴紧屏幕
2. 约束YellowView的高为屏幕高度的0.2倍，并且左、右两个边距贴紧屏幕、下边距贴紧RedView的上边距
3. 约束BlueView的左、右、上三个边距贴紧屏幕，下边距贴紧YellowView的上边距
4. 约束ImageView中心点X、Y等同于BlueView，并且约束其宽、高均为BlueView的50%

而黄色和红色内部的布局是iOS的界面思路难点

1. 要满足红色内固定元素的要求，根据AutoLayout远离，我们需要知道间距的大小
2. 需要间距的大小导致必须在 ViewController 已经探测到实际Frame后才能计算出来

或者可以换一种思路，可以 **避开对RedView宽度已知的要求**

1. 三个Container直接均分整个宽度
2. 然后在 Container 的中心放置FixView

对于黄色内部布局思路难点在于

1. 已知整个宽度上被固定间距占去的大小为 4*Gap
2. 剩下的宽度要由三个Stretch均分
3. 那么左右的 Stretch 的宽度为 1/3屏幕宽度减去 1.5倍的间距
4. 中心的 Stretch 中心 X 坐标一定等于YellowView，而宽度为 1/3屏幕宽度减去一个间距
5. 被减去的间距一共是 1.5+1+1.5 = 4 

## Android

### 细节特点

LinearLayout的权重公式 **Weight × (Parent - Constant)/SumWeight**

与 ConstraintLayout 不同 RelativeLayout 无法按百分比约束Image

如果使用 PureCode 进行 Layout 需要严格的生命周期和id，需要注意一下几点

1. View.inflate() 第三个属性不能是root，因为设置的id没有生效，导致 ConstraintSet 无法生效
2. 设置id 有两种方式，写在XML里或者通过属性设置
3. 对于不设置 id 的 View 在 ConstraintSet 里会导致Crash

### 基本界面思路

1. 使用ConstraintLayout来对R、Y、B三个View进行布局
2. 使用LinearLayout来对RedView、YellowView的内部进行布局
3. 使用RelativeLayout来对BlueView的内部进行布局

通过配置XML的attribute处理Red、Yellow、Blue的布局

1. 设定ConstraintLayout的宽高均为 match_parent 来获得屏幕大小
2. 设定R、Y、B的 layout_width="match_parent" 来获取和屏幕等宽
3. 设置Y、B的 layout_height="0dp" 来让高度约束生效
4. 设定RedView的 Bottom_toBottomOf="parent"、layout_height="100dp" 获得固定高度对其底部
5. 设定YellowView的 Bottom_toTopOf="@id/red"、constraintHeight_percent="0.2" 获得屏幕20%高度，并且贴近Red顶部
6. 设定BlueView的 Top_toTopOf="parent"、Bottom_toTopOf="@id/yellow" 来填充剩余空间

然后通过LinearLayout来处理Fix

1. 设定 LinearLayout 的 orientation="horizontal" 来获取水平布局
2. 依次间隔排列四个 space 元素 和 3个 view 元素
3. 设定每个view元素的 layout_gravity="center" 使其在 vertical 方向居中
4. 设定每个view元素的宽高为固定大小
5. 设定每个space元素的 layout_width="0dp"、layout_height="0dp"使其宽高均可自适应
6. 设定每个space元素的 layout_weight="1" 代表其布局权重为1
7. 所有7个元素的权重排列为 1 0 1 0 1 0 1
8. 由于view有固定宽高，当RedView的宽度减去三个固定的Fix宽度后，剩余宽度按权重分配给space元素
9. 每个 space 获得的宽度为 1/(1+0+1+0+1+0+1) = 1/4

然后通过LinearLayout来处理 Stretch 

1. 设定 LinearLayout 的 orientation="horizontal" 来获取水平布局
2. 依次间隔排列四个 space 元素 和 3个 view 元素
3. 设定每个 space 的 layout_width="10dp"、layout_height="0dp" 来固定宽度和高度自适应
4. 设定每个 view 的 layout_weight="1" 来获得剩余宽度的分配权重
5. 设定每个 view 的 layout_width="match_parent"、layout_height="match_parent" 来尽量拉伸
6. 设定每个 view 的 margin-top 和 margin-bottom 为10dp获取上下间距
7. 所有7个元素的权重排列为 0 1 0 1 0 1 0
8. 由于 space 有固定宽度， 当 YellowView宽度减去四个space的宽度后，剩余宽度按权重分配
9. 每个 view 获得的宽度为 1/（0+1+0+1+0+1+0）= 1/3

最后处理图片元素，图片元素布局推荐使用 ConstraintLayout ，这里使用 RelativeLayout 来对比两者区别

1. 设定 image 元素 layout_centerInParent="true" 来达到居中效果
2. 和 ConstraintLayout 区别在于，无法使用百分比约束宽高


## Web

### 细节特点

FlexLayout拉伸权重公式 **Weight × MAX(Parent, (Parent - Constant))/SumWeight**

和 Android、iOS 不同， Web 主页面  Scroll 因为可以无限滚动不存在屏幕尺寸边界，所以使用 100vh（Visual Height） 来限制高度，vh代表可视区域

在间距问题上，不同于 iOS 和 Android， FlexLayout 有CSS属性 justify-content: space-evenly 可以专门来处理间距

FlexLayout 和 AndroidLinearLayout 都存在权重的概念，但是有细微的差别

### 基本界面思路

1. 设定一个 Container Div 的Height等于100vh（100 Visual Height）
2. 如果没有 Container Div 无法获取到屏幕下边缘，因为Web页面是可以无限延展的（除非使用Float）
3. Red、Yellow、Blue 三个呈上下排列，所以应该使用 flex-direction: column
4. 由于 flex-direction: column Red、Yellow、Blue 的 flex 约束的是 height

flex布局的难点在于理解权重的作用，权重分为拉伸权重（grow）和缩小权重（shrink），使用 flex: grow shrink number 来表达

1. 设置 Red 的 flex: 0 1 100px 代表grow = 0 不能拉伸，shrink = 1 缩小权重为1， 固定 100px 的 height
2. 设置 Yellow 的 flex: 0 1 20vh 代表不能拉伸，缩小权重为1，固定20%可视屏幕宽度的高
3. 设置 Blue 的 flex: 1 1 auto 代表拉伸权重为1 缩小权重为1 高度auto
4. 由于grow权重的分配 R:Y:B = 0:0:1 就代表 Red、Yellow不会改变大小，而Blue占剩余空间的 1/(0+0+1) = 1
5. 由于shrink权重的分配 R:Y:B = 1:1:1 就代表 Red、Yellow、Blue各占剩余空间（也是总空间）的 1/(1+1+1) = 1/3

从R、Y、B的权重分析我们可以看到，在某个 display:flex 的布局中，布局的思路就是

1. 整个flex的总空间 - 固定空间 = 剩余空间
2. 在剩余空间有冗余的时候，按照权重来放大和缩小
3. 如果想固定长度，就把权重设置为 0

完成了Red、Yellow、Blue的布局后，接下来开始处理 Fix

1. 为了完成Fix的效果，需要RedView属性和子元素Fix属性 互相配合
2. 设置RedView的 display: flex ，其默认 flex-direction 为 row
3. 当RedView的 flex-direction=row 时, 其 cross-axis 即为 column 方向
4. 设置RedView的 align-items: center 保持内部子元素在cross-axis为水平
5. 设置RedView的 justify-content: space-evenly 来控制子元素间距
6. 设置子元素class fix的 width: 80px height 80px 来保持固定大小

接下来开始处理Stretch属性

1. 为了完成Stretch的效果，需要YellowView属性和子元素Stretch属性互相配合
2. 设置YellowView的 display: flex ，其默认 flex-direction 为 row
3. 设置子元素Stretch的属性 flex: 1 1 auto 代表拉伸缩小权重均为1 宽度自适应
4. 设置子元素Stretch的属性 height: auto 代表高度也自适应
5. 根据flex权重分配，三个Stretch的均占用 1/(1+1+1) = 1/3的row向mian-axis空间
6. 调整不同位置Stretch的margin，来达到固定间距10px的效果

最后对图片的位置进行处理

1. 为了完成图片居中并且正方形的效果，需要BlueView和图片子元素互相配合
2. 设置BlueView的 display: flex
3. 设置BlueView的 align-items: center; justify-content: center; 达到居中效果
4. 使用百分比设置图片 width: 50% 来使用 BlueView 一半的宽度
5. 使用 object-fit: cover 来使图片达到正方形Square的效果





