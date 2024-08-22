//
//  CoreDataBootcamp.swift
//  SwiftUIDemoApp-CoreData
//
//  Created by muhammad on 21/08/2024.
//

import SwiftUI
import CoreData

class CoreDataViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    @Published var savedEntities: [FruitsEntity] = []
    
    init() {
        container = NSPersistentContainer(name: "FruitsContainer")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("error lodaing core data. \(error)")
            }
            
        }
        fetchFruits()
    }
    
    
    
    
    
    func fetchFruits() {
        let request = NSFetchRequest<FruitsEntity>(entityName: "FruitsEntity")
        
        do {
            savedEntities = try container.viewContext.fetch(request)
            
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    func addFruit(text: String) {
        
        let newFruit  = FruitsEntity(context: container.viewContext)
        newFruit.name = text
        saveDta()
    }
    
    func updateFruit(entity: FruitsEntity) {
        let currentName = entity.name ?? ""
        let newName = currentName + "!"
        entity.name = newName
        saveDta()
    }
    
    func deleteFruit(indexSet: IndexSet) {
        guard let index = indexSet.first else {return}
        let entity = savedEntities[index]
        container.viewContext.delete(entity)
        saveDta()
    }
    
    func saveDta() {
        do {
           try container.viewContext.save()
            fetchFruits()
        } catch let error {
            print("Error Saving.  \(error)")
        }
    }
    
}


struct CoreDataBootcamp: View {
    
    @StateObject var vm = CoreDataViewModel()
    @State var textFieldText: String = ""
    
    var body: some View {
        
        NavigationView{
            
            VStack(spacing: 20){
                TextField("add fruit here...", text: $textFieldText)
                    .font(.headline)
                    .padding(.leading)
                    .frame(height: 55)
                    .background(Color.teal)
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button(action: {
                    guard !textFieldText.isEmpty else {return}
                    vm.addFruit(text: textFieldText)
                    textFieldText = ""
                },label: {
                    Text("Save")
                        .font(.headline)
                        .foregroundStyle(Color.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(10)
                })
                .padding(.horizontal)
                
                List {
                    ForEach(vm.savedEntities) {
                        entity in
                        Text(entity.name ?? " NO Name" )
                            .onTapGesture {
                                vm.updateFruit(entity: entity)
                            }
                    }
                    .onDelete(perform: vm.deleteFruit)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Fruits")
        }
        
       
        
        
    }
}

#Preview {
    CoreDataBootcamp()
}
