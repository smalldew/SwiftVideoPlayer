//
//  TeacherShowCell.swift
//  YCMath-Swift
//
//  Created by lucien on 2017/3/23.
//  Copyright © 2017年 lucien. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

class TeacherShowCell: UITableViewCell {

    var titleLabel:UILabel = UILabel()
    var subTitleLabel:UILabel = UILabel()
    var imagePic:UIImageView = UIImageView()
    
    
    required init?(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override init(style:UITableViewCellStyle, reuseIdentifier:String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI();
    }
    // 初始化UI
    func setUpUI() {
        // 主标题
        titleLabel = UILabel(frame:CGRect(x: 20, y: 20, width: kScreenWidth-40, height: 16))
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = NSTextAlignment.left
        contentView.addSubview(self.titleLabel)
        // 副标题
        subTitleLabel = UILabel(frame: CGRect(x: 20, y: 48, width: kScreenWidth-40, height: 37.5))
        subTitleLabel.textColor = UIColor.lightGray
        subTitleLabel.font = UIFont.systemFont(ofSize: 12)
        subTitleLabel.numberOfLines = 0
        subTitleLabel.textAlignment = NSTextAlignment.left
        contentView.addSubview(self.subTitleLabel)
        // 图片
        imagePic = UIImageView(frame: CGRect(x: 20, y: 97.5, width: kScreenWidth-40, height: 188))
        imagePic.layer.cornerRadius = 8
        imagePic.layer.masksToBounds = true
        self.contentView.addSubview(imagePic)
    }
    // 设置值
    func setValueForCell(dic: Dictionary<String, SwiftyJSON.JSON>) {
        titleLabel.text = dic["name"]?.string
        subTitleLabel.text = dic["desc"]?.string
        imagePic.sd_setImage(with: URL(string: (dic["thumbnail"]?.string)!))
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
