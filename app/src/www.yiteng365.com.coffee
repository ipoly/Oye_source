$ = @oye.$
@oye.fetchMethods = {
    "siteName":"伊藤洋华堂"
    "path":/\bcommodity\b/
    "goodsName":-> $("#commodityName").text()
    "price":->
        $("#commodityPrice").text().replace("¥","")
    "img":-> $("#bigImg").attr("src")
}
