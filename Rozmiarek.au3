#include <Array.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <SendMessage.au3>
#include <GDIPlus.au3>
#include <Clipboard.au3>

Opt("TrayMenuMode", 1)
Global $uchwyt_bitmapy
Global $nazwa_bitmapy1
Global $nazwa_bitmapy




#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Rozmiarek", 219, 110, -1, -1, BitOR($WS_POPUP, $DS_MODALFRAME, $DS_CONTEXTHELP), BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW, $GUI_WS_EX_PARENTDRAG))
WinSetTrans($Form1, "", 170)
$Button1 = GUICtrlCreateButton("X", 184, 8, 25, 25, $BS_FLAT)
GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
$Label1 = GUICtrlCreateLabel("bitmapy są zmierzone", 8, 88, 206, 17)
$Label2 = GUICtrlCreateLabel("Podczas działania programu wszystkie ", 8, 72, 183, 17)
$Label3 = GUICtrlCreateLabel("Monitorowanie schowka włączone", 8, 8, 119, 30)
$Label4 = GUICtrlCreateLabel("(^_^)", 64, 24, 84, 38)
GUICtrlSetFont(-1, 22, 800, 0, "Consolas")
GUICtrlSetColor(-1, 0x000000)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
$hTimer = TimerInit()
$infoLabel = True
While 1

	$obraz = ClipGet()

	For $t = 1 To 15
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				_GDIPlus_BitmapDispose($uchwyt_bitmapy)
				Exit
			Case $Button1
				Exit
			Case $GUI_EVENT_PRIMARYDOWN
				On_Drag()
		EndSwitch

		Sleep(5)
	Next



	If _ClipBoard_IsFormatAvailable($CF_BITMAP) == 1 Then
		If _ClipBoard_Open(0) == 1 Then
			$nazwa_bitmapy = _ClipBoard_GetDataEx($CF_DIB)
			If $nazwa_bitmapy == $nazwa_bitmapy1 Then
				_ClipBoard_Close()
				Else
				$uchwyt_bitmapy = _ClipBoard_GetDataEx($CF_BITMAP)

				ConsoleWrite($nazwa_bitmapy & @CRLF)

				$nazwa_bitmapy1 = $nazwa_bitmapy
				GUICtrlSetData($Label4, "(^o^)")
				$infoLabel = True
				$hTimer = TimerInit()


				_GDIPlus_Startup()
				$uchwyt_bitmapy = _GDIPlus_BitmapCreateFromHBITMAP($uchwyt_bitmapy)
				$rozmiarX = _GDIPlus_ImageGetWidth($uchwyt_bitmapy)
				$rozmiarY = _GDIPlus_ImageGetHeight($uchwyt_bitmapy)
				ToolTip("Pix X= " & $rozmiarX & " to " & Round($rozmiarX * 0.2645833333333, 2) & "mm" & @CRLF & "Pix Y= " & $rozmiarY & " to " & Round($rozmiarY * 0.2645833333333, 2) & "mm" & @CRLF & "Powierzchnia= " & Round($rozmiarX * 0.2645833333333 * $rozmiarY * 0.2645833333333, 2) & "mm2" & @CRLF, -1, -1)


				ConsoleWrite("Pix X= " & $rozmiarX & " to " & Round($rozmiarX * 0.2645833333333, 2) & "mm" & @CRLF)
				ConsoleWrite("Pix Y= " & $rozmiarY & " to " & Round($rozmiarY * 0.2645833333333, 2) & "mm" & @CRLF)
				ConsoleWrite("Powierzchnia= " & Round($rozmiarX * 0.2645833333333 * $rozmiarY * 0.2645833333333, 2) & "mm2" & @CRLF)


			EndIf
		EndIf


		Sleep(200)
	EndIf
	If $infoLabel = True Then
		If TimerDiff($hTimer) > 2000 Then
							ToolTip("")
			GUICtrlSetData($Label4, "(^_^)")
			$infoLabel = False

		EndIf
	EndIf
WEnd

Func On_Drag()
	Local $aCurInfo = GUIGetCursorInfo($Form1)
	If $aCurInfo[4] = 0 Then  ; Mouse not over a control
		DllCall("user32.dll", "int", "ReleaseCapture")
		_SendMessage($Form1, $WM_NCLBUTTONDOWN, $HTCAPTION, 0)
	EndIf
EndFunc   ;==>On_Drag
