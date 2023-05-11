//
// Created by Alexey on 01.02.2023.
//

import Foundation

public class AuthorizationManagerBuilder {

    public init(){}
    public var esiaAuthorizationManager:EsiaAuthorizationManager{
        return EsiaAuthorizationManager(.init(
                issuer: "https://iapsprelease.katharsis.ru/",
                clientId: "mobile",
                scopes: [
                    .openId,
                    .profile,
                    .mobileApi,
                    .offlineAccess
                ],
                callbackUrl: "ru.katharsis.soft.gosuslugi://signin"
                )
        )
    }
}
