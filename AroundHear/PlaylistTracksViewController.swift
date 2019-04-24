//
//  PlaylistTracksViewController.swift
//  AroundHear
//
//  Created by Andre Chang on 4/19/19.
//  Copyright © 2019 Guillermo. All rights reserved.
//

import UIKit
import Alamofire

class PlaylistTracksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tracksTableView: UITableView!
    
    var playlist = SPTPartialPlaylist()
    var plist_arr = [AnyObject]()
    typealias JSONStandard = [String : AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tracksTableView.delegate = self
        tracksTableView.dataSource = self
        
        //print("HELLOOOO: \(playlist)")
        
        //setting up url for playlist tracks request
        var playlist_str = playlist.playableUri.absoluteString
        let beg_index = playlist_str.lastIndex(of: ":")
        let range = beg_index! ..< playlist_str.endIndex
        var real_playlist_str = playlist_str[range]
        real_playlist_str.remove(at: real_playlist_str.startIndex)
        
        //get the playlist tracks
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthService.instance.tokenId!)",
            "Accept": "application/json"
        ]
    
        Alamofire.request("https://api.spotify.com/v1/playlists/\(real_playlist_str)/tracks", headers: headers).responseJSON(completionHandler: {
            response in
            do {
                var JSONStuff = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! JSONStandard
        
                self.plist_arr = JSONStuff["items"] as! [AnyObject]
                self.tracksTableView.reloadData()
            }
            catch {
                print(error)
            }
        })
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("count: \(playlist.trackCount)")
        return Int(playlist.trackCount)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tracksTableView.dequeueReusableCell(withIdentifier: "tracksTableViewCellIdentifier") as! PlaylistTracksTableViewCell!
        
        if (self.plist_arr.count > 0) {
            let one_plist = self.plist_arr[indexPath.row] as! [String: AnyObject]
            let plist = one_plist["track"] as! [String: AnyObject]
            //print("asdf: \(plist["name"])")
            cell?.trackTitle.text = plist["name"] as! String
            
            //Getting artist
            let artists_arr = plist["artists"] as! [AnyObject]
            //only get first artist (if more time add all of them)
            let artist_obj = artists_arr[0] as! [String: AnyObject]
            cell?.trackArtist.text = artist_obj["name"] as? String
            
        }

        //print("asdf: \(self.plist_arr.count)")
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SongIdentifier", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tracksTableView.indexPathForSelectedRow?.row
        
        if (segue.identifier == "SongIdentifier") {
            let vc = segue.destination as? SongViewController
            
            let one_plist = self.plist_arr[indexPath!] as! [String: AnyObject]
            let plist = one_plist["track"] as! [String: AnyObject]
            print("one_plist: \(plist["name"])")
            
            vc?.songTtle = plist["name"] as! String
            vc?.songURI = plist["uri"] as! String
            
            //Getting artist
            let artists_arr = plist["artists"] as! [AnyObject]
            //only get first artist (if more time add all of them)
            let artist_obj = artists_arr[0] as! [String: AnyObject]
            vc?.songArtist = artist_obj["name"] as? String
            
            //getting album image
            if let album = plist["album"] as? [String:AnyObject] {
                if let images = album["images"] as? [AnyObject] {
                    let first_image = images[0]
                    vc!.songImgURL = first_image["url"] as! String
                    let mainImageURL =  URL(string: first_image["url"] as! String)
                    let mainImageData = NSData(contentsOf: mainImageURL!)
                    let mainImage = UIImage(data: mainImageData as! Data)
                    vc!.songImg = mainImage
                }
            }
        }
    }
}
