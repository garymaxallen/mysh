//
//  ViewController.swift
//  mysh
//
//  Created by pcl on 10/25/22.
//

import UIKit

class ViewController: UIViewController {
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        // Do any additional setup after loading the view.
    //        NSLog("com.gg.mysh.log: %@", "viewDidLoad")
    //        self.view.backgroundColor = UIColor.systemBlue
    //    }
    
    var terminalView = TerminalView()
    var terminal = Terminal()
    var sessionPid = Int()
    var controlKey = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        NSLog("com.mycom.mytest2.log: %@", "fdasfasfasfasfasdffasa")
        // Do any additional setup after loading the view.
        setKeyboard()
        MyUtility.boot()
        _ = startSession()
    }
    
    func setKeyboard() {
        let escapeKey = UIButton(type: UIButton.ButtonType.system)
        escapeKey.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        escapeKey.setTitle("ESC", for: UIControl.State.normal)
        escapeKey.setTitleColor(UIColor.black, for: UIControl.State.normal)
        escapeKey.backgroundColor = UIColor.white
        escapeKey.addTarget(self, action: #selector(pressEscape), for: UIControl.Event.touchUpInside)
        
        let tabKey = UIButton(type: UIButton.ButtonType.system)
        tabKey.frame = CGRect(x: 40, y: 0, width: 40, height: 40)
        tabKey.setTitle("TAB", for: UIControl.State.normal)
        tabKey.setTitleColor(UIColor.black, for: UIControl.State.normal)
        tabKey.backgroundColor = UIColor.white
        tabKey.addTarget(self, action: #selector(pressTab), for: UIControl.Event.touchUpInside)
        
        controlKey = UIButton(type: UIButton.ButtonType.system)
        controlKey.frame = CGRect(x: 80, y: 0, width: 40, height: 40)
        controlKey.setTitle("CTRL", for: UIControl.State.normal)
        controlKey.setTitleColor(UIColor.black, for: UIControl.State.normal)
        controlKey.backgroundColor = UIColor.white
        controlKey.addTarget(self, action: #selector(pressControl), for: UIControl.Event.touchUpInside)
        
        let leftButton = UIButton(type: UIButton.ButtonType.system)
        leftButton.frame = CGRect(x: 120, y: 0, width: 40, height: 40)
        leftButton.setTitle("←", for: UIControl.State.normal)
        leftButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        leftButton.backgroundColor = UIColor.white
        leftButton.addTarget(self, action: #selector(pressLeft), for: UIControl.Event.touchUpInside)
        
        let rightButton = UIButton(type: UIButton.ButtonType.system)
        rightButton.frame = CGRect(x: 160, y: 0, width: 40, height: 40)
        rightButton.setTitle("→", for: UIControl.State.normal)
        rightButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        rightButton.backgroundColor = UIColor.white
        rightButton.addTarget(self, action: #selector(pressRight), for: UIControl.Event.touchUpInside)
        
        let upButton = UIButton(type: UIButton.ButtonType.system)
        upButton.frame = CGRect(x: 200, y: 0, width: 40, height: 40)
        upButton.setTitle("↑", for: UIControl.State.normal)
        upButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        upButton.backgroundColor = UIColor.white
        upButton.addTarget(self, action: #selector(pressUp), for: UIControl.Event.touchUpInside)
        
        let downButton = UIButton(type: UIButton.ButtonType.system)
        downButton.frame = CGRect(x: 240, y: 0, width: 40, height: 40)
        downButton.setTitle("↓", for: UIControl.State.normal)
        downButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        downButton.backgroundColor = UIColor.white
        downButton.addTarget(self, action: #selector(pressDown), for: UIControl.Event.touchUpInside)
        
        let pasteButton = UIButton(type: UIButton.ButtonType.system)
        pasteButton.frame = CGRect(x: 280, y: 0, width: 40, height: 40)
        pasteButton.setTitle("P", for: UIControl.State.normal)
        pasteButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        pasteButton.backgroundColor = UIColor.white
        pasteButton.addTarget(self, action: #selector(pressPaste), for: UIControl.Event.touchUpInside)
        
        let hideKeyboardButton = UIButton(type: UIButton.ButtonType.system)
        hideKeyboardButton.frame = CGRect(x: 320, y: 0, width: 40, height: 40)
        hideKeyboardButton.setTitle("⌨", for: UIControl.State.normal)
        hideKeyboardButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        hideKeyboardButton.backgroundColor = UIColor.white
        hideKeyboardButton.addTarget(self, action: #selector(pressHideKeyboard), for: UIControl.Event.touchUpInside)
        
        let kbView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40))
        kbView.backgroundColor = UIColor.white
        kbView.addSubview(escapeKey)
        kbView.addSubview(tabKey)
        kbView.addSubview(controlKey)
        kbView.addSubview(leftButton)
        kbView.addSubview(rightButton)
        kbView.addSubview(upButton)
        kbView.addSubview(downButton)
        kbView.addSubview(pasteButton)
        kbView.addSubview(hideKeyboardButton)
        
        terminalView = TerminalView(frame: UIScreen.main.bounds)
        terminalView.inputAccessoryView = kbView
        terminalView.canBecomeFirstResponder = true;
        self.view.addSubview(terminalView)
    }
    
    @objc func pressEscape() {
        terminalView.insertText("\u{1b}")
    }
    
    @objc func pressHideKeyboard() {
        terminalView.resignFirstResponder()
    }
    
    
    @objc func pressTab() {
        terminalView.insertText("\u{09}")
    }
    
    @objc func pressControl() {
        controlKey.isSelected = !controlKey.isSelected
        terminalView.isControlSelected = !terminalView.isControlSelected
        terminalView.isControlHighlighted = !terminalView.isControlHighlighted
    }
    
    @objc func pressLeft() {
        terminalView.insertText(terminal.arrow(CChar("D")!))
    }
    
    @objc func pressRight() {
        terminalView.insertText(terminal.arrow(CChar("C")!))
    }
    
    @objc func pressUp() {
        terminalView.insertText(terminal.arrow(CChar("A")!))
    }
    
    @objc func pressDown() {
        terminalView.insertText(terminal.arrow(CChar("B")!))
    }
    
    @objc func pressPaste() {
        let str = UIPasteboard.general.string
        if (str != nil) {
            terminalView.insertText(str!)
        }
    }
    
    func startSession() -> Int{
        var err = become_new_init_child()
        if (err < 0){
            return Int(err)
        }
        
        let tty = UnsafeMutablePointer<UnsafeMutablePointer<tty>?>.allocate(capacity: 1)
        tty.initialize(to: UnsafeMutablePointer<tty>.allocate(capacity: 1))
        
        terminalView.terminal = Terminal.createPseudoTerminal(tty)
        
        let stdioFile = "/dev/pts/\(String(describing: tty.pointee?.pointee.num))"
        
        err = create_stdio((stdioFile as NSString?)?.fileSystemRepresentation, TTY_PSEUDO_SLAVE_MAJOR, (tty.pointee?.pointee.num)!)
        if (err < 0){
            return Int(err)
        }
        tty_release(tty.pointee)
        
        err = do_execve("/bin/login", 3, "/bin/login\0-f\0root\0", "TERM=xterm-256color\0")
        if (err < 0){
            return Int(err)
        }
        task_start(current)
        
        return 0
    }
    
    func boot() -> Int {
        let rootsDir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.app.ish.iSH")?.appendingPathComponent("roots")
        let root = rootsDir?.appendingPathComponent(UserDefaults.standard.string(forKey: "Default Root")!)
        NSLog("root: %@", root?.description ?? "nil")
        //        var err = mount_root(&fakefs, (root!.appendingPathComponent("data") as NSURL).fileSystemRepresentation)
        //        if (err < 0){
        //            return err
        //        }
        return 0
    }
    
    
}

