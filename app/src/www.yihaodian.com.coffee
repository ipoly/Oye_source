$ = @oye.$
@oye.fetchMethods = {
    "siteName":"一号店"
    "goodsName":-> $("#productMainName").text()
    "price":->
        $("#nonMemberPrice:not(.price_del) strong,#productFacadePrice").text()
    "img":-> $("#productImg").attr("src")
}
