'The Bind mappings builder creates a source file which generates the table of all current
'Monkey keycode mappings.  By pointing the keycodes path to your latest monkey version 
'and rebuilding this project, an updated bind_mappings.monkey file is generated.
'You may then copy the bind_mappings.monkey file to your SimpleInput folder.
'												-Nobuyuki (nobu@subsoap.com), 30 August 2015

'NOTE:   Be sure to build using C++_Tool !
Import brl.filestream

Const OUTPUT_PATH:String = "../../bind_mappings.monkey"  'NASTY hack. C++_Tool targe needs to copy included files somehow!
Const KEYCODES_PATH:String = "D:\Projects\Monkey\MonkeyXPro84d\modules\mojo\keycodes.monkey"
Const TEMPLATE_PATH:String = "../../template.monkey"

Function Main:Int()
	Print("Generating mappings....")
	Local keycode_file:FileStream = FileStream.Open(KEYCODES_PATH, "r")
	Local lines:= New StringStack
	
	'Get the mappings.
	While keycode_file.Eof = 0
		Local line:String = keycode_file.ReadLine()
		'Skip preprocessor directives and non-ascii.
		If line.StartsWith("#") Then Continue
		If line.StartsWith("Const CHAR") Then Continue
		
		'Shove every line that isn't a const directly into the template.
		If Not line.StartsWith("Const")
			lines.Push(line)
		Else
			'Start chooching this into the proper jank.  First, split lines with multiple defs.
			line = line.Replace("Const ", "")
			Local splitLine:= line.Split(",")
			
			For Local item:String = EachIn splitLine
				'Determine the name part and the keycode part.
				Local part:= item.Split("=")

				'Part 0 is the string part.  Lowercase it and remove KEY_ refs.
				Local properName:Bool = True  'Special codes can override the proper name of a basic keycode. Let's avoid this.
				Local stringPart:String
				If part[0].StartsWith("KEY_")
					stringPart = part[0][4 ..].ToLower
				Else
					stringPart = part[0].ToLower
					properName = False
				End If

				'Part 1 is the keycode part.
				'Check to see if there's a comment at the end of the line.  If so, push it to lines and remove it from part[1].
				Local comment_pos:Int = part[1].Find("'")
				If comment_pos >= 0 Then
					Local comment:String = part[1][comment_pos ..]
					lines.Push(comment)
					part[1] = part[1][0 .. comment_pos]
				End If
				'If part[1] is in hex, we need to convert it.
				If part[1].StartsWith("$") Then part[1] = HexBEToDec(part[1].Trim[1 ..])
				Local keycodePart:Int = Int(part[1].Trim)
				
				
				lines.Push("~t~tcodes.Add(~q" + stringPart + "~q, " + keycodePart + ")")
				If properName Then lines.Push("~t~tnames.Set(" + keycodePart + ", ~q" + stringPart + "~q)")
			Next
		
		End If		
	Wend
	keycode_file.Close()

	
	'Now, let's open up the template monkey file and inject the pairs.	
	Local template:FileStream = FileStream.Open(TEMPLATE_PATH, "r")
	Local output:FileStream = FileStream.Open(OUTPUT_PATH, "w")
	If output = Null Then Error("Error saving to " + OUTPUT_PATH)	
			
	While template.Eof = 0
		Local line:String = template.ReadLine()
		
		If line.StartsWith("{MAPPINGS}") 'Write the mapping here!
			For Local o:String = EachIn lines
				output.WriteLine(o)
			Next
		ElseIf line.StartsWith("{INFO}")
			output.WriteLine("' " + KEYCODES_PATH)
		Else 'Write from the template.
			output.WriteLine(line)
		End If
	Wend
	
	
	Print("Mappings built.")
	Return 0
End Function


'Summary:  Provides data for a keycode equivalent.
Class Keycode
	Field name:String   'Proper name
	Field code:Int      'Codepoint for original character
	Field mapping:Int   'Mapping for the codepoint
	Field status:String 'Char determining the status type of the mapping.  See CaseFolding.txt for details.
End Class



'HexToDec code ripped from Goodlookinguy.  More information:
'http://www.nrgs.org/2030/the-fastestquickest-hex-to-dec-and-dec-to-hex/
'http://www.monkey-x.com/Community/posts.php?topic=8247&post=83171
Function HexBEToDec:Int(hex:String)
	Local a1, a2, b1, b2, c1, c2, d1, d2, len, off
	len = hex.Length ' assuming 8 is the max without having to clamp
	off = 8 - len
	
	If len < 1 Then a1 = 0 Else a1 = hex[7 - off] - 48
	If len < 2 Then a2 = 0 Else a2 = hex[6 - off] - 48
	If len < 3 Then b1 = 0 Else b1 = hex[5 - off] - 48
	If len < 4 Then b2 = 0 Else b2 = hex[4 - off] - 48
	If len < 5 Then c1 = 0 Else c1 = hex[3 - off] - 48
	If len < 6 Then c2 = 0 Else c2 = hex[2 - off] - 48
	If len < 7 Then d1 = 0 Else d1 = hex[1 - off] - 48
	If len < 8 Then d2 = 0 Else d2 = hex[0] - 48
	
	If a1 > 9 Then a1 = a1 - 7 - (a1 / 48 * 32)
	If a2 > 9 Then a2 = a2 - 7 - (a2 / 48 * 32)
	If b1 > 9 Then b1 = b1 - 7 - (b1 / 48 * 32)
	If b2 > 9 Then b2 = b2 - 7 - (b2 / 48 * 32)
	If c1 > 9 Then c1 = c1 - 7 - (c1 / 48 * 32)
	If c2 > 9 Then c2 = c2 - 7 - (c2 / 48 * 32)
	If d1 > 9 Then d1 = d1 - 7 - (d1 / 48 * 32)
	If d2 > 9 Then d2 = d2 - 7 - (d2 / 48 * 32)
	
	Return a1 | (a2 Shl 4) | (b1 Shl 8) | (b2 Shl 12) | (c1 Shl 16) | (c2 Shl 20) | (d1 Shl 24) | (d2 Shl 28)
End