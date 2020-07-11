import SwiftUI

struct CountdownView: View {
    @State var hasDisplayConnected = false
    @ObservedObject var countdown = CountdownTimer.shared
    @ObservedObject var appearance = Appearance.shared
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .foregroundColor(appearance.backgroundColor)
                if let image = appearance.backgroundImage {
                    Image(uiImage: image)
                        .resizable(resizingMode: .stretch)
                }
                if countdown.isScheduled {
                    Text(countdown.endDate, style: .timer)
                        .frame(width: geometry.size.width, height: geometry.size.width / 4 * 3, alignment: .center)
                        .font(.custom(appearance.fontName, size: appearance.fontScale * geometry.size.width))
                        .foregroundColor(appearance.textColor)
                } else {
                    Text(countdown.remaining.remainingString())
                        .frame(width: geometry.size.width, height: geometry.size.width / 4 * 3, alignment: .center)
                        .font(.custom(appearance.fontName, size: appearance.fontScale * geometry.size.width))
                        .foregroundColor(appearance.textColor)
                }
            }
        }
        .aspectRatio(4/3, contentMode: .fit)
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView()
            .previewLayout(.sizeThatFits)
    }
}
