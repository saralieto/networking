import Foundation

public protocol NetworkManagerProtocol {
 func performRequest<T: Decodable>(request: NetworkRequest, responseModel: T.Type) async -> Result<T, NetworkError>
}

public class NetworkManager: NetworkManagerProtocol {
 public init() {}
 
 public func performRequest<T: Decodable>(request: NetworkRequest,
                                          responseModel: T.Type) async -> Result<T, NetworkError> {
  guard let request = request.urlRequest else { return .failure(.invalidNetworkRequest) }
  
  do {
   let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
   guard let response = response as? HTTPURLResponse else { return .failure(.invalidResponse) }
   
   switch response.statusCode {
   case 200...299:
    guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
     return .failure(.decodeError)
    }
    return .success(decodedResponse)
   case 401:
    return .failure(.unauthorized)
   default:
    return .failure(.unknown)
   }
  } catch {
   return .failure(.unknown)
  }
 }
}
