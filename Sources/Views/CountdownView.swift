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
                TriggerView()
                Text(counter.remaining.remainingString)
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .font(appearance.font(for: geometry.size.width))
                    .foregroundColor(appearance.textColor)
            }
        }
        .aspectRatio(aspectRatio, contentMode: .fit)
    }
}


struct TriggerView: View {
    @ObservedObject var counter = Counter.shared
    @ObservedObject var appearance = Appearance.shared
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    @State var warningIsHidden = false
    
    var body: some View {
        if counter.current.showsFinalWarning && counter.remaining < counter.current.finalWarningTime {
            Rectangle()
                .foregroundColor(appearance.finalWarningColor)
                .opacity(counter.state == .finished && warningIsHidden ? 0 : 1)
                .onReceive(timer) { _ in
                    if counter.current.finalWarningFlashes {
                        warningIsHidden.toggle()
                    } else {
                        warningIsHidden = false
                    }
                }
        } else if counter.current.showsEarlyWarning && counter.remaining < counter.current.earlyWarningTime {
            Rectangle()
                .foregroundColor(appearance.earlyWarningColor)
        }
    }
}


struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView()
            .previewLayout(.sizeThatFits)
    }
}
