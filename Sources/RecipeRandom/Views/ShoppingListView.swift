import SwiftUI

struct ShoppingListView: View {
    @EnvironmentObject private var store: AppStore

    @State private var newItemName = ""
    @State private var newItemNote = ""
    @State private var selectedSectionID: UUID?

    private var sections: [ShoppingSection] {
        store.shoppingSections
    }

    private var derivedItems: [DerivedShoppingItem] {
        store.derivedShoppingItems
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                derivedSection
                quickAdd
                sectionsView
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 30)
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            if selectedSectionID == nil {
                selectedSectionID = sections.first?.id
            }
        }
        .onChange(of: sections, initial: false) { _, updatedSections in
            if selectedSectionID == nil || updatedSections.contains(where: { $0.id == selectedSectionID }) == false {
                selectedSectionID = updatedSections.first?.id
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Shopping list")
                .font(.custom("Baskerville", size: 30))
                .fontWeight(.semibold)
                .foregroundStyle(Theme.textPrimary)

            Text("From saved recipes")
                .font(.custom("Avenir Next", size: 16))
                .foregroundStyle(Theme.textSecondary)
        }
    }

    private var derivedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "From saved recipes", subtitle: "\(derivedItems.count) items")

            if derivedItems.isEmpty {
                EmptyDerivedState()
            } else {
                ForEach(derivedItems) { item in
                    ShoppingRow(
                        item: item.name,
                        note: item.note,
                        isChecked: item.isChecked,
                        onToggle: { store.toggleDerivedItem(id: item.id) },
                        onDelete: nil
                    )
                }
            }
        }
    }

    private var quickAdd: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Personal list")
                .font(.custom("Baskerville", size: 22))
                .fontWeight(.semibold)
                .foregroundStyle(Theme.textPrimary)

            Text("Add anything you still need.")
                .font(.custom("Avenir Next", size: 13))
                .foregroundStyle(Theme.textSecondary)

            TextField("Item", text: $newItemName)
                .font(.custom("Avenir Next", size: 15))
                .padding(12)
                .background(Theme.cardSurface)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Theme.cardStroke, lineWidth: 1)
                )

            TextField("Note (optional)", text: $newItemNote)
                .font(.custom("Avenir Next", size: 14))
                .padding(12)
                .background(Theme.cardSurface)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Theme.cardStroke, lineWidth: 1)
                )

            Picker("Section", selection: $selectedSectionID) {
                ForEach(sections) { section in
                    Text(section.title).tag(Optional(section.id))
                }
            }
            .pickerStyle(.segmented)

            Button(action: addItem) {
                Text("Add item")
                    .font(.custom("Avenir Next", size: 14))
                    .fontWeight(.semibold)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Theme.cardHighlight)
                    .foregroundStyle(Theme.textPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .buttonStyle(.plain)
            .disabled(newItemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || selectedSectionID == nil)
            .opacity(newItemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || selectedSectionID == nil ? 0.6 : 1)
        }
        .padding(16)
        .background(Theme.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Theme.cardStroke, lineWidth: 1)
        )
    }

    private var sectionsView: some View {
        VStack(alignment: .leading, spacing: 18) {
            ForEach(sections) { section in
                SectionHeader(title: section.title, subtitle: "\(section.items.count) items")

                ForEach(section.items) { item in
                    ShoppingRow(
                        item: item.name,
                        note: item.note,
                        isChecked: item.isChecked,
                        onToggle: { store.toggleShoppingItem(sectionID: section.id, itemID: item.id) },
                        onDelete: { store.removeShoppingItem(sectionID: section.id, itemID: item.id) }
                    )
                }
            }
        }
    }

    private func addItem() {
        let trimmedName = newItemName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedName.isEmpty == false, let sectionID = selectedSectionID else { return }
        store.addShoppingItem(name: trimmedName, note: newItemNote, sectionID: sectionID)
        newItemName = ""
        newItemNote = ""
    }
}

private struct EmptyDerivedState: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Save a recipe to populate this list.")
                .font(.custom("Avenir Next", size: 14))
                .foregroundStyle(Theme.textSecondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Theme.cardStroke, lineWidth: 1)
        )
    }
}

#Preview {
    ShoppingListView()
        .environmentObject(AppStore(preview: true))
}
