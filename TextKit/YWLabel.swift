

//
//  YWLabel.swift
//  TextKit
//
//  Created by yao wei on 16/10/18.
//  Copyright © 2016年 yao wei. All rights reserved.
//

import UIKit

class YWLabel: UILabel {
    
    //MARK: - 重写的属性
  override  var text: String? {
        didSet{
            prepareTextContent()
        }
    }
    
    //MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareTextSystem()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareTextSystem()
    }
    
    // MARK: - 交互
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //1.获取用户点击的位置
        guard  let location = touches.first?.location(in: self) else {
            return
        }
        
        //获取当前点中字符的索引
        let index = layoutManager.glyphIndex(for: location, in: textContainer)
        
        //判断 index 是否子啊urlRanges 的范围内，如果在就高亮
        for r in urlRanges ?? []{
            
            if NSLocationInRange(index, r) {
                print("选哟啊高亮")
                //修改文本的字体属性
                textStorage.addAttributes([NSForegroundColorAttributeName :UIColor.blue], range: r)
                //如果需要重回，需要调用此方法
                setNeedsDisplay()
                
            }else{
                print("烦我了,meidiandao")

            }
        }
    }
    
    // MARK: - 绘制
    override func drawText(in rect: CGRect) {
        let range = NSRange(location: 0, length: textStorage.length)
        
        //绘制背景 在iOS 中绘制巩固走类似油画，后绘制的内容，会把之前绘制的内容覆盖
        layoutManager.drawBackground(forGlyphRange: range, at: CGPoint())
        
        //绘制 Glyphs 字形
        layoutManager.drawGlyphs(forGlyphRange: range, at: CGPoint())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //指定绘制文本的区域
        textContainer.size = bounds.size
    }
    //MARK:- TextKit 的核心对象
    
    /// 属性文本存储
    fileprivate lazy var textStorage = NSTextStorage()
    
    /// 负责文本“字形”布局
    fileprivate lazy var layoutManager = NSLayoutManager()
    
    /// 设定文本绘制范围
    fileprivate lazy var textContainer = NSTextContainer()

}


// MARK: - 设置 TextKit 核心对象
extension YWLabel{
    
    /// 准备文本系统
    func prepareTextSystem() {
        
        //0.开启用户交互
        isUserInteractionEnabled = true
        
        //1.准备文本内容
        prepareTextContent()
        //2.设置对象的关系
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
    }
    
    /// 准备文本内容 - 使用textStorage 接管label 的内容
    func prepareTextContent() {
        if let attributedText = attributedText{
            textStorage.setAttributedString(attributedText)
        }else if let text = text{
            textStorage.setAttributedString(NSAttributedString(string: text))
        } else{
            textStorage.setAttributedString(NSAttributedString(string: ""))
        }
        
        print(urlRanges)
        
        //遍历范围数组，设置url 文字的属性
        for r in urlRanges ?? [] {
            textStorage.addAttributes([NSForegroundColorAttributeName:UIColor.red,NSBackgroundColorAttributeName:UIColor.groupTableViewBackground], range: r)
        }
    }
}


// MARK: - 正则表达式函数
fileprivate extension YWLabel {
    
    /// 返回textStorage 中高度URL range 数组
    var urlRanges: [NSRange]?{
        //1.正则表达式
        let pattern = "[a-zA-Z]*://[a-zA-Z0-9/\\.]*"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else{
            return nil
        }
        
        //多重匹配
        let matches = regx.matches(in: textStorage.string, options: [], range: NSRange(location: 0, length: textStorage.length))
        
        //遍历数组,生成range 数组
        var rangeArr = [NSRange]()
        
        for m in matches {
            rangeArr.append(m.rangeAt(0))
        }
        return rangeArr
    }
    
}
