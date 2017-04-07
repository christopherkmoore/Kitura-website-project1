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

// can remake with a wildcard if i name the stencils the path name ie /blogPost/HelloWorld1.stencil. I wont have to hardcode every get request.

router.get("/blog/*") { request, response, next in
	if let path = request.parsedURL.path, path != "/blog/" {
		var slightlyEditedPath = path
		for i in 0...5 {
			slightlyEditedPath.remove(at: slightlyEditedPath.startIndex)
		}
		print(slightlyEditedPath)
		try response.render(slightlyEditedPath, context: [:])
		response.status(.OK)
	}
	next()
}

router.get("/work") {
    request, response, next in
    try response.render("work", context: [:])
    next()
}

router.get("/work/*") { request, response, next in
	if let path = request.parsedURL.path, path != "/work/" {
		var slightlyEditedPath = path
		for i in 0...5 {
			slightlyEditedPath.remove(at: slightlyEditedPath.startIndex)
		}
		print(slightlyEditedPath)
		try response.render(slightlyEditedPath, context: [:])
		response.status(.OK)
	}
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
