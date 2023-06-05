//
//  AlbumViewModel.swift
//  Albums
//
//  Created by Razan Mohammed Alzannan on 15/11/1444 AH.
//

import Foundation
import SwiftUI

class AlbumViewModel : ObservableObject {
    
    @Published var albums: [Album] = []
    @Published var isLoading = true
    @Published var alertMessage = ""
    @State var isAlertShown = false
    
    struct DeleteAlbumApiResponse: Codable {
        let success: Bool
        let newAlbum: [Album]
        let message: String
    }
    
    func addNewAlbum() async {
        let newAlbum = Album(id: 2, title: "New Album")
        albums.append(newAlbum)
        await upsertOneAlbum(album: newAlbum)
        await fetchAlbums()
    }
    
    func upsertOneAlbum(album: Album) async {
        isLoading = true
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            let urlString = "https://jsonplaceholder.typicode.com/albums"
            let request = try urlString.toRequest(withBody: album, method: "PUT")//water restrunt
            let result = try await callApi(request, to: DeleteAlbumApiResponse.self)//
            albums = result.newAlbum
        } catch {
            print("Error: \(error)")
        }
        isLoading = false
    }
    
    func deleteOneAbum(albumId: String) async {
        isLoading = true
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            let urlString = "https://jsonplaceholder.typicode.com/albums/" + albumId
            let request = try urlString.toDeleteRequest()// prepare ur message
            let result = try await callApi(request, to: DeleteAlbumApiResponse.self)
            albums = result.newAlbum
            if !result.success {
                alertMessage = result.message
                isAlertShown = true
            }
        } catch {
            print("Error: \(error)")
        }
        isLoading = false
    }
    
    func fetchAlbums() async {
        isLoading = true
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            let urlString = "https://jsonplaceholder.typicode.com/albums"
            let request = try urlString.toRequest()
            let apiAlbums = try await callApi(request, to: [Album].self)
            albums = apiAlbums
            print("hooooooo")
        } catch {
            print("Error: \(error)")
        }
        isLoading = false
    }
    
}
