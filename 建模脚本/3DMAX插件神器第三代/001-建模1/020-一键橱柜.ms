
(
local general, floorUnits, wallUnits, aboutgoruss, pb1,worldWorktop
theFloater = newRolloutFloater "橱柜创建(3dheima.com)" 790 453	

	--UnitsSetup
	--floor
	worldWorktop = units.decodeValue "4.0cm"
	worldWidth = units.decodeValue "80cm"
	worldHeight = units.decodeValue "82cm"
	worldDepth = units.decodeValue "56cm"
	worldTick = units.decodeValue "1.8cm"
	worldMask = units.decodeValue "10cm"
	
	globWidth = [0,worldWidth * 4,worldWidth]
	globHeight = [0,worldHeight * 4,worldHeight]
	globDepth = [0,worldDepth * 4,worldDepth]
	globTick = [0,worldTick * 10,worldTick]
	globMask = [0,worldMask * 4,worldMask]
	--
	--wall
	worldZpos = units.decodeValue "160cm"
	worldWidth_w = units.decodeValue "80cm"
	worldHeight_w = units.decodeValue "90cm"
	worldDepth_w = units.decodeValue "35cm"
	worldTick_w = units.decodeValue "1.8cm"
	worldGlassFrame = units.decodeValue "6.0cm"
	
	globWidth_w = [0,worldWidth_w * 4,worldWidth_w]
	globHeight_w = [0,worldHeight_w * 4,worldHeight_w]
	globDepth_w = [0,worldDepth_w * 4,worldDepth_w]
	globTick_w = [0,worldTick_w * 10,worldTick_w]
	globGlassFrame = [0,worldGlassFrame * 4,worldGlassFrame]
	--End of unit setup
	
	--constants
	doorSpace = units.decodeValue "0.3cm"
	doorABS = units.decodeValue "0.2cm"
	doorZpos = units.decodeValue "0.15cm"
	doorFillet = units.decodeValue "0.2cm"
	handlesPos = units.decodeValue "5cm"
	
	handleLength = units.decodeValue "4cm"
	handleRenderHight = units.decodeValue "2cm"
	handleRenderWidth = units.decodeValue "1cm"
	handleCornerRad = units.decodeValue "1cm"
	handleRenderRadius = units.decodeValue "1.5cm"
	
--Materials
fn handlesSatinedMetal =
(
	if general.isMrayMat.triState == 1 then
	(
	   meditMaterials[1] = Arch___Design__mi ()
	   meditMaterials[1].name = "Metal: Satined_Metal"
	   meditMaterials[1].diff_weight = 0.3
	   meditMaterials[1].diff_color = color 255 255 255
	   meditMaterials[1].refl_color = color 225 225 225
	   meditMaterials[1].refl_weight = 0.8
	   meditMaterials[1].refl_gloss = 0.4
	   meditMaterials[1].refl_samples = 24
	   meditMaterials[1].refl_metal = true
	   meditMaterials[1].opts_refl_depth = 5
	   meditMaterials[1].refr_ior = 1.2
	   meditMaterials[1].anisotropy = 0.05
	   meditMaterials[1].anisoangle = 0.0
	   meditMaterials[1].refl_func_low= 0.9
		meditMaterials[1].refl_func_high= 1
		meditMaterials[1].refl_func_curve= 5	
	)else
	(
	meditMaterials[1] = Standardmaterial ()
	meditMaterials[1].shaderType = 2
	meditMaterials[1].ambient = color 255 255 255
	meditMaterials[1].Diffuse = color 255 255 255
	meditMaterials[1].specularLevel = 20
	meditMaterials[1].glossiness = 5
	)
)
fn corpusMat =
(
	if general.isMrayMat.triState == 1 then
	(
	   meditMaterials[2] = Arch___Design__mi ()
	   meditMaterials[2].name = "Corpusi:White"
	   meditMaterials[2].diff_weight = 1
	   meditMaterials[2].diff_color = color 255 255 255
	   meditMaterials[2].refl_color = color 225 225 225
	   meditMaterials[2].refl_weight = 0.3
	   meditMaterials[2].refl_gloss = 0.2
	   meditMaterials[2].refl_samples = 24
	   meditMaterials[2].refl_interp = true
	   meditMaterials[2].opts_refl_depth = 5
	   meditMaterials[2].refr_ior = 1.4
	   meditMaterials[2].anisotropy = 0.05
	   meditMaterials[2].anisoangle = 0.0
	   meditMaterials[2].refl_func_low= 0.1
	   meditMaterials[2].refl_func_high= 1
	   meditMaterials[2].refl_func_curve= 5	
	)else
	(	
	meditMaterials[2] = Standardmaterial ()
	meditMaterials[2].ambient = color 245 245 245
	meditMaterials[2].Diffuse = color 245 245 245
	meditMaterials[2].specularLevel = 20
	meditMaterials[2].glossiness = 5
	)

)
fn frontMat =
(
	   if general.isMrayMat.triState == 1 then
	(
	   meditMaterials[3] = Arch___Design__mi ()
	   meditMaterials[3].name = "Front:Wood"
	   meditMaterials[3].diff_weight = 1
	   meditMaterials[3].diff_color = color 252 205 154
	   meditMaterials[3].refl_color = color 225 225 225
	   meditMaterials[3].refl_weight = 0.7
	   meditMaterials[3].refl_gloss = 0.5
	   meditMaterials[3].refl_samples = 16
	   meditMaterials[3].opts_refl_depth = 5
	   meditMaterials[3].refr_ior = 1.4
	   meditMaterials[3].anisotropy = 0.5
	   meditMaterials[3].anisoangle = 0.25
	   meditMaterials[3].refl_func_low= 0.05
	   meditMaterials[3].refl_func_high= 1
	   meditMaterials[3].refl_func_curve= 5	
	)else
	(
	meditMaterials[3] = Standardmaterial ()
	meditMaterials[3].ambient = color 252 205 154
	meditMaterials[3].Diffuse = color 252 205 154
	meditMaterials[3].specularLevel = 20
	meditMaterials[3].glossiness = 5
	)
)
fn worktopMat =
(
	if general.isMrayMat.triState == 1 then
	(
	   meditMaterials[7] = Arch___Design__mi ()
	   meditMaterials[7].name = "Worktop:Wood"
	   meditMaterials[7].diff_weight = 1
	   meditMaterials[7].diff_color = color 165 148 131
	   meditMaterials[7].refl_color = color 225 225 225
	   meditMaterials[7].refl_weight = 0.7
	   meditMaterials[7].refl_gloss = 0.5
	   meditMaterials[7].refl_samples = 16
	   meditMaterials[7].opts_refl_depth = 5
	   meditMaterials[7].refr_ior = 1.4
	   meditMaterials[7].anisotropy = 0.5
	   meditMaterials[7].anisoangle = 0.25
	   meditMaterials[7].refl_func_low= 0.05
	   meditMaterials[7].refl_func_high= 1
	   meditMaterials[7].refl_func_curve= 5	
	)else
	(
	meditMaterials[7] = Standardmaterial ()
	meditMaterials[7].ambient = color 165 148 131
	meditMaterials[7].Diffuse = color 165 148 131
	meditMaterials[7].specularLevel = 20
	meditMaterials[7].glossiness = 5
	)
)
fn glassDoorMat =
(
	if general.isMrayMat.triState == 1 then
	(
	meditMaterials[8] = Arch___Design__mi ()
	meditMaterials[8].name = "Glass:Frosted"
	meditMaterials[8].diff_weight = 0.52
	meditMaterials[8].diff_color = color 255 255 255
	meditMaterials[8].refl_weight = 1
	meditMaterials[8].refr_weight = 0.8
	meditMaterials[8].refr_gloss = 0.5
	meditMaterials[8].refr_color = color 249 249 249 255
	meditMaterials[8].refr_samples = 12
	meditMaterials[8].refr_ior = 1.5
	meditMaterials[8].refr_trans_on = true
	meditMaterials[8].refr_transw = 0.2
	meditMaterials[8].refr_transc = color 249 249 249 255
	meditMaterials[8].refl_func_fresnel= true
	meditMaterials[8].refr_falloff_on = true
	meditMaterials[8].refr_falloff_dist = 30
	meditMaterials[8].refr_falloff_color_on = true
	meditMaterials[8].refr_falloff_color = color 104 182 218 255
	meditMaterials[8].opts_refr_depth = 8
	meditMaterials[8].opts_do_refractive_caustics = false
	meditMaterials[8].opts_backface_cull = false
	meditMaterials[8].opts_propagate_alpha = true
)else
(
	meditMaterials[8] = Standardmaterial ()
	meditMaterials[8].ambient = color 255 255 255
	meditMaterials[8].Diffuse = color 255 255 255
	meditMaterials[8].opacity = 39
	meditMaterials[8].specularLevel = 20
	meditMaterials[8].glossiness = 5
)
)

rollout General "基础 参数" width:760 height:120
(
	dropdownList whatCabs "选择类型:" pos:[8,8] width:104 height:40 items:#("地面 橱柜", "墙壁 吊柜", "以上两者全有") default:3 toolTip:"选择你想创造什么样的橱柜."
	checkbox worktop "台面面板" pos:[124,8] width:72 height:16 triState:0 toolTip:"检查如果你想创建桌面."
	spinner worktopTick "" pos:[145,24] type:#worldunits width:40 height:16 enabled:false range:[0,worldWorktop * 4,worldWorktop] scale:0.1 fieldwidth:52 toolTip:"台面厚度"
	checkbox sink "洗菜盆" pos:[200,8] width:55 height:16 triState:0 	
	checkbox sinkSquare "正方形" pos:[200,24] width:55 height:16 triState:0 enabled:false 	
	checkbox sinkRound "圆形" pos:[200,40] width:55 height:16 triState:1 enabled:false
	spinner sinkNo "" pos:[214,56]  width:40 height:16 enabled:false range:[1,2,1] scale:1 fieldwidth:45 toolTip:"洗菜盆数量."
	
	checkbox handles "柜门把手" pos:[265,8] width:80 height:16 triState:0 
	checkbox squareHandles "方形把手" pos:[265,24] width:96 height:16 enabled:false triState:1 
	checkbox roundHandles "圆形把手" pos:[265,40] width:96 height:16 enabled:false triState:0 
	
	checkbox groupobj "创建橱柜后成组" pos:[365,8] width:120 height:16 triState:1 
	checkbox isMrayMat "MentalRay 材质" pos:[365,24] width:120 height:16 triState:0 toolTip:"检测如果你想分配 Mental Ray 材质."
	
	spinner rndi "随机橱柜的数量" pos:[570,8] width:50 height:16 enabled:true range:[2,10,4] scale:1 fieldwidth:35 toolTip:"随机橱柜的数量."
	button randomCreate "随机生成橱柜" pos:[496,28] width:124 height:40 
	button allCreate "创建 全部" pos:[630,8] width:140 height:60 toolTip:"创建所有已经设置好的橱柜."
	
	progressBar pb1 "ProgressBar" pos:[8,76] width:762 height:8 color:(color 255 128 0)
	
fn randoms =
(	
	
	
	corpusMat()
	frontMat()
	worktopMat()
	handlesSatinedMetal()
	glassDoorMat()
	
	rndCabHands = random 0 1
	rndSinkType = random 0 1
	rndSinkNumber = random 1 2
	
	rndposx = 0
	--floor values
	rndTick =  units.decodeValue "1.8cm"
	rndDepth =  units.decodeValue "56cm"
	rndHeight =  units.decodeValue "82cm"
	bmask =  units.decodeValue "10cm"
	--wall values
	rndDepthw =  units.decodeValue "35cm"
	rndHeightw =  units.decodeValue "90cm"
	rndWallzpos =  units.decodeValue "160cm"
	
	for i = 1 to rndi.value do
	(
		
	pb1.value = 100.*i/rndi.value
	if rndi.value == 2 then 
		rndWidth = random (units.decodeValue "55cm") (units.decodeValue "120cm")
	else 
		rndWidth = random (units.decodeValue "30cm") (units.decodeValue "120cm")
		
	rndWidth = ceil rndWidth

	case of
	(
	(rndWidth <= units.decodeValue "40cm"): (rndFronts = 1; rndTopFronts = 1)
	(rndWidth > units.decodeValue "40cm" and rndWidth <= units.decodeValue "90cm"):(rndFronts = 2; rndTopFronts = 2)
	(rndWidth > units.decodeValue "90cm"): (rndFronts = random 2 4; rndTopFronts = random 2 4) 
	)
	
	if rndWidth <= units.decodeValue "60cm" then rndFrontsDrawers = random 1 5 else rndFrontsDrawers = random 2 4

	rndposx -= rndWidth
	rndFrontState = random 2 3
	rndShelf = random 1 3
	glassorfull = random 0 1

--rndFloorCreate 


	
			leftSide = box pos:[rndposx + (rndTick/2), 0, 0] length:rndDepth width:rndTick height:rndHeight
			leftSide.material =meditMaterials[2]
			leftSide.name = uniquename "FloorLeftSide"
		
			rightSide = box pos:[rndposx + rndWidth - (rndTick/2), 0, 0] length:rndDepth width:rndTick height:rndHeight
		    rightSide.material =meditMaterials[2]
			rightSide.name = uniquename "FloorRightSide" 
				
			bottomSide = box pos:[(rndposx + (rndWidth  - rndTick)/2 + rndTick  / 2), 0, bmask ] length:rndDepth  width:(rndWidth  - (rndTick *2)) height:rndTick 
		    bottomSide.material =meditMaterials[2]
			bottomSide.name = uniquename "FloorBottomSide"
				
			topSide = box pos:[(rndposx + (rndWidth  - rndTick)/2 + rndTick  / 2), 0, (rndHeight  - rndTick  )] length:rndDepth  width:(rndWidth  - (rndTick *2)) height:rndTick 
			topSide.material =meditMaterials[2]
			topSide.name = uniquename "FloorTopSide"
				
			bottomMask = box pos:[(rndposx + (rndWidth  - rndTick)/2 + rndTick  / 2),-((rndDepth  / 2) - rndTick ), 0] length:rndTick  width:(rndWidth  - rndTick  * 2) height:bmask 
			bottomMask.material =meditMaterials[2]
			bottomMask.name = uniquename "FloorBottomMask"
						
			backSide = box pos:[(rndposx + (rndWidth  - rndTick)/2 + rndTick  / 2),((rndDepth  / 2) - rndTick  / 4), (bmask  + rndTick )] length:(rndTick  / 4) width:(rndWidth  - rndTick  * 2) height:(rndHeight  - bmask  - rndTick  * 2)
			backSide.material =meditMaterials[2]
			backSide.name = uniquename "FloorBackSide"
--Police
				for p = 1 to rndShelf  do
					(
				posz = (rndHeight  - bmask ) / (rndShelf  + 1)
				posz = posz * p + bmask 
			    shelf = box pos:[(rndposx + (rndWidth  - rndTick )/2 + rndTick  / 2), 0, posz] length:rndDepth  width:(rndWidth  - (rndTick *2)) height:rndTick 
				shelf.material =meditMaterials[2]
				shelf.name = uniquename "FloorShelf"
				   )
					
--Frontovi		Vrata
					
					if rndFrontState == 2 do
					(			
							for v = 1 to rndFronts do
							(
								vrataWidth = 	rndWidth/rndFronts - doorSpace
								posx = ((rndposx + (vrataWidth * v) - (vrataWidth/2))) + v * doorABS
								posy = -((rndDepth/2)+(rndTick/2))
								posz = bmask  + doorZpos
								door = ChamferBox pos:[posx, posy, posz] Fillet_Segments:3 length:rndTick  width:vrataWidth  height:(rndHeight - bmask - doorSpace) Fillet:doorFillet
								door.material =meditMaterials[3]
								door.name = uniquename "FloorDoor"
								 
	
							)
					)			
	
--Frontovi Fijoke	
					
					if rndFrontState == 3 do
					(  
						for f = 1 to rndFrontsDrawers do
							(
								fijVisina = ((rndHeight - bmask - doorSpace) / rndFrontsDrawers )	
								posx = (rndposx + (rndWidth  - rndTick)/2 + rndTick  / 2)
								posy = -((rndDepth  / 2)+(rndTick  / 2))
								posz = fijVisina  * f - fijVisina  + bmask  + doorZpos
								drawer = ChamferBox pos:[posx, posy, posz] Fillet_Segments:3 length:rndTick  width:(rndWidth  - doorSpace) height:fijVisina  Fillet:doorFillet
								drawer.material =meditMaterials[3]
								drawer.name = uniquename "FloorDrawer"
							)	
					)
--Cabinet Handles
					
		--Square Handles
		if rndCabHands == 0 do 
		(
			if rndFrontState == 2 do
			(
				for v = 1 to rndFronts do
				(  
					vrataWidth = 	(rndWidth  / rndFronts )
					
					handleWidth = vrataWidth/2
					posx = ((rndposx + (vrataWidth  * v) - (vrataWidth  / 2))) + v * doorABS
					posy = -(rndDepth  / 2 + rndTick)
					if rndHeight >= units.decodeValue "120cm" then posz = rndHeight/2 else posz = rndHeight - handlesPos
					
					cabDoorHandle = Rectangle pos:[posx, posy, posz] Length:handleLength Width:handleWidth Render_renderable:true Render_displayRenderMesh:true Render_displayRenderSettings:true Render_rectangular:true Render_length:handleRenderHight Render_Width:handleRenderWidth
					cabDoorHandle.material =meditMaterials[1]
					cabDoorHandle.name = uniquename "HandleFloorDoor"
						--rotate cabhandle (eulerangles 0 90 0)	
				)
			)
			if rndFrontState == 3 do
			(
						for f = 1 to rndFrontsDrawers do
							(   
								vrataWidth = 	(rndWidth  / 2 )
								
								handleWidth = vrataWidth/2
								fijVisina = ((rndHeight  - bmask  - doorSpace) / rndFrontsDrawers  )	
								posx = rndposx + (rndWidth  / 2 )
								posy = -(rndDepth  / 2 + rndTick)
								posz = fijVisina  * f - handlesPos  + bmask  + doorZpos
								
								cabDrawerHandle = Rectangle pos:[posx, posy, posz] Length:handleLength Width:handleWidth Render_renderable:true Render_displayRenderMesh:true Render_displayRenderSettings:true Render_rectangular:true Render_length:handleRenderHight Render_Width:handleRenderWidth
								cabDrawerHandle.material =meditMaterials[1]
								cabDrawerHandle.name = uniquename "HandleDrawer"
									--rotate cabhandle (eulerangles 0 90 0)		
							)	
			)
		)
		--Round Handles
		if rndCabHands == 1 do 
		(
			if rndFrontState == 2 do
			(
				for v = 1 to rndFronts do
				(  
					vrataWidth = 	(rndWidth  / rndFronts )
					handleWidth = vrataWidth/2
					posx = ((rndposx + (vrataWidth  * v) - (vrataWidth  / 2))) + v * doorABS
					posy = -(rndDepth  / 2 + rndTick)
					if rndHeight >= units.decodeValue "120cm" then posz = rndHeight/2 else posz = rndHeight - handlesPos
						
					cabDoorHandle = Rectangle pos:[posx, posy, posz] Length:handleLength Width:handleWidth Corner_Radius:handleCornerRad Render_renderable:true Render_displayRenderMesh:true Render_displayRenderSettings:true Render_rectangular:false Render_thickness:handleRenderRadius Render_sides:24
					cabDoorHandle.material =meditMaterials[1]
					cabDoorHandle.name = uniquename "HandleFloorDoor"
						--rotate cabhandle (eulerangles 0 90 0)	
				)
			)
			if rndFrontState == 3 do
			(
						for f = 1 to rndFrontsDrawers do
							(   
								vrataWidth = 	(rndWidth  / 2 )
								
								handleWidth = vrataWidth/2
								fijVisina = ((rndHeight  - bmask  - doorSpace) / rndFrontsDrawers)	
								posx = rndposx + (rndWidth  / 2)
								posy = -(rndDepth  / 2 + rndTick)
								posz = fijVisina  * f - handlesPos  + bmask  + doorZpos
								cabDrawerHandle = Rectangle pos:[posx, posy, posz] Length:handleLength Width:handleWidth Corner_Radius:handleCornerRad Render_renderable:true Render_displayRenderMesh:true Render_displayRenderSettings:true Render_rectangular:false Render_thickness:handleRenderRadius Render_sides:24
								cabDrawerHandle.material =meditMaterials[1]
								cabDrawerHandle.name = uniquename "HandleDrawer"
									--rotate cabhandle (eulerangles 0 90 0)		
							)	
			)
		)
				
					
					
					
-- Group Cabinets one by one	
	
select (for o in objects where isGroupMember != true collect o)
		sel = getCurrentSelection()
		for i in sel do
		(
			deselect $FloorCabinet*
			deselect $WallCabinet*
			 if $Sink* != undefined do
				deselect $Sink* 
			 if $WorkTop* != undefined do
				deselect $WorkTop* 
			
		)			
	group selection name:(uniquename "FloorCabinet")
					
					
							
--Random Top Cabinets	


			
		
			leftSidew = box pos:[rndposx + (rndTick/2), (rndDepth  / 2) - (rndDepthw/2), rndWallzpos] length:rndDepthw width:rndTick height:rndHeightw
			leftSidew.material =meditMaterials[2]
			leftSidew.name = uniquename "WallLeftSide"
		
			rightSidew = box pos:[rndposx + rndWidth - (rndTick/2), (rndDepth  / 2) - (rndDepthw/2), rndWallzpos] length:rndDepthw width:rndTick height:rndHeightw
		    rightSidew.material =meditMaterials[2]
			rightSidew.name = uniquename "WallRightSide"
				
			bottomSidew = box pos:[(rndposx + (rndWidth  - rndTick)/2 + rndTick  / 2), (rndDepth  / 2) - (rndDepthw/2), rndWallzpos] length:rndDepthw  width:(rndWidth  - (rndTick *2)) height:rndTick 
		    bottomSidew.material =meditMaterials[2]
			bottomSidew.name = uniquename "WallBottomSide"
				
			topSidew = box pos:[(rndposx + (rndWidth  - rndTick)/2 + rndTick  / 2), (rndDepth  / 2) - (rndDepthw/2), (rndHeightw  - rndTick + rndWallzpos )] length:rndDepthw  width:(rndWidth  - (rndTick *2)) height:rndTick 
			topSidew.material =meditMaterials[2]
			topSidew.name = uniquename "WallTopSide"
				
			backSidew = box pos:[(rndposx + (rndWidth  - rndTick)/2 + rndTick  / 2),((rndDepth  / 2) - (rndDepthw/2) + (rndDepthw  / 2) - rndTick  / 4),  rndTick + rndWallzpos] length:(rndTick  / 4) width:(rndWidth  - rndTick  * 2) height:(rndHeightw  - rndTick  * 2)
			backSidew.material =meditMaterials[2]
			backSidew.name = uniquename "WallBackSide"
	--Police
				for p = 1 to rndShelf  do
					(
						posz = (rndHeightw) / (rndShelf + 1)
						posz = posz * p
						posz += rndWallzpos
						shelfw = box pos:[(rndposx + (rndWidth  - rndTick )/2 + rndTick  / 2), (rndDepth  / 2) - (rndDepthw/2), posz] length:rndDepthw  width:(rndWidth  - (rndTick *2)) height:rndTick 
						shelfw.material =meditMaterials[2]
						shelfw.name = uniquename "WallShelf"
				   )
					
	--Frontovi		Vrata
					
	for v = 1 to rndTopFronts do
			(
				if i == 3 then
				(
					--Glass Doors				
				doorWidth = rndWidth/rndTopFronts - doorSpace
				doorHeight = rndHeightw - doorSpace
				debljinaPanela = rndTick
				doorSir = units.decodeValue "8cm"
				
				posx = rndposx + doorWidth * v - doorWidth + doorSir / 2 + v * doorABS
				posy = (rndDepth / 2) - (rndDepthw/2)-((rndDepthw / 2)+(rndTick / 2))
				posz = rndWallzpos + doorZpos
				
				left = ChamferBox pos:[posx, posy, posz] Fillet_Segments:3 length:debljinaPanela  width:doorSir  height:doorHeight Fillet:doorFillet
				left.material =meditMaterials[3]
				left.name = uniquename "GlassFrameLeft"
				
				posx = rndposx + doorWidth * v - doorSir / 2 + v * doorABS
				right = ChamferBox pos:[posx, posy, posz] Fillet_Segments:3 length:debljinaPanela  width:doorSir  height:doorHeight Fillet:doorFillet
				right.material =meditMaterials[3]
				right.name = uniquename "GlassFrameRight"
					
				posx = ((rndposx + (doorWidth * v) - (doorWidth / 2))) + v * doorABS
				posz = rndWallzpos + doorZpos + doorHeight - doorSir	
				top = ChamferBox pos:[posx, posy, posz] Fillet_Segments:3 length:debljinaPanela  width:(doorWidth - doorSir*2)  height:doorSir Fillet:doorFillet
				top.material =meditMaterials[3]
				top.name = uniquename "GlassFrameTop"
					
				posz = rndWallzpos + doorZpos 
				bott = ChamferBox pos:[posx, posy, posz] Fillet_Segments:3 length:debljinaPanela  width:(doorWidth - doorSir*2 )  height:doorSir Fillet:doorFillet
				bott.material =meditMaterials[3]
				bott.name = uniquename "GlassFrameBottom"
				
				
				posz =rndWallzpos + doorZpos + doorSir
				glassWidth = doorWidth-doorSir*2
				glassTick=doorABS
				glassHeight = doorHeight-doorSir*2
				GlassofDoor = Box pos:[posx, posy, posz] width:glassWidth  length:glassTick height:glassHeight
				GlassofDoor.material =meditMaterials[8]
				GlassofDoor.name = uniquename "GlassFrameDoorGlass"
					
				
				)else(
				vrataWidthw = ((rndWidth)/rndTopFronts)  - doorSpace
				posx = ((rndposx + (vrataWidthw * v) - (vrataWidthw / 2))) + v * doorABS
				posy = (rndDepth / 2) - (rndDepthw/2)-((rndDepthw / 2)+(rndTick / 2))
				posz =rndWallzpos + doorZpos
				doorw = ChamferBox pos:[posx, posy, posz] Fillet_Segments:3 length:rndTick  width:vrataWidthw  height:(rndHeightw  - doorSpace) Fillet:doorFillet
				doorw.material =meditMaterials[3]
				doorw.name = uniquename "WallDoor"
				)
				
			)
								
--Cabinet Handles
					

		--Square Handles
	if rndCabHands == 0 do  
		(
			for v = 1 to rndTopFronts do
				(  vrataWidthw = rndWidth/rndTopFronts
					
					handleWidthw = vrataWidthw/2
					posx = ((rndposx + (vrataWidthw  * v) - (vrataWidthw  / 2))) + v * doorABS
					posy = -(rndDepthw  / 2 + rndTick) + (rndDepth  / 2) - (rndDepthw/2)
						
					posz = rndWallzpos + handlesPos
					
					cabDoorHandlew = Rectangle pos:[posx, posy, posz] Length:handleLength Width:handleWidthw Render_renderable:true Render_displayRenderMesh:true Render_displayRenderSettings:true Render_rectangular:true Render_length:handleRenderHight Render_Width:handleRenderWidth
					cabDoorHandlew.material =meditMaterials[1]
					cabDoorHandlew.name = uniquename "HandleWallDoor"
						--rotate cabhandle (eulerangles 0 90 0)	
				)
			
		)
		--Round Handles
		if rndCabHands == 1 do  
		(
			for v = 1 to rndTopFronts do
				(  vrataWidthw = 	(rndWidth  / rndTopFronts )
					
					handleWidthw = vrataWidthw/2
					posx = ((rndposx + (vrataWidthw  * v) - (vrataWidthw  / 2))) + v * doorABS
					posy = -(rndDepthw  / 2 + rndTick) + (rndDepth  / 2) - (rndDepthw/2)
					posz = rndWallzpos + handlesPos
					
					cabDoorHandlew = Rectangle pos:[posx, posy, posz] Length:handleLength Width:handleWidthw Corner_Radius:handleCornerRad Render_renderable:true Render_displayRenderMesh:true Render_displayRenderSettings:true Render_rectangular:false Render_thickness:handleRenderRadius Render_sides:24
					cabDoorHandlew.material =meditMaterials[1]
					cabDoorHandlew.name = uniquename "HandleWallDoor"
						--rotate cabhandle (eulerangles 0 90 0)	
				)
			
		)
		
			
	
					
-- Group Cabinets one by one	
select (for o in objects where isGroupMember != true collect o)
		sel = getCurrentSelection()
		for i in sel do
		(
			deselect $WallCabinet*
			deselect $FloorCabinet*
			if $Sink* != undefined do
				deselect $Sink* 
			 if $WorkTop* != undefined do
				deselect $WorkTop* 
		)			
	group selection name: (uniquename "WallCabinet")
	
)		
pb1.value = 0	
--randomworktop
	
	wwidth = ((abs rndposx)+units.decodeValue "20cm")
	posx = 	rndposx/2
	worktopBox = ChamferBox pos:[posx, units.decodeValue "-2cm", units.decodeValue "82cm"] Fillet_Segments:6 length:(units.decodeValue "62cm")  width:wwidth  height:(units.decodeValue "4cm") Fillet:(units.decodeValue "0.8cm")
	worktopBox.name = uniquename "WorkTop"
		
	slice_1 = sliceModifier  Slice_Type:3	
	addModifier	worktopBox slice_1
	slice_1.Slice_Plane.position=[0,0,rndposx/2]
	slice_1.Slice_Plane.rotation = eulertoquat (eulerAngles 0 90 0)
	
	slice_2 = sliceModifier  Slice_Type:2	
	addModifier	worktopBox slice_2
	slice_2.Slice_Plane.position=[0,0,-(rndposx/2)]
	slice_2.Slice_Plane.rotation = eulertoquat (eulerAngles 0 90 0)	
	
	addModifier	worktopBox (cap_holes())	
	
	slice_3 = sliceModifier  Slice_Type:2	
	addModifier	worktopBox slice_3
	slice_3.Slice_Plane.position=[0,0,units.decodeValue "30cm"]
	slice_3.Slice_Plane.rotation = eulertoquat (eulerAngles 90 0 0)	
		
	addModifier	worktopBox (cap_holes())		
		
	maxOps.CollapseNode worktopBox on
	addModifier	worktopBox (uvwmap maptype:4)
	
	worktopBox.material=meditMaterials[7]

--randomsink	
for i = 1 to rndSinkNumber do
			(
			wires = SplineShape pos:[0, 0, 0]
			addNewSpline wires
			addKnot wires 1 #corner #curve [units.decodeValue "-26cm", 0, units.decodeValue "16cm"]
			addKnot wires 1 #bezier #curve [units.decodeValue "-21cm", 0, units.decodeValue "16cm"] [units.decodeValue "-22cm", 0, units.decodeValue "17cm"][units.decodeValue "-20cm", 0, units.decodeValue "15cm"]
			addKnot wires 1 #bezier #curve [units.decodeValue "-19cm", 0, units.decodeValue "1cm"] [units.decodeValue "-20cm", 0, units.decodeValue "1cm"] [units.decodeValue "-19cm", 0, units.decodeValue "-1cm"]
			addKnot wires 1 #bezierCorner  #curve [0, 0, 0][units.decodeValue "-20cm", 0, 0][0, 0, 0]			
			
			updateShape wires
			wires.name = uniquename "Sink"
			lat = lathe()
			addModifier wires (lat)
			if rndSinkType == 1 then
			(
			lat.segments = 48
			)else
			(
			lat.segments = 4
			)
			lat.weldCore = true
			lat.axis = MatrixFromNormal [0,0,1]

			sh = Shell()
			addModifier wires (sh)
			sh.outerAmount = doorSpace

			maxOps.CollapseNode wires on
			convertTo wires PolyMeshObject
			if rndSinkType == 1 then wires.surfSubdivide = true

			CenterPivot wires
			handlesSatinedMetal()
			wires.material=meditMaterials[1]
			

				wires.transform = worktopBox.transform	
			
				if i == 1 then	wires.position = wires.position - [units.decodeValue "27cm", 0,units.decodeValue "3.7cm"]
				else wires.position = wires.position - [units.decodeValue "-27cm", 0,units.decodeValue "3.7cm"]
				
				select(for g in geometry as array collect g)
				deselect $Sink*
				
				gg = getCurrentSelection()
				
				if rndSinkType == 0 then
				(
				rot_wires = eulerangles 0 0 45
				rotate wires rot_wires
				scale wires [1.3,1.3,1]
				cilin = Cylinder pos:[0,0,0] heightsegs:5 capsegs:1 sides:4 height:(units.decodeValue "30cm") radius:(units.decodeValue "22cm") 
				rotate cilin rot_wires
				scale cilin [1.3,1.3,1]
					)else 
				(
					cilin = Cylinder pos:[0,0,0] heightsegs:5 capsegs:1 sides:18 height:(units.decodeValue "30cm") radius:(units.decodeValue "22cm") 
				)
				
				for o in gg do 
					(
						cil = copy cilin
						cil.position = wires.position - [0, 0, units.decodeValue "12cm"]
						if intersects o cil  == true do
						(
						ProBoolean.createBooleanObject o cil 2 0 0
							convertTo o Editable_Poly
						)
						--delete cilindar
						if isDeleted cil != true do
						delete cil
					)
				--delete main cilindar
				if isDeleted cilin != true do
						delete cilin				
			)

)	
	

		--Rucke		
	fn handlesfn =
	(
		if handles.triState == 1 do
		(
		squareHandles.enabled = true
		roundHandles.enabled = true
		)
		if handles.triState == 0 do
		(
		squareHandles.enabled = false
		roundHandles.enabled = false
		)
	
	)	
	--Sudopera
		fn sinkfn =
	(
		if sink.triState == 1 do
		(
		worktop.triState = 1
		worktopTick.enabled = true	
		sinkRound.enabled = true
		sinkSquare.enabled = true
		sinkNo.enabled = true
		)
		if sink.triState == 0 do
		(
		sinkRound.enabled = false
		sinkSquare.enabled = false
		sinkNo.enabled = false
		)
	
	)
	--radna ploca
	fn wtickness =
	(
		if worktop.triState == 1 do
		(
		worktopTick.enabled = true
		)
		if worktop.triState == 0 do
		(
		sink.triState = 0	
		sinkfn()	
		worktopTick.enabled = false
		)
	)
	--enable disable checkboxes in general
	
	on worktop changed theState do wtickness()
		
	on handles changed theState do handlesfn()
		
	on squareHandles changed theState do
	(
		if squareHandles.triState == 1 then
		(
			roundHandles.triState = 0
		) else roundHandles.triState = 1
		
	)
	on roundHandles changed theState do
	(
		if roundHandles.triState == 1 then 
		(
			squareHandles.triState = 0	
		) else squareHandles.triState = 1
	)
	
	--sudopera
	on sink changed theState do sinkfn()
	
	on sinkSquare changed theState do
	(
		if sinkSquare.triState == 1 then
		(
			sinkRound.triState = 0
		) else sinkRound.triState = 1
		
	)
	on sinkRound changed theState do
	(
		if sinkRound.triState == 1 then 
		(
			sinkSquare.triState = 0	
		) else sinkSquare.triState = 1
	)
	

	
	on allCreate pressed do
	(
	undo off
		(
		floorUnits.createCab()	
		floorUnits.createWorkTop()
		wallUnits.createwCab()
		deselect $*
		max views redraw
		)
	)
	on randomCreate pressed do
	(
		
	undo off
		(		
		randoms()
		deselect $*	
		max views redraw	
		)	
	)
	on whatCabs selected i do
	(
		
		if whatCabs.selection == 1 then 
		(
		for roll in theFloater.rollouts do removeRollout roll theFloater
		addRollout general theFloater rolledUp: false
		whatCabs.selection = i
		addRollout floorUnits theFloater rolledUp: false
-- 		addRollout help theFloater rolledUp: true
-- 		addRollout aboutgoruss theFloater rolledUp: true
		)
		if whatCabs.selection == 2 then 
		(
		for roll in theFloater.rollouts do removeRollout roll theFloater
		addRollout general theFloater rolledUp: false
		whatCabs.selection = i
		worktop.enabled = false
		sink.enabled = false
		addRollout wallUnits theFloater rolledUp: false
-- 		addRollout help theFloater rolledUp: true
-- 		addRollout aboutgoruss theFloater rolledUp: true
		)
		if whatCabs.selection == 3 then 
		(
		for roll in theFloater.rollouts do removeRollout roll theFloater
		addRollout general theFloater rolledUp: false	
		whatCabs.selection = i
		addRollout floorUnits theFloater rolledUp: false
		addRollout wallUnits theFloater rolledUp: false
-- 		addRollout help theFloater rolledUp: true
-- 		addRollout aboutgoruss theFloater rolledUp: true	
		)
		
	)

)

rollout floorUnits "橱柜的地面部分" width:760 height:400
(
	label lab "你要横向创建多少个?" pos:[8,12] width:104 height:16
	dropdownList howCabs "" pos:[120,8] width:40 height:21 items:#("1", "2", "3", "4", "5", "6") selection:1 
	checkbutton ckb1 "1" pos:[165,8] width:24 height:24 enabled:false checked:true  
	button btnCreate "创建" pos:[690,8] width:80 height:26
	
	GroupBox grp_1 "地面部分 1" pos:[8,40] width:120 height:264
	spinner cabWidth_1 "宽度" pos:[56,64] type:#worldunits width:68 height:16 range:globWidth scale:0.1 fieldwidth:55 toolTip:"柜子宽度."
	spinner cabHeight_1 "高度" pos:[56,84] type:#worldunits width:68 height:16 range:globHeight scale:0.1 fieldwidth:55 toolTip:"柜子高度."
	spinner cabDepth_1 "深度" pos:[56,104] type:#worldunits width:68 height:16 range:globDepth scale:0.1 fieldwidth:55 toolTip:"柜子深度."
	spinner cabTick_1 "厚度" pos:[56,124] type:#worldunits width:68 height:16 range:globTick scale:0.1 fieldwidth:55 toolTip:"木板的厚度."
	spinner cabCokla_1 "踢脚" pos:[56,144] type:#worldunits width:68 height:16 range:globMask scale:0.1 fieldwidth:55 toolTip:"踢脚挡板高度."
	spinner cabPolice_1 "隔板" pos:[56,164] width:68 height:16 range:[0,5,1] scale:1 fieldwidth:55 toolTip:"隔板数量."
	
	radiobuttons rdoFrontovi_1 "柜门参数" pos:[16,184] width:62 height:62 labels:#("开放式", "有门的", "有抽屉的") default:0 columns:1 
	radiobuttons policeHorVer_1 "" pos:[86,200] width:31 height:32 enabled:true labels:#("竖","横") default:2 columns:1 toolTip:"隔板创建方式  横向/竖向"
	spinner cabVrata_1 "门的数量" pos:[16,248] width:100 height:16 enabled:false range:[0,4,2] scale:1 fieldwidth:35 toolTip:"门的数量."
	spinner cabFijoke_1 "抽屉数量" pos:[16,268] width:100 height:16 enabled:false range:[0,6,4] scale:1 fieldwidth:35 toolTip:"抽屉的数量."
	
	GroupBox grp_2 "地面部分 2" pos:[136,40] width:120 height:264 enabled:false
	spinner cabWidth_2 "宽度" pos:[184,64] width:68 height:16 type:#worldunits enabled:false range:globWidth scale:0.1 fieldwidth:55 toolTip:"柜子宽度."
	spinner cabHeight_2 "高度" pos:[184,84] width:68 height:16 type:#worldunits enabled:false range:globHeight scale:0.1 fieldwidth:55 toolTip:"柜子高度."
	spinner cabDepth_2 "深度" pos:[184,104] width:68 height:16 type:#worldunits enabled:false range:globDepth scale:0.1 fieldwidth:55 toolTip:"柜子深度."
	spinner cabTick_2 "厚度" pos:[184,124] width:68 height:16 type:#worldunits enabled:false range:globTick scale:0.1 fieldwidth:55 toolTip:"木板的厚度."
	spinner cabCokla_2 "踢脚" pos:[184,144] width:68 height:16 type:#worldunits enabled:false range:globMask scale:0.1 fieldwidth:55 toolTip:"踢脚挡板高度."
	spinner cabPolice_2 "隔板" pos:[184,164] width:68 height:16 enabled:false range:[0,5,1] scale:1 fieldwidth:55 toolTip:"隔板数量."		
		
			
	radiobuttons rdoFrontovi_2 "柜门参数" pos:[144,184] width:62 height:62 enabled:false labels:#("开放式", "有门的", "有抽屉的") default:0 columns:1 
	radiobuttons policeHorVer_2 "" pos:[214,200] width:31 height:32 enabled:false labels:#("竖","横") default:2 columns:1 toolTip:"隔板创建方式  横向/竖向"
	spinner cabVrata_2 "门的数量" pos:[144,248] width:100 height:16 enabled:false range:[0,4,2] scale:1 fieldwidth:35 toolTip:"门的数量."
	spinner cabFijoke_2 "抽屉数量" pos:[144,268] width:100 height:16 enabled:false range:[0,6,4] scale:1 fieldwidth:35 toolTip:"抽屉的数量."
	
	
	GroupBox grp_3 "地面部分 3" pos:[264,40] width:120 height:264 enabled:false fieldwidth:35
	spinner cabWidth_3 "宽度" pos:[312,64] width:68 height:16 type:#worldunits enabled:false range:globWidth scale:0.1 fieldwidth:55 toolTip:"柜子宽度."
	spinner cabHeight_3 "高度" pos:[312,84] width:68 height:16 type:#worldunits enabled:false range:globHeight scale:0.1 fieldwidth:55 toolTip:"柜子高度."
	spinner cabDepth_3 "深度" pos:[312,104] width:68 height:16 type:#worldunits enabled:false range:globDepth scale:0.1 fieldwidth:55 toolTip:"柜子深度."
	spinner cabTick_3 "厚度" pos:[312,124] width:68 height:16 type:#worldunits enabled:false range:globTick scale:0.1 fieldwidth:55 toolTip:"木板的厚度."
	spinner cabCokla_3 "踢脚" pos:[312,144] width:68 height:16 type:#worldunits enabled:false range:globMask scale:0.1 fieldwidth:55 toolTip:"踢脚挡板高度."
	spinner cabPolice_3 "隔板" pos:[312,164] width:68 height:16 enabled:false range:[0,5,1] scale:1 fieldwidth:55 toolTip:"隔板数量."		
		
			
	radiobuttons rdoFrontovi_3 "柜门参数" pos:[272,184] width:62 height:62 enabled:false labels:#("开放式", "有门的", "有抽屉的") default:0 columns:1 
	radiobuttons policeHorVer_3 "" pos:[342,200] width:31 height:32 enabled:false labels:#("竖","横") default:2 columns:1 toolTip:"隔板创建方式  横向/竖向"
	spinner cabVrata_3 "门的数量" pos:[272,248] width:100 height:16 enabled:false range:[0,4,2] scale:1 fieldwidth:35 toolTip:"门的数量."
	spinner cabFijoke_3 "抽屉数量" pos:[272,268] width:100 height:16 enabled:false range:[0,6,4] scale:1 fieldwidth:35 toolTip:"抽屉的数量."
		
	GroupBox grp_4 "地面部分 4" pos:[392,40] width:120 height:264 enabled:false
	spinner cabWidth_4 "宽度" pos:[440,64] width:68 height:16 type:#worldunits enabled:false range:globWidth scale:0.1 fieldwidth:55 toolTip:"柜子宽度."
	spinner cabHeight_4 "高度" pos:[440,84] width:68 height:16 type:#worldunits enabled:false range:globHeight scale:0.1 fieldwidth:55 toolTip:"柜子高度."
	spinner cabDepth_4 "深度" pos:[440,104] width:68 height:16 type:#worldunits enabled:false range:globDepth scale:0.1 fieldwidth:55 toolTip:"柜子深度."
	spinner cabTick_4 "厚度" pos:[440,124] width:68 height:16 type:#worldunits enabled:false range:globTick scale:0.1 fieldwidth:55 toolTip:"木板的厚度."
	spinner cabCokla_4 "踢脚" pos:[440,144] width:68 height:16 type:#worldunits enabled:false range:globMask scale:0.1 fieldwidth:55 toolTip:"踢脚挡板高度."
	spinner cabPolice_4 "隔板" pos:[440,164] width:68 height:16 enabled:false range:[0,5,1] scale:1 fieldwidth:55 toolTip:"隔板数量."
	
	radiobuttons rdoFrontovi_4 "柜门参数" pos:[400,184] width:62 height:62 enabled:false labels:#("开放式", "有门的", "有抽屉的") default:0 columns:1 
	radiobuttons policeHorVer_4 "" pos:[470,200] width:31 height:32 enabled:false labels:#("竖","横") default:2 columns:1 toolTip:"隔板创建方式  横向/竖向"
	spinner cabVrata_4 "门的数量" pos:[400,248] width:100 height:16 enabled:false range:[0,4,2] scale:1 fieldwidth:35 toolTip:"门的数量."
	spinner cabFijoke_4 "抽屉数量" pos:[400,268] width:100 height:16 enabled:false range:[0,6,4] scale:1 fieldwidth:35 toolTip:"抽屉的数量."
		
	GroupBox grp_5 "地面部分 5" pos:[520,40] width:120 height:264 enabled:false
	spinner cabWidth_5 "宽度" pos:[568,64] width:68 height:16 type:#worldunits enabled:false range:globWidth scale:0.1 fieldwidth:55 toolTip:"柜子宽度."
	spinner cabHeight_5 "高度" pos:[568,84] width:68 height:16 type:#worldunits enabled:false range:globHeight scale:0.1 fieldwidth:55 toolTip:"柜子高度."
	spinner cabDepth_5 "深度" pos:[568,104] width:68 height:16 type:#worldunits enabled:false range:globDepth scale:0.1 fieldwidth:55 toolTip:"柜子深度."
	spinner cabTick_5 "厚度" pos:[568,124] width:68 height:16 type:#worldunits enabled:false range:globTick scale:0.1 fieldwidth:55 toolTip:"木板的厚度."
	spinner cabCokla_5 "踢脚" pos:[568,144] width:68 height:16 type:#worldunits enabled:false range:globMask scale:0.1 fieldwidth:55 toolTip:"踢脚挡板高度."
	spinner cabPolice_5 "隔板" pos:[568,164] width:68 height:16 enabled:false range:[0,5,1] scale:1 fieldwidth:55 toolTip:"隔板数量."
	
	radiobuttons rdoFrontovi_5 "柜门参数" pos:[528,184] width:62 height:62 enabled:false labels:#("开放式", "有门的", "有抽屉的") default:0 columns:1 
	radiobuttons policeHorVer_5 "" pos:[598,200] width:31 height:32 enabled:false labels:#("竖","横") default:2 columns:1 toolTip:"隔板创建方式  横向/竖向"
	spinner cabVrata_5 "门的数量" pos:[528,248] width:100 height:16 enabled:false range:[0,4,2] scale:1 fieldwidth:35 toolTip:"门的数量."
	spinner cabFijoke_5 "抽屉数量" pos:[528,268] width:100 height:16 enabled:false range:[0,6,4] scale:1 fieldwidth:35 fieldwidth:35 toolTip:"抽屉的数量."
	
	GroupBox grp_6 "地面部分 6" pos:[648,40] width:120 height:264 enabled:false
	spinner cabWidth_6 "宽度" pos:[696,64] width:68 height:16 type:#worldunits enabled:false range:globWidth scale:0.1 fieldwidth:55 toolTip:"柜子宽度."
	spinner cabHeight_6 "高度" pos:[696,84] width:68 height:16 type:#worldunits enabled:false range:globHeight scale:0.1 fieldwidth:55 toolTip:"柜子高度."
	spinner cabDepth_6 "深度" pos:[696,104] width:68 height:16 type:#worldunits enabled:false range:globDepth scale:0.1 fieldwidth:55 toolTip:"柜子深度."
	spinner cabTick_6 "厚度" pos:[696,124] width:68 height:16 type:#worldunits enabled:false range:globTick scale:0.1 fieldwidth:55 toolTip:"木板的厚度."
	spinner cabCokla_6 "踢脚" pos:[696,144] width:68 height:16 type:#worldunits enabled:false range:globMask scale:0.1 fieldwidth:55 toolTip:"踢脚挡板高度."
	spinner cabPolice_6 "隔板" pos:[696,164] width:68 height:16 enabled:false range:[0,5,1] scale:1 fieldwidth:55 toolTip:"隔板数量."
	
	radiobuttons rdoFrontovi_6 "柜门参数" pos:[656,184] width:62 height:62 enabled:false labels:#("开放式", "有门的", "有抽屉的") default:0 columns:1 
	radiobuttons policeHorVer_6 "" pos:[726,200] width:31 height:32 enabled:false labels:#("竖","横") default:2 columns:1 toolTip:"隔板创建方式  横向/竖向"
	spinner cabVrata_6 "门的数量" pos:[656,248] width:100 height:16 enabled:false range:[0,4,2] scale:1 fieldwidth:35 toolTip:"门的数量."
	spinner cabFijoke_6 "抽屉数量" pos:[656,268] width:100 height:16 enabled:false range:[0,6,4] scale:1 fieldwidth:35 toolTip:"抽屉的数量."
	
		
	local rstring = 1
	local collectVal, sirina, visina, dubina, debljinaPanela, cokla, polica, vrata, fijoke, worktopBox
	local grupe, sirine, visine, dubine, debljine, cokle, police, radiobutt, vratasp, fijokesp, policeHorVert
	
fn collectVal =
(
		 sirina = #(cabWidth_1.value, cabWidth_2.value, cabWidth_3.value, cabWidth_4.value, cabWidth_5.value, cabWidth_6.value)
		 visina = #(cabHeight_1.value, cabHeight_2.value, cabHeight_3.value, cabHeight_4.value, cabHeight_5.value, cabHeight_6.value)
		 dubina = #(cabDepth_1.value, cabDepth_2.value, cabDepth_3.value, cabDepth_4.value, cabDepth_5.value, cabDepth_6.value)
		 debljinaPanela = #(cabTick_1.value, cabTick_2.value, cabTick_3.value, cabTick_4.value, cabTick_5.value, cabTick_6.value)
		 cokla = #(cabCokla_1.value, cabCokla_2.value, cabCokla_3.value, cabCokla_4.value, cabCokla_5.value, cabCokla_6.value)
		 polica = #(cabPolice_1.value, cabPolice_2.value, cabPolice_3.value, cabPolice_4.value, cabPolice_5.value, cabPolice_6.value)
		 vrata = #(cabVrata_1.value, cabVrata_2.value, cabVrata_3.value, cabVrata_4.value, cabVrata_5.value, cabVrata_6.value)
		 fijoke = #(cabFijoke_1.value, cabFijoke_2.value, cabFijoke_3.value, cabFijoke_4.value, cabFijoke_5.value, cabFijoke_6.value)
)

fn collectUIelem =
(
		 grupe = #(grp_1, grp_2, grp_3, grp_4, grp_5, grp_6)
		 sirine = #(cabWidth_1, cabWidth_2, cabWidth_3, cabWidth_4, cabWidth_5, cabWidth_6)
		 visine = #(cabHeight_1, cabHeight_2, cabHeight_3, cabHeight_4, cabHeight_5, cabHeight_6)	
		 dubine =#(cabDepth_1, cabDepth_2, cabDepth_3, cabDepth_4, cabDepth_5, cabDepth_6)
		 debljine =#(cabTick_1, cabTick_2, cabTick_3, cabTick_4, cabTick_5, cabTick_6)
		 cokle = #(cabCokla_1, cabCokla_2, cabCokla_3, cabCokla_4, cabCokla_5, cabCokla_6)
		 police = #(cabPolice_1, cabPolice_2, cabPolice_3, cabPolice_4, cabPolice_5, cabPolice_6)
		 radiobutt = #(rdoFrontovi_1, rdoFrontovi_2, rdoFrontovi_3, rdoFrontovi_4, rdoFrontovi_5, rdoFrontovi_6)
		 vratasp = #(cabVrata_1, cabVrata_2, cabVrata_3, cabVrata_4, cabVrata_5, cabVrata_6)
		 fijokesp = #(cabFijoke_1, cabFijoke_2, cabFijoke_3, cabFijoke_4, cabFijoke_5, cabFijoke_6)
		 policeHorVert = #(policeHorVer_1, policeHorVer_2, policeHorVer_3, policeHorVer_4, policeHorVer_5, policeHorVer_6)
)

--Worktop
fn createWorkTop = 
(   
	worktopMat()
	curSir = units.decodeValue "20cm"
	if general.worktop.triState == 1 do
	(
		for i = 1 to howCabs.selection do
		(
			curSir += sirina[i]
		)
		
	posx = 	curSir/2 - units.decodeValue "10cm"
			
	worktopBox = ChamferBox pos:[posx, units.decodeValue "-2cm", cabHeight_1.value] Fillet_Segments:6 length:(cabDepth_1.value + units.decodeValue "6cm")  width:curSir  height:general.worktopTick.value Fillet:(units.decodeValue "0.8cm")
	worktopBox.name = uniquename "WorkTop"
		
	slice_1 = sliceModifier  Slice_Type:2	
	addModifier	worktopBox slice_1
	slice_1.Slice_Plane.position=[0,0,curSir/2 - units.decodeValue "10cm"]
	slice_1.Slice_Plane.rotation = eulertoquat (eulerAngles 0 90 0)
	
	slice_2 = sliceModifier  Slice_Type:3	
	addModifier	worktopBox slice_2
	slice_2.Slice_Plane.position=[0,0,-(curSir/2 - units.decodeValue "10cm")]
	slice_2.Slice_Plane.rotation = eulertoquat (eulerAngles 0 90 0)	
	
	addModifier	worktopBox (cap_holes())	
	
	slice_3 = sliceModifier  Slice_Type:2	
	addModifier	worktopBox slice_3
	slice_3.Slice_Plane.position=[0,0,cabDepth_1.value/2+units.decodeValue "2cm"]
	slice_3.Slice_Plane.rotation = eulertoquat (eulerAngles 90 0 0)	
		
	addModifier	worktopBox (cap_holes())		
		
	maxOps.CollapseNode worktopBox on
	addModifier	worktopBox (uvwmap maptype:4)
	
	worktopBox.material=meditMaterials[7]
	)
	
--create sink
querystr = "Total width of cabinets is smaller then total width of sinks. Please set width values of cabinets to be greater of " + (units.decodeValue "105cm") as string + " or set number of sinks to 1.\n\nDo you want to continue?"
querystr01 = "Total width of cabinets is smaller then total width of sink. Please set width values of cabinets to be greater of " + (units.decodeValue "53cm") as string + ". \n\nDo you want to continue?"	

if general.worktop.triState == 1 do
	(
		if general.sink.triState == 1 do
		(
			if (curSir - units.decodeValue "20cm")	< units.decodeValue "105cm" and general.sinkNo.value == 2 then
				qb = queryBox querystr  title:"Warning" 
			if (curSir - units.decodeValue "20cm")	< units.decodeValue "53cm" and general.sinkNo.value == 1 then
				qb01 = queryBox querystr01  title:"Warning"
			
				if qb == true or qb == undefined then
					if qb01 == true or qb01 == undefined then
			
						for i = 1 to general.sinkNo.value do
						(
						wires = SplineShape pos:[0, 0, 0]
						addNewSpline wires
						addKnot wires 1 #corner #curve [units.decodeValue "-26cm", 0, units.decodeValue "16cm"]
						addKnot wires 1 #bezier #curve [units.decodeValue "-21cm", 0, units.decodeValue "16cm"] [units.decodeValue "-22cm", 0, units.decodeValue "17cm"][units.decodeValue "-20cm", 0, units.decodeValue "15cm"]
						addKnot wires 1 #bezier #curve [units.decodeValue "-19cm", 0, units.decodeValue "1cm"] [units.decodeValue "-20cm", 0, units.decodeValue "1cm"] [units.decodeValue "-19cm", 0, units.decodeValue "-1cm"]
						addKnot wires 1 #bezierCorner  #curve [0, 0, 0] [units.decodeValue "-20cm", 0, 0] [0, 0, 0]			
						
						updateShape wires
						wires.name = uniquename "Sink"
						lat = lathe()
						addModifier wires (lat)
						if general.sinkRound.triState == 1 then
						(
						lat.segments = 48
						)else
						(
						lat.segments = 4
						)
						lat.weldCore = true
						lat.axis = MatrixFromNormal [0,0,1]

						sh = Shell()
						addModifier wires (sh)
						sh.outerAmount = doorSpace

						maxOps.CollapseNode wires on
						convertTo wires PolyMeshObject
						if general.sinkRound.triState == 1 then wires.surfSubdivide = true
						
						CenterPivot wires
						handlesSatinedMetal()
						wires.material=meditMaterials[1]
						
						wires.transform = worktopBox.transform
						
						if general.sinkNo.value == 1 then	wires.position = wires.position - [0, 0,(-general.worktopTick.value+units.decodeValue "7.6cm")]
						else
							if i == 1 then	wires.position = wires.position - [units.decodeValue "26cm", 0,(-general.worktopTick.value+units.decodeValue "7.6cm")]
							else wires.position = wires.position - [units.decodeValue "-26cm", 0,(-general.worktopTick.value+units.decodeValue "7.6cm")]
							
							select(for g in geometry as array collect g)
							deselect $Sink*
							
							gg = getCurrentSelection()
							
							if general.sinkRound.triState == 0 then
							(
							rot_wires = eulerangles 0 0 45
							rotate wires rot_wires
							scale wires [1.3,1.3,1]
							cilin = Cylinder pos:[0,0,0] heightsegs:5 capsegs:1 sides:4 height:(units.decodeValue "30cm") radius:(units.decodeValue "22cm") 
							rotate cilin rot_wires
							scale cilin [1.3,1.3,1]
								)else 
							(
								cilin = Cylinder pos:[0,0,0] heightsegs:5 capsegs:1 sides:18 height:(units.decodeValue "30cm") radius:(units.decodeValue "22cm") 
							)
							
							for o in gg do 
								(
									cil = copy cilin
									cil.position = wires.position - [0, 0, units.decodeValue "12cm"]
									if intersects o cil  == true do
									(
									ProBoolean.createBooleanObject o cil 2 0 0
										convertTo o Editable_Poly
									)
									--delete cilindar
									if isDeleted cil != true do
									delete cil
								)
							--delete main cilindar
							if isDeleted cilin != true do
									delete cilin				
			)
			)
	)
		
)
--Doors and Drawers	
fn	frontState = 
	(
	collectUIelem()
	for i = 1 to radiobutt.count do	
		case radiobutt[i].state of (
			
		1: spinJedan = 
			(
				vratasp[i].enabled = false 
				fijokesp[i].enabled = false
			)
		2: spinDva = 
			(	
				vratasp[i].enabled = true 
				fijokesp[i].enabled = false
			)
		3: spinTri = 
			(	
				vratasp[i].enabled = false 
				fijokesp[i].enabled = true
			)			
		)
	)
	

--Create Cabinets	
fn createCab = 
(
	if general.whatCabs.selection == 1 or general.whatCabs.selection == 3 do
	(
	corpusMat()
	frontMat()
	handlesSatinedMetal()
	collectVal()
	collectUIelem()
	general.handlesfn()
--Korpusi
	cabposx = 0
	for i = 1 to rstring do
	(
		general.pb1.value = 100.*i/rstring
		
		
			leftSide = box pos:[cabposx + (debljinaPanela[i]/2), 0, 0] length:dubina[i] width:debljinaPanela[i] height:visina[i]
			leftSide.material =meditMaterials[2]
			leftSide.name = uniquename "FloorLeftSide"
		
			rightSide = box pos:[cabposx + sirina[i] - (debljinaPanela[i]/2), 0, 0] length:dubina[i] width:debljinaPanela[i] height:visina[i]
		    rightSide.material =meditMaterials[2]
			rightSide.name = uniquename "FloorRightSide"
				
			bottomSide = box pos:[(cabposx + (sirina[i]  - debljinaPanela[i])/2 + debljinaPanela[i]  / 2), 0, cokla[i] ] length:dubina[i]  width:(sirina[i]  - (debljinaPanela[i] *2)) height:debljinaPanela[i] 
		    bottomSide.material =meditMaterials[2]
			bottomSide.name = uniquename "FloorBottomSide" 
				
			topSide = box pos:[(cabposx + (sirina[i]  - debljinaPanela[i])/2 + debljinaPanela[i]  / 2), 0, (visina[i]  - debljinaPanela[i]  )] length:dubina[i]  width:(sirina[i]  - (debljinaPanela[i] *2)) height:debljinaPanela[i] 
			topSide.material =meditMaterials[2]
			topSide.name = uniquename "FloorTopSide" 
				
			if cokla[i] != 0 then 
			(				
			bottomMask = box pos:[(cabposx + (sirina[i]  - debljinaPanela[i])/2 + debljinaPanela[i]  / 2),-((dubina[i]  / 2) - debljinaPanela[i] ), 0] length:debljinaPanela[i]  width:(sirina[i]  - debljinaPanela[i]  * 2) height:cokla[i] 
			bottomMask.material =meditMaterials[2]
			bottomMask.name = uniquename "FloorBottomMask"
			)else()	
			
			backSide = box pos:[(cabposx + (sirina[i]  - debljinaPanela[i])/2 + debljinaPanela[i]  / 2),((dubina[i]  / 2) - debljinaPanela[i]  / 4), (cokla[i]  + debljinaPanela[i] )] length:(debljinaPanela[i]  / 4) width:(sirina[i]  - debljinaPanela[i]  * 2) height:(visina[i]  - cokla[i]  - debljinaPanela[i]  * 2)
			backSide.material =meditMaterials[2]
			backSide.name = uniquename "FloorBackSide"	
--Police
					if polica[i] != 0 then --dont create if zero
					(
					if policeHorVert[i].state == 2 then	
					(				
					for p = 1 to polica[i]  do
							(
								posx = (cabposx + (sirina[i]  - debljinaPanela[i] )/2 + debljinaPanela[i]  / 2)
								posz = (visina[i]  - cokla[i] ) / (polica[i]  + 1)
								posz = posz * p + cokla[i]  - debljinaPanela[i] / 2
								shelf = box pos:[posx, 0, posz] length:dubina[i]  width:(sirina[i]  - (debljinaPanela[i] *2)) height:debljinaPanela[i] 
								shelf.material =meditMaterials[2]
								shelf.name = uniquename "FloorShelf"
						   )
					)	   
					else
					(
							for p = 1 to polica[i]  do
							(
								posx = sirina[i] / (polica[i]  + 1)
								posx = cabposx + posx * p 
								posz = debljinaPanela[i] + cokla[i] 
								shelf = box pos:[posx, 0, posz] length:dubina[i]  width:debljinaPanela[i]  height:(visina[i]  - (debljinaPanela[i] *2) - cokla[i])
								shelf.material =meditMaterials[2]
								shelf.name = uniquename "FloorShelf"
						   )
					   )	
					)		   
--Frontovi		Vrata
					if vrata[i] != 0 then  --dont create if zero
					(
						if radiobutt[i].state == 2 do
						(			
							for v = 1 to vrata[i] do
							(
								vrataWidth = 	(sirina[i]  / vrata[i] ) - doorSpace
								posx = ((cabposx + (vrataWidth  * v) - (vrataWidth  / 2))) + v * doorABS
							
								posy = -((dubina[i]  / 2)+(debljinaPanela[i]  / 2))
								posz = cokla[i]  + doorZpos
								door = ChamferBox pos:[posx, posy, posz] Fillet_Segments:3 length:debljinaPanela[i]  width:vrataWidth  height:(visina[i]  - cokla[i]  - doorSpace) Fillet:doorFillet
								door.material =meditMaterials[3]
								door.name = uniquename "FloorDoor"
								 
							)
						)			
					)
--Frontovi Fijoke	
					if fijoke[i] != 0 then  --dont create if zero
					(
						if radiobutt[i].state == 3 do
						(  
							for f = 1 to fijoke[i] do
								(
									fijVisina = ((visina[i]  - cokla[i]  - doorSpace) / fijoke[i]  )	
									posx = cabposx + (sirina[i]  / 2)
									posy = -((dubina[i]  / 2)+(debljinaPanela[i]  / 2))
									posz = fijVisina  * f - fijVisina  + cokla[i]  + doorZpos
									drawer = ChamferBox pos:[posx, posy, posz] Fillet_Segments:3 length:debljinaPanela[i]  width:(sirina[i]  - doorSpace) height:fijVisina  Fillet:doorFillet
									drawer.material =meditMaterials[3]
									drawer.name = uniquename "FloorDrawer"
								)	
						)
					)
--Cabinet Handles
					
	if general.handles.triState == 1 do
	(
		--Square Handles
		if general.squareHandles.triState == 1 and general.roundHandles.triState == 0 do 
		(
			if radiobutt[i].state == 2 do
			(
				for v = 1 to vrata[i] do
				(  vrataWidth = 	(sirina[i] / vrata[i] )
					
					handleWidth = vrataWidth/2
					posx = ((cabposx + (vrataWidth  * v) - (vrataWidth  / 2))) + v * doorABS
					posy = -(dubina[i]  / 2 + debljinaPanela[i])
					if visina[i] >= units.decodeValue "120cm" then posz = visina[i]/2 else posz = visina[i] - handlesPos
					cabDoorHandle = Rectangle pos:[posx, posy, posz] Length:handleLength Width:handleWidth Render_renderable:true Render_displayRenderMesh:true Render_displayRenderSettings:true Render_rectangular:true Render_length:handleRenderHight Render_Width:handleRenderWidth
					cabDoorHandle.material =meditMaterials[1]
					cabDoorHandle.name = uniquename "HandleFloorDoor"
					--rotate cabhandle (eulerangles 0 90 0)	
				)
			)
			if radiobutt[i].state == 3 do
			(
				for f = 1 to fijoke[i] do
					(   vrataWidth = 	(sirina[i]  / vrata[i] )
						
						handleWidth = vrataWidth/2
						fijVisina = ((visina[i]  - cokla[i]  - doorSpace) / fijoke[i]  )	
						posx = cabposx + (sirina[i]  / 2 )
						posy = -(dubina[i]  / 2 + debljinaPanela[i])
						posz = fijVisina  * f - handlesPos + cokla[i]  + doorZpos
						cabDrawerHandle = Rectangle pos:[posx, posy, posz] Length:handleLength Width:handleWidth Render_renderable:true Render_displayRenderMesh:true Render_displayRenderSettings:true Render_rectangular:true Render_length:handleRenderHight Render_Width:handleRenderWidth 
						cabDrawerHandle.material =meditMaterials[1]
						cabDrawerHandle.name = uniquename "HandleDrawer"
							--rotate cabhandle (eulerangles 0 90 0)		
					)	
			)
		)
		--Round Handles
		if general.roundHandles.triState == 1 and general.squareHandles.triState == 0 do 
		(
			if radiobutt[i].state == 2 do
			(
				for v = 1 to vrata[i] do
				(  vrataWidth = 	(sirina[i]  / vrata[i] )
					
					handleWidth = vrataWidth/2
					posx = ((cabposx + (vrataWidth  * v) - (vrataWidth  / 2))) + v * doorABS
					posy = -(dubina[i]  / 2 + debljinaPanela[i])
					if visina[i] >= units.decodeValue "120cm" then posz = visina[i]/2 else posz = visina[i] - handlesPos
					cabDoorHandle = Rectangle pos:[posx, posy, posz] Length:handleLength Width:handleWidth Corner_Radius:handleCornerRad Render_renderable:true Render_displayRenderMesh:true Render_displayRenderSettings:true Render_rectangular:false Render_thickness:handleRenderRadius Render_sides:24
					cabDoorHandle.material =meditMaterials[1]
					cabDoorHandle.name = uniquename "HandleFloorDoor"
					--rotate cabhandle (eulerangles 0 90 0)	
				)
			)
			if radiobutt[i].state == 3 do
			(
				for f = 1 to fijoke[i] do
					(   vrataWidth = 	(sirina[i]  / vrata[i] )
						
						handleWidth = vrataWidth/2
						fijVisina = ((visina[i]  - cokla[i]  - doorSpace) / fijoke[i]  )	
						posx = cabposx + (sirina[i]  / 2)
						posy = -(dubina[i]  / 2 + debljinaPanela[i])
						posz = fijVisina  * f - handlesPos  + cokla[i]  + doorZpos
						cabDrawerHandle = Rectangle pos:[posx, posy, posz] Length:handleLength Width:handleWidth Corner_Radius:handleCornerRad Render_renderable:true Render_displayRenderMesh:true Render_displayRenderSettings:true Render_rectangular:false Render_thickness:handleRenderRadius Render_sides:24
						cabDrawerHandle.material =meditMaterials[1]
						cabDrawerHandle.name = uniquename "HandleDrawer"
							--rotate cabhandle (eulerangles 0 90 0)		
					)	
			)
		)
	)				
					
					
					
-- Group Cabinets one by one	
If general.groupobj.tristate == 1 do
	(	
select (for o in objects where isGroupMember != true collect o)
sel = getCurrentSelection()

	for i in sel do
		(
			deselect $FloorCabinet*
			deselect $WallCabinet*
			 if $Sink* != undefined do
				deselect $Sink* 
			 if $WorkTop* != undefined do
				deselect $WorkTop* 
		)			
	group selection name: (uniquename "FloorCabinet")
	)
	cabposx += sirina[i]
	)
	
general.pb1.value = 0
)	--end of main for loop

)
		
	

	on howCabs selected j do
	(
		rstring = execute howCabs.items[j]
		ckb1.text = howCabs.items[j]
		for i = 1 to rstring do
			(
				if i <= rstring then
				(
					collectUIelem()
					grupe[i].enabled= true
					sirine[i].enabled = true
					visine[i].enabled = true
					dubine[i].enabled = true
					debljine[i].enabled = true
					cokle[i].enabled = true
					police[i].enabled = true		
					radiobutt[i].enabled = true
					policeHorVert[i].enabled = true					
				)
			)
		for i = 6 to rstring by -1 do
			(
			if i > rstring then
				(		
					collectUIelem()
					grupe[i].enabled= false
					sirine[i].enabled = false
					visine[i].enabled = false
					dubine[i].enabled = false
					debljine[i].enabled = false
					cokle[i].enabled = false
					police[i].enabled = false		
					radiobutt[i].enabled = false
					radiobutt[i].state = 0
					vratasp[i].enabled = false
					fijokesp[i].enabled = false	
					policeHorVert[i].enabled = false	
				)
			)
	)
	on btnCreate pressed do
	(
	undo off	
		(
		createCab()	
		createWorkTop()
		deselect $*
		max views redraw	
		)
	)
	on rdoFrontovi_1 changed state do
		frontState()
	on rdoFrontovi_2 changed state	do
		frontState()
	on rdoFrontovi_3 changed state do
		frontState()
	on rdoFrontovi_4 changed state	do
		frontState()
	on rdoFrontovi_5 changed state	do
		frontState()
	on rdoFrontovi_6 changed state	do
		frontState()
)

rollout wallUnits "墙上吊柜部分" width:760 height:328
(
	
	
	label lab "你要横向创建多少个?" pos:[8,12] width:104 height:16
	dropdownList howCabsw "" pos:[120,8] width:40 height:20 items:#("1", "2", "3", "4", "5", "6") selection:1 
	checkbutton ckb1 "1" pos:[165,8] width:22 height:22 enabled:false checked:true  
	label lab1 "高度-Z轴离地" pos:[8,34] width:104 height:16
	spinner Zpos "" pos:[120,34] width:40 height:16 type:#worldunits range:[0,worldZpos * 4,worldZpos] fieldwidth:55
	button btnCreate "创建" pos:[690,8] width:80 height:26
	
	GroupBox grp_w1 "吊柜部分 1" pos:[8,56] width:120 height:215
	spinner cabWidth_w1 "宽度" pos:[55,80] width:68 height:16 type:#worldunits range:globWidth_w scale:0.1 fieldwidth:55 toolTip:"吊柜宽度."
	spinner cabHeight_w1 "高度" pos:[55,100] width:68 height:16 type:#worldunits range:globHeight_w scale:0.1 fieldwidth:55 toolTip:"吊柜高度."
	spinner cabDepth_w1 "深度" pos:[55,120] width:68 height:16 type:#worldunits range:globDepth_w scale:0.1 fieldwidth:55 toolTip:"吊柜深度."
	spinner cabTick_w1 "厚度" pos:[55,140] width:68 height:16 type:#worldunits range:globTick_w scale:0.1 fieldwidth:55 toolTip:"木板厚度."
	radiobuttons policeHorV_w1 "" pos:[10,180] width:20 height:16 enabled:true labels:#("竖","横") default:2 columns:1 toolTip:"隔板创建方式  横向/竖向."
	spinner cabPolice_w1 "隔板" pos:[55,180] width:68 height:16 range:[0,5,2] scale:1 fieldwidth:35 toolTip:"隔板数量."
	spinner unitHeight_1 "离地高" pos:[55,160] width:68 height:16 type:#worldunits range:[0,200,0] scale:0.1 toolTip:"吊柜离地高度(忽略总高度设置)." fieldwidth:55
	spinner cabVrata_w1 "门数" pos:[55,200] width:68 height:16 range:[0,4,2] scale:1 toolTip:"门的数量(参数为0时没有门)" fieldwidth:35
	radiobuttons glass_1 "柜门类型" pos:[12,235] width:68 height:40 enabled:true labels:#("玻璃门","木门") default:2 columns:2
	spinner glassSir_1 "玻璃门框" pos:[90,220] width:33 height:16 type:#worldunits enabled:true range:globGlassFrame scale:0.1 toolTip:"玻璃门框宽度." fieldwidth:35
	
	GroupBox grp_w2 "吊柜部分 2" pos:[136,56] width:120 height:215 enabled:false
	spinner cabWidth_w2 "宽度" pos:[183,80] width:68 height:16 type:#worldunits enabled:false range:globWidth_w scale:0.1 fieldwidth:55 toolTip:"吊柜宽度."
	spinner cabHeight_w2 "高度" pos:[183,100] width:68 height:16 type:#worldunits enabled:false range:globHeight_w scale:0.1 fieldwidth:55 toolTip:"吊柜高度."
	spinner cabDepth_w2 "深度" pos:[183,120] width:68 height:16 type:#worldunits enabled:false range:globDepth_w scale:0.1 fieldwidth:55 toolTip:"吊柜深度."
	spinner cabTick_w2 "厚度" pos:[183,140] width:68 height:16 type:#worldunits enabled:false range:globTick_w scale:0.1 fieldwidth:55 toolTip:"木板厚度."
	radiobuttons policeHorV_w2"" pos:[138,180] width:20 height:16 enabled:false labels:#("竖","横") default:2 columns:1 toolTip:"隔板创建方式  横向/竖向."
	spinner cabPolice_w2 "隔板" pos:[183,180] width:68 height:16 enabled:false range:[0,5,2] scale:1 fieldwidth:35 toolTip:"隔板数量."			  
	spinner unitHeight_2 "离地高" pos:[183,160] width:68 height:16 type:#worldunits enabled:false range:[0,200,0] scale:0.1 fieldwidth:55 toolTip:"吊柜离地高度(忽略总高度设置)."
	spinner cabVrata_w2 "门数" pos:[183,200] width:68 height:16 enabled:false range:[0,4,2] scale:1 fieldwidth:35  toolTip:"门的数量(参数为0时没有门)" 
	radiobuttons glass_2 "柜门类型" pos:[140,235] width:68 height:40 enabled:false labels:#("玻璃门","木门") default:2 columns:2
	spinner glassSir_2 "玻璃门框" pos:[218,220] width:33 height:16 type:#worldunits enabled:false range:globGlassFrame scale:0.1 toolTip:"玻璃门框宽度." fieldwidth:35
	
	GroupBox grp_w3 "吊柜部分 3" pos:[264,56] width:120 height:215 enabled:false  
	spinner cabWidth_w3 "宽度" pos:[311,80] width:68 height:16 type:#worldunits enabled:false range:globWidth_w scale:0.1 fieldwidth:55 toolTip:"吊柜宽度."
	spinner cabHeight_w3 "高度" pos:[311,100] width:68 height:16 type:#worldunits enabled:false range:globHeight_w scale:0.1 fieldwidth:55 toolTip:"吊柜高度."
	spinner cabDepth_w3 "深度" pos:[311,120] width:68 height:16 type:#worldunits enabled:false range:globDepth_w scale:0.1 fieldwidth:55 toolTip:"吊柜深度."
	spinner cabTick_w3 "厚度" pos:[311,140] width:68 height:16 type:#worldunits enabled:false range:globTick_w scale:0.1 fieldwidth:55 toolTip:"木板厚度."
	radiobuttons policeHorV_w3 "" pos:[266,180] width:20 height:16 enabled:false labels:#("竖","横") default:2 columns:1 toolTip:"隔板创建方式  横向/竖向."
	spinner cabPolice_w3 "隔板" pos:[311,180] width:68 height:16 enabled:false range:[0,5,2] scale:1 fieldwidth:35	toolTip:"隔板数量."			
	spinner unitHeight_3 "离地高" pos:[311,160] width:68 height:16 type:#worldunits enabled:false range:[0,200,0] scale:0.1 fieldwidth:55 toolTip:"吊柜离地高度(忽略总高度设置)"
	spinner cabVrata_w3 "门数" pos:[311,200] width:68 height:16 enabled:false range:[0,4,2] scale:1 fieldwidth:35  toolTip:"门的数量(参数为0时没有门)." 
	radiobuttons glass_3 "柜门类型" pos:[268,235] width:68 height:40 enabled:false labels:#("玻璃门","木门") default:2 columns:2
	spinner glassSir_3 "玻璃门框" pos:[346,220] width:33 height:16 type:#worldunits enabled:false range:globGlassFrame scale:0.1 toolTip:"玻璃门框宽度." fieldwidth:35
	
	GroupBox grp_w4 "吊柜部分 4" pos:[392,56] width:120 height:215 enabled:false fieldwidth:35
	spinner cabWidth_w4 "宽度" pos:[439,80] width:68 height:16 type:#worldunits enabled:false range:globWidth_w scale:0.1 fieldwidth:55 toolTip:"吊柜宽度."
	spinner cabHeight_w4 "高度" pos:[439,100] width:68 height:16 type:#worldunits enabled:false range:globHeight_w scale:0.1 fieldwidth:55 toolTip:"吊柜高度."
	spinner cabDepth_w4 "深度" pos:[439,120] width:68 height:16 type:#worldunits enabled:false range:globDepth_w scale:0.1 fieldwidth:55 toolTip:"吊柜深度."
	spinner cabTick_w4 "厚度" pos:[439,140] width:68 height:16 type:#worldunits enabled:false range:globTick_w scale:0.1 fieldwidth:55 toolTip:"木板厚度."
	radiobuttons policeHorV_w4 "" pos:[394,180] width:20 height:16 enabled:false labels:#("竖","横") default:2 columns:1 toolTip:"隔板创建方式  横向/竖向."
	spinner cabPolice_w4 "隔板" pos:[439,180] width:68 height:16 enabled:false range:[0,5,2] scale:1 fieldwidth:35 toolTip:"隔板数量."
	spinner unitHeight_4 "离地高" pos:[439,160] width:68 height:16 type:#worldunits enabled:false range:[0,200,0] scale:0.1 fieldwidth:55 toolTip:"Overrides Height(Z Position) of Wall Element. Set '0' to use  Value"
	spinner cabVrata_w4 "门数" pos:[439,200] width:68 height:16 enabled:false range:[0,4,2] scale:1 fieldwidth:35  toolTip:"门的数量(参数为0时没有门)" 
	radiobuttons glass_4 "柜门类型" pos:[396,235] width:68 height:40 enabled:false labels:#("玻璃门","木门") default:2 columns:2
	spinner glassSir_4 "玻璃门框" pos:[474,220] width:33 height:16 type:#worldunits enabled:false range:globGlassFrame scale:0.1 toolTip:"玻璃门框宽度." fieldwidth:35
	
	GroupBox grp_w5 "吊柜部分 5" pos:[520,56] width:120 height:215 enabled:false
	spinner cabWidth_w5 "宽度" pos:[568,80] width:68 height:16 type:#worldunits enabled:false range:globWidth_w scale:0.1 fieldwidth:55 toolTip:"吊柜宽度."
	spinner cabHeight_w5 "高度" pos:[568,100] width:68 height:16 type:#worldunits enabled:false range:globHeight_w scale:0.1 fieldwidth:55 toolTip:"吊柜高度."
	spinner cabDepth_w5 "深度" pos:[568,120] width:68 height:16 type:#worldunits enabled:false range:globDepth_w scale:0.1 fieldwidth:55 toolTip:"吊柜深度."
	spinner cabTick_w5 "厚度" pos:[568,140] width:68 height:16 type:#worldunits enabled:false range:globTick_w scale:0.1 fieldwidth:55 toolTip:"木板厚度."
	radiobuttons policeHorV_w5 "" pos:[522,180] width:20 height:16 enabled:false labels:#("竖","横") default:2 columns:1 toolTip:"隔板创建方式  横向/竖向."
	spinner cabPolice_w5 "隔板" pos:[568,180] width:68 height:16 enabled:false range:[0,5,2] scale:1 fieldwidth:35 toolTip:"隔板数量."				
	spinner unitHeight_5 "离地高" pos:[568,160] width:68 height:16 type:#worldunits enabled:false range:[0,200,0] scale:0.1 fieldwidth:55 toolTip:"吊柜离地高度(忽略总高度设置)"
	spinner cabVrata_w5 "门数" pos:[568,200] width:68 height:16 enabled:false range:[0,4,2] scale:1 fieldwidth:35  toolTip:"门的数量(参数为0时没有门)" 
	radiobuttons glass_5 "柜门类型" pos:[524,235] width:68 height:40 enabled:false labels:#("玻璃门","木门") default:2 columns:2
	spinner glassSir_5 "玻璃门框" pos:[603,220] width:33 height:16 type:#worldunits enabled:false range:globGlassFrame scale:0.1 toolTip:"玻璃门框宽度." fieldwidth:35
	
	GroupBox grp_w6 "吊柜部分 6" pos:[648,56] width:120 height:215 enabled:false
	spinner cabWidth_w6 "宽度" pos:[695,80] width:68 height:16 type:#worldunits enabled:false range:globWidth_w scale:0.1 fieldwidth:55 toolTip:"吊柜宽度."
	spinner cabHeight_w6 "高度" pos:[695,100] width:68 height:16 type:#worldunits enabled:false range:globHeight_w scale:0.1 fieldwidth:55 toolTip:"吊柜高度."
	spinner cabDepth_w6 "深度" pos:[695,120] width:68 height:16 type:#worldunits enabled:false range:globDepth_w scale:0.1 fieldwidth:55 toolTip:"吊柜深度."
	spinner cabTick_w6 "厚度" pos:[695,140] width:68 height:16 type:#worldunits enabled:false range:globTick_w scale:0.1 fieldwidth:55 toolTip:"木板厚度."
	radiobuttons policeHorV_w6 "" pos:[650,180] width:20 height:16 enabled:false labels:#("竖","横") default:2 columns:1 toolTip:"隔板创建方式  横向/竖向."
	spinner cabPolice_w6 "隔板" pos:[695,180] width:68 height:16 enabled:false range:[0,5,2] scale:1 fieldwidth:35 toolTip:"隔板数量."				
	spinner unitHeight_6 "离地高" pos:[695,160] width:68 height:16 type:#worldunits enabled:false range:[0,200,0] scale:0.1 fieldwidth:55 toolTip:"吊柜离地高度(忽略总高度设置)"
	spinner cabVrata_w6 "门数" pos:[695,200] width:68 height:16 enabled:false range:[0,4,2] scale:1 fieldwidth:35  toolTip:"门的数量(参数为0时没有门)." 
	radiobuttons glass_6 "柜门类型" pos:[652,235] width:68 height:40 enabled:false labels:#("玻璃门","木门") default:2 columns:2
	spinner glassSir_6 "玻璃门框" pos:[730,220] width:33 height:16 type:#worldunits enabled:false range:globGlassFrame scale:0.1 toolTip:"玻璃门框宽度." fieldwidth:35
	
		
	local wstring = 1
	local sirinaw, visinaw, dubinaw, debljinaPanelaw, policaw, vrataw, unitHeights, curZpos, glassDoorSir
	local grupew, sirinew, visinew, dubinew, debljinew, policew, vrataspw, visineCabw, glass_elem, policawHorVert, glassDoorSirUI
	
fn collectwVal =
(
		 sirinaw = #(cabWidth_w1.value, cabWidth_w2.value, cabWidth_w3.value, cabWidth_w4.value, cabWidth_w5.value, cabWidth_w6.value)
		 visinaw = #(cabHeight_w1.value, cabHeight_w2.value, cabHeight_w3.value, cabHeight_w4.value, cabHeight_w5.value, cabHeight_w6.value)
		 dubinaw = #(cabDepth_w1.value, cabDepth_w2.value, cabDepth_w3.value, cabDepth_w4.value, cabDepth_w5.value, cabDepth_w6.value)
		 debljinaPanelaw = #(cabTick_w1.value, cabTick_w2.value, cabTick_w3.value, cabTick_w4.value, cabTick_w5.value, cabTick_w6.value)
		 policaw = #(cabPolice_w1.value, cabPolice_w2.value, cabPolice_w3.value, cabPolice_w4.value, cabPolice_w5.value, cabPolice_w6.value)
		 vrataw = #(cabVrata_w1.value, cabVrata_w2.value, cabVrata_w3.value, cabVrata_w4.value, cabVrata_w5.value, cabVrata_w6.value)
		 unitHeights = #(unitHeight_1.value, unitHeight_2.value, unitHeight_3.value, unitHeight_4.value, unitHeight_5.value, unitHeight_6.value)
		 glassDoorSir = #(glassSir_1.value, glassSir_2.value, glassSir_3.value, glassSir_4.value, glassSir_5.value, glassSir_6.value)
)
fn collectwUIelem =
(
		 grupew = #(grp_w1, grp_w2, grp_w3, grp_w4, grp_w5, grp_w6)
		 sirinew = #(cabWidth_w1, cabWidth_w2, cabWidth_w3, cabWidth_w4, cabWidth_w5, cabWidth_w6)
		 visinew = #(cabHeight_w1, cabHeight_w2, cabHeight_w3, cabHeight_w4, cabHeight_w5, cabHeight_w6)	
		 dubinew =#(cabDepth_w1, cabDepth_w2, cabDepth_w3, cabDepth_w4, cabDepth_w5, cabDepth_w6)
		 debljinew =#(cabTick_w1, cabTick_w2, cabTick_w3, cabTick_w4, cabTick_w5, cabTick_w6)
		 policawHorVert = #(policeHorV_w1, policeHorV_w2, policeHorV_w3, policeHorV_w4, policeHorV_w5, policeHorV_w6)
		 policew = #(cabPolice_w1, cabPolice_w2, cabPolice_w3, cabPolice_w4, cabPolice_w5, cabPolice_w6)
		 vrataspw = #(cabVrata_w1, cabVrata_w2, cabVrata_w3, cabVrata_w4, cabVrata_w5, cabVrata_w6)
		 visineCabw = #(unitHeight_1, unitHeight_2, unitHeight_3, unitHeight_4, unitHeight_5, unitHeight_6)
		 glass_elem = #(glass_1, glass_2, glass_3, glass_4, glass_5, glass_6)
		 glassDoorSirUI = #(glassSir_1, glassSir_2, glassSir_3, glassSir_4, glassSir_5, glassSir_6)
)


fn collZvalues = 
(
	 curZpos = #()
	for i=1 to 6 do
	(
		if unitHeights[i] == 0 then
		(curZpos[i] = Zpos.value)
			else(curZpos[i] = unitHeights[i])
	
	)
)	
fn createwCab = 
(	
	if general.whatCabs.selection == 2 or general.whatCabs.selection == 3 do
	(
	floorUnits.collectVal()	
	corpusMat()
	frontMat()
	handlesSatinedMetal()
	glassDoorMat()
	collectwVal()
	collectwUIelem()
	collZvalues()
	--Korpusi
	
	cabposxw = 0 
	for i = 1 to wstring do
	(
		general.pb1.value = 100.*i/wstring
		
		
		
			leftSidew = box pos:[cabposxw + (debljinaPanelaw[i]/2), (floorUnits.dubina[i]  / 2) - (dubinaw[i]/2), curZpos[i]] length:dubinaw[i] width:debljinaPanelaw[i] height:visinaw[i]
			leftSidew.material =meditMaterials[2]
			leftSidew.name = uniquename "WallLeftSide"
		
			rightSidew = box pos:[cabposxw + sirinaw[i] - (debljinaPanelaw[i]/2), (floorUnits.dubina[i]  / 2) - (dubinaw[i]/2), curZpos[i]] length:dubinaw[i] width:debljinaPanelaw[i] height:visinaw[i]
		    rightSidew.material =meditMaterials[2]
			rightSidew.name = uniquename "WallRightSide"
				
			bottomSidew = box pos:[(cabposxw + (sirinaw[i]  - debljinaPanelaw[i])/2 + debljinaPanelaw[i]  / 2), (floorUnits.dubina[i]  / 2) - (dubinaw[i]/2), curZpos[i]] length:dubinaw[i]  width:(sirinaw[i]  - (debljinaPanelaw[i] *2)) height:debljinaPanelaw[i] 
		    bottomSidew.material =meditMaterials[2]
			bottomSidew.name = uniquename "WallBottomSide"
				
			topSidew = box pos:[(cabposxw + (sirinaw[i]  - debljinaPanelaw[i])/2 + debljinaPanelaw[i]  / 2), (floorUnits.dubina[i]  / 2) - (dubinaw[i]/2), (visinaw[i]  - debljinaPanelaw[i] + curZpos[i] )] length:dubinaw[i]  width:(sirinaw[i]  - (debljinaPanelaw[i] *2)) height:debljinaPanelaw[i] 
			topSidew.material =meditMaterials[2]
			topSidew.name = uniquename "WallTopSide"
				
			backSidew = box pos:[(cabposxw + (sirinaw[i]  - debljinaPanelaw[i])/2 + debljinaPanelaw[i]  / 2),((floorUnits.dubina[i]  / 2) - (dubinaw[i]/2) + (dubinaw[i]  / 2) - debljinaPanelaw[i]  / 4),  debljinaPanelaw[i] + curZpos[i]] length:(debljinaPanelaw[i]  / 4) width:(sirinaw[i]  - debljinaPanelaw[i]  * 2) height:(visinaw[i]  - debljinaPanelaw[i]  * 2)
			backSidew.material =meditMaterials[2]
			backSidew.name = uniquename "WallBackSide"	
	--Police
			if policawHorVert[i].state == 2 then
			(
				for p = 1 to policaw[i]  do
					(
				posx = cabposxw + (sirinaw[i]  - debljinaPanelaw[i] )/2 + debljinaPanelaw[i]  / 2
				posy = (floorUnits.dubina[i]  / 2) - (dubinaw[i]/2)		
				posz = (visinaw[i]) / (policaw[i]  + 1)
				posz = posz * p - debljinaPanelaw[i] / 2
				posz += curZpos[i]
			    shelfw = box pos:[posx, posy, posz] length:dubinaw[i]  width:(sirinaw[i]  - (debljinaPanelaw[i] *2)) height:debljinaPanelaw[i] 
				shelfw.material =meditMaterials[2]
				shelfw.name = uniquename "WallShelf"
				   )
			)
			if policawHorVert[i].state  == 1 then
			   (
				   for p = 1 to policaw[i]  do
					(
						posx = sirinaw[i] / (policaw[i]  + 1)
						posx = cabposxw + posx * p
						posy = (floorUnits.dubina[i]  / 2) - (dubinaw[i]/2)
						posz = curZpos[i] + debljinaPanelaw[i] 
						shelf = box pos:[posx, posy, posz] length:dubinaw[i]  width:debljinaPanelaw[i]  height:(visinaw[i]  - (debljinaPanelaw[i] *2))
						shelf.material =meditMaterials[2]
						shelf.name = uniquename "FloorShelf"
				   )
			   )	
	--Frontovi		Vrata
			if glass_elem[i].state == 2 then
			(	
				for v = 1 to vrataw[i] do
						(
							vrataWidthw = 	(sirinaw[i]  / vrataw[i] ) - doorSpace
							posx = ((cabposxw + (vrataWidthw * v) - (vrataWidthw  / 2))) + v * doorABS
						
							posy = (floorUnits.dubina[i]  / 2) - (dubinaw[i]/2)-((dubinaw[i]  / 2)+(debljinaPanelaw[i]  / 2))
							posz =curZpos[i] + doorZpos
							doorw = ChamferBox pos:[posx, posy, posz] Fillet_Segments:3 length:debljinaPanelaw[i]  width:vrataWidthw  height:(visinaw[i]  - doorSpace) Fillet:doorFillet
							doorw.material =meditMaterials[3]
							doorw.name = uniquename "WallDoor"
						)
			)else
			(
				for v = 1 to vrataw[i] do
				(
						--Glass Doors				
					doorWidth = (sirinaw[i]  / vrataw[i] ) - doorSpace
					doorHeight = visinaw[i]  - doorSpace
					debljinaPanela = debljinaPanelaw[i]
					doorSir = glassDoorSir[i]
					
					posx = cabposxw + doorWidth * v - doorWidth + doorSir / 2 + v * doorABS
					posy = (floorUnits.dubina[i] / 2) - (dubinaw[i] / 2)-((dubinaw[i] / 2)+(debljinaPanelaw[i] / 2))
					posz = curZpos[i] + doorZpos
					
					left = ChamferBox pos:[posx, posy, posz] Fillet_Segments:3 length:debljinaPanela  width:doorSir  height:doorHeight Fillet:doorFillet
					left.material =meditMaterials[3]
					left.name = uniquename "GlassDoorLeft"
					
					posx = cabposxw + doorWidth * v - doorSir / 2 + v * doorABS
					right = ChamferBox pos:[posx, posy, posz] Fillet_Segments:3 length:debljinaPanela  width:doorSir  height:doorHeight Fillet:doorFillet
					right.material =meditMaterials[3]
					right.name = uniquename "GlassDoorRight"
						
					posx = ((cabposxw + (doorWidth * v) - (doorWidth / 2))) + v * doorABS
					posz = curZpos[i] + doorZpos + doorHeight - doorSir	
					top = ChamferBox pos:[posx, posy, posz] Fillet_Segments:3 length:debljinaPanela  width:(doorWidth - doorSir*2)  height:doorSir Fillet:doorFillet
					top.material =meditMaterials[3]
					top.name = uniquename "GlassDoorTop"
						
					posz = curZpos[i] + doorZpos
					bott = ChamferBox pos:[posx, posy, posz] Fillet_Segments:3 length:debljinaPanela  width:(doorWidth - doorSir*2 )  height:doorSir Fillet:doorFillet
					bott.material =meditMaterials[3]
					bott.name = uniquename "GlassDoorBottom"
					
					
					posz =curZpos[i] + doorZpos + doorSir
					glassWidth = doorWidth-doorSir*2
					glassTick=doorFillet
					glassHeight = doorHeight-doorSir*2
					GlassofDoor = Box pos:[posx, posy, posz] width:glassWidth  length:glassTick height:glassHeight
					GlassofDoor.material =meditMaterials[8]
					GlassofDoor.name = uniquename "DoorGlass"
					
				)
			)							
--Cabinet Handles
					
	if general.handles.triState == 1 do
	(
		--Square Handles
		if general.squareHandles.triState == 1 and general.roundHandles.triState == 0 do 
		(
			for v = 1 to vrataw[i] do
				(  vrataWidthw = 	(sirinaw[i]  / vrataw[i] )
					
					handleWidthw = vrataWidthw/2
					posx = ((cabposxw + (vrataWidthw * v) - (vrataWidthw / 2))) + v * doorABS
					posy = -(dubinaw[i]  / 2 + debljinaPanelaw[i]) + (floorUnits.dubina[i] / 2) - (dubinaw[i]/2)
						--namesti rucke na sredinu staklenog rama
					if glass_elem[i].state == 1 then posz = curZpos[i] + glassDoorSir[i]/2 else posz = curZpos[i] + handlesPos
					
					cabDoorHandlew = Rectangle pos:[posx, posy, posz] Length:handleLength Width:handleWidthw Render_renderable:true Render_displayRenderMesh:true Render_displayRenderSettings:true Render_rectangular:true Render_length:handleRenderHight Render_Width:handleRenderWidth
					cabDoorHandlew.material =meditMaterials[1]
					cabDoorHandlew.name = uniquename "HandleWallDoor"
						--rotate cabhandle (eulerangles 0 90 0)	
				)
			
		)
		--Round Handles
		if general.roundHandles.triState == 1 and general.squareHandles.triState == 0 do 
		(
			for v = 1 to vrataw[i] do
				(  vrataWidthw = 	(sirinaw[i]  / vrataw[i] )
					
					handleWidthw = vrataWidthw/2
					posx = ((cabposxw + (vrataWidthw * v) - (vrataWidthw / 2))) + v * doorABS
					posy = -(dubinaw[i]  / 2 + debljinaPanelaw[i]) + (floorUnits.dubina[i] / 2) - (dubinaw[i]/2)
						--namesti rucke na sredinu staklenog rama
					if glass_elem[i].state == 1 then posz = curZpos[i] + glassDoorSir[i]/2 else posz = curZpos[i] + handlesPos
					
					cabDoorHandlew = Rectangle pos:[posx, posy, posz] Length:handleLength Width:handleWidthw Corner_Radius:handleCornerRad Render_renderable:true Render_displayRenderMesh:true Render_displayRenderSettings:true Render_rectangular:false Render_thickness:handleRenderRadius Render_sides:24
					cabDoorHandlew.material =meditMaterials[1]
					cabDoorHandlew.name = uniquename "HandleWallDoor"
						--rotate cabhandle (eulerangles 0 90 0)	
				)
			
		)
	)				
					
					
					
-- Group Cabinets one by one	
If general.groupobj.tristate == 1 do
	(
select (for o in objects where isGroupMember != true collect o)
		sel = getCurrentSelection()
		for i in sel do
		(
			deselect $WallCabinet*
			deselect $FloorCabinet*
			 if $Sink* != undefined do
				deselect $Sink* 
			 if $WorkTop* != undefined do
				deselect $WorkTop* 
			
		)			
	group selection name: (uniquename "WallCabinet")
	
	)	
	cabposxw += sirinaw[i]
	)		--end of main for loop
	general.pb1.value = 0
)	
)


	on howCabsw selected j do
	(
		wstring = execute howCabsw.items[j]
		ckb1.text = howCabsw.items[j]
			for i = 1 to wstring do
			(
				if i <= wstring then
				(
					collectwUIelem()
					grupew[i].enabled= true
					sirinew[i].enabled = true
					visinew[i].enabled = true
					dubinew[i].enabled = true
					debljinew[i].enabled = true
					policew[i].enabled = true		
					vrataspw[i].enabled = true
					visineCabw[i].enabled = true
					glass_elem[i].enabled = true
					policawHorVert[i].enabled = true
					glassDoorSirUI[i].enabled = true
				)
			)
		
			for i = 6 to wstring by -1 do
			(
				if i > wstring then
				(		
					collectwUIelem()
					grupew[i].enabled= false
					sirinew[i].enabled = false
					visinew[i].enabled = false
					dubinew[i].enabled = false
					debljinew[i].enabled = false
					policawHorVert[i].enabled = false
					policew[i].enabled = false		
					vrataspw[i].enabled = false
					visineCabw[i].enabled = false
					glass_elem[i].enabled = false
					glassDoorSirUI[i].enabled = false
				)
			)
	)
	on btnCreate pressed do
	(
	undo off
		(
		createwCab()	
		deselect $*	
		max views redraw	
		)
	)
)
-- 
addRollout general theFloater rolledUp: false
addRollout floorUnits theFloater rolledUp: false
	 
)
