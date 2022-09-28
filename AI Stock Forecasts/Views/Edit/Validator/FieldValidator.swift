import SwiftUI
import Combine

// MARK: - Field Validation

struct FieldChecker {

    internal var numberOfCheck = 0
    var errorMessage: String?

    var isFirstCheck: Bool { numberOfCheck == 1 }

    var valid: Bool {
        self.errorMessage == nil
    }
    init( errorMessage: String? = nil ) {
        self.errorMessage = errorMessage
    }
}

class FieldValidator<T>: ObservableObject where T: Hashable {
    typealias Validator = (T) -> String?

    @Binding private var bindValue: T
    @Binding private var checker: FieldChecker

    @Published public var value: T {
        willSet {
            doValidate(newValue)
        }
        didSet {
            bindValue = value
        }
    }
    private let validator: Validator

    var isValid: Bool { self.checker.valid }

    var errorMessage: String? { self.checker.errorMessage }

    init(_ value: Binding<T>, checker: Binding<FieldChecker>, validator: @escaping Validator) {
        self.validator = validator
        self._bindValue = value
        self.value = value.wrappedValue
        self._checker = checker
    }

    func doValidate(_ newValue: T? = nil ) {

        self.checker.errorMessage =
            (newValue != nil) ?
            self.validator( newValue! ) :
            self.validator( self.value )
        self.checker.numberOfCheck += 1
    }
}

// MARK: - Form Field

protocol ViewWithFieldValidator: View {
    var field: FieldValidator<String> {get}

}

extension ViewWithFieldValidator {

    internal func execIfValid( _ onCommit: @escaping () -> Void ) -> () -> Void {
        return {
            if self.field.isValid {
                onCommit()
            }
        }
    }

}

struct TextFieldWithValidator: ViewWithFieldValidator {
    // specialize validator for TestField ( T = String )
    typealias Validator = (String) -> String?

    var title: String?
    var onCommit:() -> Void = {}

    @ObservedObject var field: FieldValidator<String>

    init(
        title: String = "",
        value: Binding<String>,
        checker: Binding<FieldChecker>,
        onCommit: @escaping () -> Void,
        validator: @escaping Validator
    ) {
        self.title = title
        self.field = FieldValidator(value, checker: checker, validator: validator)
        self.onCommit = onCommit
    }

    init(title: String = "", value: Binding<String>, checker: Binding<FieldChecker>, validator: @escaping Validator) {
        self.init(title: title, value: value, checker: checker, onCommit: {}, validator: validator)
    }

    var body: some View {
        VStack {
            TextField( title ?? "", text: $field.value, onCommit: execIfValid(self.onCommit) )
                .onAppear { // run validation on appear
                    field.doValidate()
                }
        }
    }

}

struct SecureFieldWithValidator: ViewWithFieldValidator {
    // specialize validator for TestField ( T = String )
    typealias Validator = (String) -> String?

    var title: String?
    var onCommit:() -> Void

    @ObservedObject var field: FieldValidator<String>

    init(
        title: String = "",
        value: Binding<String>,
        checker: Binding<FieldChecker>,
        onCommit: @escaping () -> Void,
        validator: @escaping Validator
    ) {
        self.title = title
        self.field = FieldValidator(value, checker: checker, validator: validator)
        self.onCommit = onCommit
    }

    init(title: String = "", value: Binding<String>, checker: Binding<FieldChecker>, validator: @escaping Validator) {
        self.init(title: title, value: value, checker: checker, onCommit: {}, validator: validator)
    }

    var body: some View {
        VStack {
            SecureField( title ?? "", text: $field.value, onCommit: execIfValid(self.onCommit) )
                .onAppear { // run validation on appear
                    field.doValidate()
                }
        }
    }

}
