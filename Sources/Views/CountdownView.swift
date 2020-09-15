import SwiftUI

struct CountdownView: View {
    @ObservedObject var counter = Counter.shared
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
                if counter.state == .finished {
                    Rectangle()
                        .foregroundColor(appearance.finishedColor)
                } else if counter.remaining < 120 {
                    Rectangle()
                        .foregroundColor(appearance.warningColor)
                }
                Text(counter.remaining.remainingString)
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
