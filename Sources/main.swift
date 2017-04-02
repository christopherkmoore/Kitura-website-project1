import Kitura
import LoggerAPI
import HeliumLogger
import KituraStencil
import Foundation

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

let port = Int(ProcessInfo.processInfo.environment["PORT"] ?? "8080") ?? 8080



Kitura.addHTTPServer(onPort: port, with: router)
Kitura.run()
