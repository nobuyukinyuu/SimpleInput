Import mojo
Import controllerbutton

Class InputController
	Field Binds:= New StringMap<ControllerButton>
	
	'Summary:  Polls impulses for input from the codes bound to it.
	Method Poll:Void()
		For Local o:ControllerButton = EachIn Binds.Values
			o.Poll()
		Next
	End Method

	
	'Summary:  Adds a new action/bind combo with the associated button. 
	Method Add:Bool(impulseName:String, button:ControllerButton)
		Return Binds.Add(impulseName, button)
	End Method
	'Summary:  Adds a new action/bind combo with the associated button keycode. 
	Method Add:Bool(impulseName:String, code:Int)
		Local p:= New ControllerButton(code)
		Return Binds.Add(impulseName, p)
	End Method
	'Summary:  Adds a new action/bind combo with the associated button keycodes. 
	Method Add:Bool(impulseName:String, codes:Int[])
		Local p:= New ControllerButton(codes)
		Return Binds.Add(impulseName, p)
	End Method
	'Summary:  Removes the associated action from the bind list.
	Method Remove:Int(impulseName:String)
		Return Binds.Remove(impulseName)
	End Method

		
	'Summary:  Adds a new keybind to an existing action.  Returns FALSE if the action doesn't exist.
	Method Bind:Bool(impulseName:String, code:Int)
		Local o:ControllerButton = Binds.Get(impulseName)
		If o = Null Then Return False
		
		o.Bind(code)
		Return True
	End Method
	'Summary:  Sets the action's binds to the codes given.  Returns FALSE if the action doesn't exist.
	Method Set:Bool(impulseName:String, codes:Int[])
		Local o:ControllerButton = Binds.Get(impulseName)
		If o = Null Then Return False
		
		o.codes = New IntStack(codes)
		Return True		
	End Method

			
	'Summary:  Clears this action's current keybinds.
	Method Clear:Bool(impulseName:String)
		Local o:ControllerButton = Binds.Get(impulseName)
		If o = Null Then Return False
		
		o.codes.Clear()
		Return True
	End Method	
	'Summary:  Resets all actions to their default keybinds.
	Method Reset:Void()
		For Local o:ControllerButton = EachIn Binds.Values()
			o.Reset()
		Next
	End Method
	'Summary:  Resets a specific action to its default keybind.
	Method Reset:Bool(impulse:String)
		Local o:ControllerButton = Binds.Get(impulse)
		If o = Null Then Return False
		
		o.Reset()
		Return True
	End Method
	
	
	'Summary:  Checks an impulse for Hit event. 
	Method IsHit:Bool(impulse:String)
		Return Binds.Get(impulse).Hit
	End Method
	'Summary:  Checks an impulse for Down event. 
	Method IsDown:Bool(impulse:String)
		Return Binds.Get(impulse).Down
	End Method
	'Summary:  Checks an impulse for Up event. 
	Method IsUp:Bool(impulse:String)
		Return Binds.Get(impulse).Up
	End Method	
End Class
