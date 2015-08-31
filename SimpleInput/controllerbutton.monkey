Import InputControllers

'Summary:  Represents the state of a single digital button.
Class ControllerButton
  Protected
	Field _Holding:Bool   'Checks Holding consistency over frames for Up event.
  Public
	Field codes:= New IntSet  'keycodes for the button
	Field defaultCodes:= New IntSet
	Field Hit:Bool, Down:Bool, Up:Bool  'Used by other classes to determine button state.

	'Summary:  Creates a new ControllerButton with the associated code defaults.
	Method New(code:Int)
		Bind(code, True)
		Reset()
	End Method
	Method New(code:Int[])  'Push multiple codes
		Bind(code, True)
		Reset()
	End Method
		
	'Associates this instance with a specific keycode.
	Method Bind:Bool(code:Int, toDefaults:Bool = False)
		If toDefaults = False
			codes.Insert(code)
		Else
			defaultCodes.Insert(code)
		End If
	End Method
	'Associates this instance with a specific keycodes.
	Method Bind:Bool(code:Int[], toDefaults:Bool = False)
		If toDefaults = False
			For Local o:Int = EachIn code
				Self.defaultCodes.Insert(o)
			Next					
		Else
			For Local o:Int = EachIn code
				Self.defaultCodes.Insert(o)
			Next		
		End If
	End Method
			
	Method Poll:Void()  'Polls the input state
		'Assemble codes to see if any one button is being held down.
		Local btnsHeldDown:Int
		For Local o:Int = EachIn codes
			If KeyDown(o) > 0 Then btnsHeldDown += 1
		Next
		
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
		
	'Summary:  Resets the binds to the defaults.
	Method Reset:Void()
		codes = New IntSet()
		
		For Local o:Int = EachIn defaultCodes
			codes.Insert(o)
		Next
	End Method
	
	'Summary:  Uses this class to determine a keycode to return. 
	Function Detect:Int()	
		For Local i:Int = 0 Until $FFFF
			If KeyDown(i) Then Return i
		Next
		
		Return 0
	End Function
End Class
