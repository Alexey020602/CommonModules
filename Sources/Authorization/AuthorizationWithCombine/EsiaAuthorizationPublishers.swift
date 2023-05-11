//
// Created by Alexey on 17.01.2023.
//

import FoundationExtensions
import AppAuth
import Combine
import Log

enum AuthError: Error {
    case invalidIssuerUrl
    case shouldNeverHappen
    //Не удалось найти какие-то объекты для выполнения авторизации
    case noViewController
    case noUserAgent
    case invalidGrant
    case noPreviousAuthState
    case noConfigurationWithoutError
    case noAuthStateWithoutError
    case unknownError
    case logoutWithoutAccessToken
    case noTokenRefreshRequest
    case invalidRedirectUrl
    case nilConfigurationFromDiscover
    case nilAccessToken
    case nilAuthState
}

public class CAuthorizationManager{
    
}

public class AppAuthManager{
    private var session:OIDExternalUserAgentSession? = nil
    private var cancellable = Set<AnyCancellable>()
    private let configuration:AuthorizationConfiguration
    @UserDefault(key: "authState", defaultValue: nil)public private(set) var authState:OIDAuthState?
    
    public init(_ configuration: AuthorizationConfiguration) {
        self.configuration = configuration
    }
    
    func login(){
        self.loginWithAuthState()
            .sink { completion in
                switch completion{
                case .failure(let error):
                    Log.log(error: error, category: "Авторизация")
                case .finished:
                    Log.log("Состояние авторизации получено успешно", category: "Авторизация")
                }
            } receiveValue: { authState in
                Log.log("Полученный authState: \(String(describing: authState))", category: "Авторизация")
                self.authState = authState
            }
            .store(in: &cancellable)
    }
    
    var token:AnyPublisher<String, any Error>{
        authState?.performAction()
            .map{$0.accessToken}
            .tryMap{ token in
                guard let token else{
                    throw AuthError.nilAccessToken
                }
                return token
            }.eraseToAnyPublisher()
        ??
        Fail(error:AuthError.nilAuthState).eraseToAnyPublisher()
    }
    
    /*
    var tokenType:AnyPublisher<String, any Error>{
        authState?.lastTokenResponse.
    }
    */
    
    func loginWithAuthState() -> AnyPublisher<OIDAuthState?, any Error>{
        guard let discoverUrl = URL(string:self.configuration.issuer) else{
            return Fail(error: AuthError.invalidIssuerUrl).eraseToAnyPublisher()
        }
        guard let redirectUrl = URL(string: self.configuration.callbackUrl) else{
            return Fail(error: AuthError.invalidRedirectUrl).eraseToAnyPublisher()
        }
        return OIDAuthorizationService.discoverConfiguration(forIssuer: discoverUrl)
            .flatMap { configuration in
                guard let configuration else{
                    return Fail<OIDAuthState?, any Error>(error: AuthError.nilConfigurationFromDiscover).eraseToAnyPublisher()
                }
                
                let request = OIDAuthorizationRequest(
                    configuration: configuration,
                    clientId: self.configuration.clientId,
                    scopes: Array(self.configuration.scopes).map{$0.rawValue},
                    redirectURL: redirectUrl,
                    responseType: OIDResponseTypeCode,
                    additionalParameters: nil
                )
                
                return self.authState(request)
            }
            .eraseToAnyPublisher()
    }
    
    public func present(_ request:OIDAuthorizationRequest) -> AnyPublisher<OIDAuthorizationResponse?, any Error>{
            guard let viewController = UIApplication.shared.windows.first?.rootViewController else{
                return Fail(error: AuthError.noViewController).eraseToAnyPublisher()
            }
            guard let agent = OIDExternalUserAgentIOS(presenting: viewController, prefersEphemeralSession: true) else{
                return Fail(error: AuthError.noUserAgent).eraseToAnyPublisher()
            }
            return self.present(request, externalUserAgent: agent)
    }
    
    public func present(_ request:OIDEndSessionRequest) -> AnyPublisher<OIDEndSessionResponse?, any Error>{
            guard let viewController = UIApplication.shared.windows.first?.rootViewController else{
                return Fail(error: AuthError.noViewController).eraseToAnyPublisher()
            }
            guard let agent = OIDExternalUserAgentIOS(presenting: viewController, prefersEphemeralSession: true) else{
                return Fail(error: AuthError.noUserAgent).eraseToAnyPublisher()
            }
            return self.present(request, externalUserAgent: agent)
    }
    
    public func authState(_ byPresenting:OIDAuthorizationRequest) -> AnyPublisher<OIDAuthState?, any Error>{
        guard let viewController = UIApplication.shared.windows.first?.rootViewController else{
            return Fail(error: AuthError.noViewController).eraseToAnyPublisher()
        }
        guard let agent = OIDExternalUserAgentIOS(presenting: viewController, prefersEphemeralSession: true) else{
            return Fail(error: AuthError.noUserAgent).eraseToAnyPublisher()
        }
        return self.authState(byPresenting: byPresenting, externalUserAgent: agent)
    }
}

///Расширение для использования методов OIDAuthSession
extension AppAuthManager{
    
    public func authState(
        byPresenting: OIDAuthorizationRequest,
        externalUserAgent: OIDExternalUserAgent
    ) -> AnyPublisher<OIDAuthState?, any Error>{
        return Future{promise in
            self.session = OIDAuthState.authState(
                byPresenting: byPresenting,
                externalUserAgent: externalUserAgent
            ){ authState, error in
                if let error{
                    promise(.failure(error))
                    return
                }
                promise(.success(authState))
            }
        }.eraseToAnyPublisher()
    }
    
    public func authState(
        byPresenting: OIDAuthorizationRequest,
        presenting: UIViewController
    ) -> AnyPublisher<OIDAuthState?, any Error>{
        return Future{promise in
            self.session = OIDAuthState.authState(
                byPresenting: byPresenting,
                presenting: presenting
            ){ authState, error in
                if let error{
                    promise(.failure(error))
                    return
                }
                promise(.success(authState))
            }
        }.eraseToAnyPublisher()
    }
    
    public func authState(
        byPresenting: OIDAuthorizationRequest,
        presenting: UIViewController,
        prefersEphemeralSession:Bool
    ) -> AnyPublisher<OIDAuthState?, any Error>{
        return Future{promise in
            self.session = OIDAuthState.authState(
                byPresenting: byPresenting,
                presenting: presenting,
                prefersEphemeralSession: prefersEphemeralSession) { authState, error in
                if let error{
                    promise(.failure(error))
                    return
                }
                promise(.success(authState))
            }
        }.eraseToAnyPublisher()
    }
}
///Расширение для использования методов OIDAuthorizationService
extension AppAuthManager{
    
    //Запросы авторизации
    public func present(
        _ request:OIDAuthorizationRequest,
        presenting:UIViewController
    ) -> AnyPublisher<OIDAuthorizationResponse?, any Error>{
        return Future{ promise in
            self.session = OIDAuthorizationService.present(request, presenting: presenting) { authorizationResponse, error in
                if let error{
                    promise(.failure(error))
                    return
                }
                promise(.success(authorizationResponse))
            }
        }.eraseToAnyPublisher()
    }
    
    public func present(
        _ request:OIDAuthorizationRequest,
        presenting:UIViewController,
        prefersEphemeralSession:Bool
    ) -> AnyPublisher<OIDAuthorizationResponse?, any Error>{
        return Future{ promise in
            self.session = OIDAuthorizationService.present(request, presenting: presenting, prefersEphemeralSession: prefersEphemeralSession) { authorizationResponse, error in
                if let error{
                    promise(.failure(error))
                    return
                }
                promise(.success(authorizationResponse))
            }
        }.eraseToAnyPublisher()
    }
    
    public func present(
        _ request:OIDAuthorizationRequest,
        externalUserAgent:OIDExternalUserAgent
    ) -> AnyPublisher<OIDAuthorizationResponse?, any Error>{
        return Future{ promise in
            self.session = OIDAuthorizationService.present(request, externalUserAgent: externalUserAgent) { authorizationResponse, error in
                if let error{
                    promise(.failure(error))
                    return
                }
                promise(.success(authorizationResponse))
            }
        }.eraseToAnyPublisher()
    }
    
    //Запросы окончание сессии
    public func present(
        _ request:OIDEndSessionRequest,
        externalUserAgent:OIDExternalUserAgent
    ) -> AnyPublisher<OIDEndSessionResponse?, any Error>{
        return Future{ promise in
            self.session = OIDAuthorizationService.present(request, externalUserAgent: externalUserAgent) { endSessionResponse, error in
                if let error{
                    promise(.failure(error))
                    return
                }
                promise(.success(endSessionResponse))
            }
        }.eraseToAnyPublisher()
    }
}
/*
public class EsiaAuthorizationPublishers {
    private var cacellable = Set<AnyCancellable>()
    
    private var currentAuthorizationFlow:OIDExternalUserAgentSession?
    
    public var issuer: String
    
    public var clientId: String
    
    public var scopes: [String]
    
    public var callbackURL: String
    @UserDefault(key:"authState1", defaultValue: nil) var authState:OIDAuthState?
    
    public init(issuer: String, clientId: String, scopes: [String], callbackUrl: String) {
        self.issuer = issuer
        self.clientId = clientId
        self.scopes = scopes
        self.callbackURL = callbackUrl
    }
    var accessToken:AnyPublisher<String, any Error>{
        return Future{ promise in
            self.authState?.performAction{ accessToken, idToken, error in
                if let error{
                    promise(Result.failure(error))
                    return
                }
                guard let accessToken else{
                    promise(.failure(AuthError.unknownError))
                    return
                }
                    promise(.success(accessToken))
            }
        }.eraseToAnyPublisher()
    }
    
    
    
     
}
*/
