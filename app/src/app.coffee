# @codekit-prepend jquery
# @codekit-prepend juicer
# @codekit-prepend fancybox
# @codekit-prepend fancybox-thumbs

# oye对象在jquery内定义。
win = @
o = @oye
$ = o.$
$ ->
    o.dir ?= "http://192.168.1.42:8000"
    $("head").append("<link rel='stylesheet' type='text/css' href='#{o.dir}/main.css' media='all' />")
    $("head").append("<link rel='stylesheet' type='text/css' href='#{o.dir}/source/jquery.fancybox.css' media='all' />")
    $("head").append("<link rel='stylesheet' type='text/css' href='#{o.dir}/source/helpers/jquery.fancybox-thumbs.css' media='all' />")

    # 载入对应的抓取脚本
    $.ajaxSetup({scriptCharset:"utf-8"})
    $.getScript("#{o.dir}/#{location.hostname}.js").done(-> ui.addClass("canFetched") )

    templates = {
        ui:"""
            <div class="oye_ui">
                <form class="oye_cart" action="http://www.qq.com" target="_blank" method="get"></form>
                <div class="oye_panel">
                    请<a href="">登录</a>以使用购物车
                    <button type="button" id="oye_add">一键代购</button>
                </div>
            </div>
        """

        cart: juicer("""
            <table>
                <thead>
                    <tr>
                        <td>代购商品</td>
                        <td>商城</td>
                        <td>代购数量</td>
                        <td>操作</td>
                    </tr>
                <thead>
                <tbody>
                {@each _ as item}
                    <tr>
                        <th><a href="${item.url}" title="${item.goodsName}">${item.goodsName}</a></th>
                        <td>${item.siteName}</td>
                        <td><input name="number" type="number"/></td>
                        <td><span data-id="${item.id}">删除</span></td>
                    </tr>
                {@/each}
                </tbody>
            </table>
        """)

        panel0:"""请<a href="">登录1</a>以使用购物车"""

        panel1:juicer("""
            <button type="button" id="oye_screenshot">添加截图</button>
            <span class="oye_icon oye_inPic">${current.pic.length}</span>
            <span class="oye_icon oye_inCart">${list.length}</span>
        """)

        panel2:juicer("""
            <button type="button" id="oye_add">一键代购</button>
            <span class="oye_icon oye_inCart">${list.length}</span>
        """)
    }

    # 定义ui
    ui = $(templates.ui)
    # 定义显示与隐藏事件
    .on("show hide",(e)-> $(@)[e.type]())
    # 获取数据
    .on("click","#oye_add",-> o.trigger("fetchdata"))
    # 调用截图插件
    .on("click","#oye_screenshot",->
        trigger = $("#oye_trigger")
        if trigger.length
            trigger.trigger("click")
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
    .on("click",".oye_inPic",->
        return if o.cartData.current.pic
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
    # 显示购物车
    .on("mouseenter",".oye_inCart",->
        $(@).closest(".oye_ui").find(".oye_cart").slideDown()
    )
    # 隐藏购物车
    .on("mouseleave",->
        $(@).find(".oye_cart").slideUp()
    )
    # 刷新ui面板
    .on("refresh",(e,data)->
        t = $(@)
        panel = t.find(".oye_panel")
        cart = t.find(".oye_cart")

        return panel.html(templates.panel0) unless data.isLogin

        data.current = i for i in data.list when i?.url is location.href
        if data.current
            panel.html(templates.panel1.render(data))
        else
            panel.html(templates.panel2.render(data))

        cart.html(templates.cart.render(data.list))
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
        delete data.path
        @trigger("cartReload",data)
    )
    # 刷新购物车数据
    .on("cartReload",(e,data)->
        $.ajax({
            url:"#{@dir}/json/cart.jsonp"
            data
            dataType:"jsonp"
            jsonpCallback:"jsonp_getCart"
            success:(data)->
                o.cartData = data
                ui.trigger("refresh",arguments)
        })
    )
    .trigger("cartReload")


    # 截屏回调
    o.screenShotCallback = (data)->
        @cartData.current.pic = data
        ui.trigger("refresh",@cartData)










