import UIKit
import PlaygroundSupport

enum HistoryRequest: SOAPRequest {
    case todayOrdersFor(email: String)


    var parameters: SoapParameters? {
        switch self {
        case .todayOrdersFor(let email):
            var params = SoapParameters()
            let createdAtValue: [String:Any] = ["key": "gt", "value": todayDate()]
            let createdAtWrapper: [String: Any] = [ "key": "created_at","value": createdAtValue]
            let customerEmailFilter = ["key": "customer_email","value": email]
            let dateFilter: [String : Any] = ["created_at": createdAtWrapper]
            let subDictionary = ["filter": customerEmailFilter, "complex_filter": dateFilter]
            params["filters"] = subDictionary
            return params
        }
    }
    var urn: String { return "salesOrderList"}

    private func todayDate() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: now)
    }

}

enum AuthRequest: SOAPRequest {
    case gaiaAuth
    case login(user: String, password: String)

    var parameters: SoapParameters? {
        switch self {
        case .gaiaAuth:
            var parameters = SoapParameters()
            parameters["username"] = "gaiaAppTeam"
            parameters["apiKey"] = "1234567890"
            return parameters
        case .login(let user, let password):
            var parameters = SoapParameters()
            parameters["sessionId"] = "SESION_ID"
            let userData = ["email_user": user, "password_user": password]
            parameters["data"] = userData
            return parameters
        }
    }

    var urn: String {
        switch self {
        case .gaiaAuth:
            return "login"
        case .login:
            return "gaiaappCustomerLogin"
        }

    }
}

func executeRequest() {
    let gaiaAuth = AuthRequest.login(user: "javier.castaneda@gaiadesign.com.mx", password: "123456")
    guard let request = try? gaiaAuth.toRequest() else { return }
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let data = data else {
            print("No data")
            return
        }
        let string = String(data: data, encoding: .utf8)
        print("-------------Response---------------")
        print(string ?? "No string response")
        print("----------------------------")
    }
    task.resume()
}

executeRequest()
PlaygroundPage.current.needsIndefiniteExecution = true
