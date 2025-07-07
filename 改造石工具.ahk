MyGui := Gui(,"改造石工具",)

; 停止
global stopSign := false

MyGui.Opt("+Resize +MinSize640x480")

MyGui.Add("GroupBox", "w600 h40", "说明")

MyGui.AddText("xp+10 yp+20", "alt+1 获取改造石位置 alt+2 获取装备位置 alt+3 开始改造 alt+4 停止")

MyGui.Add("GroupBox", "xp-10 yp+30 w600 h120", "配置")

MyGui.AddText("xp+10 yp+20", "改造石位置:")

gzx := MyGui.AddEdit("xp+70 yp-5 w40",)
gzy := MyGui.AddEdit("xp+50 yp w40",)

MyGui.AddText("xp-120 yp+30", "装备位置:")

zbx := MyGui.AddEdit("xp+70 yp-5 w40",)
zby := MyGui.AddEdit("xp+50 yp w40",)

MyGui.AddText("xp-120 yp+30", "循环次数:")
loopnum := MyGui.AddEdit("xp+70 yp-5 w100", "10")

MyGui.AddText("xp-70 yp+30", "洗的词缀,包含:")
filter := MyGui.AddEdit("xp+100 yp-5 w200", "护甲提高")

MyGui.Add("GroupBox", "xp-110 yp+40 w600 h400", "装备属性")

copy := MyGui.AddText("xp+10 yp+30 w550 h350", "抗性")

MyGui.OnEvent("Close", (*) => ExitApp())  ; 关闭窗口时退出脚本



MyGui.Show()


; 获取坐标
~Alt & 1:: {
    MouseGetPos &mouseX, &mouseY  ; 获取鼠标坐标（使用引用传递 &）
    gzx.Value := mouseX   ; 填入 Edit 控件
    gzy.Value := mouseY
    return
}

~Alt & 2:: {
    MouseGetPos &mouseX, &mouseY  ; 获取鼠标坐标（使用引用传递 &）
    zbx.Value := mouseX   ; 填入 Edit 控件
    zby.Value := mouseY
    return
}

; 洗装备流程
~Alt & 3:: {
    MsgBox "改造开始"
    global stopSign
    Loop loopnum.value {

        if stopSign {
            stopSign := false
            break
        }

        if  FilterEquipment(){
            MsgBox "改造成功"
            break
        }

        Sleep 100

        ; 改造操作
        UseGz()
    }
    return
}

; 停止按钮
~Alt & 4:: {
    global stopSign

    stopSign := true

    return
}


; 使用改造石
UseGz(){

    ; 移动鼠标到指定坐标
    MouseMove gzx.Value, gzy.Value

    ; 等待一小段时间让鼠标移动完成
    Sleep 100

    ; 鼠标右击
    Click "right"

    Sleep 100

    ; 移动鼠标到指定坐标
    MouseMove zbx.Value, zby.Value

    Sleep 100

    ; 鼠标左击
    Click

    Sleep 100

}


; 比较装备词缀是否正确
FilterEquipment(){

    ; 移动鼠标到指定坐标
    MouseMove zbx.Value, zby.Value
    
    ; 等待一小段时间让鼠标移动完成
    Sleep 100

    ; 发送 Ctrl+C 复制命令
    Send "^c"
    
    ; 等待复制完成
    Sleep 100

    ; 获取剪切板内容
    copy.value := A_Clipboard

    ; 判断剪切板内容是否包含

    ; 检查是否包含 "测试字符"
    if InStr(copy.value, filter.value) {
        return true
    } else {
        return false
    }

}
