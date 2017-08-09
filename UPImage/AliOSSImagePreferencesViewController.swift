//
//  ImagePreferencesViewController.swift
//  imageUpload
//
//  Created by Pro.chen on 16/7/8.
//  Copyright © 2016年 chenxt. All rights reserved.
//

import Cocoa
import MASPreferences

class AliOSSImagePreferencesViewController: NSViewController, MASPreferencesViewController {
	
	override var identifier: String? { get { return "aliOSS" } set { super.identifier = newValue } }
	var toolbarItemLabel: String? { get { return "OSS" } }
	var toolbarItemImage: NSImage? { get { return NSImage(named: "oss-setting") } }
	var window: NSWindow?
	@IBOutlet weak var statusLabel: NSTextField!
	@IBOutlet weak var accessKeyTextField: NSTextField!
	@IBOutlet weak var secretKeyTextField: NSTextField!
	@IBOutlet weak var bucketTextField: NSTextField!
	@IBOutlet weak var urlPrefixTextField: NSTextField!
	@IBOutlet weak var checkButton: NSButton!
    @IBOutlet weak var markTextField: NSTextField!
    @IBOutlet weak var AliOSSZonePopButton: NSPopUpButton!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
		
        NotificationCenter.default.addObserver(self, selector: #selector(clearCatch), name: NSNotification.Name(rawValue: "clearCatch"), object: nil)
        setupSubViews()
	}
    
    func setupSubViews() {
        guard let oss =  AppCache.shared.ossConfig else {
            AliOSSZonePopButton.selectItem(withTag: 1)
            statusLabel.cell?.title = "请配置图床"
            return
        }
        statusLabel.cell?.title = "配置成功。"
        statusLabel.textColor = .magenta
        AliOSSZonePopButton.selectItem(withTag: oss.zone);
        accessKeyTextField.cell?.title = oss.accessKey;
        secretKeyTextField.cell?.title = oss.secretKey;
        bucketTextField.cell?.title = oss.bucket;
        //        urlPrefixTextField.cell?.title = qc.picUrlPrefix;
        //        markTextField.cell?.title = qc.mark;
    }
    
    func clearCatch() {
        setupSubViews()
    }
    
	@IBAction func setDefault(_ sender: AnyObject) {
        //TODO: 将当前默认方式换成通知
//		AppCache.shared.appConfig.useDefServer = true
		statusLabel.cell?.title = "目前使用默认图床"
        AppCache.shared.appConfig.setInCache("appConfig")
        //选择使用默认后发送通知
        AppCache.shared.appConfig.uploadType = .defaultType
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setDefault"), object: self)
	}
	
    @IBAction func selectAliOSSZone(_ sender: NSMenuItem) {
        AliOSSZonePopButton.select(sender);
    }
    
	@IBAction func setQiniuConfig(_ sender: AnyObject) {
		if (accessKeyTextField.cell?.title.characters.count == 0 ||
			secretKeyTextField.cell?.title.characters.count == 0 ||
			bucketTextField.cell?.title.characters.count == 0 ) {
				showAlert("有配置信息未填写", informative: "请仔细填写")
				return
		}
		
		let ack = (accessKeyTextField.cell?.title)!
		let sek = (secretKeyTextField.cell?.title)!
		let bck = (bucketTextField.cell?.title)!
        
        let ossConfig = AliOSSConfig(accessKey: ack, bucket: bck, secretKey: sek, zone: (AliOSSZonePopButton.selectedItem?.tag)!)
        
        print(ossConfig)
        
        checkButton.title = "验证中"
        checkButton.isEnabled = false
        OSSClient.shared.getOSSBucketIsAvaliable(endPoint: ossConfig.zoneHost, ossConfig.accessKey, ossConfig.secretKey, bucketName: ossConfig.bucket, bucketLocation: ossConfig.location) { [weak self] (avaliableType) in
            self?.checkButton.isEnabled = true
            self?.checkButton.title = "验证配置"
            
            switch avaliableType {
            case .fail:
                self?.showAlert("验证失败", informative: "验证失败，请仔细填写信息。")
            case .errorLocation:
                self?.showAlert("验证失败", informative: "所选区域与Bucket所在区域不匹配")
            case .none:
                self?.showAlert("验证失败", informative: "没有匹配到对应的BUcket")
            case .sucess:
                self?.statusLabel.cell?.title = "配置成功。"
                self?.statusLabel.textColor = .magenta
                self?.showAlert("验证成功", informative: "配置成功。")
                ossConfig.setInCache("AliOSS_User_Config");
                AppCache.shared.ossConfig = ossConfig;
                AppCache.shared.appConfig.setInCache("appConfig")
            }
        }

//		let qnConfig =  QNConfig(picUrlPrefix: (urlPrefixTextField.cell?.title)!, accessKey: ack, scope: bck, secretKey: sek, mark: (markTextField.cell?.title)!, zone: (AliOSSZonePopButton.selectedItem?.tag)!)
//		checkButton.title = "验证中"
//		checkButton.isEnabled = false
//        QNService.shared.register(config:qnConfig)
//        QNService.shared.createToken()
//        QNService.shared.verifyQNConfig(zone: AliOSSZonePopButton.selectedItem?.tag){ [weak self] (result) in
//            self?.checkButton.isEnabled = true
//            self?.checkButton.title = "验证配置"
//            result.Success(success: {_ in
//                self?.statusLabel.cell?.title = "配置成功。"
//                self?.statusLabel.textColor = .magenta
//                self?.showAlert("验证成功", informative: "配置成功。")
//                qnConfig.setInCache("QN_Use_Config");
//                AppCache.shared.qnConfig = qnConfig;
//                AppCache.shared.appConfig.useDefServer = false
//                AppCache.shared.appConfig.setInCache("appConfig")
//            }).Failure(failure: { _ in
//                self?.showAlert("验证失败", informative: "验证失败，请仔细填写信息。")
//            })
//        }
	}
	
	func showAlert(_ message: String, informative: String) {
		let arlert = NSAlert()
		arlert.messageText = message
		arlert.informativeText = informative
		arlert.addButton(withTitle: "确定")
        arlert.icon = message == "验证成功" ? NSImage(named: "Icon_32x32") :  NSImage(named: "Failure")
		arlert.beginSheetModal(for: self.window!, completionHandler: { (response) in
			
		})
	}
	
}
