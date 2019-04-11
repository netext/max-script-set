rollout a "Ω≈±æπ‹¿Ì" width:151 height:60
(
	global SmLink
	global SmLink1
	global SmLink2
	button btn1 "‰Ø¿¿" pos:[40,0] width:111 height:20
	button btn2 "" pos:[40,0] width:111 height:20
	button btn3 "÷ÿ÷√" pos:[0,0] width:40 height:20
	button btn4 "‰Ø¿¿" pos:[40,20] width:111 height:20
	button btn5 "" pos:[40,20] width:111 height:20
	button btn6 "÷ÿ÷√" pos:[0,20] width:40 height:20
	button btn7 "‰Ø¿¿" pos:[40,40] width:111 height:20
	button btn8 "" pos:[40,40] width:111 height:20
	button btn9 "÷ÿ÷√" pos:[0,40] width:40 height:20
	----------------------
	---------------------------

	on a open do
	(
		if ( getINISetting  "C:\wulin.ini" "jiaoben" "jiaoben1" ) != "" then 
		(
		btn2.text =getFilenameFile ( getINISetting  "C:\wulin.ini" "jiaoben" "jiaoben1" )
		a.btn1.visible=false	
		)
		else(a.btn2.visible=false)
		------------
		if ( getINISetting  "C:\wulin.ini" "jiaoben" "jiaoben2" ) != ""then 
		(
		btn5.text =getFilenameFile ( getINISetting  "C:\wulin.ini" "jiaoben" "jiaoben2" )
		a.btn4.visible=false	
		)
		else(a.btn5.visible=false)
		------------
		if ( getINISetting  "C:\wulin.ini" "jiaoben" "jiaoben3" ) != "" then 
		(
		btn8.text =getFilenameFile ( getINISetting  "C:\wulin.ini" "jiaoben" "jiaoben3" )
		a.btn7.visible=false	
		)
		else(a.btn8.visible=false)
	)
	on btn1 pressed do
	(
		SmLink = getOpenFileName caption:"Open A Test File:" types:"ms (*.ms)|*.ms|mse (*.mse)|*.mse|All Files (*.*)|*.*|"
		if Smlink != undefined then
		(
			btn2.text = getFilenameFile SmLink
			a.btn1.visible=false
			a.btn2.visible=true
			setINISetting  "C:\wulin.ini" "jiaoben" "jiaoben1" (SmLink as string)
		)
		else()
	)
	on btn2 pressed do
	(
		fileIn ( getINISetting  "C:\wulin.ini" "jiaoben" "jiaoben1" as string)
	)
	on btn3 pressed do
	(
		a.btn1.visible=true
		a.btn2.visible=false
	)
	on btn4 pressed do
	(
		SmLink1 = getOpenFileName caption:"Open A Test File:" types:"ms (*.ms)|*.ms|mse (*.mse)|*.mse|All Files (*.*)|*.*|"
		if Smlink1 != undefined then
		(
			btn5.text = getFilenameFile SmLink1
			a.btn4.visible=false
			a.btn5.visible=true
			setINISetting  "C:\wulin.ini" "jiaoben" "jiaoben2" (SmLink1 as string)
		)
		else()
	)
	on btn5 pressed do
	(
		fileIn ( getINISetting  "C:\wulin.ini" "jiaoben" "jiaoben2" as string)
	)
	on btn6 pressed do
	(
		a.btn4.visible=true
		a.btn5.visible=false
	)
	on btn7 pressed do
	(
		SmLink2 = getOpenFileName caption:"Open A Test File:" types:"ms (*.ms)|*.ms|mse (*.mse)|*.mse|All Files (*.*)|*.*|"
		if Smlink2 != undefined then
		(
			btn8.text = getFilenameFile SmLink2
			a.btn7.visible=false
			a.btn8.visible=true
			setINISetting  "C:\wulin.ini" "jiaoben" "jiaoben3" (SmLink2 as string)
		)
		else()
	)
	on btn8 pressed do
	(
		fileIn ( getINISetting  "C:\wulin.ini" "jiaoben" "jiaoben3" as string)
	)
	on btn9 pressed do
	(
		a.btn7.visible=true
		a.btn8.visible=false
	)
)
createdialog a