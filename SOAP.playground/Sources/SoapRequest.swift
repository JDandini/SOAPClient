import UIKit

public typealias SoapParameters = [String: Any]
public typealias SOAPHeaders = [String: String]

enum RequestError: Error {
    case invalidBaseURL
    case noParametersAtRequest
}

public protocol SOAPRequest {
    var parameters: SoapParameters? { get }
    var urn: String { get }
    var baseURL: URL? { get }
    var headers: SOAPHeaders? { get }
    var timeout: TimeInterval { get }
    var image: UIImage? { get }
    var httpMethod: HTTPMethod { get }
}

extension SOAPRequest {
    public var timeout: TimeInterval { return 60 }
    public var image: UIImage? { return .none }
    public var baseURL: URL? { return URL(string: "https://st463.gaiadesign.com.mx/index.php/api/v2_soap/") }
    public var httpMethod: HTTPMethod { return .post }
    public var headers: SOAPHeaders? { return .none }

    public func toRequest()throws -> URLRequest {
        guard let url = baseURL else {
            throw RequestError.invalidBaseURL
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = timeout
        request.httpMethod = httpMethod.rawValue.uppercased()
        var bodyString = "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
        guard let parameters = parameters else { throw RequestError.noParametersAtRequest }
        let parametersInXML = parameters.toXML()
        let body = ["soap:Body": [ urn: parametersInXML].toXML()]
        bodyString += body.toXML()
        bodyString += "</soap:Envelope>"
        print(bodyString)
        request.httpBody = bodyString.data(using: .utf8)
        var defaultHeaders = SOAPHeaders()
        defaultHeaders["Host"] = url.host
        defaultHeaders["Content-Length"] = String(bodyString.count)
        if let headers = headers {
            headers.keys.forEach { defaultHeaders[$0] = headers[$0] }
        }
        return request
    }

}
