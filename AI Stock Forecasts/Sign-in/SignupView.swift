import SwiftUI
import AudioToolbox
import FirebaseAuth

struct SignupView: View {

    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var signupViewModel: SignupViewModel

    private let generator = UISelectionFeedbackGenerator()
    var sector: String

    var body: some View {
        ZStack {
            Image(signupViewModel.signupToggle ? "background-3" : "background-1")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(signupViewModel.fadeToggle ? 1 : 0)

            Color("secondaryBackground")
                .edgesIgnoringSafeArea(.all)
                .opacity(signupViewModel.fadeToggle ? 0 : 1)

            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    headerSection
                    switch authenticationManager.biometryType {
                    case .faceID:
                        GradientButton(buttonImage: "faceid", buttonTitle: "Login with FaceID") {
                            Task.init {
                                await authenticationManager.authenticateWithBiometrics()
                            }
                        }
                        .padding(.bottom, 5)
                    case .touchID:
                        GradientButton(buttonImage: "touchid", buttonTitle: "Login with TouchID") {
                            Task.init {
                                await authenticationManager.authenticateWithBiometrics()
                            }
                        }
                        .padding(.bottom, 5)

                    default:
                        creditentialLogin
                            .environmentObject(authenticationManager)
                    }
                }.padding(20)
            }
            .signupViewAnimationModifier(rotationAngle: signupViewModel.rotationAngle)
            .alert(isPresented: $signupViewModel.showAlert) {
                Alert(
                    title: Text(signupViewModel.alertTitle),
                    message: Text(signupViewModel.alertMessage),
                    dismissButton: .cancel()
                )
            }
        }
        .fullScreenCover(isPresented: $authenticationManager.isAuthenticated) {
            ContentView(sector: sector)
        }
    }

    // MARK: - Components

    var creditentialLogin: some View {
        Group {
            emailSection
            passwordSection
            signUpButton
            if signupViewModel.signupToggle {
                privacyPolicy
            }
            footerSection
        }
    }

    var headerSection: some View {
        Group {
            // Title
            Text(signupViewModel.signupToggle ? "Sign up" : "Sign in")
                .font(.largeTitle.bold())
                .foregroundColor(.white)
            // Subtitle
            Text("Forecast stocks & cryptos value with AI based technology")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        }
    }

    var emailSection: some View {
        HStack(spacing: 12) {
            TextfieldIcon(
                iconName: "envelope.open.fill",
                currentlyEditing: $signupViewModel.editingEmailTextField,
                passedImage: .constant(nil)
            )
            .scaleEffect(signupViewModel.emailIconBounce ? 1.2 : 1)
            TextField("Email", text: $signupViewModel.email) { isEditing in
                signupViewModel.editingEmailTextField = isEditing
                signupViewModel.editingPasswordTextField = false
                generator.selectionChanged()
                if isEditing {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                        signupViewModel.emailIconBounce.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                            signupViewModel.emailIconBounce.toggle()
                        }
                    }
                }
            }
            .colorScheme(.dark)
            .foregroundColor(.white.opacity(0.7))
            .textInputAutocapitalization(.never)
            .textContentType(.emailAddress)
        }
        .frame(height: 52)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white, lineWidth: 1)
                .blendMode(.overlay)
        )
        .background(
            Color("secondaryBackground")
                .cornerRadius(16)
                .opacity(0.8)
        )
    }

    var passwordSection: some View {
        HStack(spacing: 12) {
            TextfieldIcon(
                iconName: "key.fill",
                currentlyEditing: $signupViewModel.editingPasswordTextField,
                passedImage: .constant(nil)
            )
            .scaleEffect(signupViewModel.passwordIconBounce ? 1.2 : 1)
            SecureField("Password", text: $signupViewModel.password)
                .colorScheme(.dark)
                .foregroundColor(.white.opacity(0.7))
                .textInputAutocapitalization(.never)
                .textContentType(.password)
        }
        .frame(height: 52)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white, lineWidth: 1)
                .blendMode(.overlay)
        )
        .background(
            Color("secondaryBackground")
                .cornerRadius(16)
                .opacity(0.8)
        )
        .onTapGesture {
            signupViewModel.editingEmailTextField = false
            signupViewModel.editingPasswordTextField = true
            generator.selectionChanged()
            if signupViewModel.editingPasswordTextField {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                    signupViewModel.passwordIconBounce.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                        signupViewModel.passwordIconBounce.toggle()
                    }
                }
            }
        }
    }

    var signUpButton: some View {
        GradientButton(buttonTitle: signupViewModel.signupToggle ? "Create account" : "Sign in") {
            generator.selectionChanged()
            signupViewModel.signup()
        }
        .onAppear {
            Auth.auth().addStateDidChangeListener { _, user in
                if user != nil {
                    authenticationManager.isAuthenticated.toggle()
                }
            }
        }
    }

    var privacyPolicy: some View {
        Group {
            // Footnote
            Text("By clicking on Sign up, you agree to our Terms of service and Privacy policy")
                .font(.footnote)
                .foregroundColor(.white.opacity(0.7))
            // Custom Divider
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.white.opacity(0.1))
        }
    }

    var footerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // sign in - up button
            Button {
                withAnimation(.easeInOut(duration: 0.35)) {
                    signupViewModel.fadeToggle.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            signupViewModel.fadeToggle.toggle()
                        }
                    }
                }
                withAnimation(.easeInOut(duration: 0.7)) {
                    signupViewModel.signupToggle.toggle()
                    signupViewModel.rotationAngle += 180
                }
            } label: {
                HStack(spacing: 4) {
                    Text(signupViewModel.signupToggle ? "Already have an account?" : "Don't have an accout?")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.7))
                    GradientText(text: signupViewModel.signupToggle ? "Sign in" : "Sign up")
                        .font(.footnote.bold())
                }
            }
            if !signupViewModel.signupToggle {
                Button {
                    signupViewModel.sendPasswordResetEmail()
                } label: {
                    HStack(spacing: 4) {
                        Text("Forgot password?")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.7))
                        GradientText(text: "Reset password")
                            .font(.footnote.bold())
                    }
                }
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.white.opacity(0.1))

                Button {
                    print("Sign in with Apple")
                    signupViewModel.signInWithAppleObject.signInWithApple()
                } label: {
                    SigninWithAppleButtonView()
                        .frame(height: 50)
                        .cornerRadius(16)
                }

            }
        }
    }

}
