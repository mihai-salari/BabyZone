//
//  GreetView.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/9/5.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit
private let greetButtonWidth = upRateWidth(50)
class GreetView: UIView {
    
    private var videoRecordButton:UIButton!
    private var audioRecordButton:UIButton!
    private var musicPlayButton:UIButton!
    private var videoHandler:(()->())?
    private var audioHandler:(()->())?
    private var musicHandler:(()->())?
    private var baby:Baby!
    
    init(frame: CGRect, baby:Baby, videoHandler:(()->())?, audioHandler:(()->())?, musicHandler:(()->())?) {
        super.init(frame: frame)
        self.videoHandler = videoHandler
        self.audioHandler = audioHandler
        self.musicHandler = musicHandler
        self.backgroundColor = UIColor.clearColor()
        self.audioRecordButton = UIButton.init(type: .Custom)
        self.audioRecordButton.frame = CGRectMake((CGRectGetWidth(self.frame) - greetButtonWidth) / 2, (CGRectGetHeight(self.frame) - greetButtonWidth) / 2, greetButtonWidth, greetButtonWidth)
        self.audioRecordButton.setImage(UIImage.imageWithName("audioRecord.png"), forState: .Normal)
        self.audioRecordButton.addTarget(self, action: #selector(GreetView.audioButtonClick(_:)), forControlEvents: .TouchDown)
        self.audioRecordButton.layer.cornerRadius = greetButtonWidth / 2
        self.audioRecordButton.layer.masksToBounds = true
        self.addSubview(self.audioRecordButton)
        
        self.videoRecordButton = UIButton.init(type: .Custom)
        self.videoRecordButton.frame = CGRectMake(CGRectGetWidth(self.frame) * (1 / 3) - greetButtonWidth, CGRectGetMinY(self.audioRecordButton.frame), greetButtonWidth, greetButtonWidth)
        self.videoRecordButton.layer.cornerRadius = greetButtonWidth / 2
        self.videoRecordButton.setImage(UIImage.imageWithName("videoRecord.png"), forState: .Normal)
        self.videoRecordButton.layer.masksToBounds = true
        self.videoRecordButton.addTarget(self, action: #selector(GreetView.videoButtonClick(_:)), forControlEvents: .TouchDown)
        self.addSubview(self.videoRecordButton)
        
        self.musicPlayButton = UIButton.init(type: .Custom)
        self.musicPlayButton.frame = CGRectMake(CGRectGetWidth(self.frame) * (2 / 3), CGRectGetMinY(self.audioRecordButton.frame), greetButtonWidth, greetButtonWidth)
        self.musicPlayButton.layer.cornerRadius = greetButtonWidth / 2
        self.musicPlayButton.layer.masksToBounds = true
        self.musicPlayButton.setImage(UIImage.imageWithName("musicPlay.png"), forState: .Normal)
        self.musicPlayButton.addTarget(self, action: #selector(GreetView.musicButtonClick(_:)), forControlEvents: .TouchDown)
        self.addSubview(self.musicPlayButton)
        
    }
    
    func audioButtonClick(btn:UIButton) -> Void {
        
    }
    
    func videoButtonClick(btn:UIButton) -> Void {
        
    }
    
    func musicButtonClick(btn:UIButton) -> Void {
        
    }
    
    func babyGreetClick() -> Void {
        print("greet baby")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
