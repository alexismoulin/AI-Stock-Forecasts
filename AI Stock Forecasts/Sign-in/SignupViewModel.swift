import SwiftUI
import FirebaseAuth

class SignupViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var editingEmailTextField: Bool = false
    @Published var editingPasswordTextField: Bool = false
    @Published var emailIconBounce: Bool = false
    @Published var passwordIconBounce: Bool = false
    @Published var signupToggle: Bool = true
    @Published var rotationAngle: Double = 0
    @Published var signInWithAppleObject = SigninWithAppleObject()
    @Published var fadeToggle: Bool = true
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""

    func signup() {
        if signupToggle {
            Auth.auth().createUser(withEmail: email, password: password) { _, error in
                guard error == nil else {
                    self.alertTitle = "User creation error"
                    self.alertMessage = error!.localizedDescription
                    self.showAlert = true
                    return
                }
                print("User signed up")
            }
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { _, error in
                guard error == nil else {
                    self.alertTitle = "Sign in error"
                    self.alertMessage = error!.localizedDescription
                    self.showAlert = true
                    return
                }
                print("User signed in")
            }
        }
    }

    func sendPasswordResetEmail() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            guard error == nil else {
                self.alertTitle = "Password reset error"
                self.alertMessage = error!.localizedDescription
                self.showAlert = true
                return
            }
            self.alertTitle = "Password reset email sent"
            self.alertMessage = "Check your inbox for an email to reset your password"
            self.showAlert = true
        }
    }
}
