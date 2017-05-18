//
//  MoviePlayerVC.swift
//  YCMath-Swift
//
//  Created by lucien on 2017/3/23.
//  Copyright © 2017年 lucien. All rights reserved.
//



import UIKit
import AVFoundation

/// navView
var navView: UIView = UIView()
var navLabel: UILabel = UILabel()
var navBackButton: UIButton = UIButton()
/// bottomview
var bottomView: UIView = UIView()
var bottomButton: UIButton = UIButton()
var slider: UISlider = UISlider()
var startTimeLabel: UILabel = UILabel()
var sumTimeLabel:UILabel = UILabel()
/// data
var player: AVPlayer = AVPlayer()
var playerLayer = AVPlayerLayer()
var playerItem: AVPlayerItem!
var displayLink: CADisplayLink!
var playButton: UIButton = UIButton()
var play = false
var isHiddenBar = false
var isPortrait = false
let appDelegate = UIApplication.shared.delegate as! AppDelegate

/** 
 BUG
 横竖屏
 slider的控件漂移

 */
class MoviePlayerVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.lauoutMoviePlayer()
        self.layoutUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 横屏
        appDelegate.blockRotation = true
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        // 2秒后隐藏bar
//        self.perform(#selector(isHiddenBarView), with: nil, afterDelay: 2)
        // 横屏布局
        layoutLandscapeUI()
        // 暂停播放
        player.pause()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 竖屏
        appDelegate.blockRotation = false
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
//        layoutPortraitUI()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var shouldAutorotate: Bool {
        return false
    }
    // 监听页面旋转的时候 重新布局
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        if toInterfaceOrientation.isPortrait {
            // 竖屏
            layoutPortraitUI()
        } else {
            // 横屏
            layoutLandscapeUI()
        }
    }
    // 初始化UI
    func layoutUI() {
        self.view.backgroundColor = UIColor.black
        // nav
        navView.frame = CGRect(x: 0, y: 0, width: kScreenHeight, height: 44)
        navView.backgroundColor = UIColor.white
        self.view.addSubview(navView)
        // 头部返回按钮
        navBackButton = UIButton(type: .custom)
        navBackButton.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        navBackButton.setBackgroundImage(UIImage(named: "NavItemBackGrey"), for: .normal)
        navBackButton.addTarget(self, action: #selector(clickBackButton), for: .touchUpInside)
        navView.addSubview(navBackButton)
        // 头部描述
        navLabel.frame = CGRect(x: 60, y: 0, width: kScreenHeight - 120, height: 44)
        navLabel.text = "播放器-2017.03.21"
        navLabel.font = UIFont.systemFont(ofSize: 16, weight: 0.8)
        navLabel.textAlignment = .center
        navView.addSubview(navLabel)
        // bottom
        bottomView.frame = CGRect(x: 0, y: kScreenWidth-44, width: kScreenHeight, height: 44)
        bottomView.backgroundColor = UIColor.white
        self.view.addSubview(bottomView)
        // 底部暂停播放按钮
        playButton = UIButton(type: UIButtonType.custom)
        playButton.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        playButton.addTarget(self, action: #selector(clickPlayButton), for: .touchUpInside)
        playButton.setTitle("播放", for: .normal)
        playButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: 0.6)
        playButton.setTitleColor(UIColor.black, for: .normal)
        playButton.backgroundColor = UIColor.clear
        bottomView.addSubview(playButton)
        // 起始时间
        startTimeLabel.frame = CGRect(x: 70, y: 0, width: 40, height: 44)
        startTimeLabel.text = "00:00";
        startTimeLabel.font = UIFont.systemFont(ofSize: 12, weight: 0.5)
        startTimeLabel.backgroundColor = UIColor.clear
        bottomView.addSubview(startTimeLabel)
        // slider     left: 60 + 10 + 40 + 10      right: 10 + 40 + 10
        slider.frame = CGRect(x: 120, y: 44/2 - 6/2, width: kScreenHeight - 180, height: 6);
        slider.layer.cornerRadius = 3;
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0
        slider.maximumTrackTintColor = UIColor.clear
        // 从最小值滑向最大值时杆的颜色
        slider.minimumTrackTintColor = UIColor.green
        // 背景色
        slider.backgroundColor = UIColor.gray
        // 在滑块圆按钮添加图片
        slider.setThumbImage(UIImage(named:"slider_thumb"), for: UIControlState())
        // slider按下
        slider.addTarget(self, action: #selector(sliderTouchDown), for: .touchDown)
        // slider抬起
        slider.addTarget(self, action: #selector(sliderTouchUp), for: .touchUpOutside)
        slider.addTarget(self, action: #selector(sliderTouchUp), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderTouchUp), for: .touchCancel)
        bottomView.addSubview(slider)
        // 总共时间
        sumTimeLabel.frame = CGRect(x: kScreenHeight - 50, y: 0, width: 40, height: 44)
        sumTimeLabel.text = "4:27"
        sumTimeLabel.font = UIFont.systemFont(ofSize: 12, weight: 0.5)
        sumTimeLabel.backgroundColor = UIColor.clear
        bottomView.addSubview(sumTimeLabel)
        
    }
    func lauoutMoviePlayer() {
        // 播放器
        let videoURL = NSURL(string: "https://mvvideo5.meitudata.com/571090934cea5517.mp4")
        player = AVPlayer(url: videoURL as! URL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: kScreenHeight, height: kScreenWidth)
        playerLayer.backgroundColor = UIColor.black.cgColor
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.contentsScale = UIScreen.main.scale
        self.view.layer.addSublayer(playerLayer)
        // 动画渲染
        displayLink = CADisplayLink(target: self, selector: #selector(refreshSliderAndTime))
        displayLink.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }
    // 点击返回按钮
    func clickBackButton() {
       _ = navigationController?.popViewController(animated: true)
        player.pause()
    }
    // 点击播放按钮
    func clickPlayButton() {
        // 暂停播放
        if (play) {
            playButton.setTitle("播放", for: .normal)
            player.pause()
        } else {
            playButton.setTitle("暂停", for: .normal)
            self.refreshSliderAndTime()
            player.play()
        }
        play = !play
    }
    // 隐藏bar
    func isHiddenBarView() {
        if isPortrait {
            UIView.animate(withDuration: 0.5, animations: {
                navView.frame = CGRect(x: 0, y: -64, width: kScreenWidth, height: 64)
                navBackButton.frame = CGRect(x: 0, y: 20, width: 60, height: 44)
                navLabel.frame = CGRect(x: 60, y: 20, width: kScreenWidth - 120, height: 44)
                bottomView.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 44)
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                navView.frame = CGRect(x: 0, y: -44, width: kScreenHeight, height: 44)
                bottomView.frame = CGRect(x: 0, y: kScreenWidth, width: kScreenHeight, height: 44)
            })
        }
    }
    // 展示bar
    func isShowBarView() {
        if isPortrait {
            UIView.animate(withDuration: 0.5, animations: {
                navView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 64)
                navBackButton.frame = CGRect(x: 0, y: 20, width: 60, height: 44)
                navLabel.frame = CGRect(x: 60, y: 20, width: kScreenWidth - 120, height: 44)
                bottomView.frame = CGRect(x: 0, y: kScreenHeight-44, width: kScreenWidth, height: 44)
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                navView.frame = CGRect(x: 0, y: 0, width: kScreenHeight, height: 44)
                bottomView.frame = CGRect(x: 0, y: kScreenWidth-44, width: kScreenHeight, height: 44)
            })
        }
    }
    // 触摸屏幕
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isHiddenBar {
            isShowBarView()
        } else {
            isHiddenBarView()
        }
        isHiddenBar = !isHiddenBar
    }
    // sliderTouchDown
    func sliderTouchDown() {
        if (play) {
            play = !play;
        }
    }
    // sliderTouchUp
    func sliderTouchUp () {
        if (!play) {
            play = !play
        }
        let duration = slider.value * Float(CMTimeGetSeconds((player.currentItem?.duration)!))
        let seekTime = CMTimeMake(Int64(duration), 1)
        player.seek(to: seekTime)
    }
    // 刷新slider&time
    func refreshSliderAndTime() {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let totalTime = TimeInterval((player.currentItem?.duration.value)!) / TimeInterval((player.currentItem?.duration.timescale)!)
        let timeStr = "\(formatPlayTime(currentTime))"
        startTimeLabel.text = timeStr
        // 播放进度
        slider.value = Float(currentTime / totalTime)
    }
    // 时间转换
    func formatPlayTime(_ secounds:TimeInterval)->String{
        if secounds.isNaN{
            return "00:00"
        }
        let Min = Int(secounds / 60)
        let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", Min, Sec)
    }
    // 竖屏 change frame
    func layoutPortraitUI() {
        isPortrait = true
        // 头部 frame
        navView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 64)
        navBackButton.frame = CGRect(x: 0, y: 20, width: 60, height: 44)
        navLabel.frame = CGRect(x: 60, y: 20, width: kScreenWidth - 120, height: 44)
        // 视频 frame
        playerLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        // 底部 frame
        bottomView.frame = CGRect(x: 0, y: kScreenHeight-44, width: kScreenWidth, height: 44)
        playButton.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        startTimeLabel.frame = CGRect(x: 70, y: 0, width: 40, height: 44)
        slider.frame = CGRect(x: 120, y: 44/2 - 6/2, width: kScreenWidth - 180, height: 6);
        sumTimeLabel.frame = CGRect(x: kScreenWidth - 50, y: 0, width: 40, height: 44)
//        self.perform(#selector(isHiddenBarView), with: nil, afterDelay: 2)
    }
    // 横屏 change frame
    func layoutLandscapeUI() {
        isPortrait = false
        // 头部 frame
        navView.frame = CGRect(x: 0, y: 0, width: kScreenHeight, height: 44)
        navBackButton.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        navLabel.frame = CGRect(x: 60, y: 0, width: kScreenHeight - 120, height: 44)
        // 视频 frame
        playerLayer.frame = CGRect(x: 0, y: 0, width: kScreenHeight, height: kScreenWidth)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        // 底部 frame
        bottomView.frame = CGRect(x: 0, y: kScreenWidth-44, width: kScreenHeight, height: 44)
        playButton.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        startTimeLabel.frame = CGRect(x: 70, y: 0, width: 40, height: 44)
        slider.frame = CGRect(x: 120, y: 44/2 - 6/2, width: kScreenHeight - 180, height: 6);
        sumTimeLabel.frame = CGRect(x: kScreenHeight - 50, y: 0, width: 40, height: 44)
//        self.perform(#selector(isHiddenBarView), with: nil, afterDelay: 2)
    }
    
}
