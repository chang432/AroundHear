//
//  LoginViewController.swift
//  AroundHear
//
//  Created by Guillermo on 3/28/19.
//  Copyright © 2019 Guillermo. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {

    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    var player: SPTAudioStreamingController?
    var loginUrl: URL?
    var myplaylists = [SPTPartialPlaylist]()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessfull"), object: nil)
        
        //self.view.backgroundColor = UIColor .orange
        logInButton.layer.cornerRadius = logInButton.frame.height/2
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goBackButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToWelcome", sender: self)
    }
    
    
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
                //check if returned user is nil
                if let u = user{
                    //correct password -> go to home screen
                    if UIApplication.shared.openURL(self.loginUrl!) {
                        if self.auth.canHandle(self.auth.redirectURL) {
                            // To do - build in error handling
                            print("IM CONFUSED")
                        }
                    }
                    self.performSegue(withIdentifier: "goHome", sender: self)
                }else{
                    //Error, check error and display message
                    let errorMessage = error?.localizedDescription
                    let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            })
        }
        
    }
    
    func setup () {
        // insert redirect your url and client ID below
        let redirectURL = "Around-Hear://returnAfterLogin" // put your redirect URL here
        let clientID = "462b797e1b894d84852e03b64501f957" // put your client ID here
        auth.redirectURL     = URL(string: redirectURL)
        auth.clientID        = "462b797e1b894d84852e03b64501f957"
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginUrl = auth.spotifyWebAuthenticationURL()
        
        //searchButtn.alpha = 0
    }

    func initializePlayer(authSession:SPTSession){
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player?.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }
    
    @objc func updateAfterFirstLogin () {
        let userDefaults = UserDefaults.standard
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            initializePlayer(authSession: session)
            
            AuthService.instance.sessiontokenId = session.accessToken!
            print(AuthService.instance.sessiontokenId!)
            SPTUser.requestCurrentUser(withAccessToken: session.accessToken) { (error, data) in
                guard let user = data as? SPTUser else { print("Couldn't cast as SPTUser"); return }
                AuthService.instance.sessionuserId = user.canonicalUserName
                
                print(AuthService.instance.sessionuserId!)
                
            }
            
            // Method 1 : To get current user's playlist
            SPTPlaylistList.playlists(forUser: session.canonicalUsername, withAccessToken: session.accessToken, callback: { (error, response) in
                if let listPage = response as? SPTPlaylistList, let playlists = listPage.items as? [SPTPartialPlaylist] {
                    print(playlists)   // or however you want to parse these
                    //  self.myplaylists = playlists
                    self.myplaylists.append(contentsOf: playlists)
                    print(self.myplaylists)
                }
            })
            
            /*// Method 2 : To get current user's playlist
            let playListRequest = try! SPTPlaylistList.createRequestForGettingPlaylists(forUser: AuthService.instance.sessionuserId ?? "", withAccessToken: AuthService.instance.sessiontokenId ?? "")
            Alamofire.request(playListRequest)
                .response { response in
                    
                    
                    let list = try! SPTPlaylistList(from: response.data, with: response.response)
                    
                    for playList in list.items  {
                        if let playlist = playList as? SPTPartialPlaylist {
                            print( playlist.name! ) // playlist name
                            print( playlist.uri!)    // playlist uri
                        }}
            }*/
        }
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        SPTUser.requestCurrentUser(withAccessToken: session.accessToken) { (error, data) in
            guard let user = data as? SPTUser else { print("Couldn't cast as SPTUser"); return }
            AuthService.instance.sessionuserId = user.canonicalUserName
            print(AuthService.instance.sessionuserId!)
        }
        
        //Plays a song
        /*self.player?.playSpotifyURI("spotify:track:63bAGRSSX2V1hhPSP2NpBC", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
        })*/
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
