import Kitura
import LoggerAPI
import HeliumLogger
import KituraStencil

HeliumLogger.use()
let router = Router()

router.setDefault(templateEngine: StencilTemplateEngine())
router.all("/static", middleware: StaticFileServer())


router.get("/") {
    request, response, next in
    try response.render("blog", context: [:])
    next()
}

router.get("/work") {
    request, response, next in
    try response.render("work", context: [:])
    next()
}

router.get("/about") {
    request, response, next in
    try response.render("about", context: [:])
    next()
}

router.get("/contact") {
    request, response, next in
    try response.render("contact", context: [:])
    next()
}



Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
