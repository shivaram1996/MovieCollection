//
//  NetworkManager.swift
//  MovieCollection
//
//  Created by shiva ram on 25/09/22.
//

import Foundation

protocol NetworkClient {
    func getRequest<T: Decodable>(fromURL url: URL, httpMethod: HttpMethod, completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkManager : NetworkClient {
    
    public static let shared = NetworkManager()
    
    
    private init(){}
    
    /// Request data from an endpoint
    /// - Parameters:
    ///   - url: the URL
    ///   - httpMethod: The HTTP Method to use, either get or post in this case
    ///   - completion: The completion closure, returning a Result of either the generic type or an error
    func getRequest<T>(fromURL url: URL,httpMethod: HttpMethod, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        
        // Create the request. On the request you can define if it is a GET or POST request, add body and more.
        
//        let components = URLComponents()
//        components.queryItems
        
        var request = URLRequest(url: url)
        request.httpMethod =  httpMethod.method
        
        let urlSession = URLSession.shared.dataTask(with: request) { data, response, error in
            // First check if we got an error, if so we are not interested in the response or data.
            // Remember, and 404, 500, 501 http error code does not result in an error in URLSession, it
            // will only return an error here in case of e.g. Network timeout.
            if let error = error {
                completion(.failure(error))
                return
            }
            // Lets check the status code, we are only interested in results between 200 and 300 in statuscode. If the statuscode is anything
            // else we want to return the error with the statuscode that was returned. In this case, we do not care about the data.
            guard let urlResponse = response as? HTTPURLResponse else { return completion(.failure(ManagerErrors.invalidResponse)) }
            if !(200..<300).contains(urlResponse.statusCode) {
                return completion(.failure(ManagerErrors.invalidStatusCode(urlResponse.statusCode)))
            }
            
            // Now that all our prerequisites are fullfilled, we can take our data and try to translate it to our generic type of T.
            guard let data = data else { return }
            do {
                let movieList = try JSONDecoder().decode(T.self, from: data)
                completion(.success(movieList))
            } catch (let error){
                debugPrint("Could not translate the data to the requested type. Reason: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        // Start the request
        urlSession.resume()
    }
}
