import SwiftUI

struct CountdownView: View {
    @ObservedObject var counter = Counter.shared
    @ObservedObject var appearance = Appearance.shared
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .foregroundColor(appearance.backgroundColor)
                    .overlay { // overlay fixes text alignment in the z-stack due to aspect ratio modifier
                        appearance.backgroundImage.map { image in
                            Image(uiImage: image)
                                .resizable(resizingMode: .stretch)
                                .aspectRatio(contentMode: .fill)
                        }
                    }
                
                WarningView()
                
                Text(counter.remaining.remainingString)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .font(appearance.font(for: geometry.size.width))
                    .foregroundColor(appearance.textColor)
            }
        }
        .ignoresSafeArea() // doesn't work alongside .aspectRatio modifier
    }
}


struct WarningView: View {
    @ObservedObject var counter = Counter.shared
    @ObservedObject var appearance = Appearance.shared
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    @State var warningIsHidden = false
    
    var body: some View {
        if counter.current.showsFinalWarning, counter.remaining < counter.current.finalWarningTime {
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
