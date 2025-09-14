import SwiftUI

struct AppearanceView: View {
    @Bindable var appearance: Appearance
    
    @Namespace private var namespace
    @State private var isPresentingPhotoPicker = false
    @State private var isLoadingPhoto = false
    private let photoPickerID = "PhotoPicker"
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                outputPreview
                
                Spacer()
                
                appearanceForm
            }
            .background() // without this the output preview has a grey background
            .navigationTitle("Appearance")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset", action: appearance.reset)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm, action: dismiss.callAsFunction)
                }
            }
            .sheet(isPresented: $isPresentingPhotoPicker) {
                PhotoPicker(isLoadingPhoto: $isLoadingPhoto)
                    .overlay {
                        ZStack {
                            Rectangle()
                                .ignoresSafeArea()
                                .foregroundStyle(.black.opacity(0.3))
                            ProgressView("Loading")
                                .padding()
                                .background(.regularMaterial)
                                .cornerRadius(15)
                        }
                        .opacity(isLoadingPhoto ? 1 : 0)
                    }
                    // disabled as the second presentation has a full screen animation on the iPadOS 26 release candidate
                    // .navigationTransition(.zoom(sourceID: photoPickerID, in: namespace))
            }
        }
    }
    
    var outputPreview: some View {
        CountdownView()
            .aspectRatio(4 / 3, contentMode: .fit)
            .cornerRadius(7)
            .padding()
    }
    
    var appearanceForm: some View {
        Form {
            Section("Font") {
                Slider(value: $appearance.fontScale, in: 0.1...0.4) {
                    Text("Size")
                } minimumValueLabel: {
                    Image(systemName: "textformat.size.smaller")
                } maximumValueLabel: {
                    Image(systemName: "textformat.size.larger")
                }
                .foregroundStyle(.secondary)
                .fontWeight(.medium)
                
                Picker("Style", selection: $appearance.fontStyle) {
                    Text("Normal").tag(Appearance.FontStyle.normal)
                    Text("Light").tag(Appearance.FontStyle.light)
                    Text("Serif").tag(Appearance.FontStyle.serif)
                    Text("Rounded").tag(Appearance.FontStyle.rounded)
                }

                ColorPicker("Colour", selection: $appearance.textColor)
            }
            
            Section("Background") {
                ColorPicker("Colour", selection: $appearance.backgroundColor)
                
                LabeledContent("Image") {
                    HStack {
                        Button("Load") {
                            isPresentingPhotoPicker = true
                        }
                        .buttonStyle(.borderless)
                        .padding(.horizontal)
                        .matchedTransitionSource(id: photoPickerID, in: namespace)
                        
                        Button("Clear") {
                            appearance.backgroundImageData = nil
                        }
                        .buttonStyle(.borderless)
                        .disabled(appearance.backgroundImage == nil)
                    }
                }
            }
            
            Section("Warnings") {
                ColorPicker("Early Warning", selection: $appearance.earlyWarningColor)
                ColorPicker("Final Warning", selection: $appearance.finalWarningColor)
            }
        }
        .overlay(alignment: .top) { Divider() }
    }
}

// MARK: - Previews

#Preview {
    AppearanceView(appearance: .shared)
        .environment(Counter.shared)
        .environment(Appearance.shared)
}
