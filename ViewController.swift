import SwiftUI

// Classe per gestire il tema dell'app
class ThemeSettings: ObservableObject {
    @Published var isDarkMode: Bool = true
}

@main
struct DrayFireEditorApp: App {
    @StateObject private var themeSettings = ThemeSettings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeSettings)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var themeSettings: ThemeSettings
    @State private var selectedSection: String? = nil
    @State private var isSidebarVisible = true

    var body: some View {
        HStack(spacing: 0) {
            if isSidebarVisible {
                SidebarView(selectedSection: $selectedSection)
                    .frame(width: 250)
                    .background(themeSettings.isDarkMode ? Color.black.opacity(0.9) : Color.white)
            }

            MainContentView(selectedSection: selectedSection)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(themeSettings.isDarkMode ? Color.black.opacity(0.8) : Color.white)
                .animation(.easeInOut, value: themeSettings.isDarkMode)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct SidebarView: View {
    @Binding var selectedSection: String?

    var body: some View {
        VStack(alignment: .leading) {
            Text("DrayFire Editor V1.0.0")
                .font(.headline)
                .padding(.top, 20)
                .padding(.bottom, 10)
                .foregroundColor(.white)

            SidebarButton(title: "Impostazioni", icon: "gear", selectedSection: $selectedSection)
            SidebarButton(title: "YouTube", icon: "play.rectangle", selectedSection: $selectedSection)
            SidebarButton(title: "Profilo", icon: "person", selectedSection: $selectedSection)
            SidebarButton(title: "Tema", icon: "paintbrush", selectedSection: $selectedSection)
            SidebarButton(title: "Progetti", icon: "folder", selectedSection: $selectedSection)

            Spacer()
        }
        .padding()
        .background(Color.black.opacity(0.9))
    }
}

struct SidebarButton: View {
    let title: String
    let icon: String
    @Binding var selectedSection: String?

    var body: some View {
        Button(action: { selectedSection = title }) {
            Label(title, systemImage: icon)
                .foregroundColor(.white)
                .padding(.vertical, 5)
        }
    }
}

struct MainContentView: View {
    var selectedSection: String?
    @State private var showCreateFolderAlert = false
    @State private var showCreateFileAlert = false
    @State private var folderName = ""
    @State private var fileName = ""
    @State private var createdFolderPath: URL?

    var body: some View {
        VStack {
            if selectedSection == "Impostazioni" {
                SettingsView()
            } else {
                VStack {
                    Text("Seleziona una sezione dal menu laterale")
                        .foregroundColor(.gray)
                        .padding()

                    Spacer()

                    // Riquadro con pulsante "+" per creare cartella
                    VStack {
                        Text("Crea nuova cartella")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Button(action: { showCreateFolderAlert = true }) {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 50))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))

                    Spacer()
                }
            }
        }
        .alert("Nome Cartella", isPresented: $showCreateFolderAlert, actions: {
            TextField("Nome della cartella", text: $folderName)
            Button("Crea", action: createFolder)
            Button("Annulla", role: .cancel) {}
        })
        .alert("Nome File", isPresented: $showCreateFileAlert, actions: {
            TextField("Nome del file", text: $fileName)
            Button("Crea", action: createFile)
            Button("Annulla", role: .cancel) {}
        })
    }

    // Funzione per creare una cartella
    private func createFolder() {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let folderURL = documentsURL.appendingPathComponent(folderName)

        do {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            createdFolderPath = folderURL
            folderName = ""
            showCreateFileAlert = true // Mostra l'alert per creare il file subito dopo
        } catch {
            print("Errore durante la creazione della cartella: \(error)")
        }
    }

    // Funzione per creare un file all'interno della cartella
    private func createFile() {
        guard let folderURL = createdFolderPath else { return }
        let fileURL = folderURL.appendingPathComponent(fileName).appendingPathExtension("txt")

        let initialText = "Benvenuto nel tuo nuovo file del DrayFireEditor!"
        do {
            try initialText.write(to: fileURL, atomically: true, encoding: .utf8)
            fileName = ""
        } catch {
            print("Errore durante la creazione del file: \(error)")
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var themeSettings: ThemeSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Impostazioni")
                .font(.largeTitle)
                .foregroundColor(themeSettings.isDarkMode ? .white : .black)
                .padding(.top, 20)

            Divider().background(Color.gray)

            Text("Opzioni di Modifica")
                .font(.headline)
                .foregroundColor(themeSettings.isDarkMode ? .gray : .black)
            
            Toggle(themeSettings.isDarkMode ? "Cambia a Tema Chiaro" : "Cambia a Tema Scuro", isOn: $themeSettings.isDarkMode)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .foregroundColor(themeSettings.isDarkMode ? .white : .black)
                .padding(.top, 10)

            Toggle("Evidenzia Sintassi", isOn: .constant(true))
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .foregroundColor(themeSettings.isDarkMode ? .white : .black)

            Toggle("Salvataggio Automatico", isOn: .constant(false))
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .foregroundColor(themeSettings.isDarkMode ? .white : .black)

            Spacer()
        }
        .padding(.horizontal, 20)
        .background(themeSettings.isDarkMode ? Color.black.opacity(0.8) : Color.white)
    }
}
