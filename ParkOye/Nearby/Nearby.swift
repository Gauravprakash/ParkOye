//
//  Nearby.swift
//  Travolution
//
//  Created by Navin on 2/22/18.
//  Copyright © 2018 Zillious Solutions. All rights reserved.
//

import Foundation

class NearbyGeometry : NSObject, NSCoding{
    
    var location : NearbyLocation!
    var viewport : NearbyViewport!
    
    init(fromDictionary dictionary: [String:Any]){
        if let locationData = dictionary["location"] as? [String:Any]{
            location = NearbyLocation(fromDictionary: locationData)
        }
        if let viewportData = dictionary["viewport"] as? [String:Any]{
            viewport = NearbyViewport(fromDictionary: viewportData)
        }
    }
     func toDictionary() -> [String:Any]
     {
        var dictionary = [String:Any]()
        if location != nil{
            dictionary["location"] = location.toDictionary()
        }
        if viewport != nil{
            dictionary["viewport"] = viewport.toDictionary()
        }
        return dictionary
    }
    
    @objc required init(coder aDecoder: NSCoder)
    {
        location = aDecoder.decodeObject(forKey: "location") as? NearbyLocation
        viewport = aDecoder.decodeObject(forKey: "viewport") as? NearbyViewport
        
    }
    @objc func encode(with aCoder: NSCoder)
    {
        if location != nil{
            aCoder.encode(location, forKey: "location")
        }
        if viewport != nil{
            aCoder.encode(viewport, forKey: "viewport")
        }
        
    }
    
}
class NearbyList : NSObject, NSCoding{
    
    var geometry : NearbyGeometry!
    var icon : String!
    var id : String!
    var name : String!
    var openingHours : NearbyOpeningHour!
    var photos : [NearbyPhoto]!
    var reference : String!
    var scope : String!
    var types : [String]!
    var vicinity : String!
    var rating : Float?
    var placeId : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let geometryData = dictionary["geometry"] as? [String:Any]{
            geometry = NearbyGeometry(fromDictionary: geometryData)
        }
        icon = dictionary["icon"] as? String
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
        if let openingHoursData = dictionary["opening_hours"] as? [String:Any]{
            openingHours = NearbyOpeningHour(fromDictionary: openingHoursData)
        }
        photos = [NearbyPhoto]()
        if let photosArray = dictionary["photos"] as? [[String:Any]]{
            for dic in photosArray{
                let value = NearbyPhoto(fromDictionary: dic)
                photos.append(value)
            }
        }
        placeId = dictionary["place_id"] as? String
        rating = dictionary["rating"] as? Float
        reference = dictionary["reference"] as? String
        scope = dictionary["scope"] as? String
        types = dictionary["types"] as? [String]
        vicinity = dictionary["vicinity"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if geometry != nil{
            dictionary["geometry"] = geometry.toDictionary()
        }
        if icon != nil{
            dictionary["icon"] = icon
        }
        if id != nil{
            dictionary["id"] = id
        }
        if name != nil{
            dictionary["name"] = name
        }
        if openingHours != nil{
            dictionary["opening_hours"] = openingHours.toDictionary()
        }
        if photos != nil{
            var dictionaryElements = [[String:Any]]()
            for photosElement in photos {
                dictionaryElements.append(photosElement.toDictionary())
            }
            dictionary["photos"] = dictionaryElements
        }
        if placeId != nil{
            dictionary["place_id"] = placeId
        }
        if rating != nil{
            dictionary["rating"] = rating
        }
        if reference != nil{
            dictionary["reference"] = reference
        }
        if scope != nil{
            dictionary["scope"] = scope
        }
        if types != nil{
            dictionary["types"] = types
        }
        if vicinity != nil{
            dictionary["vicinity"] = vicinity
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        geometry = aDecoder.decodeObject(forKey: "geometry") as? NearbyGeometry
        icon = aDecoder.decodeObject(forKey: "icon") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        openingHours = aDecoder.decodeObject(forKey: "opening_hours") as? NearbyOpeningHour
        photos = aDecoder.decodeObject(forKey :"photos") as? [NearbyPhoto]
        placeId = aDecoder.decodeObject(forKey: "place_id") as? String
        rating = aDecoder.decodeObject(forKey: "rating") as? Float
        reference = aDecoder.decodeObject(forKey: "reference") as? String
        scope = aDecoder.decodeObject(forKey: "scope") as? String
        types = aDecoder.decodeObject(forKey: "types") as? [String]
        vicinity = aDecoder.decodeObject(forKey: "vicinity") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if geometry != nil{
            aCoder.encode(geometry, forKey: "geometry")
        }
        if icon != nil{
            aCoder.encode(icon, forKey: "icon")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if openingHours != nil{
            aCoder.encode(openingHours, forKey: "opening_hours")
        }
        if photos != nil{
            aCoder.encode(photos, forKey: "photos")
        }
        if placeId != nil{
            aCoder.encode(placeId, forKey: "place_id")
        }
        if rating != nil{
            aCoder.encode(rating, forKey: "rating")
        }
        if reference != nil{
            aCoder.encode(reference, forKey: "reference")
        }
        if scope != nil{
            aCoder.encode(scope, forKey: "scope")
        }
        if types != nil{
            aCoder.encode(types, forKey: "types")
        }
        if vicinity != nil{
            aCoder.encode(vicinity, forKey: "vicinity")
        }
        
    }
    
}
class NearbyLocation : NSObject, NSCoding{
    
    var lat : Double!
    var lng : Double!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        lat = dictionary["lat"] as? Double
        lng = dictionary["lng"] as? Double
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if lat != nil{
            dictionary["lat"] = lat
        }
        if lng != nil{
            dictionary["lng"] = lng
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        lat = aDecoder.decodeObject(forKey: "lat") as? Double
        lng = aDecoder.decodeObject(forKey: "lng") as? Double
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if lat != nil{
            aCoder.encode(lat, forKey: "lat")
        }
        if lng != nil{
            aCoder.encode(lng, forKey: "lng")
        }
        
    }
    
}
class NearbyOpeningHour : NSObject, NSCoding{
    
    var openNow : Bool!
    var weekdayText : [AnyObject]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        openNow = dictionary["open_now"] as? Bool
        weekdayText = dictionary["weekday_text"] as? [AnyObject]
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if openNow != nil{
            dictionary["open_now"] = openNow
        }
        if weekdayText != nil{
            dictionary["weekday_text"] = weekdayText
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        openNow = aDecoder.decodeObject(forKey: "open_now") as? Bool
        weekdayText = aDecoder.decodeObject(forKey: "weekday_text") as? [AnyObject]
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if openNow != nil{
            aCoder.encode(openNow, forKey: "open_now")
        }
        if weekdayText != nil{
            aCoder.encode(weekdayText, forKey: "weekday_text")
        }
        
    }
    
}
class NearbyPhoto : NSObject, NSCoding{
    
    var height : Int!
    var htmlAttributions : [String]!
    var photoReference : String!
    var width : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        height = dictionary["height"] as? Int
        htmlAttributions = dictionary["html_attributions"] as? [String]
        photoReference = dictionary["photo_reference"] as? String
        width = dictionary["width"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if height != nil{
            dictionary["height"] = height
        }
        if htmlAttributions != nil{
            dictionary["html_attributions"] = htmlAttributions
        }
        if photoReference != nil{
            dictionary["photo_reference"] = photoReference
        }
        if width != nil{
            dictionary["width"] = width
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        height = aDecoder.decodeObject(forKey: "height") as? Int
        htmlAttributions = aDecoder.decodeObject(forKey: "html_attributions") as? [String]
        photoReference = aDecoder.decodeObject(forKey: "photo_reference") as? String
        width = aDecoder.decodeObject(forKey: "width") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if height != nil{
            aCoder.encode(height, forKey: "height")
        }
        if htmlAttributions != nil{
            aCoder.encode(htmlAttributions, forKey: "html_attributions")
        }
        if photoReference != nil{
            aCoder.encode(photoReference, forKey: "photo_reference")
        }
        if width != nil{
            aCoder.encode(width, forKey: "width")
        }
        
    }
    
}
class NearbyViewport : NSObject, NSCoding{
    
    var northeast : NearbyLocation!
    var southwest : NearbyLocation!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let northeastData = dictionary["northeast"] as? [String:Any]{
            northeast = NearbyLocation(fromDictionary: northeastData)
        }
        if let southwestData = dictionary["southwest"] as? [String:Any]{
            southwest = NearbyLocation(fromDictionary: southwestData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if northeast != nil{
            dictionary["northeast"] = northeast.toDictionary()
        }
        if southwest != nil{
            dictionary["southwest"] = southwest.toDictionary()
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        northeast = aDecoder.decodeObject(forKey: "northeast") as? NearbyLocation
        southwest = aDecoder.decodeObject(forKey: "southwest") as? NearbyLocation
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if northeast != nil{
            aCoder.encode(northeast, forKey: "northeast")
        }
        if southwest != nil{
            aCoder.encode(southwest, forKey: "southwest")
        }
        
    }
    
}
class NearbyQs{
    var location : String!
    var radius : String!
    var key : String!
    var type : String!
    init(dictionary:[String:Any]) {
        location = dictionary["location"] as? String
        radius = dictionary["radius"] as? String
        key = dictionary["key"] as? String
        type = dictionary["type"] as? String
    }
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        
        if location != nil{
            dictionary["location"] = location
        }
        if radius != nil{
            dictionary["radius"] = radius
        }
        if type != nil{
            dictionary["type"] = type
        }
        if key != nil{
            dictionary["key"] = key
        }
        return dictionary
    }
}
class WeatherQs{
    var lat : Double!
    var lon : Double!
    var appId : String!
    
    
    init(dictionary:[String:Any]) {
        lat = dictionary["lat"] as? Double
        lon = dictionary["lon"] as? Double
        appId = dictionary["appid"] as? String
        
    }
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if appId != nil{
            dictionary["appid"] = appId
        }
        if lat != nil{
            dictionary["lat"] = lat
        }
        if lon != nil{
            dictionary["lon"] = lon
        }
        return dictionary
    }
}
