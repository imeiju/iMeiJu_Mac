////  IZMainViewController.swift
//  iMeiJu_Mac
//
//  Created by iizvv on 2019/2/2.
//    QQ群:    577506623
//    GitHub:    https://github.com/iizvv
//  Copyright © 2019 iizvv. All rights reserved.
//

import Cocoa

enum MenuType: Int {
    case recommend = 0
    case movie = 1
    case television = 2
    case search = 3
    case tracing = 4
    case setting = 5
}

class IZMainViewController: NSViewController {
    @IBOutlet var menusView: IZMenusView!

    @IBOutlet var contentView: IZView!

    var menusType: MenuType?

    @IBOutlet weak var recommend: NSButton!
    @IBOutlet weak var movie: NSButton!
    @IBOutlet weak var television: NSButton!
    @IBOutlet weak var search: NSButton!
    @IBOutlet weak var setting: NSButton!
    @IBOutlet weak var tracing: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setting.alphaValue = 0.01

        NotificationCenter.default.addObserver(self, selector: #selector(search(_:)), name: NSNotification.Name(rawValue: "search"), object: nil)
        view.wantsLayer = true
        windowConfiguration()
        // 默认选择推荐
        recommend(recommend)
    }

    @IBAction func recommend(_: NSButton) {
        changeViewController(type: .recommend)
    }

    @IBAction func movie(_: NSButton) {
        changeViewController(type: .movie)
    }

    @IBAction func television(_: NSButton) {
        changeViewController(type: .television)
    }

    @IBAction func search(_: NSButton) {
        changeViewController(type: .search)
    }

    @IBAction func tracing(_ sender: NSButton) {
        changeViewController(type: .tracing)
    }
    
    @IBAction func setting(_: NSButton) {
//        changeViewController(type: .setting)
    }

   
    
    func initImages() {
        recommend.image = NSImage(named: "recommend")
        movie.image = NSImage(named: "movie")
        television.image = NSImage(named: "television")
        search.image = NSImage(named: "search")
        setting.image = NSImage(named: "setting")
        tracing.image = NSImage(named: "tracing");
    }

    func changeViewController(type: MenuType) {
        if type == menusType {
            return
        }
        menusType = type
        initImages()
        var vc: NSViewController!
        if type == .recommend {
            recommend.image = NSImage(named: "recommend_selected")
            let cvc = IZCollectionViewController(nibName: "IZCollectionViewController", bundle: nil)
            cvc.api = .index(vsize: "15")
            cvc.isZtid = true
            cvc.isMenu = type
            vc = cvc
        } else if type == .movie {
            movie.image = NSImage(named: "movie_selected")
            let cvc = IZCollectionViewController(nibName: "IZCollectionViewController", bundle: nil)
            cvc.api = .movie(id: "1", vsize: "15")
            cvc.isZtid = false
            cvc.isMenu = type
            vc = cvc
        } else if type == .television {
            television.image = NSImage(named: "television_selected")
            let cvc = IZCollectionViewController(nibName: "IZCollectionViewController", bundle: nil)
            cvc.api = .movie(id: "2", vsize: "15")
            cvc.isZtid = false
            cvc.isMenu = type
            vc = cvc
        } else if type == .search {
            search.image = NSImage(named: "search_selected")
            vc = IZSearchViewController(nibName: "IZSearchViewController", bundle: nil)

        } else if type == .tracing {
            tracing.image = NSImage(named: "tracing_selected")
            vc = IZTracingViewController(nibName: "IZTracingViewController", bundle: nil)
        } else if type == .setting {
            setting.image = NSImage(named: "setting_selected")
            vc = IZSettingViewController(nibName: "IZSettingViewController", bundle: nil)
        }
        addChild(vc)
        view.replaceSubview(contentView, with: vc.view)
        contentView = (vc.view as! IZView)
        addConstraint(with: vc.view)
    }

    func addConstraint(with tmpView: NSView) {
        tmpView.translatesAutoresizingMaskIntoConstraints = false
        tmpView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tmpView.leftAnchor.constraint(equalTo: menusView.rightAnchor).isActive = true
        tmpView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tmpView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    @IBAction func vip(_ sender: NSButton) {
        UserDefaults.standard.set(sender.state, forKey: "isVip")
    }

    func windowConfiguration() {
        let window = NSApplication.shared.windows.first
        var frame = window?.frame
        frame?.size.width = 800
        frame?.size.height = 600
        window?.setFrame(frame!, display: true)
    }
}
