# @codekit-prepend jquery
# @codekit-prepend juicer
# @codekit-prepend fancybox
# @codekit-prepend fancybox-thumbs

# oye对象在jquery内定义。
win = @
o = @oye
$ = o.$
$ ->
    # 文件根目录
    o.dir ?= "http://192.168.1.42:8000"
    # 购物车数据缓存
    o.cartData = {status:{action:"",Error:"",msg:""},list:[]}
    # session刷新频率
    o.sessionTimeout = 20
    $("head").append("<link rel='stylesheet' type='text/css' href='#{o.dir}/main.css' media='all' />")
    $("head").append("<link rel='stylesheet' type='text/css' href='#{o.dir}/source/jquery.fancybox.css' media='all' />")
    $("head").append("<link rel='stylesheet' type='text/css' href='#{o.dir}/source/helpers/jquery.fancybox-thumbs.css' media='all' />")

    # 载入对应的抓取脚本
    $.ajaxSetup({scriptCharset:"utf-8"})
    $.getScript("#{o.dir}/#{location.hostname}.js").done(-> ui.addClass("canFetched") )

    templates = {
        ui:"""
            <div class="oye_ui">
                <a id="oye_logo" href="http://www.oye.com"></a>
                <div id="oye_notice"></div>
                <form class="oye_cart" action="http://www.qq.com" target="_blank" method="get"></form>
                <div class="oye_panel"> </div>
            </div>
        """

        # 购物车列表面板
        cart: juicer("""
            <table>
                <caption>测试：${timeMark}</caption>
                <thead>
                    <tr>
                        <td></td>
                        <td>代购商品</td>
                        <td>商城</td>
                        <td>代购数量</td>
                        <td>操作</td>
                    </tr>
                <thead>
                <tbody>
                {@each list as item}
                    <tr>
                        <th><a href="${item.url}" title="${item.goodsName}"><img src="${item.img}"/></a></th>
                        <td><a href="${item.url}" title="${item.goodsName}">${item.goodsName}</a></td>
                        <td>${item.siteName}</td>
                        <td>
                            <input name="id" type="hidden" value="${item.CartID}"/>
                            <input data-id="${item.CartID}" name="number" type="number" value="${item.number}"/>
                        </td>
                        <td><span data-id="${item.CartID}">删除</span></td>
                    </tr>
                {@/each}
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="5">
                            <button type="submit" id="oye_submit"></button>
                            <p>查看操作完整购物车，请前往 <a href="">噢叶商城购物车</a></p>
                        </td>
                    </tr>
                </tfoot>
            </table>
        """)

        # 未登陆
        panel0:"""<span class="lh40">点我 <a href="http://www.oye.com/user.php?act=default">登录</a> 以使用代购功能</span>"""

        # 当前页已在购物车中
        panel1:juicer("""
            <a title="查看购物车" class="oye_icon oye_icon_cart"><i class="oye_cart_part"></i><span class="oye_inCart">${list.length}</span></a>
            <a title="查看截图" class="oye_icon oye_icon_img"><span class="oye_inPic">${current.pic.length}</span></a>
            <a title="添加截图" class="oye_icon oye_icon_camera" id="oye_screenshot"></a>
        """)

        # 当前页不在购物车中
        panel2:juicer("""
            <a title="查看截图" class="oye_icon oye_icon_cart"><i class="oye_cart_part"></i><span class="oye_inCart">${list.length}</span></a>
            <button title="立即订购" type="button" id="oye_add"></button>
        """)

        # 当前页不是商品详细页
        panel3:juicer("""
            <a title="查看购物车" class="oye_icon oye_icon_cart"><i class="oye_cart_part"></i><span class="oye_inCart">${list.length}</span></a>
        """)
    }

    # 定义ui
    ui = $(templates.ui)
    # 定义显示与隐藏事件
    .on("show hide",(e)-> $(@)[e.type]())
    # 获取数据
    .on("click","#oye_add",-> o.trigger("fetchdata"))
    # 删除商品
    .on("click","span[data-id]",->
        data = {}
        data.CartID = $(@).data("id")
        data.action = "del"
        o.trigger("cartReload",data)
    )
    # 调用截图插件
    .on("click","#oye_screenshot",->
        trigger = $("#oye_shot")
        if trigger.length
            trigger[0].click()
        else
            # 测试用数据
            o.screenShotCallback([
                "http://pic.cnhan.com/uploadfile/2012/0905/20120905040655740.jpg",
                "http://pic.cnhan.com/uploadfile/2012/0905/20120905040700746.jpg",
                "http://pic.cnhan.com/uploadfile/2012/0905/20120905040700342.jpg",
                "http://pic.cnhan.com/uploadfile/2012/0905/20120905040831340.jpg",
                "http://pic.cnhan.com/uploadfile/2012/0905/20120905040832569.jpg",
                "http://pic.cnhan.com/uploadfile/2012/0905/20120905040832588.jpg",
                "http://pic.cnhan.com/uploadfile/2012/0905/20120905040833724.jpg"
            ])
    )
    # 打开截图浏览
    .on("click",".oye_icon_img",->
        return unless o.cartData.current.pic.length
        ui.trigger("hide")
        $.fancybox.open(o.cartData.current.pic,{
            helpers : {
                    thumbs : {
                        width  : 50,
                        height : 50
                    }
            },
            afterClose:->
                ui.trigger("show")
        })
    )
    .on("keyup","input[type=number]",->
        t = $(@)
        t.val(0) unless Number(t.val())
    )
    # 显示购物车列表
    .on("hover",".oye_icon_cart,.oye_cart",(e)->
        cart = $(".oye_cart")
        icon = $(".oye_icon_cart")
        clearTimeout(o.timer)
        type = e.type
        o.timer = setTimeout(
            ->
                if type is "mouseenter"
                    cart.show()
                    icon.addClass("active")
                else
                    cart.hide()
                    icon.removeClass("active")
        ,300)
    )
    # 刷新ui面板
    .on("refresh",(e,data)->
        t = $(@)
        panel = t.find(".oye_panel")
        cart = t.find(".oye_cart")
        cart.html(templates.cart.render(data))

        # 判断是否登陆,Error==1 表示未登陆
        return panel.html(templates.panel0) if data.status.Error is 1

        # 判断当前页是否商品详细页
        if !o.fetchMethods or !o.fetchMethods.path.test(location.href)
            return panel.html(templates.panel3.render(data))

        # 判断当前页是否已在购物车中
        data.current = i for i in data.list when i?.url is location.href
        console.log data
        if data.current
            $("#oye_id").val(data.current.CartID)
            panel.html(templates.panel1.render(data))
        else
            panel.html(templates.panel2.render(data))

    )
    # 消息提示
    .on("alert",(e,data)->
        return unless data?
        n = $(@).find("#oye_notice")
        n.html(data)
        clearTimeout(o.alertTimer)
        n.stop(true,true).fadeIn()
        o.alertTimer = setTimeout(->
            n.fadeOut()
        ,3000)
    )

    $("body").append(ui)

    # 使用jquery的事件绑定来扩展oye对象
    o.on = ->
        $.fn.on.apply($(@),arguments)

    o.trigger = ->
        $.fn.trigger.apply($(@),arguments)

    o.off = ->
        $.fn.off.apply($(@),arguments)

    # 抓取数据
    o.on("fetchdata",->
        data = {}
        for own name,value of o.fetchMethods
            data[name] = if $.type(value) is "function" then value() else value

        data.url = win.location.href
        data.action = "AddCart"
        data.number = 1
        delete data.path
        @trigger("cartReload",data)
    )
    # 刷新购物车数据
    .on("cartReload",(e,data)->
        cartData = o.cartData
        para = {action:"Cartlist"}
        $.extend(para,data)
        cartData.status.action = para.action
        $.getJSON(
            "http://www.oye.com/api/plugins.php?callback=?",
            para,
            (data)->
                if data.Error
                    $.extend(cartData.status,data)
                    ui.trigger("alert",data.msg)
                else
                    cartData.list = data
                    if cartData.status.action is "AddCart"
                        ui.trigger("alert","恭喜您！商品已加入购物车。点这里可以添加截图哟&darr;")
                    if cartData.status.action is "DelCart"
                        ui.trigger("alert","商品已删除。")
                cartData.timeMark = (new Date()).toLocaleTimeString()
                ui.trigger("refresh",cartData)
        )
    )
    .trigger("cartReload")

    # 刷新数据避免session过期
    setInterval((->o.trigger("cartReload")),1000*60*o.sessionTimeout)


    # 截屏回调
    o.screenShotCallback = (data)->
        if data.Error
            ui.trigger("alert",data.msg)
        else
            @cartData.timeMark = (new Date()).toLocaleTimeString()
            @cartData.current.pic = data
            ui.trigger("refresh",@cartData)
            ui.trigger("alert","恭喜您！截图已添加。")











