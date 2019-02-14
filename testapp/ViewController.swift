//
//  ViewController.swift
//  testapp
//
//  Created by kamadochoko on 2019/02/03.
//  Copyright © 2019年 kamadochoko. All rights reserved.
//

import UIKit
import Expression
class ViewController: UIViewController {

    @IBAction func onTapImage(_ sender: Any) {
        // セグエを使用して画面を遷移
        performSegue(withIdentifier: "result", sender: nil)
    }
    @IBOutlet weak var viewPurupuru: UIImageView!
    @IBOutlet weak var formulaLable: UILabel!
    @IBOutlet weak var answerLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // ビューがロードされた時点で式と答えのラベルは空にする
        formulaLable.text = ""
        answerLable.text = ""
        
        
        
    }
    func degreesToRadians(degrees: Float) -> Float {
        return degrees * Float(M_PI) / 180.0
    }
    
    func vibrated(vibrated:Bool, view: UIView) {
        if vibrated {
            var animation: CABasicAnimation
            animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.duration = 0.15
            animation.fromValue = degreesToRadians(degrees: 8.0)
            animation.toValue = degreesToRadians(degrees: -3.0)
            animation.repeatCount = Float.infinity
            animation.autoreverses = true
            view.layer .add(animation, forKey: "VibrateAnimationKey")
        }
        else {
            view.layer.removeAnimation(forKey: "VibrateAnimationKey")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func inputFormula(_ sender: UIButton) {
        // ボタン（Cと=以外）が押されたら式を表示する
        guard let formulaText = formulaLable.text else {
            return
        }
        guard let senderedText = sender.titleLabel?.text else {
            return
        }
        formulaLable.text = formulaText + senderedText
        vibrated(vibrated: true, view: viewPurupuru)
    }
    @IBAction func clearCalculation(_ sender: UIButton) {
        // Cボタンが押されたら式と答えをクリアする
        formulaLable.text = ""
        answerLable.text = ""
    }
   
    @IBAction func calculateAnswer(_ sender: UIButton) {
        // =ボタンが押されたら答えを計算して表示する
        guard let formulaText = formulaLable.text else {
            return
        }
        let formula: String = formatFormula(formulaText)
        answerLable.text = evalFormula(formula)
    }
    
    private func formatFormula(_ formula: String) -> String {
        // 入力された整数には`.0`を追加して小数として評価する
        // また`÷`を`/`に、`×`を`*`に置換する
        let formattedFormula: String = formula.replacingOccurrences(
            of: "(?<=^|[÷×\\+\\-\\(])([0-9]+)(?=[÷×\\+\\-\\)]|$)",
            with: "$1.0",
            options: NSString.CompareOptions.regularExpression,
            range: nil
            ).replacingOccurrences(of: "÷", with: "/").replacingOccurrences(of: "×", with: "*")
        return formattedFormula
    }
    
    private func evalFormula(_ formula: String) -> String {
        do {
            // Expressionで文字列の計算式を評価して答えを求める
            let expression = Expression(formula)
            let answer = try expression.evaluate()
            return formatAnswer(String(answer))
        } catch {
            // 計算式が不当だった場合
            return "式を正しく入力してください"
        }
    }
    
    private func formatAnswer(_ answer: String) -> String {
        // 答えの小数点以下が`.0`だった場合は、`.0`を削除して答えを整数で表示する
        let formattedAnswer: String = answer.replacingOccurrences(
            of: "\\.0$",
            with: "",
            options: NSString.CompareOptions.regularExpression,
            range: nil)
        return formattedAnswer
    }

}

