//
//  SecurityManager.swift
//  Core
//
//  Created by Jefferson Barbosa Puchalski on 08/07/20.
//  Copyright © 2020 PagSeguro Credisim. All rights reserved.
//

import Foundation
import LocalAuthentication

// MARK: - Protocols
/**
 Biometric authentication delegate.
 
 This protocol has all method called in biometrich authentication process, they are called by Security Manager delegate.
 All are not optional, so must be implemented in his herance.
 */
@available(iOS 11.0, *)
@available(OSX 10.13.2, *)
public protocol BiometricAuthenticationDelegate: AnyObject {
    func biometricAuthSupport( _ authenticationType: LABiometryType )
    func biometricAuthSuccess(_ message: String)
    func biometricAuthLAError(_ error: BiometricError)
    func biometricAuthFailure(_ message: String)
    func biometricAuthUserCancel()
}

public enum BiometricError: Error {
    case userFallbackInvalid
    case unknowError
}

/**
 Security Manager classs responsible for security matters.
*/
@available(iOS 11.0, *)
public class AuthSecManager {
    var context: LAContext
    public weak var delegate: BiometricAuthenticationDelegate?
    
    private var contextTitle: String = "Enter Password or Biometric"
    
    required init() {
       context = LAContext()
    }
    
    convenience init(cancelTitle: String) {
        self.init()
        self.contextTitle = cancelTitle
    }
    
    func setupInstance() {
        self.context.localizedCancelTitle = self.contextTitle
    }
    
    /**
     Prompt for user authentication chalange.
     */
    func promptForAuth(fallBackTitle: String, message: String) {
        self.context.localizedFallbackTitle = fallBackTitle
        self.context.localizedReason = message
        
        self.delegate?.biometricAuthSupport(self.context.biometryType)      // Send how biometric will be used.
        
        // First check if we have the needed hardware support.
        var error: NSError?
        self.context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        // get a LA context error
        let laError: LAError = LAError(_nsError: error ?? NSError())
        
        switch laError.code {
        case .appCancel:
            self.delegate?.biometricAuthFailure("A aplicacao cancelou a tentativa do autenticação biometrica.")
        case .authenticationFailed:
            self.delegate?.biometricAuthFailure("Falha ao autenticar o usuário.")
        case .invalidContext:
            self.delegate?.biometricAuthFailure("LA context has invalitaded.")
        case .userCancel:
            self.delegate?.biometricAuthUserCancel()
        case .userFallback:
            self.delegate?.biometricAuthLAError(.userFallbackInvalid)
        case .systemCancel:
            self.delegate?.biometricAuthFailure("Sistema cancelou esta operação!")
        case .passcodeNotSet:
            self.delegate?.biometricAuthFailure("O password não foi preenchido corretamente ou não existe.")
        case .touchIDNotAvailable:
            self.delegate?.biometricAuthFailure("Touch ID not avaliable")
        case .touchIDNotEnrolled:
            self.delegate?.biometricAuthFailure("Touch ID not register")
        case .touchIDLockout:
            self.delegate?.biometricAuthFailure("Touch ID is locked after many tries.")
        case .notInteractive:
            self.delegate?.biometricAuthFailure("Authentication is forbidden")
        case .watchNotAvailable:
            self.delegate?.biometricAuthFailure("Watch is not avaiable")
        @unknown default:
            self.delegate?.biometricAuthLAError(.unknowError)
        }
        
        self.context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: message) { (sucess, error) in
            if sucess {
                self.delegate?.biometricAuthSuccess("Usuario autenticado com sucesso")
            } else {
                self.delegate?.biometricAuthFailure(error?.localizedDescription ?? "Unknow Error")
            }
        }
    }
}
