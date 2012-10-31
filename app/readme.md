# 前端功能说明

## 文件目录：
+ ### app.js
    主脚本，由Activex通过script标记插入页面。

+ ### hostname.js
     各商城的抓取设置脚本。

+ ### src
     源文件目录。

=================

## 响应的域名
+ #### 京东
    + www.360buy.com
    + book.360buy.com
    + mvd.360buy.com

+ #### 一淘和一淘商城
    + www.1mall.com
    + www.yihaodian.com

+ #### 伊藤
    + www.yiteng365.com

+ #### 淘宝
    + www.taobao.com
    + s.taobao.com
    + item.taobao.com

+ #### 天猫
    + www.tmall.com
    + list.tmall.com
    + temai.tmall.com
    + detail.tmall.com

========================

## 工作流程
脚本文件载入后，自动调用当前hostname对应的**抓取设置脚本**;

同时请求**购物车数据**，如果验证登陆未通过，则插件面板为“未登录”状态;

如果没有对应的**抓取设置脚本**，或经脚本验证当前页不是产品详细页，则插件面板为“购物车”状态;

否则验证当前页是否已存在购物车中，以决定插件面板为“添加订单”状态或“添加截图状态”。


========================

## 公开接口
+ ###oye
    本插件的命名空间

+ ###oye.dir
    根目录地址，所有的脚本、样式表和图片都从此开始寻址

    默认调试用的地址是192.168.1.42:8000

+ ###oye.screenShotCallback(Array)
    截图完成后的回调函数，由插件调用，期待一个**图片地址数组**作为参数


========================


## 服务器交互
### 数据请求地址
${oye.dir}/json/cart.jsonp

### request可用参数
+ ##### 增加一个抓取数据
    + **action: add**
    + siteName: string
    + goodsName: string
    + price: string
    + prop: string
    + img: string
    + url: string

+ ##### 删除一个商品记录
    + **action: del**
    + id: string


### response数据
+ **格式** jsonp
+ **内容**
    + **isLogin: boolean** 是否登陆
    + **list: object Array** 最新的5条商品记录
        + **id: string** 商品id
        + **goodsName: string** 商品名称
        + **img: string** 商品图片地址
        + **price: string** 商品价格
        + **prop: string** 商品属性
        + **siteNmae: string** 商城名称
        + **url: string** 商品地址
        + **pic: string Array** 商品截图列表
        + **number: int** 订购数量，默认为1









