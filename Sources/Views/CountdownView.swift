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
    @State var finishedIsHidden = false
    
    var body: some View {
        if counter.current.hasSecondWarning && counter.remaining < counter.current.secondWarningTime {
            Rectangle()
                .foregroundColor(appearance.secondWarningColor)
                .opacity(counter.state == .finished && finishedIsHidden ? 0 : 1)
                .onReceive(timer) { _ in
                    finishedIsHidden = counter.current.flashWhenFinished ? !finishedIsHidden : false
                }
        } else if counter.current.hasFirstWarning && counter.remaining < counter.current.warningTime {
            Rectangle()
                .foregroundColor(appearance.warningColor)
        }
    }
}


struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView()
            .previewLayout(.sizeThatFits)
    }
}
