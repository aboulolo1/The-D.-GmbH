//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Repository : Codable {

	var descriptionField : String?
	var fullName : String?
	var htmlUrl : String?
	var id : Int?
	var language : String?
	var name : String?
	var updatedAt : String?
    var dateTimeAgo:String?

	enum CodingKeys: String, CodingKey {
		case descriptionField = "description"
		case htmlUrl = "html_url"
		case id = "id"
		case language = "language"
        case fullName = "full_name"
		case name = "name"
		case updatedAt = "updated_at"
	}
  
    init(repositoryEntity:RepositoryEntity?) {
        self.descriptionField = repositoryEntity?.descriptionField
        self.fullName = repositoryEntity?.fullName
        self.htmlUrl = repositoryEntity?.htmlUrl
        self.id = repositoryEntity?.id
        self.language = repositoryEntity?.language
        self.name = repositoryEntity?.name
        self.updatedAt = repositoryEntity?.updatedAt
        self.dateTimeAgo = repositoryEntity?.dateTimeAgo
    }
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
		fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
		htmlUrl = try values.decodeIfPresent(String.self, forKey: .htmlUrl)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		language = try values.decodeIfPresent(String.self, forKey: .language)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: updatedAt ?? "")
        dateTimeAgo = date?.getElapsedInterval()
	}
   

}
