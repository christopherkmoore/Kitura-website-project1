import Kitura
import LoggerAPI
import HeliumLogger
import KituraStencil
import Foundation
import KituraMarkdown




HeliumLogger.use()
let router = Router()

router.setDefault(templateEngine: StencilTemplateEngine())
router.all("/static", middleware: StaticFileServer())
router.add(templateEngine: KituraMarkdown())

router.get("/") {
    request, response, next in
	try response.render("blog", context: [:])
	next()
}

router.get("/blogPosts/HelloWorld1") { request, response, next in
	
	try response.render("HelloWorld1", context: [:])
	response.status(.OK)
	next()
}
router.get("/blogPosts/HelloWorld2") { request, response, next in
	
	try response.render("HelloWorld2", context: [:])
	response.status(.OK)
	next()
}
router.get("/blogPosts/HelloWorld3") { request, response, next in
	
	try response.render("HelloWorld3", context: [:])
	response.status(.OK)
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

let port = Int(ProcessInfo.processInfo.environment["PORT"] ?? "8090") ?? 8090




Kitura.addHTTPServer(onPort: port, with: router)
Kitura.run()
