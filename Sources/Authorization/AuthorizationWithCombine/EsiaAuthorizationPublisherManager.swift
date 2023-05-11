//
// Created by Alexey on 17.01.2023.
//

import Combine
import AppAuthCore

/*public class EsiaAuthorizationPublisherManager {
    private var authorizationPublishers:EsiaAuthorizationPublishers
    public init(authorizationPublishers:EsiaAuthorizationPublishers){
        self.authorizationPublishers = authorizationPublishers
    }
     public func login() -> AnyPublisher<Bool, Never> {
         authorizationPublishers.discoverConfiguration(issuer: authorizationPublishers.issuer)
                 .map{(conf) -> OIDServiceConfiguration? in
                     return conf
                 }
                 .replaceError(with: nil)
                 .filter { $0 != nil}
                 .map{ (conf) -> OIDServiceConfiguration in
                     return conf
                 }
                 .eraseToAnyPublisher()

     }
}*/
