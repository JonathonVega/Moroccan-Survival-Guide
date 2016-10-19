//
//  MoroccanGuide.swift
//  Moroccan Survival Guide
//
//  Created by Jonathon F Vega on 8/28/16.
//  Copyright © 2016 Jonathon Vega. All rights reserved.
//

import Foundation

enum Topics: CustomStringConvertible {
    case greetings
    case family
    case house
    case street
    case food
    case numbers
    case money
    case cities_Sites
    case shopping
    case usefulQuestions
    case usefulExpressions
    
    var description: String {
        switch self {
        case .greetings: return "Greetings"
        case .family: return "Family"
        case .house: return "House"
        case .street: return "Street"
        case .food: return "Food"
        case .numbers: return "Numbers"
        case .money: return "Money"
        case .cities_Sites: return "Cities/Sites"
        case .shopping: return "Shopping"
        case .usefulQuestions: return "Useful Questions"
        case .usefulExpressions: return "Useful Expressions"
        }
    }
    
    static var count: Int { return Topics.usefulExpressions.hashValue + 1}
    
    static func getStringFromEnum(_ int: Int) -> String {
        switch int {
        case 0: return greetings.description
        case 1: return family.description
        case 2: return house.description
        case 3: return street.description
        case 4: return food.description
        case 5: return numbers.description
        case 6: return money.description
        case 7: return cities_Sites.description
        case 8: return shopping.description
        case 9: return usefulQuestions.description
        case 10: return usefulExpressions.description
        default: return "Hi"
        }
    }
}

extension Topics {
    var words: [[String]] {
        switch self {
        case .greetings: return [["Hello", "Hello", "How are you", "How are you doing", "What\'s up", "How are you doing", "What\'s going on", "How\'s Everything?", "How\'s Everything", "It\'s fine", "Fine, Thank God"],
                                 ["Salam", "Salamu 3alikum", "Labas", "Kidayr/a", "Ash Khabarak", "Keef Dayr/a", "Ash t3awwd/i", "Kolshee Labas", "Kolshee Bekheer", "Labas", "L\'hamdollah"]]
            
        case .family: return [["Mom", "Dad", "Sister", "Brother", "Aunt(paternal)", "Aunt(maternal)", "Uncle(paternal)", "Uncle(maternal)", "Cousin(paternal)", "Cousin(maternal)", "Wife", "Husband", "Fiancé", "Girl", "Boy", "Man", "Woman", "Grandmother", "Grandfather", "Grandchild"],
                              ["Mmi", "Bba", "Okht", "Kho", "3amma", "Khala", "3amm", "Khaal", "Wld a3m/bnt a3m", "Wld khal/bnt khal", "Mra", "Zawj/rajol", "Khateeb", "Bnt", "Wld", "Rajol", "Mra", "Jdda", "Jdd", "Hafeed"]]
            
        case .house: return [["Door", "Floor", "Wall", "Kitchen", "Bathroom", "Shower", "Refrigerator", "Table", "Stove", "Faucet", "Window", "Couch", "Chair", "Bed", "Stairs", "Light", "Outlet", "Television"],
                             ["Bab", "Ard", "HayT", "Cuzina", "Banyo/L'hammam", "Douche", "Tllaja", "Tabla", "Forno", "Robini", "Sharjam", "Ponj", "Korsi", "Frash", "Dorjj", "Do2", "Preez", "Talfaza"]]
            
        case .street: return [["Street", "Road/Highway", "Corner", "Car", "House", "Place", "Bike", "Motorcycle", "Street Vendor", "Parking", "Parking Service", "Market", "Building", "Grocery Store", "Pharmacy", "School", "Police Station", "Embassy", "Tram Station", "Train Station", "Taxi"],
                              ["Zn9a", "Tre9", "9ent", "Tomobil", "Dar", "Blasa", "Pikala", "Motor", "Ba2i3 Motajowwil", "l\'Parking", "l\'a3ssas", "Souk", "3emara", "Hanout", "Saydalia", "Scuela", "Commisaria", "Ssifara", "MahTa d L\'Tram", "La gare", "Taksi"]]
        
        case .food: return [["Restaurant", "Food", "Alcohol", "Bar", "Café", "Tajine", "Soup", "Plate", "Dish", "Snack", "Orange Juice", "Coffee", "Water", "Water Bottle", "Cake", "Grill", "Corn", "Snails", "Fork", "Spoon", "Knife", "Napkin", "Cups"],
                            ["Ristorant", "Makla", "Shrab", "Cabaray", "9hiwa", "Tajine", "Sopa", "Tbsil", "Okla", "Okla Khafifa", "3asir Limon", "9hiwa", "l\'ma2", "9r3 d l\'ma2", "Keeka", "Shwaya", "L\'kbbal", "Ghalala", "Forschetta", "Ma3l9a", "Mos", "Sirbeta", "Keesan"]]
            
        case .numbers: return [["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen", "Twenty", "Twenty-one", "30", "40", "50", "60", "70", "80", "90", "100", "200", "1,000", "1,000,000", "1,000,000,000"],
                               ["Wa7d", "Jouj", "Tlata", "Arba3", "Khamsa", "Stta", "Sb3a", "Tmaniya", "Tss3oud", "A3chra", "7dach", "Thnash", "Thltash", "Arba3tash", "Khamstach", "Sttash", "Sba3tash", "Tmntach", "Ts3atash", "3ashriin", "W7d w a3shriin", "Tlatin", "Arb3iin", "Khamsiin", "Sttiin", "Sb3iin", "Tmaniin", "Ts3iin", "Mia", "Mitin", "Alf", "Milion", "Miliar"]]
            
        case .money: return [["Money", "Country Currency", "1 USD", "10 USD", "100 USD", "1000 USD"],
                             ["Flous", "Dirham (dh)", "10 dh", "100 dh", "1000 dh", "10000 dh"]]
            
        case .cities_Sites: return [["City", "Old Town", "Village", "Town", "River", "Downtown", "Neighborhood", "Beach", "Pool", "Mountains", "Desert", "Country", "North", "South", "Atlas", "Forest"],
                                    ["Madina", "L\'medina", "9ariya", "Blda", "Wad", "Centre Ville", "Hay", "L\'bahr", "La Piscine", "Jbal", "Sahra2", "Bled", "Shamal", "Janoub", "Atlasi", "Ghaba"]]
            
        case .shopping: return [["To Shop", "Market", "Old town", "Clothes", "Thobe", "Traditional Mens Shirt", "Tradional Shoes", "Hat", "Sandals", "Shirt", "Jeans/Pants", "Shoes/Dress Shoes", "Shoes(ordinary)", "Socks", "Necklace", "Jewelry", "Shopowner", "What do you need", "Price", "Give me a good price", "Expensive", "I cannot afford it", "No", "Yes", "A little bit", "No thanks, Bye!", "That\'s it"],
                                ["T9adda", "Swi9a", "Medina", "7waije", "Djellaba", "Jabador", "Belgha", "Taggiya", "Sandalia", "9amija", "Sirwal", "Sbbat", "Sbirdeela", "T9ashir", "Sensla", "Mojawharat", "Moul hanout", "Ach habbat l\'khatar", "Thaman", "Sawb ma3aya taman", "Ghali", "Ma mselkash", "La", "Ayeh", "Shwiya", "Allah y3awnik", "Safi"]]
            
        case .usefulQuestions: return [["Where is ...", "What time is it?", "Where are you from?", "How old are you", "Where are we going?", "What are you doing?", "How is..(s.o.) doing?", "Who are you?", "Who is that?", "When", "When (What time)?", "Why?", "How?", "How much(size)?", "There is...", "Help me", "Please", "Call"],
                                       ["Feen...", "Ch7al f Sa3a", "Minin nta?", "Ch7al f omrek", "Feen Ghadiin", "Achno katdeer", "Kidayr...(name)", "Chkoon nta?", "Chkoon hada?", "Imta", "Wa9tash", "3alache", "Kifache", "Giddach", "Kayn", "A3wnni", "A3fak", "3eyt 3ala"]]
            
        case .usefulExpressions: return [["Thank you", "You're Welcome", "Get out of my face", "Move away from me", "Run away", "Money", "Food", "Food", "Food", "People", "Fun", "Weird", "What\'s up?", "Whats good?", "Foreigner", "Neighborhood", "Boy/Dude", "Girl", "Friendship", "Friend", "Go"],
                                         ["Chokran", "La Chokr 3la Wajb", "Drrg a3liya dzalftk", "Ba3d mnni", "A3ll9", "3omar", "L\'9as", "L\'mo3alaja", "Tkiya", "Bnadem", "Tfwija", "F shi shkl", "Wesh", "Wa feen", "Barrani", "L\'7ouma", "Sat", "Satta", "3achran", "3achir", "9alla3"]]
        }
    }
    
    static func getWords(_ Section: String) -> [[String]]{
        switch Section {
            case "Greetings": return Topics.greetings.words
            case "Family": return Topics.family.words
            case "House": return Topics.house.words
            case "Street": return Topics.street.words
            case "Food": return Topics.food.words
            case "Numbers": return Topics.numbers.words
            case "Money": return Topics.money.words
            case "Cities/Sites": return Topics.cities_Sites.words
            case "Shopping": return Topics.shopping.words
            case "Useful Questions": return Topics.usefulQuestions.words
            case "Useful Expressions": return Topics.usefulExpressions.words
            default: return [[""],[""]]
        }
    }
}





