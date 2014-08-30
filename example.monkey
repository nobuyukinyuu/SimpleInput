'SimpleInput example.   2014 Nobuyuki. (nobu@subsoap.com)
'Please visit https://github.com/nobuyukinyuu/SimpleInput for more details.

Import mojo
Import SimpleInput.InputControllers
Import SimpleInput.analogbutton

Function Main:Int()
	New Game()
End Function


Class Game Extends App
	'Erroneous analog stick values can happen rarely on glfw for some controllers and create phantom triggers.  
	'If so, this example lets you disable analog binds. 
	Const DISABLE_ANALOG_DETECTION:Bool

	Field Control:InputController     'The Controller contains all of our virtual buttons and their binds.
	Field btns:= New Stack<DrawBtn>   'The UI buttons associated with buttons in our InputController.
	Field currentBtn:DrawBtn          'The currently selected UI button.

	Field bg:Image                    'Picture of a controller.....
	
	Field Detecting:Bool              'are we polling for a bind?
	
	Field BindThreshold:Float = 0.75  'We use this when detecting binds, and set it to a value >1 when analog's disabled.
	
	Field crap = 2
	
	Method OnCreate()
		SetUpdateRate 60
		
		bg = LoadImage("mazenl77_controller2.png")
		
		Control = New InputController()

		'Determine if we're needing to disable the AnalogAxisButton detection.
		If DISABLE_ANALOG_DETECTION Then
			'Here's how you would add controls normally if you just wanted to detect digital buttons.
			Control.Add("up",[KEY_UP, KEY_JOY0_UP])
			Control.Add("down",[KEY_DOWN, KEY_JOY0_DOWN])
			Control.Add("left",[KEY_LEFT, KEY_JOY0_LEFT])
			Control.Add("right",[KEY_RIGHT, KEY_JOY0_RIGHT])
	
			Control.Add("a",[KEY_D, KEY_JOY0_A])
			Control.Add("b",[KEY_C, KEY_JOY0_B])
			Control.Add("x",[KEY_S, KEY_JOY0_X])
			Control.Add("y",[KEY_X, KEY_JOY0_Y])
			Control.Add("l",[KEY_A, KEY_JOY0_LB])
			Control.Add("r",[KEY_F, KEY_JOY0_RB])
			
			' Since we specified we have a broken stick but are still using AnalogAxisButton's bind detection, 
			' make the detection threshold such that analog axises never bind.
			BindThreshold = 255
			Print("Warning: Disabling analog detection...")
			
		Else
			'Add the direcitonal buttons.  Here's how to do it when using an extension like having analog support.
			Control.Add("up", New AnalogAxisButton([KEY_UP, KEY_JOY0_UP, AnalogAxisButton.LS_UP1]))
			Control.Add("down", New AnalogAxisButton([KEY_DOWN, KEY_JOY0_DOWN, AnalogAxisButton.LS_DOWN1]))
			Control.Add("left", New AnalogAxisButton([KEY_LEFT, KEY_JOY0_LEFT, AnalogAxisButton.LS_LEFT1]))
			Control.Add("right", New AnalogAxisButton([KEY_RIGHT, KEY_JOY0_RIGHT, AnalogAxisButton.LS_RIGHT1]))
	
			Control.Add("a",New AnalogAxisButton([KEY_D, KEY_JOY0_A]))
			Control.Add("b",New AnalogAxisButton([KEY_C, KEY_JOY0_B]))
			Control.Add("x",New AnalogAxisButton([KEY_S, KEY_JOY0_X]))
			Control.Add("y",New AnalogAxisButton([KEY_X, KEY_JOY0_Y]))
			Control.Add("l",New AnalogAxisButton([KEY_A, KEY_JOY0_LB]))
			Control.Add("r", New AnalogAxisButton([KEY_F, KEY_JOY0_RB]))	
		End If
		
	
		'Setup gui buttons.
		For Local o:String = EachIn Control.Binds.Keys
			Local p:= New DrawBtn()
			If o = "l" or o = "r" or o = "select" or o = "start" Then p.drawTri = True
			
			Select o
				Case "up"
					p.Set(102, 208)
				Case "down"
					p.Set(102, 290)
				Case "left"
					p.Set(60, 248)
				Case "right"
					p.Set(142, 248)
				Case "a"
					p.Set(448, 248)
				Case "b"
					p.Set(408, 288)
				Case "x"
					p.Set(408, 208)
				Case "y"
					p.Set(368, 248)
				Case "l"
					p.Set(102, 108)
				Case "r"
					p.Set(408, 108)
			End Select

			p.name = o
			p.btn = Control.Binds.Get(o)
			btns.Push(p)
		Next
	End Method
	
	Method OnUpdate()	
		Control.Poll()  'Poll the inputController
		
		For Local o:DrawBtn = EachIn btns
			If o.btn.Hit Then Print "Hit: " + o.name
			If o.btn.Up Then Print "Up: " + o.name
			
			If Dist(o.x, o.y, MouseX, MouseY) <= o.r and MouseHit() Then currentBtn = o  'Set the current UI button.
		Next
	
			
		If currentBtn <> Null
			If Detecting
				'Get the button pressed, if any.
				Local i:Int = AnalogAxisButton.Detect(BindThreshold) 'ControllerButton.Detect() if not using analog
				
				'In our example, we deliberately reserve F1/Esc for other functions.
				If i > 0 and i <> KEY_F1 And i <> KEY_ESCAPE Then  'Stop detection and bind.
					Detecting = False					
					Control.Bind(currentBtn.name, i)
				ElseIf i = KEY_ESCAPE
					Detecting = False
				End If

			Else
				If KeyHit(KEY_ESCAPE) Then Control.Clear(currentBtn.name)  'Clear all binds for this controller's button.
				If KeyHit(KEY_F1) Then Detecting = True  'Ignore dupe triggers for the "start detection" key.
			End If
		End If
		
			If KeyHit(KEY_F12)  'Reset to defaults
				'currentBtn = Null
				Control.Reset()
			End If
	End Method
	
	Method OnRender()
		Cls()
		
		DrawImage(bg, 0, 0)
		
		For Local o:DrawBtn = EachIn btns
			o.Draw()
		Next
		
		If currentBtn <> Null
			Local binds:String
			For Local o:Int = EachIn currentBtn.btn.codes
				binds += o + ","
			Next
		
			binds = binds[ .. - 1]  'clip trailing comma
			
			DrawText(currentBtn.name, 8, 8)
			DrawText("Associated binds: " + binds, 8, 24)
			
			If Detecting
				DrawText("Press ESC to cancel bind detection.", 8, 48)
			Else
				DrawText("Press F1 to bind.  Press Esc to clear this bind.", 8, 48)
			End If
			
		Else
				DrawText("Click a button for more info.", 8, 8)			
		End If
				DrawText("Press F12 to reset all binds. ", 8, 64)

	End Method
End Class


Class DrawBtn
	Field x:Float, y:Float, r:Float = 18
	Field drawTri:Bool
	Field name:String
	
	Field btn:ControllerButton  'The actual button associated with this UI element.
	
	Method New(x:Float, y:Float, tri:Bool = False)
		Self.x = x; Self.y = y; Self.drawTri = tri
	End Method
	
	Method Draw:Void()
		'Detect our associated ControllerButton's input state and draw based on that.
		If btn.Hit
			SetAlpha(1)
		ElseIf btn.Down
			SetAlpha(0.5)
		Else
			SetAlpha(0.1)
		End If
			
		If drawTri
			DrawPoly([x, y, x - r / 1.4, y - r, x + r / 1.4, y - r])
		Else
			DrawCircle(x, y, r)
		End If
		SetAlpha(1)
	End Method
	
	Method Set(x:Float, y:Float)
		Self.x = x; Self.y = y
	End Method
End Class

Function Dist:Float(x1:Float, y1:Float, x2:Float, y2:Float)
	Return Sqrt( (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1))
End Function