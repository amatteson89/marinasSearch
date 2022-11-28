//
//  PointData.swift
//  Marinas Search
//
//  Created by mattesona on 11/25/22.
//

import Foundation

/// All point data fields listed here https://marinas.com/developers/api_documentation#points-search
struct PointData: Codable{
    var resource: String?
    var data:[LocationData]
}

struct LocationData: Codable {
    var id: String?
    var resource: String?
    var name: String?
    var kind: String?
    var rating: String?
    var review_count: Int?
    var location: LocationInfo
    var web_url: String
    var api_url: String
    var fuel: FuelInfo?
    var icon_url: String?
    var images: Images
}

struct FuelInfo: Codable {
    var has_diesel: Bool?
    var has_propane: Bool?
    var has_gas: Bool?
    var propane_price: Double?
    var diesel_price: Double?
    var gas_regular_price: Double?
    var gas_super_price: Double?
    var gas_premium_price: Double?
}

struct LocationInfo: Codable {
    var lat: Double
    var lon: Double
    var what3words: String?
}

struct Images: Codable {
    var resource: String
    var data: [ImageData]?
}

struct ImageData: Codable {
    var resource: String
    var thumbnail_url: String
    var small_url: String
    var medium_url: String
    var banner_url: String
    
}


