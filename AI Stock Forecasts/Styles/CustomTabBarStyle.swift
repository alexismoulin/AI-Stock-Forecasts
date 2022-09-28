import SwiftUI

struct CustomTabBarStyle: ViewModifier {

    var color: Color
    var tabItemWidth: CGFloat
    var selectedTab: Tab

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 8)
            .padding(.top, 14)
            .frame(height: 88, alignment: .top)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 34, style: .continuous))
            .background(background)
            .overlay(overlay)
            .strokeStyle(cornerRadius: 34)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
    }

    var background: some View {
        HStack {
            if selectedTab == .sector { Spacer() }
            if selectedTab == .topBottom { Spacer() }
            if selectedTab == .edit { Spacer(); Spacer() }
            Circle()
                .fill(color)
                .frame(width: tabItemWidth)
            if selectedTab == .explore { Spacer() }
            if selectedTab == .topBottom { Spacer(); Spacer() }
            if selectedTab == .edit { Spacer() }
        }.padding(.horizontal, 8)
    }

    var overlay: some View {
        HStack {
            if selectedTab == .sector { Spacer() }
            if selectedTab == .topBottom { Spacer() }
            if selectedTab == .edit { Spacer(); Spacer() }
            Rectangle()
                .fill(color)
                .frame(width: 28, height: 5)
                .cornerRadius(3)
                .frame(width: tabItemWidth)
                .frame(maxHeight: .infinity, alignment: .top)
            if selectedTab == .explore { Spacer() }
            if selectedTab == .topBottom { Spacer(); Spacer() }
            if selectedTab == .edit { Spacer() }
        }.padding(.horizontal, 8)
    }

}

extension View {
    func customTabBarStyle(color: Color, tabItemWidth: CGFloat, selectedTab: Tab) -> some View {
        return self.modifier(CustomTabBarStyle(color: color, tabItemWidth: tabItemWidth, selectedTab: selectedTab))
    }
}
