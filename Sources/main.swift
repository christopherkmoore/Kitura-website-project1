import Kitura
import LoggerAPI 
import HeliumLogger
import KituraStencil

HeliumLogger.use()
let router = Router()
router.setDefault(templateEngine: StencilTemplateEngine())

let bios = [
    "kirk": "My name is James Kirk and I love snakes.",
    "picard": "My name is Jean-Luc Picard and I'm mad for cats.",
    "sisko": "My name is Benjamin Sisko and I'm all about the budgies.",
    "janeway": "My name is Kathryn Janeway and I want to hug every hamster.",
    "archer": "My name is Jonathan Archer and beagles are my thing."
]

router.get("/") {
    request, response, next in
    try response.render("home", context: [:])
    next()
}

router.get("/staff") {
    request, response, next in
    var context = [String: Any]()
    
    context["people"] = bios.keys.sorted()
    
    try response.render("staff", context: context)
    next()
    
}

router.get("/staff/:name") {
    request, response, next in
    guard let name = request.parameters["name"] else { return }
    

    var context = [String: Any]()
    
    context["people"] = bios.keys.sorted()
    
    if let bio = bios[name] {
        context["name"] = name
        context["bio"] = bio
    }
    try response.render("staffName", context: context)
    next()

}

router.get("/contact") {
    request, response, next in
    try response.render("contact", context: [:])
    next()
}

Kitura.addHTTPServer(onPort: 8090, with: router)
Log.info("Haters gun h8")
Kitura.run()
