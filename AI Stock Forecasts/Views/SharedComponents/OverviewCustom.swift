import SwiftUI

struct OverviewCustom: View {

    @ObservedObject var company: CustomCompany
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    // MARK: - Component functions

    func createSquaredIcon(imageName: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 16, height: 16)
                .foregroundColor(.white.opacity(0))
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.squaredGray, lineWidth: 1)
                )
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 12)
        }
    }

    func createSquaredIcon(systemName: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 16, height: 16)
                .foregroundColor(.white.opacity(0))
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.squaredGray, lineWidth: 1)
                )
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.squaredGray)
                .frame(width: 12)
        }
    }

    // MARK: - body

    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.background)
                    .colorScheme(.light)
                    .frame(width: 100, height: 84)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)

                Image(uiImage: UIImage(named: "custom")!)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .padding(2)
                    .frame(maxWidth: 100, maxHeight: 84)
                    .foregroundColor(Color(company.wrappedColorName))
            }

            VStack(alignment: .leading, spacing: 5) {
                Text("\(company.wrappedName)")
                    .font(.system(size: 15, weight: .semibold))
                HStack {
                    createSquaredIcon(systemName: "building.columns.fill")
                    Text(company.wrappedId)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.squaredGray)
                }
                HStack {
                    createSquaredIcon(systemName: "newspaper")
                    Text(company.wrappedName)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.squaredGray)
                }
                HStack {
                    createSquaredIcon(imageName: colorScheme == .light ? "twitter32-gray" : "twitter32-white")
                    Text(company.wrappedArobase)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.squaredGray)
                }
            }.padding(.bottom, 3)

            Spacer()

            VStack {
                Spacer()
                SectorThumbnail(sector: company.sector ?? "all")
                    .padding(8)
            }
        }
        .frame(maxWidth: 800, maxHeight: 100)
        .background(.ultraThinMaterial)
        .cornerRadius(10)
        .padding([.top, .leading, .trailing], 10)
        .shadow(radius: 3)
    }
}
