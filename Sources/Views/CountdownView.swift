import SwiftUI

struct CountdownView: View {
    @ObservedObject var countdown = CountdownTimer.shared
    @ObservedObject var appearance = Appearance.shared
    
    var aspectRatio: CGFloat = 4 / 3
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .foregroundColor(appearance.backgroundColor)
                if let image = appearance.backgroundImage {
                    Image(uiImage: image)
                        .resizable(resizingMode: .stretch)
                }
                Text(countdown.remaining.remainingString)
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .font(appearance.font(for: geometry.size.width))
                    .foregroundColor(appearance.textColor)
            }
        }
        .aspectRatio(aspectRatio, contentMode: .fit)
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView()
            .previewLayout(.sizeThatFits)
    }
}
