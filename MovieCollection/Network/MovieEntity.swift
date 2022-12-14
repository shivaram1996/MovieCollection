//
//  MovieEntity.swift
//  MovieCollection
//
//  Created by shiva ram on 25/09/22.
//

import Foundation

struct MovieList : Codable{
    let Search : [MovieResponse]?
    let totalResults : String?
}



//movie list
struct MovieResponse : Codable {
    let title : String?
    let year : String?
    let imdbID : String?
    let type : String?
    let poster : String?

    enum CodingKeys: String, CodingKey {

        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        year = try values.decodeIfPresent(String.self, forKey: .year)
        imdbID = try values.decodeIfPresent(String.self, forKey: .imdbID)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        poster = try values.decodeIfPresent(String.self, forKey: .poster)
    }
}


//Movie detail response
struct MovieDetailResponse : Codable {
    let title : String?
    let releaseDate : String?
    let directorName : String?
    let plot : String?
    let poster : String?

    enum CodingKeys: String, CodingKey {

        case title = "Title"
        case releaseDate = "Released"
        case directorName = "Director"
        case plot = "Plot"
        case poster = "Poster"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)
        directorName = try values.decodeIfPresent(String.self, forKey: .directorName)
        plot = try values.decodeIfPresent(String.self, forKey: .plot)
        poster = try values.decodeIfPresent(String.self, forKey: .poster)
    }
}

/// These are the errors this class might return
enum ManagerErrors: Error {
    case invalidResponse
    case invalidStatusCode(Int)
}

/// The request method you like to use
enum HttpMethod: String {
    case get
    case post

    var method: String { rawValue.uppercased() }
}

class URLList{
    static let BASE_URL = "https://www.omdbapi.com/"
}
