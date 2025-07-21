MyGui := Gui(,"改造石工具",)

; 停止
global stopSign := false
; 词缀
global filter

MyGui.Opt("+Resize +MinSize640x480")

MyGui.Add("GroupBox", "w600 h40", "说明")

MyGui.AddText("xp+10 yp+20", "alt+1 改造石位置 alt+2  装备位置  alt+3 增幅石位置 alt+4 开始改造 alt+5 停止 alt+6 测试")

MyGui.Add("GroupBox", "xp-10 yp+30 w600 h140", "配置")

MyGui.AddText("xp+10 yp+20", "改造石位置:")

gzx := MyGui.AddEdit("xp+70 yp-5 w40",)
gzy := MyGui.AddEdit("xp+50 yp w40",)

zfSign := MyGui.Add("CheckBox", "xp+90 yp+5", "增幅石位置:")
zfSign.OnEvent("Click", ChangeZf)

zfx := MyGui.AddEdit("xp+90 yp-5 w40",)
zfy := MyGui.AddEdit("xp+50 yp w40",)

MyGui.AddText("xp-350 yp+30", "装备位置:")

zbx := MyGui.AddEdit("xp+70 yp-5 w40",)
zby := MyGui.AddEdit("xp+50 yp w40",)

MyGui.AddText("xp-120 yp+30", "循环次数:")
loopnum := MyGui.AddEdit("xp+70 yp-5 w100", "100")

MyGui.AddText("xp-70 yp+30", "词缀包含:")
filter := MyGui.AddEdit("xp+70 yp-5 w500 h40", "该装备附加 \b(3[4-9]|4[0-7])\b - \b(7[2-9]|8[0-4])\b 基础物理伤害`n物理伤害提高 \b(17[0-9])\b%")

MyGui.Add("GroupBox", "xp-80 yp+55 w600 h370", "装备属性")

copy := MyGui.AddEdit("xp+20 yp+30 w550 h330", "该装备附加 43 - 84 基础物理伤害 (fractured)`n物理伤害提高 170%")

MyGui.Add("Text","xp-20 yp+350", "by mihugui v1.0")

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

~Alt & 3:: {
    MouseGetPos &mouseX, &mouseY  ; 获取鼠标坐标（使用引用传递 &）
    zfx.Value := mouseX   ; 填入 Edit 控件
    zfy.Value := mouseY
    return
}

; 洗装备流程
~Alt & 4:: {

    ; 判断 
    if (gzx.Value != "" && gzy.Value != "" && zbx.Value != "" && zby.Value != "" && filter.Value != "") {
        ; 三个变量都不为空时执行的代码
        if zfSign.Value {
            if (zfx.Value == "" || zfy.Value == "") {
                MsgBox "增幅已经启用,请确认坐标"
                return
            }
        }
        MsgBox "改造开始"
    }else{
        MsgBox "坐标不能为空或者筛选不能为空"
        return
    }

    global stopSign

    global  filters
    filters := StrSplit(filter.value, "`n")

    A_Clipboard := ""

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

        ; 增幅操作
        if zfSign.Value {
            UseZf()
        }

    }

    return
}

; 停止按钮
~Alt & 5:: {
    global stopSign

    stopSign := true

    return
}

; 停止按钮
~Alt & 6:: {

    global  filters
    filters := StrSplit(filter.value, "`n")

    for part in filters {
        if RegExStr(copy.value, part) {
            MsgBox "成功"
            return
        }
    }

    MsgBox "失败"
}

; 启用增幅石
ChangeZf(Ctrl, *) {
    if (Ctrl.Value) {
        MsgBox "启用增幅石"
    }
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

; 使用增幅
UseZf(){

    ; 移动鼠标到指定坐标
    MouseMove zfx.Value, zfy.Value

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

    global filters

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
    for part in filters {
        if RegExStr(copy.value, part) {
            return true
        }
    }

    return false

}

; 正则匹配数据
RegExStr(value,filter){


    if RegExMatch(value,filter) > 0 {
        return true
    }

    return false

}