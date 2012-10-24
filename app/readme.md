# 前端功能说明

## 文件目录：
+ ###app.js
    主脚本，由Axtivex通过script标记插入页面。

+ ###hostname.js
     各商城的抓取设置脚本。

+ ###src
     源文件目录。

## 工作流程
脚本文件载入后，自动调用当前hostname对应的**抓取设置脚本**，如果没有对应的脚本，则只显示“截图订单”按钮。

截图订单的图片数据采用**base64**格式传输；

抓取的商品图片使用其原本的图片路径传输；

商户名称和商品地址，不在用户界面内显示，用隐藏的表单项传输；


## 公开接口
+ ###oye
    本插件的命名空间

+ ###oye.dir
    根目录地址，所有的脚本、样式表和图片都从此开始寻址

    默认调试用的地址是192.168.1.42:8000

+ ###oye.screenShot()
    覆盖它以设置启动截图的方法

+ ###oye.screenShotCallback(o)
    截图完成后的回调函数，期待一个对象作为参数

    *o.img_path* :截图在本地的缓存地址

    *o.img_64* :截图的base64值

## 私有接口
+ ###oye.ui
    jqDom对象，本插件的ui根节点

+ ###oye.tmpFetch
    已编译的juicer模板，用于抓取数据的展示

+ ###oye.tmpFetchFail
    已编译的juicer模板，用于抓取失败的展示

+ ###oye.tmpShot
    已编译的juicer模板，用于截图订单的展示

+ ###oye.fetch()
    数据抓取方法，返回值为商品信息数据对象

+ ###oye.popUp(dom)
    弹出窗方法，用于显示结果，参数为文本或者dom对象

+ ###oye.checkRequired(data)
    数据验证方法，**data**为商品信息数据对象，返回true或fasle

    验证失败时会有log信息供调试

+ ###oye.rePosition()
    刷新弹出窗位置














