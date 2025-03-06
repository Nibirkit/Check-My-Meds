//
//  ContentView.swift
//  Check My Meds
//
//  Created by Nikita Korovin on 27.02.2025.
//

import SwiftUI

// Модель данных для лекарства
struct Medicine: Identifiable {
    let id = UUID()
    var name: String
    var dosage: String
}

// Класс для управления данными
class MedicineStorage: ObservableObject {
    @Published var medicines: [Medicine] = []
}

// Главный экран
struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                // Кнопка "Моя аптечка"
                NavigationLink(destination: MedicineListView()) {
                    MenuRow(title: "Моя аптечка", icon: "cross.case")
                }
                
                // Кнопка "Страна ввоза"
                NavigationLink(destination: EmptyView()) {
                    MenuRow(title: "Страна ввоза", icon: "globe")
                }
                
                // Кнопка "Сканировать штрих-код"
                NavigationLink(destination: BarcodeScannerView()) {
                    MenuRow(title: "Сканировать штрих-код", icon: "barcode")
                }
                
                // Кнопка "Справочник"
                NavigationLink(destination: EmptyView()) {
                    MenuRow(title: "Справочник", icon: "book")
                }
                
                // Кнопка "Язык"
                NavigationLink(destination: EmptyView()) {
                    MenuRow(title: "Язык", icon: "character.bubble")
                }
            }
            .navigationTitle("Check My Meds")
            .listStyle(.grouped)
        }
    }
}

// Строка меню
struct MenuRow: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            Text(title)
                .font(.system(size: 18, weight: .medium))
        }
        .padding(.vertical, 8)
    }
}

// Экран списка лекарств
struct MedicineListView: View {
    @StateObject private var storage = MedicineStorage()
    @State private var showingAddScreen = false
    
    var body: some View {
        List {
            ForEach(storage.medicines) { medicine in
                VStack(alignment: .leading) {
                    Text(medicine.name)
                        .font(.headline)
                    Text(medicine.dosage)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Моя аптечка")
        .toolbar {
            Button(action: { showingAddScreen.toggle() }) {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingAddScreen) {
            AddMedicineView(storage: storage)
        }
    }
}

// Экран добавления лекарства
struct AddMedicineView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var storage: MedicineStorage
    @State private var name = ""
    @State private var dosage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Название препарата", text: $name)
                TextField("Дозировка", text: $dosage)
            }
            .navigationTitle("Новое лекарство")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        let newMedicine = Medicine(name: name, dosage: dosage)
                        storage.medicines.append(newMedicine)
                        dismiss()
                    }
                    .disabled(name.isEmpty || dosage.isEmpty)
                }
            }
        }
    }
}

// Экран сканера штрих-кода (заглушка)
struct BarcodeScannerView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "barcode.viewfinder")
                .font(.system(size: 100))
                .foregroundColor(.blue)
            Text("Сканирование штрих-кода")
                .font(.title)
            Text("Данная функция находится в разработке")
                .foregroundColor(.secondary)
        }
        .padding()
        .navigationTitle("Сканер")
    }
}

// Предварительный просмотр
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
