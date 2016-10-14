#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon_dropyt.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         yair reshef

 Script Function:
	youtube-dl drag and droper

#ce ----------------------------------------------------------------------------

#Include <GUIConstantsEx.au3>
#Include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>

#Include "DragDropEvent.au3"

$YTformat = IniRead("settings.ini","vars","format","18/22/44/45/84/102")
;MsgBox(4096, "Result", $YTformat)
;$ytpath= FileGetShortName(@ScriptDir)&'\youtube-dl.exe'
$ytpath= 'youtube-dl.exe'

;$RegExp="(?i)^http://((www\.)?youtube\.com/(watch\?v=|embed/)|youtu\.be/)[a-z0-9_]{11}($|&[a-z0-9_=&]*)"

;Opt("MustDeclareVars", 1)

DragDropEvent_Startup()
Main()
Exit

Func Main()
	Local $MainWin = GUICreate("youtube-dl gui", 350, 120, 150, 150, BitOR($WS_SYSMENU,$WS_EX_TOPMOST))
	$uploadBtn = GUICtrlCreateButton("update", 80, 60, 50, 20)
	$homeBtn = GUICtrlCreateButton("home", 10, 60, 50, 20)
	$paste = GUICtrlCreateInput("  or paste valid url here", 10, 32, 281, 21)
	$pasteBtn = GUICtrlCreateButton("ok", 295, 32, 33, 20)

    GUISetFont(12, 400,"","Consolas")
    GUICtrlCreateLabel("dragDrop video link", 5, 5)
    DragDropEvent_Register($MainWin)

    GUIRegisterMsg($WM_DRAGENTER, "OnDragDrop")
    GUIRegisterMsg($WM_DRAGOVER, "OnDragDrop")
    GUIRegisterMsg($WM_DRAGLEAVE, "OnDragDrop")
    GUIRegisterMsg($WM_DROP, "OnDragDrop")

    GUISetState(@SW_SHOW)

	While 1
        $msg = GUIGetMsg()
        Select
            Case $msg = $GUI_EVENT_CLOSE
                ExitLoop
            Case $msg = $uploadBtn
                Run('youtube-dl.exe -U')
			Case $msg = $homeBtn
                Shellexecute("http://yair.cc/dropYT")
			case $msg=$pasteBtn
				$link = GUICtrlRead($paste)
				;ConsoleWrite(_getDOSOutput('youtube-dl.exe') & @CRLF)
				Run(@ComSpec & ' /c ' & $ytpath& ' -o %(title)s-%(id)s-%(uploader)s.%(ext)s -c --format '&$YTformat&' --console-title -w  --restrict-filenames -i "' &$link&'"', @DesktopCommonDir, @SW_SHOW) ;

        EndSelect

	WEnd
	GUIDelete()
EndFunc

Func OnDragDrop($hWnd, $Msg, $wParam, $lParam)
	Static $DropAccept

	Switch $Msg
		Case $WM_DRAGENTER, $WM_DROP
			ToolTip("")
			Select
				Case DragDropEvent_IsFile($wParam)
					If $Msg = $WM_DROP Then

					EndIf
					$DropAccept = $DROPEFFECT_COPY
				Case DragDropEvent_IsText($wParam)
					If $Msg = $WM_DROP Then
						$link = DragDropEvent_GetText($wParam)
						;ConsoleWrite(_getDOSOutput('youtube-dl.exe') & @CRLF)
						Run(@ComSpec & ' /c ' & $ytpath& ' -o %(title)s-%(id)s-%(uploader)s.%(ext)s -c --format '&$YTformat&' --console-title -w  --restrict-filenames -i "' &$link&'"', @DesktopCommonDir, @SW_SHOW) ;
						;Run(@ComSpec & ' /c ' & $ytpath& ' -o %(title)s-%(id)s-%(uploader)s.%(ext)s -c --format '&$YTformat&' --console-title -w  --restrict-filenames -i "' &$link&'"', @DesktopCommonDir, @SW_SHOW) ;
					EndIf
					$DropAccept = $DROPEFFECT_COPY

				Case Else
					$DropAccept = $DROPEFFECT_NONE

			EndSelect
			Return $DropAccept

		Case $WM_DRAGOVER
			Local $X = DragDropEvent_GetX($wParam)
			Local $Y = DragDropEvent_GetY($wParam)
			ToolTip("(" & $X & "," & $Y & ")")
			Return $DropAccept

		Case $WM_DRAGLEAVE
			ToolTip("")

	EndSwitch
EndFunc

; http://stackoverflow.com/questions/16463854/autoit-capture-run-dos-command-output-as-well-print-on-stdout
;ConsoleWrite(_getDOSOutput('ipconfig /all') & @CRLF)
Func _getDOSOutput($command)
    Local $text = '', $Pid = Run('"' & @ComSpec & '" /c ' & $command, '', @SW_HIDE, 2 + 4)
    While 1
            $text &= StdoutRead($Pid, False, False)
            If @error Then ExitLoop
            Sleep(10)
    WEnd
    Return StringStripWS($text, 7)
EndFunc   ;==>_getDOSOutput