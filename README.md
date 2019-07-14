# MapDemo


这是我要做的需求

![map.gif](https://upload-images.jianshu.io/upload_images/1682698-4bd4d218aeb6a685.gif?imageMogr2/auto-orient/strip)

+ 细化功能
☑️ 接入高德地图
✅ 通过偏移量改变透明度
✅ KVO监听实现路线视图frame的改变
✅ 滑动列表不影响地图点击
✅ 滑动结束根据偏移量确定列表最终位置(待优化)
☑️滑动结束更新地图边界
☑️点击路线视图自动切换列表偏移量(分三级)
☑️横向滑动路线视图并重新绘制地图路线

大概就这么多慢慢去实现

&emsp;&emsp;说实话，就列表滑动这一块就卡了我一个多礼拜，然后我就看到了这个兄弟的[Demo](https://github.com/WiitterSimithYU/--hipview)。
&emsp;&emsp;通过改变`tableview`的内边距，重写`hitTest:(CGPoint)point withEvent:(UIEvent *)event`方法，当`point`的`y`值小于0时，返回`nil`，这样就可以穿透`tableview`直接操作地图了。
&emsp;&emsp;当偏移量达到屏幕中间再继续向上滑动时，才根据偏移量计算透明度。
&emsp;&emsp;因为改变了内边距，所以显示路线的`view`就不能放在`tableview`上了。我的解决办法是，给`tableview`设置一个空白的`headerview`，用KVO监听`tableview`的偏移量并实时更新路线视图的`frame`。
&emsp;&emsp;实现列表滚动停止，根据偏移量来确定最终位置。我这里是将屏幕三等分作为阈值，当偏移量在屏幕上部三分之一时，列表最终会置顶。当偏移量在屏幕中间的三分之一时，列表会居中显示。当偏移量在屏幕下部三分之一时，列表会置底，只显示出路线视图。后期会根据百度地图来修改的。


*详细的还是看代码吧，里面有详细的备注。*
[Demo地址]([https://github.com/24KYang/MapDemo/tree/master](https://github.com/24KYang/MapDemo/tree/master)
)
[简书地址](https://www.jianshu.com/p/c8ef6f62b6a1)
