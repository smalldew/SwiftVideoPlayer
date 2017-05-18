//
//  TeacherShowVC.swift
//  YCMath-Swift
//
//  Created by lucien on 2017/3/23.
//  Copyright © 2017年 lucien. All rights reserved.
//

import UIKit
// classes
import Alamofire
import SwiftyJSON

// 数据
var jsonData: JSON = JSON.null
// 变量
var teacherShowLabel: UILabel = UILabel()
var teacherShowTableView: UITableView = UITableView()
var moviePlayerVc: MoviePlayerVC = MoviePlayerVC()

class TeacherShowVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.layoutUI()
        //发起请求
        self.requestHttps()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // 初始化UI
    func layoutUI() {
        self.view.backgroundColor = UIColor.white
        //nav
        let navView = UIView.init()
        navView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 64)
        self.view.addSubview(navView)
        // 头部描述
        let navLabel = UILabel.init()
        navLabel.frame = CGRect(x: 0, y: 20, width: kScreenWidth, height: 44)
        navLabel.text = "真人秀界面-2017.03.22"
        navLabel.font = UIFont.systemFont(ofSize: 16, weight: 0.8)
        navLabel.textAlignment = .center
        navView.addSubview(navLabel)
        // 头部返回按钮
        let navBackButton = UIButton.init(type: .custom)
        navBackButton.frame = CGRect(x: 0, y: 20, width: 60, height: 44)
        navBackButton.setBackgroundImage(UIImage(named: "NavItemBackGrey"), for: .normal)
        navBackButton.addTarget(self, action: #selector(clickBackButton), for: .touchUpInside)
        navView.addSubview(navBackButton)
        //tableView
        teacherShowTableView = UITableView(frame: CGRect(x: 0, y: 64, width: kScreenWidth, height: kScreenHeight-64), style: UITableViewStyle.grouped)
        teacherShowTableView.delegate = self
        teacherShowTableView.dataSource = self
        teacherShowTableView.register(UITableViewCell.self, forCellReuseIdentifier: "teacherCell")
        view.addSubview(teacherShowTableView)
    }
    // 发请求
    func requestHttps() {
//        self.pleaseWait()
        self.pleaseWaitWithText("正在请求数据")
//        self.noticeOnlyText("正在请求数据...")
        // 请求地址
        let teacherShowURL = "https://ios-api-v4-0.yangcong345.com/teacherShows"
        // 请求头
        let headers: HTTPHeaders = [
            "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjU4ZDg4YjRiNTE4MGEzMjQyODhmMTdmMSIsInJvbGUiOiJzdHVkZW50IiwiaWF0IjoxNDkyNTg3MzU1LCJleHAiOjE0OTUxNzkzNTV9.PDxnkpq_W2nGDBAbUBGKTUqNz-K3mhextonpsNhWiks"
        ]
        Alamofire.request(teacherShowURL, method: HTTPMethod.get, parameters:nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                jsonData = JSON(value)
                self.noticeSuccess("真人秀数据请求成功!")
                teacherShowTableView.reloadData()
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2.5, execute: {
                    self.clearAllNotice()
//                })
            case .failure:
                self.noticeError("真人秀数据请求失败!", autoClear: true, autoClearTime: 2)
                    self.clearAllNotice()
            }
        }
    }
    // 返回多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arrVideos:Array  = jsonData["videos"].arrayValue
        return arrVideos.count
    }
    // 返回cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "teacherShowCell"
        var cell:TeacherShowCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? TeacherShowCell
        if cell == nil{
            cell = TeacherShowCell.init(style: .default, reuseIdentifier: identifier)
        }
        cell.setValueForCell(dic: jsonData["videos"].arrayValue[indexPath.row].dictionaryValue)
        cell.selectionStyle = .default
        return cell
    }
    // 行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 305.5
    }
    // 头高
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001;
    }
    // 点击了那个cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        teacherShowTableView.deselectRow(at: indexPath, animated: true)
       // 跳转到视频播放页
        self.navigationController?.pushViewController(moviePlayerVc, animated: true)
    }
    // 返回按钮
    func clickBackButton() {
        _ = navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
