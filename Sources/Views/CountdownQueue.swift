import SwiftUI

struct CountdownQueue: View {
    @ObservedObject var countdown = CountdownTimer.shared
    
    var body: some View {
        List {
            Section {
                CountdownCell(countdown: countdown.current)
            }
            
            Section {
                ForEach(countdown.queue, id: \.self) { countdown in
                    Button { withAnimation { self.countdown.load(countdown) } } label: {
                        CountdownCell(countdown: countdown)
                    }
                }
                .onDelete(perform: delete)
            }
            
            Section {
                HStack {
                    HStack {
                        Spacer()
                        Button("Countdown") {
                            withAnimation {
                                countdown.queue.append(Countdown(Length(timeInterval: 300)))
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Spacer()
                    }
                    
                    Divider()
                    
                    HStack {
                        Spacer()
                        Button("Scheduled") {
                            withAnimation {
                                countdown.queue.append(Countdown(Date().addingTimeInterval(300)))
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Spacer()
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .overlay(Divider(), alignment: .top)
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            countdown.queue.remove(at: index)
        }
    }
}
