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
    
    @IBOutlet var PanGestureRecognizerOnAss: UIPanGestureRecognizer!
    @IBOutlet weak var AssView: UIView!
    @IBOutlet weak var AssRight: UIImageView!
    @IBOutlet weak var AssLeft: UIImageView!
    
    @IBOutlet weak var FootRight: UIImageView!
    @IBOutlet weak var FootLeft: UIImageView!
    @IBOutlet weak var CoinsLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var BestScoreLabel: UILabel!
    @IBOutlet weak var RoundImage: UIImageView!
    @IBOutlet weak var SettingsButton: UIButton!
    @IBOutlet weak var NoAdsButton: UIButton!
    @IBOutlet weak var ShopButton: UIButton!
    @IBOutlet weak var CursorButton: UIButton!
    @IBOutlet weak var RoundRedImage: UIImageView!
    @IBOutlet weak var RoundGreenImage: UIImageView!
    
    
    var DefaultAssPosition : CGPoint!
    
    @IBOutlet weak var HipRight: UIImageView!
    @IBOutlet weak var HipLeft: UIImageView!
    
    fileprivate func prepareForGame() {
        AddArrows()
        UpdateArrowViews()
        UpdateLabels()
        UpdateSpeedOfTheGame()
    }
    
    override func viewDidLoad() {
        if Game == nil {
            //если мы впервые попали
            Game = TwerkGame()
            Game!.PrepareForGame()
        }
        
        if let game = Game {
            if game.ifShowReplay {
                game.RandomiseAll()
            }
        }
        DefaultAssPosition = AssView.center
        
        DistanceBetweenArrows = CGFloat (self.view.bounds.width/CGFloat(NUM_OF_ARROWS + 1))
        RoundImage.alpha = 0.0
        RoundGreenImage.alpha = 0.0
        RoundRedImage.alpha = 0.0
        ScoreLabel.alpha = 0.0
        
        
        
        prepareForGame()
        
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
    
    
    //возвращает угол в зависимости от направления
    func GetDegree (dir: Direction) -> CGFloat {
        switch dir {
        case .ToDown:
            return 0.0
        case .ToLeft:
            return (90.0 * .pi) / 180.0
        case .ToRight:
            return (270.0 * .pi) / 180.0
        case .ToUp:
            return (180.0 * .pi) / 180.0
        default:
            return 0.0
        }
    }
    
    //динамически добавляет стрелки вью
    func AddArrows () {
        let pos_y = RoundImage.center.y
        let size = CGFloat (40)
        for i in 0...NUM_OF_ARROWS {
            let cur = UIImageView()
            cur.image = #imageLiteral(resourceName: "DefaultArrow")
            cur.center.x = DistanceBetweenArrows * CGFloat(i + 1) + self.view.frame.width*1.5
            cur.center.y = pos_y
            cur.bounds.size.width = size
            cur.bounds.size.height = size
            
            ArrowsView.append(cur)
            
            super.view.addSubview(cur)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //сдвиг стрелочек налево на одну, анимация идет до тех пор пока человек играет
    func AnimateArrows () {
        UIView.animate(withDuration: SpeedOfTheGame, delay: 0, options: .curveLinear, animations: {
            for arrow in self.ArrowsView {
                arrow.center.x -= 10
            }}, completion: { (finished: Bool) in
                //проверяем не проебал ли игрок из-за того что не успел
                guard let curFirst = self.ArrowsView.first else {
                    NSLog ("FKDBG problem in AnimateArrows")
                    return
                }
                if (curFirst.center.x + curFirst.frame.width/2 < self.RoundImage.center.x - self.RoundImage.frame.width/2) {
                    if let game = self.Game {
                        game.EndGame()
                    } else {
                        NSLog ("FKDBG Trouble with game in AniamateArrows")
                    }
                }
                
                if let game = self.Game{
                    self.UpdateSpeedOfTheGame()
                    if (game.ifGame) {
                        self.AnimateArrows()
                    } else {
                        if (game.ifShowReplay) {
                            self.showReplayView()
                        } else {
                            self.showGameEndView()
                        }
                    }
                } else {
                    print("Trouble with game in AnimateArrows")
                }
        })
    }
    
    func UpdateSpeedOfTheGame() {
        if let game = Game{
            if game.Score >= 0 {
                SpeedOfTheGame = 0.15
            }
            if game.Score >= 10 {
                SpeedOfTheGame = 0.14
            }
            if game.Score >= 20 {
                SpeedOfTheGame = 0.13
            }
            if game.Score >= 40 {
                SpeedOfTheGame = 0.12
            }
            if game.Score >= 80 {
                SpeedOfTheGame = 0.11
            }
            if game.Score >= 120 {
                SpeedOfTheGame = 0.1
            }
        }
    }
    
    func showReplayView () {
        performSegue(withIdentifier: "fromGameToReplay", sender: self)
    }
    
    func showGameEndView () {
        performSegue(withIdentifier: "fromGameToEndGame", sender: self)
    }
    
    //обновляет вьюшки стрелок в соответствии с логикой
    func UpdateArrowViews () {
        if var game = Game {
            var i = 0
            for curArrowModel in game.Arrows {
                switch curArrowModel.State {
                case .Empty:
                    ArrowsView[i].isHidden = true
                case .Default:
                    ArrowsView[i].isHidden = false
                    ArrowsView[i].image = #imageLiteral(resourceName: "DefaultArrow")
                case .Coin:
                    ArrowsView[i].isHidden = false
                    ArrowsView[i].image = #imageLiteral(resourceName: "CoinArrow")
                default:
                    ArrowsView[i].isHidden = false
                    ArrowsView[i].image = #imageLiteral(resourceName: "DefaultArrow")
                }
                ArrowsView[i].transform = CGAffineTransform(rotationAngle: GetDegree(dir: game.Arrows[i].Direct))
                i += 1
            }
        }
    }

    //обработка жеста над жопой
    @IBAction func handlePand (recognizer: UIPanGestureRecognizer){
        let MULTIPLICATOR = CGFloat(0.2)  
        let location = recognizer.location(in: self.view)
        
        if !ifRecognizing {
            ifRecognizing = true
            startRecognizingPosition = location
        }
        
        let newX = DefaultAssPosition.x - (startRecognizingPosition.x - location.x)*MULTIPLICATOR
        let newY = DefaultAssPosition.y - (startRecognizingPosition.y - location.y)*MULTIPLICATOR
        
        AssView.center = CGPoint(x: newX, y: newY)
        var cDelta = CGPoint(x: (startRecognizingPosition.x - location.x)*MULTIPLICATOR,
                            y: (startRecognizingPosition.y - location.y)*MULTIPLICATOR)
        UpdateAssViewPosition(delta: cDelta)
        NSLog("FKDBG cDelta \(cDelta))")
        /* if let view = recognizer.view {
            let newX = DefaultAssPosition.x - (DefaultAssPosition.x - location.x)*MULTIPLICATOR
            let newY = DefaultAssPosition.y - (DefaultAssPosition.y - location.y)*MULTIPLICATOR
            
            view.center = CGPoint(x: newX, y: newY)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)*/
        
        
        if(recognizer.state == .ended) {
            ifRecognizing = false
            UpdateAssViewPosition(delta: CGPoint.zero)
            let endingPosition = getDirectionFromTouchPosition(startPoint: startRecognizingPosition, endPoint: location)
            PlayerMadeHisTurn(dir: endingPosition)
        }
    }
    
    func getDirectionFromTouchPosition(startPoint s: CGPoint, endPoint e: CGPoint) -> Direction {
        if (e.y < s.y && abs(Int(e.x - s.x)) < abs(Int(s.y - e.y))) {
            return Direction.ToUp
        }
        if (e.y > s.y && abs(Int(e.x - s.x)) < abs(Int(s.y - e.y))) {
            return Direction.ToDown
        }
        if (e.x < s.x && abs(Int(e.y - s.y)) < abs(Int(s.x - e.x))) {
            return Direction.ToLeft
        }
        if (e.x > s.x && abs(Int(e.y - s.y)) < abs(Int(s.x - e.x))) {
            return Direction.ToRight
        }
        
        NSLog("FKDBG someproblems in getDirectionFromTouchPosition")
        return Direction.ToDown
    }
    
    //переставляем первый View в конец ArrowView чтобы не создавать новый
    func MakeFirstArrowViewLast () {
        guard let curLast = ArrowsView.last else {
            print ("WTF in MakeFirstArrowViewLast")
            return
        }
        ArrowsView[0].center.x = curLast.center.x + DistanceBetweenArrows
        ArrowsView.append(ArrowsView.removeFirst())
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
        var curDelta = delta
        var transformForLeftAss = CGAffineTransform.identity
        var transformForLeftHip = CGAffineTransform.identity
        var transformForRightAss = CGAffineTransform.identity
        var transformForRightHip = CGAffineTransform.identity
        var transformForLeftLeg = CGAffineTransform.identity
        var transformForRightLeg = CGAffineTransform.identity
        
        let MAX_X_TRANS_SHIFT = CGFloat(40.0)
        let MAX_DELTA_Y = CGFloat(150.0)
        let MAX_DELTA_X = CGFloat(50.0)
        let MAX_Y_ROT_SHIFT = CGFloat(M_PI/6);
        let MAX_Y_TRANS_SHIFT = CGFloat(100.0)
        
        if(curDelta.y < -50.0) {
            curDelta.y = -50.0
        }
        if(curDelta.y > 50.0) {
            curDelta.y = 50.0
        }
        
        if (curDelta.x < -1*MAX_DELTA_X) {
            curDelta.x = -1*MAX_DELTA_X
        }
        if (curDelta.x > MAX_DELTA_X) {
            curDelta.x = MAX_DELTA_X
        }
        
        
        transformForRightHip = transformForRightHip.rotated(by: MAX_Y_ROT_SHIFT*(curDelta.y / MAX_DELTA_Y))
        transformForLeftHip = transformForLeftHip.rotated(by: MAX_Y_ROT_SHIFT*(curDelta.y / MAX_DELTA_Y))
        
        transformForLeftHip = transformForLeftHip.translatedBy(x: -1*curDelta.x/MAX_DELTA_X*MAX_X_TRANS_SHIFT/3 - curDelta.y * 0.13, y: -1*MAX_Y_TRANS_SHIFT*(curDelta.y / MAX_DELTA_Y / 2))
        // y:
        transformForRightHip = transformForRightHip.translatedBy(x: -1*curDelta.x/MAX_DELTA_X*MAX_X_TRANS_SHIFT/3 - curDelta.y * 0.13, y: -1*MAX_Y_TRANS_SHIFT*(curDelta.y / MAX_DELTA_Y / 2))
        // y:
        
        var scale = 1 + curDelta.x/MAX_DELTA_X/3
        
        transformForLeftHip = transformForLeftHip.scaledBy(x: scale, y: 1)
        transformForRightHip = transformForRightHip.scaledBy(x: scale, y: 1)
        
        
        HipLeft.transform = transformForLeftHip
        HipRight.transform = transformForRightHip
        
//        transformForRightLeg = transformForRightLeg.rotated(by: -1*MAX_Y_ROT_SHIFT*(curDelta.y / MAX_DELTA_Y))
//        transformForLeftLeg = transformForLeftLeg.rotated(by: -1*MAX_Y_ROT_SHIFT*(curDelta.y / MAX_DELTA_Y))
//
//        transformForLeftLeg = transformForLeftLeg.translatedBy(x: 0, y: -1*MAX_Y_TRANS_SHIFT*(curDelta.y / MAX_DELTA_Y))
//        transformForRightLeg = transformForRightLeg.translatedBy(x: 0, y: -1*MAX_Y_TRANS_SHIFT*(curDelta.y / MAX_DELTA_Y))
//
//        FootLeft.transform = transformForLeftLeg
//        FootRight.transform = transformForRightLeg
        
    }
    
    func TwerkAnimation (){
        //анимация
        if (snapForAss != nil){
            animatorForAss.removeBehavior(snapForAss)
        }
        snapForAss = UISnapBehavior(item: AssView, snapTo: DefaultAssPosition)
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
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            for cur in self.ArrowsView {
                cur.center.x -= self.view.frame.width*1.2
            }
        }, completion: { finished in
            //в этот момент начинается сама игра .
            self.AnimateArrows()
        })

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.ScoreLabel.alpha = 1.0
            self.RoundImage.alpha = 1.0
            self.SettingsButton.center.y += 100
            self.NoAdsButton.center.y += 100
            self.ShopButton.center.y += 200
        }, completion: nil)
    }
    
    //обновляем значения в текстовых элементах
    func UpdateLabels () {
        if let game = Game {
            BestScoreLabel.text = String(game.bestScore)
            ScoreLabel.text = String(game.Score)
            CoinsLabel.text = String(game.coins)
        }
    }
    
    //обновляем значения всех видимых элеменетов
    func UpdateAllVisibleInfo (){
        UpdateArrowViews()
        UpdateLabels()
    }
    
    //игрок сделал ход
    func PlayerMadeHisTurn (dir : Direction) {
        NSLog("FKDBG Игрок дернул жопу в сторону: \(dir)");
        if let game = Game {
            guard let curFirst = ArrowsView.first else {
                return
            }
            let delta = abs(curFirst.center.x - RoundImage.center.x)/(RoundImage.frame.width/2)
            let isPlayerMadeRightDisigion = game.PlayerEndedTurn(onPosition: dir, withDelta: Double(delta))
            
            animateRound(forWin: isPlayerMadeRightDisigion)
            MakeFirstArrowViewLast()
            UpdateAllVisibleInfo()
            
            TwerkAnimation()
        } else {
            NSLog ("FKDBG Troubles with PlayerMadeHisTurn")
        }
    }
    
    @IBAction func testBtnUp(_ sender: Any) {
        PlayerMadeHisTurn(dir: .ToUp)
    }
    
    @IBAction func testBtnRight(_ sender: Any) {
        PlayerMadeHisTurn(dir: .ToRight)
    }
    
    @IBAction func testBtnDown(_ sender: Any) {
        PlayerMadeHisTurn(dir: .ToDown)
    }
    
    @IBAction func testBtnLeft(_ sender: Any) {
        PlayerMadeHisTurn(dir: .ToLeft)
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
            NSLog ("FKDBG не подготовился к какой-то segue в GameView")
            abort()
        }
    }
    
    func animateRound(forWin isGreen: Bool) {
        let duration = 0.1
        if isGreen {
            UIView.animate(withDuration: duration, animations: {
                self.RoundGreenImage.alpha = 1
            })
            UIView.animate(withDuration: duration, delay: duration, options: [], animations: {
                self.RoundGreenImage.alpha = 0
            }, completion: nil)
        } else {
            UIView.animate(withDuration: duration, animations: {
                self.RoundRedImage.alpha = 1
            })
            UIView.animate(withDuration: duration, delay: duration, options: [], animations: {
                self.RoundRedImage.alpha = 0
            }, completion: nil)
        }
    }
}
