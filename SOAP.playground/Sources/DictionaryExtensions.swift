import Foundation

extension Dictionary {
    func toXML(gotFilters: Bool = false) -> String {
        var xmlString = ""
        for (key, value) in self {
            xmlString += "<\(key)>"
            if let dic = value as? Dictionary {
                xmlString += dic.toXML()
            } else if let array = value as? Array<Any> {
                array.forEach {
                    xmlString += "\($0)"
                }
            } else {
                xmlString += "\(value)"
            }
            xmlString += "</\(key)>"
        }

        return xmlString
    }
}
