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

router.get("/blogPosts/*") { request, response, next in
	var context = [String: Any] ()
	if let path = request.parsedURL.path, path != "/blogPosts/" {
		var context = [String: Any]()
		
		//local
//		let url = URL(fileURLWithPath: "/Users/modelf/iOS_projects/KituraSwift/public/\(path)")
		// heroku
		let url = URL(fileURLWithPath: "/public/\(path)")
		if let data = try? String(contentsOf: url) {
			context = [
				"markdown": KituraMarkdown.render(from: data)
			]
		}
		try response.render("blogPost", context: context)

	}
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
