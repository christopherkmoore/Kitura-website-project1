//
//  Blog.swift
//  project1
//
//  Created by modelf on 4/5/17.
//
//

import Foundation

public class Post {
	
	public var title: String
	public var datePublished: String
	public var abstract: String
	public var link: String
	
	public init(title: String, datePublished: String, abstract: String, link: String) {
		
		self.title = title
		self.datePublished = datePublished
		self.abstract = abstract
		self.link = link
	}
	
	
}

