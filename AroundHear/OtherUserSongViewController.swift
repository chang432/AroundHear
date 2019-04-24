//
//  OtherUserSongViewController.swift
//  AroundHear
//
//  Created by Andre Chang on 4/23/19.
//  Copyright © 2019 Guillermo. All rights reserved.
//

import UIKit
import AVFoundation

class OtherUserSongViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {

    @IBOutlet var songImage: UIImageView!
    @IBOutlet var songTitle: UILabel!
    @IBOutlet var playPauseBtn: UIButton!
    
    var songTtle: String!
    var songURI: String!
    var songImg: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setGradientBackground(colorOne: UIColor.init(red: 95/255.0, green: 114/255.0, blue: 189/255.0, alpha: 1.0), colorTwo: UIColor.init(red: 155/255.0, green: 35/255.0, blue: 234/255.0, alpha: 1.0))
        
        songImage.image = songImg
        songTitle.text = songTtle
        self.handleNewSession()
    }
    
    @IBAction func playPausePressed(_ sender: Any) {
        SPTAudioStreamingController.sharedInstance().setIsPlaying(!SPTAudioStreamingController.sharedInstance().playbackState.isPlaying, callback: nil)
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController) {
        print("LOGGED INTO SESSION")
        
        SPTAudioStreamingController.sharedInstance().playSpotifyURI(songURI, startingWith: 0, startingWithPosition: 10) { error in
            if error != nil {
                print("*** failed to play: \(error)")
                return
            }
        }
    }
    
    func audioStreamingDidLogout(_ audioStreaming: SPTAudioStreamingController!) {
        print("LOGGED OUT OF SESSION")
    }
    
    func handleNewSession() {
        //if SPTAudioStreamingController.sharedInstance() == nil {
        if SPTAudioStreamingController.sharedInstance().loggedIn {
            SPTAudioStreamingController.sharedInstance().playSpotifyURI(songURI, startingWith: 0, startingWithPosition: 10) { error in
                if error != nil {
                    print("*** failed to play: \(error)")
                    return
                }
            }
            return
        }
        
        do {
            try SPTAudioStreamingController.sharedInstance().start(withClientId: SPTAuth.defaultInstance().clientID, audioController: nil, allowCaching: true)
            SPTAudioStreamingController.sharedInstance().delegate = self
            SPTAudioStreamingController.sharedInstance().playbackDelegate = self
            SPTAudioStreamingController.sharedInstance().diskCache = SPTDiskCache() /* capacity: 1024 * 1024 * 64 */
            SPTAudioStreamingController.sharedInstance().login(withAccessToken: AuthService.instance.sessiontokenId ?? "")
        } catch let error {
            let alert = UIAlertController(title: "Error init", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: {})
            self.closeSession()
        }
        //}
    }
    
    func closeSession() {
        do {
            try SPTAudioStreamingController.sharedInstance().stop()
            SPTAuth.defaultInstance().session = nil
            _ = self.navigationController!.popViewController(animated: true)
        } catch let error {
            let alert = UIAlertController(title: "Error deinit", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: { })
        }
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didChangePlaybackStatus isPlaying: Bool) {
        print("is playing = \(isPlaying)")
        if isPlaying {
            //playPauseBtn.titleLabel?.text = "Pause"
            self.activateAudioSession()
        }
        else {
            //playPauseBtn.titleLabel?.text = "Play"
            self.deactivateAudioSession()
        }
    }
    
    func activateAudioSession() {
        do {
            print("ACTIVE")
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func deactivateAudioSession() {
        do {
            print("NOT ACTIVE")
            try AVAudioSession.sharedInstance().setActive(false)
        }
        catch let error {
            print(error.localizedDescription)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
