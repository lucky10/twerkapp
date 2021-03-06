//
//  ViewController.swift
//  TwerkApp
//
//  Created by mac on 24.01.18.
//  Copyright © 2018 Filipp. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var snapForAss: UISnapBehavior!
    var animatorForAss: UIDynamicAnimator!
    
    var SpeedOfTheGame = 0.2
    var Game: TwerkGame? = nil
    var ArrowsView = [UIImageView]()
    var ifPlaying = false
    var DistanceBetweenArrows = CGFloat(60)
    
    var ifRecognizing = false
    var startRecognizingPosition = CGPoint(x: 0, y: 0)
    
    var waitingForSecondArrow = false
    
    var PlayerView: UIView? = nil
    
    @IBOutlet weak var PlayerView1: UIView!
    @IBOutlet weak var PlayerView2: UIView!
    // todo: add PlayerView3
    @IBOutlet weak var PlayerView4: UIView!
    @IBOutlet weak var PlayerView5: UIView!
    @IBOutlet weak var PlayerView6: UIView!
    
    @IBOutlet weak var AssView: UIView!
    @IBOutlet weak var AssRight: UIImageView!
    @IBOutlet weak var AssLeft: UIImageView!
    @IBOutlet weak var Body: UIImageView!
    @IBOutlet weak var Back: UIImageView!
    @IBOutlet weak var FootRight: UIImageView!
    @IBOutlet weak var FootLeft: UIImageView!
    
    @IBOutlet weak var CoinsLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var BestScoreLabel: UILabel!
    @IBOutlet weak var SettingsButton: UIButton!
    @IBOutlet weak var NoAdsButton: UIButton!
    @IBOutlet weak var ShopButton: UIButton!
    @IBOutlet weak var CursorButton: UIButton!
    
    @IBOutlet weak var TopArrow: UIImageView!
    @IBOutlet weak var MiddleArrow: UIImageView!
    @IBOutlet weak var BottomArrow: UIImageView!
    
    
    var DefaultAssPosition : CGPoint!
    
    @IBOutlet weak var HipRight: UIImageView!
    @IBOutlet weak var HipLeft: UIImageView!
    
    fileprivate func prepareForGame() {
        waitingForSecondArrow = false
        
        animateTopArrow(correct: true, toPosition: .Begin)
        animateMiddleArrow(correct: true, toPosition: .Begin)
        animateBottomArrow(correct: true, toPosition: .Begin)
        
        TopArrow.image = UIImage(named: "Arrow")
        MiddleArrow.image = UIImage(named: "Arrow")
        BottomArrow.image = UIImage(named: "Arrow")
        
        UpdateLabels()
        UpdateSpeedOfTheGame()
        UpdateSkins()
        UpdateArrowDirections()
    }
    
    func UpdateSkins() {
        if let game = Game {
            switch game.personNum {
            case SKIN_NICKI_NUM:
                PlayerView = PlayerView1
                SetSkin(number: SKIN_NICKI_NUM)
            case 2:
                PlayerView = PlayerView2
                SetSkin(number: 2)
            case 4:
                PlayerView = PlayerView4
                SetSkin(number: 4)
            case 5:
                PlayerView = PlayerView5
                SetSkin(number: 5)
            case SKIN_TRUMP_NUM:
                PlayerView = PlayerView6
                SetSkin(number: SKIN_TRUMP_NUM)
            default:
                NSLog("Something wrong in UpdateSkins()")
                PlayerView = PlayerView1
                SetSkin(number: SKIN_NICKI_NUM)
            }
        }
    }
    
    func SetSkin(number: Int) {
        reassignUIImageViews(number: number)
        
        PlayerView1.alpha = number == 1 ? 1 : 0
        PlayerView2.alpha = number == 2 ? 1 : 0
        PlayerView4.alpha = number == 4 ? 1 : 0
        PlayerView5.alpha = number == 5 ? 1 : 0
        PlayerView6.alpha = number == 6 ? 1 : 0
        
        guard let playerView = PlayerView else {
            return
        }
        
        DefaultAssPosition = sumCGPoint(left: AssView.center, right: playerView.frame.origin)
    }
    
    func UpdateArrowDirections() {
        guard let game = Game else {
            return
        }
        let degree = GetDegree(dir: game.curArrow.Direct)
        TopArrow.transform = CGAffineTransform(rotationAngle: degree)
        MiddleArrow.transform = CGAffineTransform(rotationAngle: degree)
        BottomArrow.transform = CGAffineTransform(rotationAngle: degree)
    }
    
    func reassignUIImageViews(number: Int) {
        guard let playerView = PlayerView else {
            NSLog("SOMETHING GO WRONG IN reassignUIImageViews")
            return
        }
        
        for child in playerView.subviews {
            if let curImage = child as? UIImageView {
                switch curImage.tag {
                case 10 * number + 1:
                    FootLeft = curImage
                case 10 * number + 2:
                    FootRight = curImage
                case 10 * number + 5:
                    HipLeft = curImage
                case 10 * number + 6:
                    HipRight = curImage
                case 10 * number + 7:
                    Body = curImage
                case 10 * number + 8:
                    Back = curImage
                default:
                    NSLog("SOMETHING GO WRONG IN reassignUIImageViews")
                }
            }
            
            if let curAssView = child as? UIView {
                AssView = curAssView
                if curAssView.tag == 10 * number + 9 {
                    for assChild in curAssView.subviews {
                        if let curAssImage = assChild as? UIImageView {
                            switch curAssImage.tag {
                            case 10 * number + 3:
                                AssLeft = curAssImage
                            case 10 * number + 4:
                                AssRight = curAssImage
                            default:
                                NSLog("SOMETHING GO WRONG IN reassignUIImageViews")
                            }
                        }
                    }
                }
            }
        }
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePand))
        self.view.addGestureRecognizer(pan)
    }
    
    override func viewDidLoad() {
        if Game == nil {
            //если мы впервые попали
            Game = TwerkGame()
            Game!.PrepareForGame()
        }
        
        ScoreLabel.alpha = 0.0
        
        prepareForGame()
        
        guard let playerView = PlayerView else {
            NSLog("NO PlayerView in viewDidLoad")
            abort()
        }
        
        animatorForAss = UIDynamicAnimator(referenceView: self.view)
        
        super.viewDidLoad()
    }
    
    // hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func CursorClicked(_ sender: UIButton) {
        if let game = Game{
            game.ifGame = true
            AnimateGameBegin()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func UpdateSpeedOfTheGame() {
        if let game = Game{
            SpeedOfTheGame = getSpeedFromScore(Score: game.Score)
        }
    }
    
    func showReplayView () {
        performSegue(withIdentifier: "fromGameToReplay", sender: self)
    }
    
    func showGameEndView () {
        performSegue(withIdentifier: "fromGameToEndGame", sender: self)
    }
    
    //обработка жеста над жопой
    @objc func handlePand (recognizer: UIPanGestureRecognizer){
        let MULTIPLICATOR = CGFloat(0.1)
        let location = recognizer.location(in: self.view)
        
        if !ifRecognizing {
            ifRecognizing = true
            startRecognizingPosition = location
        }
        
        let newX = DefaultAssPosition.x - (startRecognizingPosition.x - location.x)*MULTIPLICATOR
        let newY = DefaultAssPosition.y - (startRecognizingPosition.y - location.y)*MULTIPLICATOR
        
        guard let playerView = PlayerView else {
            NSLog("no PlayerView in handlePand")
            abort()
        }
        
        AssView.center = subCGPoint(left: CGPoint(x: newX, y: newY), right: playerView.frame.origin)
        
        let cDelta = CGPoint(x: (startRecognizingPosition.x - location.x)*MULTIPLICATOR,
                            y: (startRecognizingPosition.y - location.y)*MULTIPLICATOR)
        
        UpdateAssViewPosition(delta: cDelta)
        NSLog("FKDBG cDelta \(cDelta))")
        
        if(recognizer.state == .ended) {
            ifRecognizing = false
            AnimateHipAndBackReturn(from: cDelta)
            let endingPosition = getDirectionFromTouchPosition(startPoint: startRecognizingPosition, endPoint: location)
            PlayerMadeHisTurn(dir: endingPosition)
        }
    }
    
    func AnimateHipAndBackReturn(from: CGPoint) {
        let delta = 0.07
        var cur_delay = 0.0
        UIView.animate(withDuration: delta, delay: cur_delay, options: .curveEaseInOut, animations: {
            self.UpdateAssViewPosition(delta: CGPoint(x: -0.5 * from.x, y: -0.5 * from.y))
        }, completion: nil)
        cur_delay += delta
        UIView.animate(withDuration: delta, delay: cur_delay, options: .curveEaseInOut, animations: {
            self.UpdateAssViewPosition(delta: CGPoint.zero)
        }, completion: nil)
    }
    
    //определяет в каком направлении игрок отпустил жопу
    //диагонали AssView делят плоскость на 4 части каждая из которых отвечает за своё направление
    func getDirectionFromAssViewPosition () -> Direction {
        let UpLine1 = ifUpperThenLine1(point: AssView.center)
        let UpLine2 = ifUpperThenLine2(point: AssView.center)
        
        if (UpLine1 && UpLine2){
            return .ToUp
        }
        if (!UpLine1 && UpLine2){
            return .ToLeft
        }
        if (UpLine1 && !UpLine2){
            return .ToRight
        }
        if (!UpLine1 && !UpLine2){
            return .ToDown
        }
        print("неправильное определение направления в getDirectionFromAssViewPosition")
        return .ToUp
    }
    
    //line 1 - воображаемая линия которая идёт от левого верхнего угла AssView в правый нижний
    func ifUpperThenLine1(point: CGPoint) -> Bool {
        let y1 = DefaultAssPosition.y - AssView.frame.size.height/2
        let y2 = DefaultAssPosition.y + AssView.frame.size.height/2
        let x1 = DefaultAssPosition.x - AssView.frame.size.width/2
        let x2 = DefaultAssPosition.x + AssView.frame.size.width/2
        
        if (((y1 - y2) * point.x + (x2 - x1)*point.y + (x1*y2 - x2*y1)) > 0) {
            return false
        } else {
            return true
        }
    }
    
    //line 2 - воображаемая линия которая идёт от левого нижнего угла AssView в правый верхний
    func ifUpperThenLine2(point: CGPoint) -> Bool {
        let y1 = DefaultAssPosition.y + AssView.frame.size.height/2
        let y2 = DefaultAssPosition.y - AssView.frame.size.height/2
        let x1 = DefaultAssPosition.x - AssView.frame.size.width/2
        let x2 = DefaultAssPosition.x + AssView.frame.size.width/2
        
        if (((y1 - y2) * point.x + (x2 - x1)*point.y + (x1*y2 - x2*y1)) > 0) {
            return false
        } else {
            return true
        }
    }
    
    func UpdateAssViewPosition (delta: CGPoint) {
        let curDelta = normaliseDeltaForUpdatingAssPosition(delta: delta)
        
        guard let game = Game else {
            NSLog("FKDBG no game in UpdateAssViewPosition")
            return
        }
        
        let transformForLeftHip = createTransformForLeftHip(delta: curDelta, personNum: game.personNum)
        let transformForRightHip = createTransformForRightHip(delta: curDelta, personNum: game.personNum)
        let transformForBack = createTransformForBack(delta: curDelta, personNum: game.personNum)
    
        HipLeft.transform = transformForLeftHip
        HipRight.transform = transformForRightHip
        Back.transform = transformForBack
    }
    
    func animateTwerk(){
        //анимация
        if snapForAss != nil {
            animatorForAss.removeBehavior(snapForAss)
        }
        snapForAss = UISnapBehavior(item: AssView, snapTo: DefaultAssPosition)
        NSLog("DefaultAssPosition \(String(describing: DefaultAssPosition)) ")
        snapForAss.damping = 0.15
        animatorForAss.addBehavior(snapForAss)
        
        //расширение и сужение ягодиц
        let delta = 0.07
        var cur_duration = 0.0
        var cur_delay = delta
        for _ in 0...2 {
            UIView.animate(withDuration: cur_duration, delay: cur_delay, options: .curveEaseInOut, animations: {
                self.AssLeft.frame.size.width *= 0.8
                self.AssLeft.frame.size.height *= 0.8
                self.AssRight.frame.size.width *= 0.8
                self.AssRight.frame.size.height *= 0.8
            }, completion: nil)
            cur_duration += delta
            cur_delay += delta
            UIView.animate(withDuration: cur_duration, delay: cur_delay, options: .curveEaseInOut, animations: {
                self.AssLeft.frame.size.width /= 0.8
                self.AssLeft.frame.size.height /= 0.8
                self.AssRight.frame.size.width /= 0.8
                self.AssRight.frame.size.height /= 0.8
            }, completion: nil)
            cur_duration += delta
            cur_delay += delta
        }
    }
    
    func AnimateGameBegin () {
        CursorButton.isHidden = true

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.ScoreLabel.alpha = 1.0
            self.SettingsButton.center.y += 100
            self.NoAdsButton.center.y += 100
            self.ShopButton.center.y += 200
        }, completion: nil)
        
        guard let game = Game else {
            return
        }
        
        if game.curArrow.isDouble {
            animateTopArrow(correct: true, toPosition: .Middle)
            animateBottomArrow(correct: true, toPosition: .Middle)
        } else {
            animateMiddleArrow(correct: true, toPosition: .Middle)
        }
    }
    
    //обновляем значения всех видимых элеменетов
    func updateAllVisibleInfo (){
        UpdateLabels()
        UpdateArrowDirections()
    }
    
    //обновляем значения в текстовых элементах
    func UpdateLabels () {
        if let game = Game {
            BestScoreLabel.text = String(game.bestScore)
            ScoreLabel.text = String(game.Score)
            CoinsLabel.text = String(game.coins)
        }
    }
    
    //игрок сделал ход
    func PlayerMadeHisTurn (dir: Direction) {
        NSLog("GAME LOGIC Игрок дернул жопу в сторону: \(dir)");
        
        guard let game = Game else {
            NSLog ("ERROR Troubles with PlayerMadeHisTurn")
            return
        }
        
        NSLog("GAME LOGIC game.curArrow.Direct \(game.curArrow.Direct)")
        
        let correct = dir == game.curArrow.Direct
        
        if game.curArrow.isDouble {
            if waitingForSecondArrow {
                waitingForSecondArrow = false
                animateBottomArrow(correct: correct, toPosition: .End)
                game.PlayerEndedTurn(isCorrect: correct)
            } else {
                if correct {
                    waitingForSecondArrow = true
                    animateTopArrow(correct: true, toPosition: .End)
                } else {
                    waitingForSecondArrow = false
                    animateTopArrow(correct: false, toPosition: .End)
                    animateBottomArrow(correct: true, toPosition: .End, delay: 0.2)
                }
            }
        } else {
            animateMiddleArrow(correct: correct, toPosition: .End)
        }
    }
    
    func nextTurn (isCorrect: Bool) {
        guard let game = Game else {
            return
        }
        updateAllVisibleInfo()
        if !waitingForSecondArrow {
            game.PlayerEndedTurn(isCorrect: isCorrect)
            if (isCorrect) {
                createNextTurn()
            } else {
                endGame()
            }
        }
    }
    
    func createNextTurn () {
        UpdateArrowDirections()
        guard let game = Game else {
            return
        }
        if game.curArrow.isDouble {
            animateTopArrow(correct: true, toPosition: .Middle)
            animateBottomArrow(correct: true, toPosition: .Middle)
        } else {
            animateMiddleArrow(correct: true, toPosition: .Middle)
        }
    }
    
    func endGame () {
        guard let game = Game else {
            return
        }
        
        game.EndGame()
        if game.ifShowReplay {
            showReplayView()
        } else {
            showGameEndView()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier {
            if let vc = segue.destination as? ReplayViewController {
                vc.Game = Game
                return
            }
            if let vc = segue.destination as? GameEndViewController {
                vc.Game = Game
                return
            }
            if let vc = segue.destination as? SettingsView {
                vc.Game = Game
                return
            }
            if let vc = segue.destination as? ShopViewController {
                vc.Game = Game
                return
            }
            NSLog ("FKDBG не подготовился к какой-то segue в GameView")
            abort()
        }
    }
    
    fileprivate func animateTopArrow(correct: Bool, toPosition: ArrowPosition, delay: Double = 0.0) {
        switch toPosition {
        case .Begin:
            TopArrow.center.x = 123
            TopArrow.alpha = 0
        case .Middle:
            UIView.animate(withDuration: 0.2, delay: delay, options: .curveEaseOut, animations: {
                self.TopArrow.center.x = 63
                self.TopArrow.alpha = 1
            }, completion: nil)
        case .End:
            animateTwerk()
            if !correct {
                TopArrow.image = UIImage(named: "ArrowRed")
            }
            UIView.animate(withDuration: 0.2, delay: delay, options: .curveEaseOut, animations: {
                self.TopArrow.center.x = 3
                self.TopArrow.alpha = 0
            }, completion: { (finished: Bool) in
                self.animateTopArrow(correct: true, toPosition: .Begin)
                self.nextTurn(isCorrect: correct)
            })
        }
    }
    
    fileprivate func animateMiddleArrow(correct: Bool, toPosition: ArrowPosition, delay: Double = 0.0) {
        switch toPosition {
        case .Begin:
            MiddleArrow.center.x = 123
            MiddleArrow.alpha = 0
        case .Middle:
            UIView.animate(withDuration: 0.2, delay: delay, options: .curveEaseOut, animations: {
                self.MiddleArrow.center.x = 63
                self.MiddleArrow.alpha = 1
            }, completion: nil)
        case .End:
            animateTwerk()
            if !correct {
                MiddleArrow.image = UIImage(named: "ArrowRed")
            }
            UIView.animate(withDuration: 0.2, delay: delay, options: .curveEaseOut, animations: {
                self.MiddleArrow.center.x = 3
                self.MiddleArrow.alpha = 0
            }, completion: { (finished: Bool) in
                self.animateMiddleArrow(correct: true, toPosition: .Begin)
                self.nextTurn(isCorrect: correct)
            })
        }
    }
    
    fileprivate func animateBottomArrow(correct: Bool, toPosition: ArrowPosition, delay: Double = 0.0) {
        switch toPosition {
        case .Begin:
            BottomArrow.center.x = 123
            BottomArrow.alpha = 0
        case .Middle:
            UIView.animate(withDuration: 0.2, delay: delay, options: .curveEaseOut, animations: {
                self.BottomArrow.center.x = 63
                self.BottomArrow.alpha = 1
            }, completion: nil)
        case .End:
            animateTwerk()
            if !correct {
                BottomArrow.image = UIImage(named: "ArrowRed")
            }
            UIView.animate(withDuration: 0.2, delay: delay, options: .curveEaseOut, animations: {
                self.BottomArrow.center.x = 3
                self.BottomArrow.alpha = 0
            }, completion: { (finished: Bool) in
                self.animateBottomArrow(correct: true, toPosition: .Begin)
                self.nextTurn(isCorrect: correct)
            })
        }
    }
}
