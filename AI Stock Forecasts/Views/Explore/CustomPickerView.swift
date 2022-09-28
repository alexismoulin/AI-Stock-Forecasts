import SwiftUI

struct CustomPickerView: View {

    // MARK: - Properties

    var items: [Company]

    @State private var filteredItems: [Company] = []
    @State private var filterString: String = ""
    @State private var frameHeight: CGFloat = 400

    @Binding var pickerField: String
    @Binding var presentPicker: Bool
    @Binding var selectedCompanyId: String

    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    private var filterBinding: Binding<String> {
        Binding<String>(
            get: { filterString },
            set: {
                filterString = $0
                if filterString != "" {
                    filteredItems = items.filter { $0.name.lowercased().contains(filterString.lowercased()) }
                } else {
                    filteredItems = items
                }
                setHeight()
            }
        )
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).onTapGesture {
                withAnimation {
                    presentPicker = false
                }
            }
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    cancelTopBar
                    filteredTextViewSection
                    companyList
                }
                .colorScheme(.light)
                .background(Color.secondaryPickerColor)
                .cornerRadius(10)
                .frame(maxWidth: sizeClass == .compact ? 400 : 800)
                .padding(.horizontal, 10)
                .frame(height: frameHeight)
                .padding(.top, 40)

               Spacer()
            }
        }
        .onAppear {
            filteredItems = items
            setHeight()
        }
    }

    // MARK: - Custom Components

    private var cancelTopBar: some View {
        HStack {
            Button {
                withAnimation {
                    presentPicker = false
                }
            } label: {
                Text("Cancel")
            }
            .padding(10)
            Spacer()
        }
        .background(Color(UIColor.darkGray))
        .foregroundColor(.white)
    }

    private var filteredTextViewSection: some View {
        Group {
            Text("Tap an entry to select it, or type in a new entry.")
                .font(.caption)
                .padding(.leading, 10)
            TextField("Filter by entering text", text: filterBinding)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
    }

    private var companyList: some View {
        List {
            ForEach(filteredItems) { item in
                Button {
                    pickerField = item.name
                    selectedCompanyId = item.id
                    withAnimation {
                        presentPicker = false
                    }
                } label: {
                    HStack {
                        Text(item.name)
                        Spacer()
                        createMiniLogos(company: item)
                            .padding(.horizontal, 5)
                    }
                }.buttonStyle(.plain)
            }
        }.listStyle(.plain)
    }

    // MARK: - Helper functions

    fileprivate func setHeight() {
        withAnimation {
            if filteredItems.count > 5 {
                frameHeight = 400
            } else if filteredItems.count == 0 {
                frameHeight = 130
            } else {
                frameHeight = CGFloat(filteredItems.count * 45 + 130)
            }
        }
    }

    @ViewBuilder
    func createMiniLogos(company: Company) -> some View {
        if company.custom {
            Image("custom")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 50, maxHeight: 32)
                .foregroundColor(Color(company.colorName!))
        } else {
            Image(company.hash)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 50, maxHeight: 32)
        }
    }

}
