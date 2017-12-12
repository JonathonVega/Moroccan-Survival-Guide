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
    case travel
    case medical
    case party_Festivities
    case weather
    case daysOfTheWeek
    case possessions
    case textLanguage
    
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
        case .travel: return "Travel"
        case .medical: return "Medical"
        case .party_Festivities: return "Party/Festivities"
        case .weather: return "Weather"
        case .daysOfTheWeek: return "Days of the Week"
        case .possessions: return "Possessions"
        case .textLanguage: return "Text Language"
        }
    }
    
    static var count: Int { return Topics.textLanguage.hashValue + 1}
    
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
        case 11: return travel.description
        case 12: return medical.description
        case 13: return party_Festivities.description
        case 14: return weather.description
        case 15: return daysOfTheWeek.description
        case 16: return possessions.description
        case 17: return textLanguage.description
        default: return "Hi"
        }
    }
}

extension Topics {
    var words: [[String]] {
        switch self {
        case .greetings: return [["Hello","Salam"],
                                 ["Hello","Salamu 3alikum"],
                                 ["How are you","Labas"],
                                 ["How are you doing","Kidayr/a"],
                                 ["What\'s up","Ash Khabarak"],
                                 ["How are you doing","Keef Dayr/a"],
                                 ["What\'s going on","Ash t3awwd/i"],
                                 ["How\'s Everything?", "Kolshee Labas"],
                                 ["How\'s Everything", "Kolshee Bekheer"],
                                 ["It's fine", "Labas"],
                                 ["Fine, Thank God", "L\'hamdollah"]]
            
        case .family: return [["Mom", "Mmi"],
                              ["Dad", "Bba"],
                              ["Sister","Okht"],
                              ["Brother","Kho"],
                              ["Aunt(paternal","3amma"],
                              ["Aunt(maternal)","Khala"],
                              ["Uncle(paternal)","3amm"],
                              ["Uncle(maternal)", "Khaal"],
                              ["Cousin(paternal)", "Wld a3m/bnt a3m"],
                              ["Cousin(maternal)","Wld khal/bnt khal"],
                              ["Wife", "Mra"],
                              ["Husband", "Zawj/rajol"],
                              ["Fiancé", "Khateeb"],
                              ["Girl", "Bnt"],
                              ["Boy","Wld"],
                              ["Man", "Rajol"],
                              ["Woman", "Mra"],
                              ["Grandmother","Jdda"],
                              ["Grandfather", "Jdd"],
                              ["Grandchild", "Hafeed"]]
            
        case .house: return [["Door", "Bab"],
                             ["Floor", "Ard"],
                             ["Wall", "HayT"],
                             ["Kitchen", "Cuzina"],
                             ["Bathroom", "Banyo/L\'hammam"],
                             ["Shower", "Douche"],
                             ["Refrigerator", "Tllaja"],
                             ["Table", "Tabla"],
                             ["Stove", "Forno"],
                             ["Faucet", "Robini"],
                             ["Window", "Sharjam"],
                             ["Couch", "Ponj"],
                             ["Chair", "Korsi"],
                             ["Bed", "Frash"],
                             ["Stairs", "Dorjj"],
                             ["Light", "Do2"],
                             ["Outlet", "Preez"],
                             ["Television", "Talfaza"]]
            
        case .street: return [["Street", "Zn9a"],
                              ["Road/Highway", "Tre9"],
                              ["Corner", "9ent"],
                              ["Car", "Tomobil"],
                              ["House", "Dar"],
                              ["Place", "Blasa"],
                              ["Bike", "Pikala"],
                              ["Motorcycle", "Motor"],
                              ["Street Vendor", "Ba2i3 Motajowwil"],
                              ["Parking", "l\'Parking"],
                              ["Parking Service", "l\'a3ssas"],
                              ["Market", "Souk"],
                              ["Building", "3emara"],
                              ["Grocery Store", "Hanout"],
                              ["Pharmacy", "Saydalia"],
                              ["School", "Scuela"],
                              ["Police Station", "Commisaria"],
                              ["Embassy", "Ssifara"],
                              ["Tram Station", "MahTa d L\'Tram"],
                              ["Train Station", "La gare"],
                              ["Taxi", "Taksi"]]
        
        case .food: return [["Restaurant", "Ristorant"],
                            ["Food", "Makla"],
                            ["Alcohol", "Shrab"],
                            ["Bar", "Cabaray"],
                            ["Café", "9hiwa"],
                            ["Tajine", "Tajine"],
                            ["Soup", "Sopa"],
                            ["Plate", "Tbsil"],
                            ["Dish", "Okla"],
                            ["Snack", "Okla Khafifa"],
                            ["Orange Juice", "3asir Limon"],
                            ["Coffee", "9hiwa"],
                            ["Water", "l\'ma2"],
                            ["Water Bottle", "9r3 d l\'ma2"],
                            ["Cake", "Keeka"],
                            ["Grill", "Shwaya"],
                            ["Corn", "L\'kbbal"],
                            ["Snails", "Ghalala"],
                            ["Fork", "Forschetta"],
                            ["Spoon", "Ma3l9a"],
                            ["Knife", "Mos"],
                            ["Napkin", "Sirbeta"],
                            ["Cups", "Keesan"]]
            
        case .numbers: return [["One", "Wa7d"],
                               ["Two", "Jouj"],
                               ["Three", "Tlata"],
                               ["Four", "Arba3"],
                               ["Five", "Khamsa"],
                               ["Six", "Stta"],
                               ["Seven", "Sb3a"],
                               ["Eight", "Tmaniya"],
                               ["Nine", "Tss3oud"],
                               ["Ten", "A3chra"],
                               ["Eleven", "7dach"],
                               ["Twelve", "Thnash"],
                               ["Thirteen", "Thltash"],
                               ["Fourteen", "Arba3tash"],
                               ["Fifteen", "Khamstach"],
                               ["Sixteen", "Sttash"],
                               ["Seventeen", "Sba3tash"],
                               ["Eighteen", "Tmntach"],
                               ["Nineteen", "Ts3atash"],
                               ["Twenty", "3ashriin"],
                               ["Twenty-one", "W7d w a3shriin"],
                               ["30", "Tlatin"],
                               ["40", "Arb3iin"],
                               ["50", "Khamsiin"],
                               ["60", "Sttiin"],
                               ["70", "Sb3iin"],
                               ["80", "Tmaniin"],
                               ["90", "Ts3iin"],
                               ["100", "Mia"],
                               ["200", "Mitin"],
                               ["1,000", "Alf"],
                               ["1,000,000", "Milion"],
                               ["1,000,000,000", "Miliar"]]
            
        case .money: return [["Money", "Flous"],
                             ["Country Currency", "Dirham (dh)"],
                             ["1 USD", "10 dh"],
                             ["10 USD", "100 dh"],
                             ["100 USD", "1000 dh"],
                             ["1000 USD", "10000 dh"]]
            
        case .cities_Sites: return [["City", "Madina"],
                                    ["Old Town", "L'medina"],
                                    ["Village", "9ariya"],
                                    ["Town", "Blda"],
                                    ["River", "Wad"],
                                    ["Downtown", "Centre Ville"],
                                    ["Neighborhood", "Hay"],
                                    ["Beach", "L\'bahr"],
                                    ["Pool", "La Piscine"],
                                    ["Mountains", "Jbal"],
                                    ["Desert", "Sahra2"],
                                    ["Country", "Bled"],
                                    ["North", "Shamal"],
                                    ["South", "Janoub"],
                                    ["Atlas", "Atlasi"],
                                    ["Forest", "Ghaba"]]
            
        case .shopping: return [["To Shop", "T9adda"],
                                ["Market", "Swi9a"],
                                ["Old town", "Medina"],
                                ["Clothes", "7waije"],
                                ["Thobe", "Djellaba"],
                                ["Traditional Mens Shirt", "Jabador"],
                                ["Traditional Shoes", "Belgha"],
                                ["Hat", "Taggiya"],
                                ["Sandals", "Sandalia"],
                                ["Shirt", "9amija"],
                                ["Jeans/Pants", "Sirwal"],
                                ["Shoes/Dress Shoes", "Sbbat"],
                                ["Shoes(ordinary)", "Sbirdeela"],
                                ["Socks", "T9ashir"],
                                ["Necklace", "Sensla"],
                                ["Jewelry", "Mojawharat"],
                                ["Shop Owner", "Moul hanout"],
                                ["What do you need", "Ach habbat l\'khatar"],
                                ["Price", "Thaman"],
                                ["Give me a good price", "Sawb ma3aya taman"],
                                ["Expensive", "Ghali"],
                                ["I cannot afford it", "Ma mselkash"],
                                ["No", "La"],
                                ["Yes", "Ayeh"],
                                ["A little bit", "Shwiya"],
                                ["No thanks, Bye!", "Allah y3awnik"],
                                ["That\'s it", "Safi"]]
            
        case .usefulQuestions: return [["Where is...", "Feen..."],
                                       ["What time is it?", "Ch7al f Sa3a"],
                                       ["Where are you from?", "Minin nta?"],
                                       ["How old are you", "Ch7al f omrek"],
                                       ["Where are we going", "Feen Ghadiin"],
                                       ["What are you doing", "Achno katdeer"],
                                       ["How is..(name) doing?", "Kidayr...(name)"],
                                       ["Who are you?", "Chkoon nta?"],
                                       ["Who is that?", "Chkoon hada?"],
                                       ["When", "Imta"],
                                       ["When (What time)?", "Wa9tash"],
                                       ["Why?", "3alache"],
                                       ["How?", "Kifache"],
                                       ["How much(size)?", "Giddach"],
                                       ["There is...", "Kayn"],
                                       ["Help me", "A3wnni"],
                                       ["Please", "A3fak"],
                                       ["Call", "3eyt 3ala"]]
            
        case .usefulExpressions: return [["Thank you", "Chokran"],
                                         ["You\'re Welcome", "La Chokr 3la Wajb"],
                                         ["Get out of my face", "Drrg a3liya dzalftk"],
                                         ["Move away from me", "Ba3d mnni"],
                                         ["Run away", "A3ll9"],
                                         ["Money", "3omar"],
                                         ["Food", "L\'9as"],
                                         ["Food", "L\'mo3alaja"],
                                         ["Food", "Tkiya"],
                                         ["People", "Bnadem"],
                                         ["Fun", "Tfwija"],
                                         ["Weird", "F shi shkl"],
                                         ["What\'s up?", "Wesh"],
                                         ["Whats good?", "Wa feen"],
                                         ["Foreigner", "Barrani"],
                                         ["Neighborhood", "L\'7ouma"],
                                         ["Boy/Dude", "Sat"],
                                         ["Girl", "Satta"],
                                         ["Friendship", "3achran"],
                                         ["Friend", "3achir"],
                                         ["Go", "9alla3"]]
            
        case .travel: return [["Travel", "Safr"],
                                  ["Suitcase", "Baliza"],
                                  ["Bag", "Shanta"],
                                  ["Custom", "Diwane"],
                                  ["Airport", "Matar"],
                                  ["Airplane", "Tyara"],
                                  ["Arrivals", "Wsol"],
                                  ["Departures", "Moghadirat"],
                                  ["Clock", "Sa3a"],
                                  ["Hour", "Sa3a"],
                                  ["Delay", "Ta2jil"],
                                  ["Seat(Airplane)", "Blasa"],
                                  ["Ticket", "Billet"],
                                  ["Reservation", "Reservation"],
                                  ["Passport", "Passeporte"],
                                  ["Far", "B3id"],
                                  ["Close", "9rib"],
                                  ["Toll", "L'khlas"],
                                  ["Gas", "Mazot"],
                                  ["Gas station", "Mahta dl mazot"],
                                  ["Road", "Tri9"]]
            
        case .medical: return [["Hospital", "Sbitar"],
                               ["Ambulance", "Isa3f"],
                               ["Medicine", "Dwa"],
                               ["Doctor", "Tbib"],
                               ["Hurt", "Drr"],
                               ["My head hurts", "Drrni rassi"],
                               ["Room", "Biit"],
                               ["My feet hurt", "Drroni rjliya"],
                               ["Prescription", "Wsfa dl dwa"],
                               ["Dizzy", "Daykh"],
                               ["Nurse", "Fermliya"],
                               ["Heal", "Bra"],
                               ["Fever", "Homma"],
                               ["Cold", "Rwa7"],
                               ["Get better!", "Allah ychafik!"]]
            
        case .party_Festivities: return [["Party", "Hafla"],
                                         ["Bar", "Bar"],
                                         ["Dance", "ShTa7"],
                                         ["To have fun", "Fowwj"],
                                         ["Hungover(adj)", "Mtammn"],
                                         ["Alcohol", "Shrab"],
                                         ["Stage", "MnSa"]]
            
        case .weather: return [["Clouds", "S7aab"],
                               ["Weather", "L'jow"],
                               ["Hot", "Skhoon"],
                               ["Cold", "Brd"],
                               ["Rain", "Shta2"],
                               ["Snow", "Tlj"],
                               ["Nice(weatherwise)", "Zwiin"],
                               ["Sunny", "Kayn l'chms"],
                               ["Wind", "Rii7"],
                               ["Fog", "Dabab"],
                               ["Thunder", "Ra3d"],
                               ["Summer", "Sayf"],
                               ["Winter", "Shta2"],
                               ["Fall", "L'kharif"],
                               ["Spring", "L'rbii3"],
                               ["Temperature", "Daraja"]]
            
        case .daysOfTheWeek: return [["Days", "Eyamat"],
                                     ["Week", "Semana"],
                                     ["Sunday", "L'7ad"],
                                     ["Monday", "L'itniin"],
                                     ["Tuesday", "L'tlata"],
                                     ["Wednesday", "L'arab3"],
                                     ["Thursday", "L'khamiis"],
                                     ["Friday", "Joma3"],
                                     ["Saturday", "Ssbt"],
                                     ["Morning", "Sba7"],
                                     ["Noon", "Zhuhr"],
                                     ["Afternoon/Eve", "L'a3chiya"],
                                     ["Night", "Lil"],
                                     ["Early", "Bkri"],
                                     ["Late", "Ma3ttl"]]
            
        case .possessions: return [["Of, Possess", "Diel"],
                                   ["Mine", "Dieli"],
                                   ["Yours", "Dielk"],
                                   ["His", "Dielo"],
                                   ["Hers", "Dielha"],
                                   ["You alls", "Dielkoum"],
                                   ["Ours", "Dielna"],
                                   ["Theirs", "Dielhom"],
                                   ["Of(plural form)", "Dieol"]]
            
        case .textLanguage: return [["2", "'a"],
                                    ["3", "Aa"],
                                    ["4", "gh"],
                                    ["5", "Kh"],
                                    ["7", "H"],
                                    ["9", "Q"]]
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
            case "Travel": return Topics.travel.words
            case "Medical": return Topics.medical.words
            case "Party/Festivities": return Topics.party_Festivities.words
            case "Weather": return Topics.weather.words
            case "Days of the Week": return Topics.daysOfTheWeek.words
            case "Possessions": return Topics.possessions.words
            case "Text Language": return Topics.textLanguage.words
            default: return [[""],[""]]
        }
    }
}





