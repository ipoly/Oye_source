$ = @oye.$
@oye.fetchMethods = {
    "siteName":"京东"
    "path":/\d+\.html$/
    "goodsName":->
        el = $("#name h1").clone()
        el.find("*").remove()
        el.text()
    "price":-> $("#priceinfo").html().replace(/[^\d.]/g,"")
    "prop":->
        el = $("#summary").clone()
        el.find(".hide").remove()
        el.text().replace(/(\s*\n)+/g,"|")
    "img":-> $("#spec-n1 img").attr("src")
}
