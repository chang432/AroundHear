//
//  SongViewController.swift
//  AroundHear
//
//  Created by Andre Chang on 4/20/19.
//  Copyright © 2019 Guillermo. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class SongViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {

    //var player = AVAudioPlayer()
    //var player: SPTAudioStreamingController?
    
    @IBOutlet var songImage: UIImageView!
    @IBOutlet var songTitle: UILabel!
    @IBOutlet var playPauseBtn: UIButton!
    var songImg: UIImage!
    var songImgURL: String!
    var songTtle: String!
    var songURI: String!
    var songArtist: String!
    var auth = SPTAuth.defaultInstance()!
    var player: SPTAudioStreamingController?
    var session:SPTSession!
    var playSwitch: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setGradientBackground(colorOne: UIColor.init(red: 95/255.0, green: 114/255.0, blue: 189/255.0, alpha: 1.0), colorTwo: UIColor.init(red: 155/255.0, green: 35/255.0, blue: 234/255.0, alpha: 1.0))
        
        playSwitch = 0
        songImage.image = songImg
        songTitle.text = songTtle
    
        self.handleNewSession()
        /*SPTAudioStreamingController.sharedInstance().playSpotifyURI(songURI, startingWith: 0, startingWithPosition: 10) { error in
            if error != nil {
                print("*** failed to play: \(error)")
                return
            }
        }*/
        
        /*initializePlayer(authSession: session)
        
        player?.playSpotifyURI("spotify:track:63bAGRSSX2V1hhPSP2NpBC", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
        })*/
    }
    
    @IBAction func playPause(_ sender: Any) {
        print("pressed, playSwitch: \(playSwitch)")
        if (playSwitch == 0) {
            //playPauseBtn.titleLabel?.text = "Pause"
            playSwitch = 1
        } else {
            //playPauseBtn.titleLabel?.text = "Play"
            playSwitch = 0
        }
    
        SPTAudioStreamingController.sharedInstance().setIsPlaying(!SPTAudioStreamingController.sharedInstance().playbackState.isPlaying, callback: nil)
    }
    
    /*func initializePlayer(authSession:SPTSession){
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player?.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }*/
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       //SPTAuth.defaultInstance().session = nil
        //self.closeSession()
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController) {
        print("LOGGED INTO SESSION")
    Database.database().reference().child("users").child(((Auth.auth().currentUser?.uid)!)).child("song").setValue(songURI)
    Database.database().reference().child("users").child(((Auth.auth().currentUser?.uid)!)).child("song").child("track_name").setValue(songTtle)
    Database.database().reference().child("users").child(((Auth.auth().currentUser?.uid)!)).child("song").child("track_artist").setValue(songArtist)
    Database.database().reference().child("users").child(((Auth.auth().currentUser?.uid)!)).child("song").child("track_image").setValue(songImgURL)
        
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
        print("shared instance!!!!!!!!!!!!!: \(SPTAudioStreamingController.sharedInstance())")
        
        if SPTAudioStreamingController.sharedInstance().loggedIn {
        Database.database().reference().child("users").child(((Auth.auth().currentUser?.uid)!)).child("song").child("track_uri").setValue(songURI)
        Database.database().reference().child("users").child(((Auth.auth().currentUser?.uid)!)).child("song").child("track_name").setValue(songTtle)
        Database.database().reference().child("users").child(((Auth.auth().currentUser?.uid)!)).child("song").child("track_artist").setValue(songArtist)
        Database.database().reference().child("users").child(((Auth.auth().currentUser?.uid)!)).child("song").child("track_image").setValue(songImgURL)
            
            SPTAudioStreamingController.sharedInstance().playSpotifyURI(songURI, startingWith: 0, startingWithPosition: 10) { error in
                if error != nil {
                    print("*** failed to play: \(error)")
                    return
                }
            }
            return
        }
        //if SPTAudioStreamingController.sharedInstance() == nil {
            print("HI")
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
