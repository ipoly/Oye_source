$ = @oye.$
@oye.fetchMethods = {
    "siteName":"一号商城"
    "path":/\bproduct\b/
    "goodsName":-> $("#productMainName").text()
    "price":->
        $("#nonMemberPrice:not(.price_del) strong,#productFacadePrice").text()
    "prop":->
        $("#seriesShow td:last()").text()
    "img":-> $("#productImg").attr("src")
}
