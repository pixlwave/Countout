import SwiftUI

struct TimersView: View {
    @ObservedObject var counter = Counter.shared
    
    var body: some View {
        Form {
            Section(header: Text("Current")) {
                CountdownCell(countdown: counter.current)
            }
            
            if !counter.queue.isEmpty {
                Section(header: Text("Queue")) {
                    ForEach(counter.queue, id: \.self) { countdown in
                        Button { withAnimation { self.counter.load(countdown) } } label: {
                            CountdownCell(countdown: countdown)
                        }
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                }
            }
            
            Section {
                HStack {
                    Button {
                        withAnimation {
                            counter.queue.append(Countdown(Length(timeInterval: 300)))
                        }
                    } label: {
                        Spacer()
                        Text("Countdown")
                        Spacer()
                    }.buttonStyle(BorderlessButtonStyle())
                    
                    Divider()
                    
                    Button {
                        withAnimation {
                            counter.queue.append(Countdown(Date().addingTimeInterval(300)))
                        }
                    } label: {
                        Spacer()
                        Text("Scheduled")
                        Spacer()
                    }.buttonStyle(BorderlessButtonStyle())
                }
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        counter.queue.remove(atOffsets: offsets)
    }
    
    func move(source: IndexSet, destination: Int) {
        counter.queue.move(fromOffsets: source, toOffset: destination)
    }
}
