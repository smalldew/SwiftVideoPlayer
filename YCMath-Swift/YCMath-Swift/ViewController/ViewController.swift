//
//  ViewController.swift
//  YCMath-Swift
//
//  Created by lucien on 2017/3/21.
//  Copyright © 2017年 lucien. All rights reserved.
//

import UIKit

/// 常量
let kScreenHeight = UIScreen.main.bounds.size.height
let kScreenWidth = UIScreen.main.bounds.size.width
let dataSource = ["真人秀","习题","能力","排行榜"]
/// ui

/// main
var oneLabel: UILabel = UILabel()
var oneTableView: UITableView = UITableView()
var teacherShowVc: TeacherShowVC = TeacherShowVC()


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.layoutUI()
        self.navigationController?.navigationBar.isHidden = true
    }
    // 初始化UI
    func layoutUI() {
        // nav
        let navView = UIView.init()
        navView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 64)
        self.view.addSubview(navView)
        // 头部
        let navLabel = UILabel.init()
        navLabel.frame = CGRect(x: 0, y: 20, width: kScreenWidth, height: 44)
        navLabel.text = "洋葱数学swift版正式启动-2017.03.21"
        navLabel.font = UIFont.systemFont(ofSize: 16, weight: 0.8)
        navLabel.textAlignment = .center
        navView.addSubview(navLabel)
        // tableView
        oneTableView = UITableView(frame: CGRect(x: 0, y: 64, width: kScreenWidth, height: kScreenHeight), style: UITableViewStyle.grouped)
        oneTableView.delegate = self
        oneTableView.dataSource = self
        oneTableView.register(UITableViewCell.self, forCellReuseIdentifier: "swiftCell")
        view.addSubview(oneTableView)
        
    }
    // 返回行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    // 返回cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: identifier)
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.selectionStyle = .default
        return cell
    }
    // 行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    // 头高
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001;
    }
    // 点击了那个cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        oneTableView.deselectRow(at: indexPath, animated: true)
        let str = dataSource[indexPath.row]
        switch str {
          case "真人秀":
        self.navigationController?.pushViewController(teacherShowVc, animated: true)
        break
          default:
        self.navigationController?.pushViewController(teacherShowVc, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

