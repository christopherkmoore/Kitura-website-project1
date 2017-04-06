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

	// changing this will change the blog posts that are displayed on the root page
	// this is a bad way to do this, a better way would be to pass an excerpt from 
	// the generated MD file (ex: http://www.jessesquires.com/ ) 

	var context = [String: Any]()
	
	// local urls
//	let excerpt1 = URL(fileURLWithPath: "/Users/modelf/iOS_projects/KituraSwift/public/blogPostExcerpts/HelloWorld1.html")
//	let excerpt2 = URL(fileURLWithPath: "/Users/modelf/iOS_projects/KituraSwift/public/blogPostExcerpts/HelloWorld2.html")
//	let excerpt3 = URL(fileURLWithPath: "/Users/modelf/iOS_projects/KituraSwift/public/blogPostExcerpts/HelloWorld3.html")
	
	// heroku urls
	let excerpt1 = URL(fileURLWithPath: "/public/blogPostExcerpts/HelloWorld1.html")
	let excerpt2 = URL(fileURLWithPath: "/public/blogPostExcerpts/HelloWorld2.html")
	let excerpt3 = URL(fileURLWithPath: "/public/blogPostExcerpts/HelloWorld3.html")

	if let data1 = try? String(contentsOf: excerpt1, encoding: .utf8), let data2 = try? String(contentsOf: excerpt2, encoding: .utf8), let data3 = try? String(contentsOf: excerpt3, encoding: .utf8) {
		
		context = [
			"excerpt1": data1,
			"excerpt2": data2,
			"excerpt3": data3
		]
	}
	print(context)

	try response.render("blog", context: context)
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
