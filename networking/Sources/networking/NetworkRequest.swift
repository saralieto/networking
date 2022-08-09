import Foundation

public enum NetworkError: Error {
 case decodeError
 case invalidNetworkRequest
 case invalidResponse
 case unauthorized
 case unknown
}

open class NetworkRequest {
 var method: String
 var path: String
 var host: String?
 var header: [String: String]?
 var body: [String: String]?
 var httpScheme: String
 
 init(method: String,
      path: String,
      host: String?,
      header: [String: String]?,
      body: [String: String]?,
      httpScheme: String = "https") {
  self.method = method
  self.path = path
  self.host = host
  self.header = header
  self.body = body
  self.httpScheme = httpScheme
 }
 
 var urlRequest: URLRequest? {
  var urlComp = URLComponents()
  urlComp.path = path
  urlComp.scheme = httpScheme
  urlComp.host = host
  
  guard let url = urlComp.url else { return nil }
  
  var request = URLRequest(url: url)
  request.httpMethod = method
  request.allHTTPHeaderFields = header
  
  if let body = body {request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) }
  
  return request
 }
}
