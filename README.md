# ALiVideoRecorder
边录边写,不用Move文件,不用转码

#### 0、 功能简介

最近APP中用到了视频的录制功能，原有的功能是在录制视频结束之后将视频转换为mp4格式。

这种做法的一个缺点是`需要转码的时间且视频越大需要的时间就越久`，影响用户的交互

这里我们使用了边录边写的方案，具体实现可以查看[代码](https://github.com/LeeWongSnail/ALiVideoRecorder)

同时，这次我添加了`强制横屏`的做法，用户在竖屏的状态下会给用户一个提示，让用户横屏后进行录制。

这种录制方法可以自定义视频的各类属性 包含`码率`等视频属性，所以为了如果你觉得录制后的`视频过大`，可以通过修改视频写入的属性，定义输出视频的大小。

如果帮到了你，请帮我请高抬贵手，帮我[star一下](https://github.com/LeeWongSnail/ALiVideoRecorder)

下面是gif演示图

![gif演示](http://hoop8.com/1610C/DwnHZy5J.gif)



![gif演示2](http://hoop8.com/1610C/EMCI5zGW.gif)


#### 1、 功能目录

![功能目录](https://i.niupic.com/images/2016/10/13/3hhrO9.png)


#### 2、竖屏录制视频

![竖屏录制视频](https://i.niupic.com/images/2016/10/13/D7NLJg.png)

#### 3、视频录制后预览

![视频录制后预览](https://i.niupic.com/images/2016/10/13/BwrDKL.png)

#### 4、横屏录制视频

![横屏录制视频](https://i.niupic.com/images/2016/10/13/BdmigA.png)

#### 5、强制横屏标识

![强制横屏标识](https://i.niupic.com/images/2016/10/13/ogsTlO.png)


后期有时间我会详细整理出一份博客，对视频录制做一个简单的说明，以及在项目中可能遇到的一些特殊的要求。





