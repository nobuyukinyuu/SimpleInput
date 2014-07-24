Import controllerbutton

'Summary:  Like ControllerButton, but also detects directions on an analog stick or trigger.
Class AnalogAxisButton Extends ControllerButton
  Private
  	'Base constants	
	Const UP = 1
	Const DOWN = 2
	Const LEFT = 3
	Const RIGHT = 4


	Const LT = 9
	Const RT = 10

  Public
	'Player 1
	Const LS_UP1 = $10000 + 1
	Const LS_DOWN1 = $10000 + 2
	Const LS_LEFT1 = $10000 + 3
	Const LS_RIGHT1 = $10000 + 4

	Const RS_UP1 = $10000 + 5
	Const RS_DOWN1 = $10000 + 6
	Const RS_LEFT1 = $10000 + 7
	Const RS_RIGHT1 = $10000 + 8

	Const LT1 = $10000 + 9
	Const RT1 = $10000 + 10

	'Player 2
	Const LS_UP2 = $10020 + 1
	Const LS_DOWN2 = $10020 + 2
	Const LS_LEFT2 = $10020 + 3
	Const LS_RIGHT2 = $10020 + 4

	Const RS_UP2 = $10020 + 5
	Const RS_DOWN2 = $10020 + 6
	Const RS_LEFT2 = $10020 + 7
	Const RS_RIGHT2 = $10020 + 8

	Const LT2 = $10020 + 9
	Const RT2 = $10020 + 10

	'Player 3
	Const LS_UP3 = $10040 + 1
	Const LS_DOWN3 = $10040 + 2
	Const LS_LEFT3 = $10040 + 3
	Const LS_RIGHT3 = $10040 + 4

	Const RS_UP3 = $10040 + 5
	Const RS_DOWN3 = $10040 + 6
	Const RS_LEFT3 = $10040 + 7
	Const RS_RIGHT3 = $10040 + 8

	Const LT3 = $10040 + 9
	Const RT3 = $10040 + 10

	'Player 4
	Const LS_UP4 = $10060 + 1
	Const LS_DOWN4 = $10060 + 2
	Const LS_LEFT4 = $10060 + 3
	Const LS_RIGHT4 = $10060 + 4

	Const RS_UP4 = $10060 + 5
	Const RS_DOWN4 = $10060 + 6
	Const RS_LEFT4 = $10060 + 7
	Const RS_RIGHT4 = $10060 + 8

	Const LT4 = $10060 + 9
	Const RT4 = $10060 + 10


	Field Threshold:Float = 0.75  'How far does the stick have to move from center to fire off?
	
	
	'Summary:  Creates a new AnalogAxisButton with the associated code defaults.
	Method New(code:Int)
		Bind(code, True)
		Reset()
	End Method
	Method New(code:Int[])  'Push multiple codes
		Bind(code, True)
		Reset()
	End Method
	
	
	Method Poll:Void()  'Polls the input state
		'Assemble codes to see if any one button is being held down.
		Local btnsHeldDown:Int
		For Local o:Int = EachIn codes
			If KeyDown(o) > 0 Then btnsHeldDown += 1

			'The big list of manual chex			
			Select o
			'Player 1
			Case LS_DOWN1
				If JoyY(0, 0) <= - Threshold Then btnsHeldDown += 1
			Case LS_UP1
				If JoyY(0, 0) >= Threshold Then btnsHeldDown += 1
			Case LS_LEFT1
				If JoyX(0, 0) <= - Threshold Then btnsHeldDown += 1
			Case LS_RIGHT1
				If JoyX(0, 0) >= Threshold Then btnsHeldDown += 1
		
			Case RS_DOWN1
				If JoyY(1, 0) <= - Threshold Then btnsHeldDown += 1
			Case RS_UP1
				If JoyY(1, 0) >= Threshold Then btnsHeldDown += 1
			Case RS_LEFT1
				If JoyX(1, 0) <= - Threshold Then btnsHeldDown += 1
			Case RS_RIGHT1
				If JoyX(1, 0) >= Threshold Then btnsHeldDown += 1
		
			Case LT1
				If JoyZ(0, 0) >= Threshold Then btnsHeldDown += 1
			Case RT1
				If JoyZ(0, 0) <= - Threshold Then btnsHeldDown += 1
		
			'Player 2
			Case LS_DOWN2
				If JoyY(0, 1) <= - Threshold Then btnsHeldDown += 1
			Case LS_UP2
				If JoyY(0, 1) >= Threshold Then btnsHeldDown += 1
			Case LS_LEFT2
				If JoyX(0, 1) <= - Threshold Then btnsHeldDown += 1
			Case LS_RIGHT2
				If JoyX(0, 1) >= Threshold Then btnsHeldDown += 1
		
			Case RS_DOWN2
				If JoyY(1, 1) <= - Threshold Then btnsHeldDown += 1
			Case RS_UP2
				If JoyY(1, 1) >= Threshold Then btnsHeldDown += 1
			Case RS_LEFT2
				If JoyX(1, 1) <= - Threshold Then btnsHeldDown += 1
			Case RS_RIGHT2
				If JoyX(1, 1) >= Threshold Then btnsHeldDown += 1
		
			Case LT2
				If JoyZ(0, 1) >= Threshold Then btnsHeldDown += 1
			Case RT2
				If JoyZ(0, 1) <= - Threshold Then btnsHeldDown += 1

			'Player 3
			Case LS_DOWN3
				If JoyY(0, 2) <= - Threshold Then btnsHeldDown += 1
			Case LS_UP3
				If JoyY(0, 2) >= Threshold Then btnsHeldDown += 1
			Case LS_LEFT3
				If JoyX(0, 2) <= - Threshold Then btnsHeldDown += 1
			Case LS_RIGHT3
				If JoyX(0, 2) >= Threshold Then btnsHeldDown += 1
		
			Case RS_DOWN3
				If JoyY(1, 2) <= - Threshold Then btnsHeldDown += 1
			Case RS_UP3
				If JoyY(1, 2) >= Threshold Then btnsHeldDown += 1
			Case RS_LEFT3
				If JoyX(1, 2) <= - Threshold Then btnsHeldDown += 1
			Case RS_RIGHT3
				If JoyX(1, 2) >= Threshold Then btnsHeldDown += 1
		
			Case LT3
				If JoyZ(0, 2) >= Threshold Then btnsHeldDown += 1
			Case RT3
				If JoyZ(0, 2) <= - Threshold Then btnsHeldDown += 1
				
			'Player 3
			Case LS_DOWN4
				If JoyY(0, 3) <= - Threshold Then btnsHeldDown += 1
			Case LS_UP4
				If JoyY(0, 3) >= Threshold Then btnsHeldDown += 1
			Case LS_LEFT4
				If JoyX(0, 3) <= - Threshold Then btnsHeldDown += 1
			Case LS_RIGHT4
				If JoyX(0, 3) >= Threshold Then btnsHeldDown += 1
		
			Case RS_DOWN4
				If JoyY(1, 3) <= - Threshold Then btnsHeldDown += 1
			Case RS_UP4
				If JoyY(1, 3) >= Threshold Then btnsHeldDown += 1
			Case RS_LEFT4
				If JoyX(1, 3) <= - Threshold Then btnsHeldDown += 1
			Case RS_RIGHT4
				If JoyX(1, 3) >= Threshold Then btnsHeldDown += 1
		
			Case LT4
				If JoyZ(0, 3) >= Threshold Then btnsHeldDown += 1
			Case RT4
				If JoyZ(0, 3) <= - Threshold Then btnsHeldDown += 1				
			End Select
		Next
		
		
		'Super.Poll()
		
		If btnsHeldDown > 0 Then
			Hit = True
		
			If Self._Holding = True Then 'Was _Holding last frame. Disable Hit.
				Hit = False
			End If

			_Holding = True
			Down = True
			
		Else 'Not _Holding Down any of the valid binds.
			Down = False

			If _Holding = True Then 'Was _Holding last frame. Do KeyUp
				Self._Holding = False
				Up = True
			Else; Up = False
			End If
		End If
	End Method
	
	'Summary:  Returns a const > 65536 if a stick exceeds threshold, else performs normal ControllerButton detection. 
	Function Detect:Int(Threshold:Float = 0.75)
		
		For Local player:Int = 0 To 3
		
			For Local stick:Int = 0 To 1
				If JoyX(stick,player) >= Threshold Then Return $10000 + (player * 32) + (stick * 4) + RIGHT
				If JoyX(stick,player) <= - Threshold Then Return $10000 + (player * 32) + (stick * 4) + LEFT

				If JoyY(stick, player) >= Threshold Then Return $10000 + (player * 32) + (stick * 4) + UP
				If JoyY(stick, player) <= - Threshold Then Return $10000 + (player * 32) + (stick * 4) + DOWN
				
				If JoyZ(stick, player) >= Threshold Then Return $10000 + (player * 32) + LT
				If JoyZ(stick, player) <= - Threshold Then Return $10000 + (player * 32) + RT
				
			Next
		Next
		
		
		Return ControllerButton.Detect()
	End Function			
End Class