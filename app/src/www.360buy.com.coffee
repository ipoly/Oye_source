$ = @oye.$
@oye.fetchMethods = {
    "siteName":"京东"
    "path":/product/
    "goodsName":-> pageConfig?.product?.name
    "price":-> pageConfig?.product?.price
    "prop":->
        el = $("#choose-result .dd").clone()
        el.find("em").remove()
        el.text()
    "img":-> $("#spec-n1 img").attr("src")
}
