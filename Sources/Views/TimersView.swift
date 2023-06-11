import SwiftUI

struct TimersView: View {
    @Environment(Counter.self) private var counter
    
    var body: some View {
        Form {
            Section("Current") {
                CountdownCell(countdown: counter.current)
            }
            
            if !counter.queue.isEmpty {
                Section("Queue") {
                    ForEach(counter.queue, id: \.self) { countdown in
                        Button { withAnimation { counter.load(countdown) } } label: {
                            CountdownCell(countdown: countdown)
                        }
                        .accessibilityElement(children: .contain)
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
                        Text("Countdown")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderless)
                    
                    Divider()
                    
                    Button {
                        withAnimation {
                            counter.queue.append(Countdown(Date().droppingSeconds().addingTimeInterval(300)))
                        }
                    } label: {
                        Text("Scheduled")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderless)
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

struct TimersView_Previews: PreviewProvider {
    static var previews: some View {
        TimersView()
    }
}
