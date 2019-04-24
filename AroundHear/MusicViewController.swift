//
//  MusicViewController.swift
//  AroundHear
//
//  Created by Andre Chang on 4/14/19.
//  Copyright © 2019 Guillermo. All rights reserved.
//

import UIKit
import Alamofire

class MusicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    var player: SPTAudioStreamingController?
    var loginUrl: URL?
    
    var myplaylists = [SPTPartialPlaylist]()
    var playlistIndex = 0
    
    @IBOutlet var playlistTableView: UITableView!
    
    typealias JSONStandard = [String : AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playlistTableView.delegate = self
        playlistTableView.dataSource = self
        
        callToken()
        
        //let defaultURL = "https://api.spotify.com/v1/search?q=Linkin+Park&type=track&limit=5&access_token=\(AuthService.instance.tokenId ?? "")"
        //callAlamofire(url: defaultURL)
        
        SPTPlaylistList.playlists(forUser: AuthService.instance.sessionuserId, withAccessToken: AuthService.instance.sessiontokenId, callback: { (error, response) in
            if let listPage = response as? SPTPlaylistList, let playlists = listPage.items as? [SPTPartialPlaylist] {
                //print(playlists)   // or however you want to parse these
                //playlists[0].playableUri
                
                print("tokenId: \(AuthService.instance.tokenId)")
                print("sessiontokenId: \(AuthService.instance.sessiontokenId)")
                print("sessionuserId: \(AuthService.instance.sessionuserId)")
                
                var playlist_str = playlists[0].playableUri.absoluteString
                let beg_index = playlist_str.lastIndex(of: ":")
                let range = beg_index! ..< playlist_str.endIndex
                var real_playlist_str = playlist_str[range]
                real_playlist_str.remove(at: real_playlist_str.startIndex)
                
                print("$$$$ \(real_playlist_str)")
                
                self.callAlamofire(url: "https://api.spotify.com/v1/playlists/\(real_playlist_str)/tracks")
                
                self.myplaylists.append(contentsOf: playlists)
                print("LENGTH!!!!!!: \(self.myplaylists.count)")
                
                self.playlistTableView.reloadData()
                /*self.myplaylists.forEach{ pl in
                    // do thing with your each playlist
                }*/
            }
        })
    
    }
    
    func callToken() {
        let parameters = ["client_id" : "462b797e1b894d84852e03b64501f957",
                          "client_secret" : "b5a5580453f24182ab69f2972571416b",
                          "grant_type" : "client_credentials"]
        Alamofire.request("https://accounts.spotify.com/api/token", method: .post, parameters: parameters).responseJSON(completionHandler: {
            response in
            //print(response)
            //print(response.result.value)
            if let result = response.result.value {
                let jsonData = result as! NSDictionary
                //print("RESPONSE: ", jsonData)
                AuthService.instance.tokenId = jsonData.value(forKey: "access_token") as? String
                //print(AuthService.instance.tokenId!)
            }
        })
    }
    
    func callAlamofire(url: String) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AuthService.instance.tokenId!)",
            "Accept": "application/json"
        ]
        Alamofire.request(url, headers: headers).responseJSON(completionHandler: {
            response in
            //print("CALL RESPONSE: \(response.data!)")
            self.parseData(JSONData: response.data!)
        })
    }
    
    func parseData(JSONData : Data) {
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            //print("RESPONSE: \(readableJSON)")
        }
        catch {
            print(error)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myplaylists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playlistTableView.dequeueReusableCell(withIdentifier: "playlistTableViewCellIdentifier") as! playlistTableViewCell!
        
        var plist = self.myplaylists[indexPath.row]
        cell!.playlistName.text = plist.name
        cell!.tracknum.text = String(plist.trackCount)
        
        let first_image = plist.smallestImage.imageURL
        let mainImageData = NSData(contentsOf: plist.smallestImage.imageURL!)
        let mainImage = UIImage(data: mainImageData as! Data)
        cell!.playlistPic.image = mainImage
        
        //cell?.contentView.setGradientBackground(colorOne: UIColor.init(red: 95/255.0, green: 114/255.0, blue: 189/255.0, alpha: 1.0), colorTwo: UIColor.init(red: 155/255.0, green: 35/255.0, blue: 234/255.0, alpha: 1.0))
        
        cell?.contentView.backgroundColor = UIColor.init(red: 155/255.0, green: 35/255.0, blue: 234/255.0, alpha: 1.0)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playlistIndex = indexPath.row
        performSegue(withIdentifier: "playlistTracksIdentifier", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "playlistTracksIdentifier") {
            let vc = segue.destination as? PlaylistTracksViewController
            vc?.playlist = myplaylists[playlistIndex]
        }
    }
}
