//
// Created by Alexey on 01.11.2022.
//

import FoundationExtensions
import AppAuth
import Combine
import Log

public enum AuthorizationError: Error {
    case authStateNil
    case authStateHasNotToken
    case authorizationManagerUninitialized
    case discoverConfigurationError
}

//import AuthenticationServices

/*struct AuthorizationConfiguration {
    init(
            issuer: String = "https://iapsprelease.katharsis.ru/",
            clientId: String = "mobile",
            scopes: [String] = [
                "openid",
                "profile",
                "mobile_api",
                "offline_access"
            ],
            callbackURL: String = "ru.katharsis.soft.gosuslugi://signin"
    ) {
        self.issuer = issuer
        self.clientId = clientId
        self.scopes = scopes
        self.callbackURL = callbackURL
    }

    let issuer: String
    let clientId: String
    let scopes: [String]
    let callbackURL: String
}*/

public class EsiaAuthorizationManager: AuthorizationManager, ObservableObject {
    


    //Создание объекта

    //private var myAppDelegate: AppDelegate?
    private var cancelable = Set<AnyCancellable>()

    public init(_ configuration:AuthorizationConfiguration){
        self.authConfiguration = configuration
    }
    
    public var authConfiguration:AuthorizationConfiguration
    public var issuer:String{
        get{
            authConfiguration.issuer
        }
        set{
            authConfiguration.issuer = newValue
        }
    }
    /*
    public var issuer: String

    public var clientId: String

    public var scopes: [String]

    public var callbackURL: String
     */

    //Необходимо для работы AppAuth
    private var currentAuthorizationFlow: OIDExternalUserAgentSession?
    //private var authorizationConfiguration: AuthorizationConfiguration = AuthorizationConfiguration()
    private var configuration: OIDServiceConfiguration?

    //Сохраняемые значения для входа
    @UserDefault(key: "authState", defaultValue: nil) private var authState: OIDAuthState? /*{
        didSet {
            print("EsiaAutherizationManager: authState \(authState)")
        }
    }*/


    //Проверка результатов авторизации
/*    @Published var isSuccessfulAuthorization = false
    public var isAuthorizationSuccessful: AnyPublisher<Bool, Never> {
        $isSuccessfulAuthorization
                .eraseToAnyPublisher()
    }*/
    private var loginFlowPublisher = CurrentValueSubject<Bool, Never>(true)
    public var isAuthorizationSuccessful: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($authState, self.loginFlowPublisher)
                .map { (authState, loginFlow) in
                    guard
                            let authState = authState,
                            authState.isAuthorized,
                            let response = authState.lastTokenResponse,
                            let accessTokenExpirationDate = response.accessTokenExpirationDate
                    else {
                        return false
                    }
                    guard response.accessToken != nil else {
                        return false
                    }
                    guard response.tokenType != nil else {
                        return false
                    }
                    guard Date() < accessTokenExpirationDate else {
                        return false
                    }
                    return true
                }
                //.print("Combine AuthorizationPublisher")
                .eraseToAnyPublisher()
    }
    
    public var isLoginFailed: AnyPublisher<Bool, Never>{
        loginSubject.eraseToAnyPublisher()
    }
    
    private var loginSubject:PassthroughSubject<Bool, Never> = .init()

    public var accessToken: String? {
        guard let authState = self.authState else{
            Log.log("Отсутствует состояние авторизации", category: "Авторизация")
            return nil
        }
        guard authState.isAuthorized else{
            Log.log("Последний токен недействителен", category: "Авторизация")
            return nil
        }
        guard let response = authState.lastTokenResponse else{
            Log.log("Последний ответ на запрос токена отсутствует", category: "Авторизация")
             return nil
        }
        guard let accessTokenExpirationDate = response.accessTokenExpirationDate else {
            Log.log("Отсутствует дата истечения токена", category: "Авторизация")
            return nil
        }


        if Date() > accessTokenExpirationDate {
            Log.log("Текущий access token истек", category: "Авторизация")
            self.updateAccessToken()
        }
        guard authState.isAuthorized else{
            Log.log("После обновления токен недействителен", category: "Авторизация")
             return nil
        }
        guard let token = self.authState?.lastTokenResponse?.accessToken
        else {
            Log.log("Обновленный токен nil", category: "Авторизация")
            return nil
        }
        Log.log("Токен: \(token)", category: "Авторизация")
        return "\(token)"
    }
    
    
    public var tokenType: String? {
        guard let authState = self.authState else{
            Log.log("Отсутствует состояние авторизации", category: "Авторизация")
            return nil
        }
        guard authState.isAuthorized else{
            Log.log("Последний токен недействителен", category: "Авторизация")
            return nil
        }
        guard let response = authState.lastTokenResponse else{
            Log.log("Последний ответ на запрос токена отсутствует", category: "Авторизация")
             return nil
        }
        guard let accessTokenExpirationDate = response.accessTokenExpirationDate else {
            Log.log("Отсутствует дата истечения токена", category: "Авторизация")
            return nil
        }


        if Date() > accessTokenExpirationDate {
            Log.log("Текущий access token истек", category: "Авторизация")
            self.updateAccessToken()
        }
        guard authState.isAuthorized else{
            Log.log("После обновления токен недействителен", category: "Авторизация")
             return nil
        }
        guard let type = response.tokenType
        else {
            Log.log("Обновленный токен nil", category: "Авторизация")
            return nil
        }
        Log.log("Тип токена: \(type)", category: "Авторизация")
        return "\(type)"
    }
    /*public var appDelegate:AppDelegate?{
        set{
            if myAppDelegate != nil {
                 return
            }
            myAppDelegate = newValue
        }
        get{
            return myAppDelegate
        }
    }*/

    /*private init(appDelegate: AppDelegate? = nil) {
        self.myAppDelegate = appDelegate
    }*/

    //Методы для обновления токена/проверки авторизации и т.п.
/*    public func checkAuthorization() {
        if accessToken != nil {
            isSuccessfulAuthorization = true
        } else {
            isSuccessfulAuthorization = false
        }
    }*/


    /*public func setAuthorizationConfiguration(
            issuer: String = "https://iapsprelease.katharsis.ru/",
            clientId: String = "mobile",
            scopes: [String] = [
                "openid",
                "profile",
                "mobile_api",
                "offline_access"
            ],
            callbackURL: String = "ru.katharsis.soft.gosuslugi://signin") {
        authorizationConfiguration = AuthorizationConfiguration(issuer: issuer, clientId: clientId, scopes: scopes, callbackURL: callbackURL)
    }*/


    private func updateAccessToken() {
        guard let authState else {
            Log.log("Отсутствует состояние авторизации", category: "Авторизация")
            return
        }
        guard let request = authState.tokenRefreshRequest() else {
            Log.log("Не создан запрос обновления токена", category: "Авторизация")
            return
        }
        OIDAuthorizationService.perform(
            request,
            originalAuthorizationResponse:authState.lastAuthorizationResponse
        ){ tokenResponse, error in
            Log.log("Результат запроса токена:\ntokenResponse:\(String(describing:tokenResponse))\nError:\(error.debugDescription)", category: "Авторизация")
            authState.update(with: tokenResponse, error: error)
        }
    }


    public func login() {
        /*
        if let authState = self.authState {
            if authState.isAuthorized {
                self.loginFlowPublisher.send(true)
                ///MARK: need to check
                //authState.performAction(freshTokens: { (_, _, _) in })
                return
            }
            //self.loginFlowPublisher.send(false)
        }
         */

        OIDAuthorizationService.discoverConfiguration(forIssuer: URL(string: self.authConfiguration.issuer)!, completion: { [weak self] configuration, error in
            if let error {
                Log.log(error: error, category: "Авторизации")
                return
            }
            guard let self else {
                Log.log("EsiaAuthorizationManager является nil во время поиска конфигурации", category: "Авторизация")
                return
            }

            guard let configuration else {
                if let error{
                    Log.log(error: error, category: "Авторизация")
                } else{
                    Log.log("Неизвестная ошибка во время поиска конфигурации авторизации", level: .error, category: "Авторизация")
                }
                return
            }
            self.configuration = configuration
        
            /*guard let appDelegate = self.myAppDelegate else {
                print("Authentication manager have no appDelegate")
                return
            }*/
//            print(UIApplication.shared)
            /*guard let viewController = viewController else {
                print("No browser viewController")
                return
            }*/
            //print(configuration)
            //print(self.authorizationConfiguration)
            let request = OIDAuthorizationRequest(
                    configuration: configuration,
                    clientId: self.authConfiguration.clientId,
                    scopes: Array(self.authConfiguration.scopes).map{$0.rawValue},
                    redirectURL: URL(string: self.authConfiguration.callbackUrl)!,
                    responseType: OIDResponseTypeCode,
                    additionalParameters: nil
            )
            
            /* let session = ASWebAuthenticationSession(url: request.configuration.issuer!, callbackURLScheme: nil){ url, error in
            }*/
            
            //session.
            let vc = UIApplication.shared.windows.first!.rootViewController!
//            let agent = OIDExternalUserAgentIOS(presenting: vc, prefersEphemeralSession: false)
            self.currentAuthorizationFlow = OIDAuthState.authState(
                    byPresenting: request,
                    presenting: vc,
                    prefersEphemeralSession: true) { [weak self] authState, error in
                guard let self = self else {
                    return
                }
                if let authState = authState {
                    self.authState = authState
                    guard let lastTokenResponse = authState.lastTokenResponse else{return}
                    if let accessToken = lastTokenResponse.accessToken{
                        Log.log("Access token: \(accessToken)", category: "Авторизация")
                    }
                    if let refreshToken = lastTokenResponse.refreshToken{
                        Log.log("Refresh token: \(refreshToken)", category: "Авторизация")
                    }
                    //self.isSuccessfulAuthorization = true
                } else {
                    if let error{
                        Log.log(error: error, category: "Авторизация")
                    }else{
                        Log.log("Ошибка получения токена", category: "Авторизация")
                    }
                    self.loginSubject.send(true)
                    self.authState = nil
                }
            }
            

        })
        /*return $isAuthorizationSuccesful
                .eraseToAnyPublisher()*/
    }

    public func logout() {
        //print("logout in manager")
        guard let authState else {
            Log.log("AuthState является nil во время выхода из учетной записи", category: "Авторизация")
            return
        }
        self.authState = nil
        guard let accessToken = authState.lastTokenResponse?.accessToken else {
            Log.log("accessToken является nil во время выхода из учетной записи", category: "Авторизация")
            return
        }
        guard let issuer = URL(string: self.authConfiguration.issuer) else{
            Log.log("Отсутствует issuer для логаута", level: .error, category: "Авторизация")
            return
        }
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) { [weak self] (configuration: OIDServiceConfiguration?, error: Error?) in
            if let error {
                Log.log(error: error, category: "Авторизации")
                return
            }
            guard let self else {
                Log.log("EsiaAuthorizationManager является nil во время поиска конфигурации", category: "Авторизация")
                return
            }

            guard let configuration = configuration else {
                if let error{
                    Log.log(error: error, category: "Авторизация")
                } else{
                    Log.log("Неизвестная ошибка во время поиска конфигурации авторизации", level: .error, category: "Авторизация")
                }
                return
            }
            self.configuration = configuration


            let logoutRequest = OIDEndSessionRequest(
                    configuration: configuration,
                    idTokenHint: accessToken,
                    postLogoutRedirectURL: URL(string: self.authConfiguration.callbackUrl)!,
                    additionalParameters: nil
            )
            //print("vc")
            let vc = UIApplication.shared.windows.first!.rootViewController!
            //print("agent")
            let agent = OIDExternalUserAgentIOS(presenting: vc, prefersEphemeralSession: true)!
            self.currentAuthorizationFlow = OIDAuthorizationService.present(logoutRequest, externalUserAgent: agent) { [weak self] (endSessionResponse: AppAuthCore.OIDEndSessionResponse?, error) in
                if let error {
                    Log.log(error: error, category: "Авторизации")
                    return
                }
                guard let self else {
                    Log.log("EsiaAuthorizationManager является nil во время выхода из учетной записи")
                    return
                }
                Log.log("Выход из учетной записи выполнен успешно")
                self.authState = nil
                //self.isSuccessfulAuthorization = false
            }
        }
    }
}

