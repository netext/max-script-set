toolTip="VrayMatte pass of Selected objects"
buttonText="VrayMatte pass of Selected objects"

--start macro

fn SetAsMatte obj =
(
	try(setUserProp obj "VRay_Matte_Enable" true)catch()
	try(setUserProp obj "VRay_Matte_Alpha" -1.000000)catch()
)

fn SetAsVisible obj = 
(
	try(setUserProp obj "VRay_Matte_Enable" false)catch()
	try(setUserProp obj "VRay_Matte_Alpha" 1.000000)catch()
)

rollout MatteRoll "Warning: MattePass" width:200 height:47
(

	checkbutton MatteButton "EXIT: Set everything Visible" pos:[8,8] width:184 height:32 highlightColor:(color ((colorman.getcolor #activecommand).x *255) ((colorman.getcolor #activecommand).y *255)((colorman.getcolor #activecommand).z *255)) checked:true  -- LAM - localize?


	on MatteRoll open do
	(
		if (((getinisetting "$max\vsaiFloaters.ini" "vsaiFloater" "MatteRollX") as float) != "") then
		(
		setdialogpos MatteRoll [ 	((getinisetting "$max\vsaiFloaters.ini" "vsaiFloater" "MatteRollX") as integer), \
									((getinisetting "$max\vsaiFloaters.ini" "vsaiFloater" "MatteRollY") as integer)]
		)
	)
	
	on MatteRoll close do 
	(
			--allobjs = objects as array
			--first matte out everything..
			for n = 1 to objects.count do SetAsVisible objects[n]
	
		try (
			setIniSetting "$max\vsaiFloaters.ini" "vsaiFloater" "MatteRollX" (((GetDialogPos(MatteRoll)).x as integer) as string)
			setIniSetting "$max\vsaiFloaters.ini" "vsaiFloater" "MatteRollY" (((GetDialogPos(MatteRoll)).y as integer) as string)
		) catch ()
	)
	
	on MatteButton changed state do
	(
		try (
				setIniSetting "$max\vsaiFloaters.ini" "vsaiFloater" "MatteRollX" (((GetDialogPos(MatteRoll)).x as integer) as string)
				setIniSetting "$max\vsaiFloaters.ini" "vsaiFloater" "MatteRollY" (((GetDialogPos(MatteRoll)).y as integer) as string)
			) catch ()
		destroyDialog MatteRoll 
	)			
) -- end MatteRoll 

	sel = selection as array
	if (sel.count == 0) then ( 
		--Matte out everything, but warn them!
		messagebox "***WARNING*** Nothing selected! \n Setting everything to Matte -1!!! \n Good for quickly setting VrayMTLWrapper Mattes" 
		for n = 1 to objects.count do SetAsMatte objects[n]
	)
	else
	(
		--allobjs = objects as array
		
		--first matte out everything..
		for n = 1 to objects.count do SetAsMatte objects[n]
			
		--next unmatte the selected objects to be visible
		for n = 1 to sel.count do SetAsVisible sel[n]
	)
	
	if (((getinisetting "$max\vsaiFloaters.ini" "vsaiFloater" "MatteRollX") as float) != "") then
	(
		createdialog MatteRoll width:200 height:47 pos:[	((getinisetting "$max\vsaiFloaters.ini" "vsaiFloater" "MatteRollX") as integer), \
															((getinisetting "$max\vsaiFloaters.ini" "vsaiFloater" "MatteRollY") as integer)] \
															style:#(#style_border, #style_toolwindow, #style_sysmenu)
													
	)
	else createDialog MatteRoll height:47 width:200 style:#(#style_border, #style_toolwindow, #style_sysmenu)
		

