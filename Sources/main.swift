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

var blog: [Post] = [Post(title: "HelloWorld", datePublished: "2017-04-05", abstract: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur sodales ligula in libero. Sed dignissim lacinia nunc. Curabitur tortor. Pellentesque nibh. Aenean quam. In scelerisque sem at dolor. Maecenas mattis. Sed convallis tristique sem. Proin ut ligula vel nunc egestas porttitor. Morbi lectus risus, iaculis vel, suscipit quis, luctu.", link: "/blogPosts/HelloWorld.md"), Post(title: "HelloWorld2", datePublished: "2017-04-05", abstract: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur sodales ligula in libero. Sed dignissim lacinia nunc. Curabitur tortor. Pellentesque nibh. Aenean quam. In scelerisque sem at dolor. Maecenas mattis. Sed convallis tristique sem. Proin ut ligula vel nunc egestas porttitor. Morbi lectus risus, iaculis vel, suscipit quis, luctu.", link: "/blogPosts/HelloWorld2.md"), Post(title: "HelloWorld3", datePublished: "2017-04-05", abstract: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur sodales ligula in libero. Sed dignissim lacinia nunc. Curabitur tortor. Pellentesque nibh. Aenean quam. In scelerisque sem at dolor. Maecenas mattis. Sed convallis tristique sem. Proin ut ligula vel nunc egestas porttitor. Morbi lectus risus, iaculis vel, suscipit quis, luctu.", link: "/blogPosts/HelloWorld3.md")]



router.get("/") {
    request, response, next in

	// changing this will change the blog posts that are displayed on the root page
	// this is a bad way to do this, a better way would be to pass an excerpt from 
	// the generated MD file (ex: http://www.jessesquires.com/ ) 
	
//	var context: [String: Any] = [
//		"post-title": blog[0].title,
//		"post-published": blog[0].datePublished,
//		"post-abstract": blog[0].abstract,
//		"post-link": blog[0].link,
//		
//		"post-title1": blog[1].title,
//		"post-published1": blog[1].datePublished,
//		"post-abstract1": blog[1].abstract,
//		"post-link1": blog[1].link,
//		
//		"post-title2": blog[2].title,
//		"post-published2": blog[2].datePublished,
//		"post-abstract2": blog[2].abstract,
//		"post-link2": blog[2].link
//		]

	var context = [String: Any]()
	
	let excerpt1 = URL(fileURLWithPath: "/Users/modelf/iOS_projects/KituraSwift/public/blogPostExcerpts/HelloWorld1.html")
	let excerpt2 = URL(fileURLWithPath: "/Users/modelf/iOS_projects/KituraSwift/public/blogPostExcerpts/HelloWorld2.html")
	let excerpt3 = URL(fileURLWithPath: "/Users/modelf/iOS_projects/KituraSwift/public/blogPostExcerpts/HelloWorld3.html")
	
	if let data = try? String(contentsOf: excerpt1), let data2 = try? String(contentsOf: excerpt2), let data3 = try? String(contentsOf: excerpt3) {
		
		context = [
			"excerpt1": data,
			"excerpt2": data2,
			"excerpt3": data3
			
		]
	}
	    try response.render("blog", context: context)
    next()
}

router.get("/blogPosts/*") { request, response, next in
	
	if let path = request.parsedURL.path, path != "/blogPosts/" {
		var context = [String: Any]()
		
		let url = URL(fileURLWithPath: "/Users/modelf/iOS_projects/KituraSwift/public/\(path)")
		if let data = try? String(contentsOf: url) {
		
			 context = [
				"markdown": KituraMarkdown.render(from: data)
				]
		}


		
		try response.render("blogPost", context: context)
		response.status(.OK)
	}
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
