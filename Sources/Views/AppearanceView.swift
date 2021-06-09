import SwiftUI

struct AppearanceView: View {
    @ObservedObject var appearance = Appearance.shared
    @State private var isPresentingPhotoPicker = false
    @State private var isLoadingPhoto = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                CountdownView()
                    .aspectRatio(4 / 3, contentMode: .fit)
                    .cornerRadius(7)
                    .padding()
                
                Spacer()
                
                ScrollView {
                    GroupBox(label: Text("Font")) {
                        Picker("Style", selection: $appearance.fontStyle) {
                            Text("Normal").tag(Appearance.FontStyle.normal)
                            Text("Light").tag(Appearance.FontStyle.light)
                            Text("Serif").tag(Appearance.FontStyle.serif)
                            Text("Rounded").tag(Appearance.FontStyle.rounded)
                        }
                        .pickerStyle(.segmented)
                        Slider(value: $appearance.fontScale, in: 0.1...0.4) {
                            Text("Size")
                        }
                        ColorPicker("Colour", selection: $appearance.textColor)
                    }
                    .padding(.horizontal)
                    
                    GroupBox(label: Text("Background")) {
                        ColorPicker("Background", selection: $appearance.backgroundColor)
                        
                        HStack {
                            Text("Image")
                            Spacer()
                            Button("Load") {
                                isPresentingPhotoPicker = true
                            }.padding(.horizontal)
                            Button("Clear") {
                                appearance.backgroundImageData = nil
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    GroupBox(label: Text("Warnings")) {
                        ColorPicker("Early Warning", selection: $appearance.earlyWarningColor)
                        ColorPicker("Final Warning", selection: $appearance.finalWarningColor)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .navigationBarTitle("Appearance", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") { appearance.reset() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { presentationMode.wrappedValue.dismiss() }
                }
            }
            .sheet(isPresented: $isPresentingPhotoPicker) {
                PhotoPicker(isLoadingPhoto: $isLoadingPhoto)
                    .overlay(
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color.black.opacity(0.3))
                            ProgressView("Loading")
                                .padding()
                                .background(.regularMaterial)
                                .cornerRadius(15)
                        }
                        .opacity(isLoadingPhoto ? 1 : 0)
                    )
            }
        }
    }
}

struct AppearanceView_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceView()
    }
}
