import Foundation
import LocalAuthentication

class AuthenticationManager: ObservableObject {
    private(set) var context = LAContext()
    @Published var biometryType: LABiometryType = .none
    private(set) var canEvaluatePolicy: Bool = false
    @Published var isAuthenticated: Bool = false
    @Published private(set) var errorDescription: String?
    @Published var showAlert: Bool = false

    init() {
        getBiometryType()
    }

    func getBiometryType() {
        canEvaluatePolicy = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        biometryType = context.biometryType
    }

    func authenticateWithBiometrics() async {
        context = LAContext()

        if canEvaluatePolicy {
            let reason = "Log into your account"
            do {
                let success = try await context.evaluatePolicy(
                    .deviceOwnerAuthenticationWithBiometrics,
                    localizedReason: reason
                )
                if success {
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                        print("Authenticated: \(self.isAuthenticated)")
                    }
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.errorDescription = error.localizedDescription
                    self.showAlert = true
                    self.biometryType = .none
                }
            }
        }
    }

}
