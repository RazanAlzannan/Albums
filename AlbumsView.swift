//
//  AlbumsView.swift
//  Albums
//
//  Created by Razan Mohammed Alzannan on 15/11/1444 AH.
//

import SwiftUI

struct AlbumsView: View {

    @State var vm = AlbumViewModel()
    
    var body: some View {
        VStack {
            Button("Add Abum") {
                Task { await vm.addNewAlbum() }
            }
            Button("Refresh") {
                Task {
                    await vm.fetchAlbums()
                }
            }
//            if (vm.isLoading) {
//                ProgressView()
//            }
                
           
            List {
                ForEach(vm.albums) { album in
                    HStack {
                        Text(album.title)
                    }.task {
                        await vm.fetchAlbums()
                    }
                    
                    AlbumView(album: album, onTitleChange: { newTitle in
                        guard let index = vm.albums.firstIndex(where: { $0.id == album.id }) else {
                            return
                        }
                        
                        let updatedAlbum = Album(id: album.id, title: newTitle)
                        
                        vm.albums[index] = updatedAlbum
                        Task {
                            await vm.upsertOneAlbum(album:updatedAlbum)
                        }
                    })
                }
                .onDelete { index in
                    let deletedAlbumId = index.map { vm.albums[$0].title}.first ?? ""
                    vm.albums.remove(atOffsets: index)
                    Task {
                        await vm.deleteOneAbum(albumId:deletedAlbumId)
                    }
                }
            }
//            .alert(vm.alertMessage, isPresented: vm.$isAlertShown, actions: {})
        }
        
        .task {
            await vm.fetchAlbums()
        }
    }
    }


struct AlbumsView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView{
            AlbumsView()
        }.environmentObject(AlbumViewModel())
    }
}

struct AlbumView: View {
    let album: Album
    let onTitleChange: (String) -> Void

    @State var taskTitle = ""
    
    var body: some View  {
        HStack {
            Text(album.title)
            TextField("", text: $taskTitle)
                .onChange(of: taskTitle) {
                    onTitleChange($0)
                }
            
            Spacer()
        }.onAppear {
            taskTitle = album.title
        }
    }
}

