-- Copyright (c) 2008 Jerry Ylilammi
-- All rights reserved.

/*
	Update log
		13.1.2009		
			Version 1.00 (build 25)

*/

/*
	Update log
		12.14.2010		
			Version 1.00 (build 25) Chinese(Simplified)language 
                                                                  黑马设计网(www.3dheima.com) 

*/

/*
	如有修改请保留以上信息，谢谢合作!

*/



-- #############################################################################################
-- #################################/ Reset                    \################################
-- #############################################################################################

-- #################### // Attribute definition \\ ####################
/*
global floorGenAttributes = attributes floorGenStorage (
	parameters param (
		floorFloats type:#floatTab 		tabSizeVariable:true
		floorInts 	type:#intTab 		tabSizeVariable:true
		floorBools 	type:#boolTab 		tabSizeVariable:true
		floorNode 	type:#node 
	)
)
*/

-- #################### // Kill Previous \\ ####################
global FloorGenerator
try(destroyDialog FloorGenerator)catch()

rollout FloorGenerator "木地板生成器 (黑马设计网)出品" width:315 (
	
-- #############################################################################################
-- #################################/ User Interface           \################################
-- #############################################################################################

	/* Size */
	
	groupbox gb2 "大小" width:311 height:116 pos:[2,2]
	label LABEL_Max "最大" pos:[90,17]
	label LABEL_Min "最小" pos:[180,17]
	label LABEL_Spread "扩展" pos:[258,17]

	label LABEL_Length "长度" pos:[48,35]
	spinner SPINNER_Length "" range:[0.0,100000.0,1000.0] type:#Float width:70 pos:[82,35]
	checkbutton CHECK_LengthL "L" width:16 height:16 pos:[155,35] checked:true
	spinner SPINNER_LengthR "" range:[0.0,100000.0,1000.0] type:#Float width:70 pos:[174,35]
	spinner SPINNER_LengthS	"" range:[0.0,1.0,0.5] type:#Float width:55 pos:[253,35]

	label LABEL_Width "宽度" pos:[48,55]
	spinner SPINNER_Width "" range:[0.0,100000.0,70.0] type:#Float width:70 pos:[82,55]
	checkbutton CHECK_WidthL "L" width:16 height:16 pos:[155,55] checked:true
	spinner SPINNER_WidthR "" range:[0.0,100000.0,70.0] type:#Float width:70 pos:[174,55]
	spinner SPINNER_WidthS	"" range:[0.0,1.0,0.5] type:#Float width:55 pos:[253,55]

	label LABEL_GapLength "缝隙长度" pos:[20,77]
	spinner SPINNER_GapLength "" range:[0.0,100000.0,0.2] type:#Float width:70 pos:[82,77]
	
	checkbutton CHECK_GapL "L" checked:true width:16 height:16 pos:[155,87]
	
	label LABEL_GapWidth "缝隙宽度" pos:[24,97]
	spinner SPINNER_GapWidth "" range:[0.0,100000.0,0.2] type:#Float width:70 pos:[82,97]

	/* Variation Per Board */
	
	groupbox gb3 "局部变化" width:311 height:136 pos:[2,122]	
	label LABEL_Max2 "最大" pos:[90,137]
	label LABEL_Min2 "最小" pos:[182,137]
	label LABEL_Spread2 "扩展" pos:[258,137]
	checkbutton CHECK_MinL "L" checked:false width:16 height:16 pos:[228,135] visible:false
		
	label LABEL_Rotation "旋转%" pos:[39,155]
	spinner SPINNER_Rotation "" range:[0.0,100.0,0.0] type:#Float width:70 pos:[82,155]
	spinner SPINNER_RotationR "" range:[0.0,100.0,0.0] type:#Float width:70 pos:[174,155]
	spinner SPINNER_RotationS	"" range:[0.0,1.0,0.5] type:#Float width:55 pos:[253,155]		

	label LABEL_RandomX "偏移X" pos:[39,175]
	spinner SPINNER_RandomX "" range:[0.0,100000.0,0.0] type:#Float width:70 pos:[82,175]
	spinner SPINNER_RandomXR "" range:[0.0,100000.0,0.0] type:#Float width:70 pos:[174,175]
	spinner SPINNER_RandomXS "" range:[0.0,1.0,0.5] type:#Float width:55 pos:[253,175]	

	checkbutton CHECK_RandomL "L" checked:true width:16 height:16 pos:[155,185]

	label LABEL_RandomY "偏移Y" pos:[39,195]
	spinner SPINNER_RandomY "" range:[0.0,100000.0,0.0] type:#Float width:70 pos:[82,195]
	spinner SPINNER_RandomYR "" range:[0.0,100000.0,0.0] type:#Float width:70 pos:[174,195]
	spinner SPINNER_RandomYS "" range:[0.0,1.0,0.5] type:#Float width:55 pos:[253,195]		
	
	label LABEL_Tilt "倾斜" pos:[39,215]
	spinner SPINNER_Tilt "" range:[0.0,100000.0,0.0] type:#Float width:70 pos:[82,215]
	spinner SPINNER_TiltR "" range:[0.0,100000.0,0.0] type:#Float width:70 pos:[174,215]
	spinner SPINNER_TiltS "" range:[0.0,1.0,0.5] type:#Float width:55 pos:[253,215]	

	label LABEL_Overlap "最大重叠" pos:[18,237]
	spinner SPINNER_Overlap "" range:[0,100000.0,0.0] type:#Float width:70 pos:[82,237]		
		
	/* Floor Adjustment */
		
	groupbox gb1 "整体" width:311 height:82 pos:[2,262]
	label LABEL_Scale "范围%" pos:[38,282]
	spinner SPINNER_Scale "" range:[0.0,100000.0,100.0] type:#Float width:70 pos:[82,282]
	label LABEL_Seed "种子" pos:[210,282]	
	spinner SPINNER_Seed "" range:[0,100000,12345] type:#Integer width:70 pos:[238,282]	
	
	label LABEL_Direction "旋转" pos:[38,302]
	spinner SPINNER_Direction "" range:[-360.0,360.0,0.0] type:#Float width:70 pos:[82,302]		
	label LABEL_OffsetX "偏移X" pos:[197,302]	
	spinner SPINNER_OffLength "" range:[-100000.0,100000.0,0.0] type:#Float width:70 pos:[238,302]
	
	label LABEL_RowOffset "行偏移%" pos:[38,322]
	spinner SPINNER_RowOffset "" range:[0.0,100.0,20.0] type:#Float width:70 pos:[82,322]		
	label LABEL_OffsetY "偏移Y" pos:[197,322]
	spinner SPINNER_OffWidth "" range:[-100000.0,100000.0,0.0] type:#Float width:70 pos:[238,322]	
		
	/* Rest */
	
	groupbox gb5 "拉伸 / 倒角 / 焊接 / UV" width:311 height:100 pos:[2,348]

	checkbox CHECKBOX_FlipU "随机翻转贴图U" checked:true pos:[174,368]
	checkbox CHECKBOX_FlipV	"随机翻转贴图V" checked:true pos:[174,388]
	checkbox CHECKBOX_OffU "随机偏移U" checked:true pos:[174,408]
	checkbox CHECKBOX_OffV	"随机偏移V" checked:true pos:[174,428]

	checkbox CHECKBOX_Weld "焊接" checked:false pos:[37,368]
	label LABEL_Weld "" pos:[70,368]
	spinner SPINNER_Weld "" range:[0.0,100000.0,0.05] type:#Float width:70 pos:[82,368]
		
	checkbox CHECKBOX_Extrude "拉伸" checked:true pos:[37,388]
	label LABEL_Extrude "" pos:[70,388]
	spinner SPINNER_Extrude "" range:[0.0,100000.0,1.0] type:#Float width:70 pos:[82,388]
	
	checkbox CHECKBOX_Bevel "倒角" checked:true pos:[37,408]
	label LABEL_Bevel "" pos:[70,408]
	spinner SPINNER_Bevel "" range:[0.0,100000.0,0.5] type:#Float width:70 pos:[82,408]
	checkbutton CHECK_BevelL "L" checked:true width:16 height:16 pos:[155,418]	
	label LABEL_Outline "轮廓线" pos:[37,428]
	spinner SPINNER_Outline	"" range:[0.0,100000.0,0.5] type:#Float width:70 pos:[82,428]
	
	/* Buttons */
	
	label LABEL_ObjName "请先选择要创建地板的模型: < 还没有创建地板 >" offset:[0,4]
	
	label underlineHACK "________________" pos:[137,540]
	
	button BUTTON_Create "创建" width:155	pos:[2, 472]
	button BUTTON_Load "取回设置" width:155 pos:[158, 472]
	
	button BUTTON_Update "更新场景" width:155 pos:[2, 496]
	checkbutton CHECK_Update "自动更新场景" width:155 pos:[158, 496]
	
	/* Credits */		
		
	label credit1 "FloorGenerator Version 1.00"
	label credit2 "Created by" across:2 offset:[22,0]
	hyperLink creditLink "www.3dheima.com" offset:[-21,0] color:[0,0,0] hoverColor:[255,255,255] visitedColor:[0,0,0] address:"http://www.3dheima.com"
	label credit3 "The source to HighQuality textures"
	
	
	
-- #############################################################################################
-- #################################/ UI related functions     \################################
-- #############################################################################################
	
	-- #################### // Function declarations \\ ####################			
	local valChanged

   -- #################### // UI Enables \\ ####################		
	fn enableUI = (
		SPINNER_LengthR.enabled = not CHECK_LengthL.checked
		SPINNER_WidthR.enabled = not CHECK_WidthL.checked		
		SPINNER_Outline.enabled = LABEL_Outline.enabled = not CHECK_BevelL.checked		
		SPINNER_GapWidth.enabled = LABEL_GapWidth.enabled = not CHECK_GapL.checked
		SPINNER_GapWidth.enabled = LABEL_GapWidth.enabled = not CHECK_GapL.checked				
		SPINNER_RandomY.enabled = LABEL_RandomY.enabled = SPINNER_RandomYS.enabled = not CHECK_RandomL.checked				
		SPINNER_RandomYR.enabled = (not CHECK_RandomL.checked) and (not CHECK_MinL.checked)
		SPINNER_TiltR.enabled = SPINNER_RandomXR.enabled = SPINNER_RotationR.enabled = not CHECK_MinL.checked
		LABEL_Min2.enabled = not CHECK_MinL.checked
	)
	
	fn limitUI = (
		if SPINNER_Length.value < SPINNER_LengthR.value or CHECK_LengthL.checked then
			SPINNER_LengthR.range = [0.0, SPINNER_Length.value, SPINNER_Length.value]			
		else
			SPINNER_LengthR.range = [0.0, SPINNER_Length.value, SPINNER_LengthR.value]			
		
		if SPINNER_Width.value < SPINNER_WidthR.value or CHECK_WidthL.checked then
			SPINNER_WidthR.range = [0.0, SPINNER_Width.value, SPINNER_Width.value]			
		else
			SPINNER_WidthR.range = [0.0, SPINNER_Width.value, SPINNER_WidthR.value]
		
		if SPINNER_Rotation.value < SPINNER_RotationR.value then
			SPINNER_RotationR.range = [0.0, SPINNER_Rotation.value, SPINNER_Rotation.value]			
		else
			SPINNER_RotationR.range = [0.0, SPINNER_Rotation.value, SPINNER_RotationR.value]
		
		if SPINNER_RandomX.value < SPINNER_RandomXR.value then
			SPINNER_RandomXR.range = [0.0, SPINNER_RandomX.value, SPINNER_RandomX.value]			
		else
			SPINNER_RandomXR.range = [0.0, SPINNER_RandomX.value, SPINNER_RandomXR.value]		
		
		if SPINNER_RandomY.value < SPINNER_RandomYR.value then
			SPINNER_RandomYR.range = [0.0, SPINNER_RandomY.value, SPINNER_RandomY.value]			
		else
			SPINNER_RandomYR.range = [0.0, SPINNER_RandomY.value, SPINNER_RandomYR.value]			
		
		if SPINNER_Tilt.value < SPINNER_TiltR.value then
			SPINNER_TiltR.range = [0.0, SPINNER_Tilt.value, SPINNER_Tilt.value]			
		else
			SPINNER_TiltR.range = [0.0, SPINNER_Tilt.value, SPINNER_TiltR.value]						
	)
	
	on SPINNER_Length 		changed val do (limitUI(); valChanged())
	on SPINNER_LengthR 		changed val do (limitUI(); valChanged())
	on SPINNER_Width 		changed val do (limitUI(); valChanged())
	on SPINNER_WidthR 		changed val do (limitUI(); valChanged())
	on SPINNER_Rotation 	changed val do (limitUI(); valChanged())
	on SPINNER_RotationR 	changed val do (limitUI(); valChanged())
	on SPINNER_RandomX 		changed val do (limitUI(); valChanged())
	on SPINNER_RandomXR 	changed val do (limitUI(); valChanged())
	on SPINNER_RandomY 		changed val do (limitUI(); valChanged())
	on SPINNER_RandomYR 	changed val do (limitUI(); valChanged())
	on SPINNER_Tilt 		changed val do (limitUI(); valChanged())
	on SPINNER_TiltR 		changed val do (limitUI(); valChanged())	
				
	on CHECK_LengthL 		changed val	do (enableUI(); valChanged(); limitUI())
	on CHECK_WidthL 		changed val do (enableUI(); valChanged(); limitUI())
	on CHECK_BevelL 		changed val	do (enableUI(); valChanged())
	on CHECK_GapL 			changed val do (enableUI(); valChanged())
	on CHECK_RandomL 		changed val do (enableUI(); valChanged())
	on CHECK_MinL 			changed val do (enableUI(); valChanged())
	
	on SPINNER_LengthS 		changed val do (valChanged())		
	on SPINNER_WidthS 		changed val do (valChanged())		
	on SPINNER_GapLength	changed val do (valChanged())		
	on SPINNER_GapWidth 	changed val do (valChanged())		
	on SPINNER_RotationS	changed val do (valChanged())		
	on SPINNER_RandomXS 	changed val do (valChanged())		
	on SPINNER_RandomYS		changed val do (valChanged())		
	on SPINNER_TiltS 		changed val do (valChanged())		
	on SPINNER_Scale 		changed val do (valChanged())		
	on SPINNER_Overlap 		changed val do (valChanged())		
	on SPINNER_Seed 		changed val do (valChanged())		
	on SPINNER_Direction	changed val do (valChanged())		
	on SPINNER_OffLength	changed val do (valChanged())		
	on SPINNER_RowOffset 	changed val do (valChanged())		
	on SPINNER_OffWidth 	changed val do (valChanged())		
	on CHECKBOX_FlipU 		changed val do (valChanged())		
	on CHECKBOX_FlipV 		changed val do (valChanged())		
	on CHECKBOX_OffU 		changed val do (valChanged())		
	on CHECKBOX_OffV 		changed val do (valChanged())		
	on CHECKBOX_Weld 		changed val do (valChanged())		
	on SPINNER_Weld 		changed val do (valChanged())		
	on CHECKBOX_Extrude 	changed val do (valChanged())		
	on SPINNER_Extrude 		changed val do (valChanged())		
	on CHECKBOX_Bevel 		changed val do (valChanged())		
	on SPINNER_Bevel 		changed val do (valChanged())		
	on SPINNER_Outline 		changed val do (valChanged())		

-- #############################################################################################
-- #################################/ Variables and Paramters  \################################
-- #############################################################################################
		
   -- #################### // Variables \\ ####################
	local DEBUGMODE = true -- Debug mode, prints stuff
   
	local base = undefined -- The object the floor is created to		
	local floorObject = undefined -- Contains the floor geometry
	local floorObjectOld = undefined -- Previously done floor geometry
	local objOld = undefined -- The object the old floor was created to	
	local oldModifiers = #() -- Modifiers on the floor object
	
	local zOffset = undefined -- Average position of base vertices on z axis
		
	local floorSpace = undefined -- Matrix3	
	local floorRotation = undefined -- quat (SPINNER_Rotation.value) z
		
	local bb1 = undefined -- Bounding box top left corner
	local bb2 = undefined -- Bounding box bottom right corner
	
	local baseAvgZ = undefined -- Average Z
	
	local patOrigin = undefined -- Pattern origin
	local patWidth = undefined -- Pattern dimensions
	local patLength = undefined	
	
	local useGaps = undefined -- If gaps are used
	local useRot = undefined
	local useOff = undefined
	local useTilt = undefined -- If tilting is used
			
	local plankPos = #() -- UVW matrices for each plank, ID by matid	
	local plankRot = #() -- Plank rotation matrix
	local plankTilt = #() -- Plank tilt direction
	local plankTiltStr = #() -- Tilt strength
	local plankLenMin = #() -- Plank length min
	local plankLenMax = #() -- Plank length max
	local plankUOff = #()
	local plankVOff = #()
	
	local zAxis = [0,0,1]
	
	-- #################### // Parameters \\ ####################
	local p_Length
	local p_LengthR
	local p_Width
	local p_WidthR	
	local p_GapLength
	local p_GapWidth	
	local p_RowOffset
	local p_OffsetLength
	local p_OffsetWidth	
	local p_RandomX
	local p_RandomXR
	local p_RandomY
	local p_RandomYR
	local p_RandomYS
	local p_Tilt
	local p_TiltR	
	local p_RandomRot
	local p_RandomRotR
	local p_Weld
	local p_Extrude
	local p_Bevel
	local p_Outline
	local p_RestrictX
	local p_RestrictY
	
	fn evaluateParameters = (		
		local s = SPINNER_Scale.value / 100.
		p_Length 		= s * SPINNER_Length.value
		p_LengthR 		= if CHECK_LengthL.checked then p_Length else s * SPINNER_LengthR.value
		p_Width 		= s * SPINNER_Width.value
		p_WidthR 		= if CHECK_WidthL.checked then p_Width else s * SPINNER_WidthR.value
		p_GapLength 	= s * SPINNER_GapLength.value		
		p_GapWidth		= if CHECK_GapL.checked then p_GapLength else s * SPINNER_GapWidth.value	
		
		p_RandomX		= s * SPINNER_RandomX.value
		p_RandomXR		= if CHECK_MinL.checked then 0.0 else s * SPINNER_RandomXR.value
		
		if CHECK_RandomL.checked then (
			p_RandomY	= p_RandomX
			p_RandomYR	= p_RandomXR
			p_RandomYS	= SPINNER_RandomXS.value
		) else (
			p_RandomY	= s * SPINNER_RandomY.value
			p_RandomYR	= if CHECK_MinL.checked then 0.0 else s * SPINNER_RandomYR.value
			p_RandomYS	= SPINNER_RandomYS.value
		)
		
		p_Tilt			= s * SPINNER_Tilt.value
		p_TiltR			= if CHECK_MinL.checked then 0.0 else s * SPINNER_TiltR.value			
		
		p_RandomRot		= SPINNER_Rotation.value / 100.
		p_RandomRotR	= if CHECK_MinL.checked then 0.0 else SPINNER_RotationR.value / 100.
		
		p_Weld			= s * SPINNER_Weld.value		
		p_Extrude		= s * SPINNER_Extrude.value		
		p_Bevel			= s * SPINNER_Bevel.value		
		p_Outline		= if CHECK_BevelL.checked then p_Bevel else s * SPINNER_Outline.value				
		
		p_RestrictX 	= s * SPINNER_Overlap.value	+ p_GapLength
		p_RestrictY 	= s * SPINNER_Overlap.value	+ p_GapWidth
		
		p_OffsetLength 	= mod (s * SPINNER_OffLength.value) (p_Length + p_GapLength)
		p_OffsetWidth	= mod (s * SPINNER_OffWidth.value) (p_Width + p_GapWidth)		
		p_RowOffset 	= SPINNER_RowOffset.value / 100.		
		
		if p_RandomX > p_RestrictX * .5 then p_RandomX = p_RestrictX * .5
		if p_RandomXR > p_RestrictX * .5 then p_RandomXR = p_RestrictX * .5
		if p_RandomY > p_RestrictY * .5 then p_RandomY = p_RestrictY * .5
		if p_RandomYR > p_RestrictY * .5 then p_RandomYR = p_RestrictY * .5				
				
		useGaps = p_GapLength > 0.00001 and p_GapWidth > 0.00001 
		useRot = p_RandomRot > 0.00001
		useOff = (p_RandomX + p_RandomY) > 0.00001
		useTilt = p_Tilt > 0.00001
	)	
	
-- #############################################################################################
-- #################################/ Custom Attributes        \################################
-- #############################################################################################			
			
	fn storeSettings obj = (
		local floorGenAttributes = attributes floorGenStorage (
			parameters param (
				floorFloats type:#floatTab 		tabSizeVariable:true
				floorInts 	type:#intTab 		tabSizeVariable:true
				floorBools 	type:#boolTab 		tabSizeVariable:true
				floorNode 	type:#node 
			)
		)		
		
		custAttributes.add floorObject floorGenAttributes
		floorObject.floorFloats = #(
			SPINNER_Length.value,
			SPINNER_LengthR.value,				
			SPINNER_Width.value,
			SPINNER_WidthR.value,
			SPINNER_Rotation.value,
			SPINNER_RotationR.value,				
			SPINNER_RandomX.value,
			SPINNER_RandomXR.value,
			SPINNER_RandomY.value,
			SPINNER_RandomYR.value,
			SPINNER_Tilt.value,
			SPINNER_TiltR.value,

			SPINNER_LengthS.value,
			SPINNER_WidthS.value,
			SPINNER_GapLength.value,
			SPINNER_GapWidth.value,
			SPINNER_RotationS.value,
			SPINNER_RandomXS.value,
			SPINNER_RandomYS.value,
		
			SPINNER_TiltS.value,
			SPINNER_Scale.value,
			SPINNER_Overlap.value,
			
			SPINNER_Direction.value,
			SPINNER_OffLength.value,
			SPINNER_RowOffset.value,
			SPINNER_OffWidth.value,

			SPINNER_Weld.value,
			SPINNER_Extrude.value,
			SPINNER_Bevel.value,
			SPINNER_Outline.value				
		)
		floorObject.floorInts = #(
			SPINNER_Seed.value
		)
		floorObject.floorBools = #(
			CHECKBOX_FlipU.checked,
			CHECKBOX_FlipV.checked,
			CHECKBOX_OffU.checked,
			CHECKBOX_OffV.checked,
			CHECKBOX_Weld.checked,			
			CHECK_LengthL.checked,
			CHECK_WidthL.checked,
			CHECK_BevelL.checked,
			CHECK_GapL.checked,
			CHECK_RandomL.checked,
			CHECK_MinL.checked,
			CHECKBOX_Extrude.checked,
			CHECKBOX_Bevel.checked
		)
		floorObject.floorNode = obj
	)
	
	fn loadSettings obj = (
		local found = false
		if custAttributes.getDefs obj != undefined then
			for i in custAttributes.getDefs obj do
				if i.name == #floorGenStorage then
					found = true
		if found == false then return 0

		SPINNER_Length.value 		= obj.floorFloats[1]
		SPINNER_LengthR.value 		= obj.floorFloats[2]
		SPINNER_Width.value 		= obj.floorFloats[3]
		SPINNER_WidthR.value 		= obj.floorFloats[4]
		SPINNER_Rotation.value 		= obj.floorFloats[5]
		SPINNER_RotationR.value 	= obj.floorFloats[6]
		SPINNER_RandomX.value 		= obj.floorFloats[7]
		SPINNER_RandomXR.value 		= obj.floorFloats[8]
		SPINNER_RandomY.value 		= obj.floorFloats[9]
		SPINNER_RandomYR.value	 	= obj.floorFloats[10]
		SPINNER_Tilt.value		 	= obj.floorFloats[11]
		SPINNER_TiltR.value			= obj.floorFloats[12]

		SPINNER_LengthS.value 		= obj.floorFloats[13]
		SPINNER_WidthS.value 		= obj.floorFloats[14]
		SPINNER_GapLength.value 	= obj.floorFloats[15]
		SPINNER_GapWidth.value 		= obj.floorFloats[16]
		SPINNER_RotationS.value 	= obj.floorFloats[17]
		SPINNER_RandomXS.value 		= obj.floorFloats[18]
		SPINNER_RandomYS.value 		= obj.floorFloats[19]
	
		SPINNER_TiltS.value 		= obj.floorFloats[20]
		SPINNER_Scale.value 		= obj.floorFloats[21]
		SPINNER_Overlap.value 		= obj.floorFloats[22]
		
		SPINNER_Direction.value 	= obj.floorFloats[23]
		SPINNER_OffLength.value 	= obj.floorFloats[24]
		SPINNER_RowOffset.value 	= obj.floorFloats[25]
		SPINNER_OffWidth.value 		= obj.floorFloats[26]

		SPINNER_Weld.value 			= obj.floorFloats[27]
		SPINNER_Extrude.value 		= obj.floorFloats[28]
		SPINNER_Bevel.value 		= obj.floorFloats[29]
		SPINNER_Outline.value		= obj.floorFloats[30]		
				
		SPINNER_Seed.value = obj.floorInts[1]

		CHECKBOX_FlipU.checked		= obj.floorBools[1]
		CHECKBOX_FlipV.checked		= obj.floorBools[2]
		CHECKBOX_OffU.checked		= obj.floorBools[3]
		CHECKBOX_OffV.checked		= obj.floorBools[4]
		CHECKBOX_Weld.checked		= obj.floorBools[5]			
		CHECK_LengthL.checked		= obj.floorBools[6]
		CHECK_WidthL.checked		= obj.floorBools[7]
		CHECK_BevelL.checked		= obj.floorBools[8]
		CHECK_GapL.checked			= obj.floorBools[9]
		CHECK_RandomL.checked		= obj.floorBools[10]
		CHECK_MinL.checked			= obj.floorBools[11]
		CHECKBOX_Extrude.checked	= obj.floorBools[12]
		CHECKBOX_Bevel.checked		= obj.floorBools[13]
				
		objOld = obj.floorNode

		floorObjectOld = obj

		if not (isDeleted objOld) then
			LABEL_ObjName.text = "地板模型: < " + objOld.name + " >"			
			
		enableUI()
	)		

-- #############################################################################################
-- #################################/ Helper functions         \################################
-- #############################################################################################
	
	-- #################### // "Macros" \\ ####################
	fn createPolygon p1 p2 id = (
		local num = getNumVerts floorObject + 1
		setNumVerts floorObject (num + 3) true
		setVert floorObject (num  ) [p1.x,p2.y,0]
		setVert floorObject (num+1) p2
		setVert floorObject (num+2) [p2.x,p1.y,0]
		setVert floorObject (num+3) p1		
		meshop.createPolygon floorObject #(num, num+1, num+2, num+3) matID:id
		-- Bug in max sets the actual material id plus one the given value, matd id 1 becomes 2
	)	
	
	fn rnd = ( random .0 1.	)
	
	fn urnd = ( random -1. 1. )	
	
	fn flipCoin = ( random 0 1 == 0 )
	
	fn maxAngle w l g = (		
		local x = sqrt (w*w * .25 + l*l * .25)
		local m = (w + g) * .5
		if x < m then		
			return 180.0
		local a = atan (w / l)		
		local b = acos (m / x)		
		90.0 - a - b
	)
	
	fn spreadCurve spread val = (		
		if spread < 0.00001 then return 0.
		if spread > 0.99999 then return 1.
		if val < 1. - spread then
			return ((spread / (1. - spread)) * val)
		else		
			return ((1. - spread) * (val - 1.) / spread + 1.)
	)
	
	fn rand fromVal toVal spread = (
		fromVal + (toVal - fromVal) * (spreadCurve (rnd()) spread)
	)
		
	-- #################### // "Utilities" \\ ####################
	fn resetUtils = (
		timeLog = #()
	)	
	local timeLog = #()
	local timeLogIndent = 0
	fn timeStart eventName = (
		if not DEBUGMODE then return 0		
		for i in 0 to timeLogIndent do format "   "
		format "Start : %\n" eventName
		append timeLog #(eventName, timeStamp())
		timeLogIndent += 1
	)
	fn timeStop eventName = (		
		if not DEBUGMODE then return 0
		timeLogIndent -= 1
		for i in 0 to timeLogIndent do format "   "
		local elapsed = -1
		for i in timeLog where i[1] == eventName do
			elapsed = (timeStamp() - i[2]) / 1000.0
		format "Stop  : % : % seconds\n" eventName elapsed		
	)		

-- #############################################################################################
-- #################################/ Main Functions           \################################
-- #############################################################################################			
			
	-- #################### // Functions \\ ####################

	-- Creates floor node
	fn initNodes toNode oldFloor:undefined = (		
		-- Creates the floor object	
		if oldFloor != undefined then (
			floorObject = oldFloor
			-- Store modifiers
			oldModifiers = #()
			for i in 1 to floorObject.modifiers.count do 
				oldModifiers[i] = floorObject.modifiers[i]
			-- Delete modifiers
			while floorObject.modifiers.count > 0 do
				deleteModifier floorObject 1
			-- Clear geometry
			setMesh floorObject numverts:0 numfaces:0
			update floorObject
			floorObject.transform = matrix3 1
		) else (
			floorObject = editable_mesh name:(uniquename "Floor_Object")				
		)		
		
		-- Creates copy of the base object with no transformations
		-- World space == local space
		base = editable_mesh name:(uniquename "Floor_TemporaryObject")
		attach base (copy toNode)
		
		-- We asume floor resides on XY plane, Z values must be zero so
		zOffset = 0.0
		local xyPoint
		for i in 1 to getNumVerts base do (
			xyPoint = getVert base i
			zOffset += xyPoint.z
			xyPoint.z = 0.0
			setVert base i xyPoint
		)		
		zOffset /= getNumVerts base
	)
	
	-- Creates the floorSpace transformation matrix
	fn createMatrix3 p = (		
		local x = [1,0,0]		
		local y = [0,1,0]
		local z = [0,0,1]
		floorRotation = quat (SPINNER_Direction.value) z
		x *= floorRotation
		y *= floorRotation
		floorSpace = Matrix3 x y z p
	)
	
	-- Calculates bounding box for the floor	
	fn calcBoundingBox = (
		bb1 = (getVert base 1) * (inverse floorSpace)
		bb2 = (getVert base 1) * (inverse floorSpace)		
		
		local num = getNumVerts base
		local v
		for i in 1 to num do (
			v = getVert base i			
			v *= (inverse floorSpace)		
			if bb1.x < v.x then bb1.x = v.x
			else if bb2.x > v.x then bb2.x = v.x
			if bb1.y > v.y then bb1.y = v.y
			else if bb2.y < v.y then bb2.y = v.y
		)				
		bb1.z = bb2.z = 0		
		patOrigin = [bb2.x, bb1.y, 0]
		patWidth = bb2.y - bb1.y
		patLength = bb1.x - bb2.x		
	)
	
	-- Creates the floor pattern geometry
	fn createPattern_01 = (
		plankPos = #()
		plankRot = #()		
		plankTilt = #()
		plankLenMin = #()
		plankLenMax = #()
		
		local totalWidth = -p_Width - p_GapWidth + p_OffsetWidth
		local x,y,z,w,p1,p2,p3,p4,center,rot,q,minL,maxL,pX,pY,rX,rY,r,maxA,maxB,uvRand
		local row = 0
		local count = 1						
		local lengthPlusGap = p_Length + p_GapLength		
		while totalWidth < (patWidth + p_Width + p_GapWidth) do (
			x = rand p_WidthR p_Width (SPINNER_WidthS.value)
			y = p_GapWidth

			totalLength = mod (-(lengthPlusGap) * p_RowOffset * row) lengthPlusGap
			totalLength += -lengthPlusGap + p_OffsetLength
			
			while totalLength < (patLength + lengthPlusGap) do (
				z = rand p_LengthR p_Length (SPINNER_LengthS.value)
				w = p_GapLength

				-- Center offset				
				rX = (rand p_RandomX p_RandomXR (1.0 - SPINNER_RandomXS.value))
				rY = (rand p_RandomY p_RandomYR (1.0 - p_RandomYS))
				if flipCoin() then rX = -rX
				if flipCoin() then rY = -rY
				pX = totalLength - rX
				pY = totalWidth - rY
				
				-- Vertex positions
				p1 = [pX,   pY+x, 0] + patOrigin			
				p2 = [pX+z, pY,   0] + patOrigin								
				p3 = [p1.x,p2.y,0]				
				p4 = [p2.x,p1.y,0]	
				
				-- Create polygon and set material id
				createPolygon p1 p2 count		
	
				-- Create UVW transformation center
				center = [(pX+z/2.), (pY+x/2.), 0] + patOrigin	 
				plankPos[count] = center
				
				-- Create UVW offset
				if CHECKBOX_OffU.checked then (
					uvRand = (p_Length - z) *.5 / p_Length
					plankUOff[count] = random -uvRand uvRand					
				) else (random 0 1)
				if CHECKBOX_OffV.checked then (
					uvRand = (p_Width - x) *.5 / p_Width
					plankVOff[count] = random -uvRand uvRand
				) else (random 0 1)
					
				-- Calculate rotation amount
				if useRot then (
					r = rand p_RandomRot p_RandomRotR (1.0 - SPINNER_RotationS.value)					
					maxA = r * (maxAngle x z (p_RestrictY - 2. * abs rY))
					maxB = r * (maxAngle z x (p_RestrictX - 2. * abs rX))
					if maxA < maxB then
						if flipCoin() then
							plankRot[count] = maxA
						else
							plankRot[count] = -maxA
					else 
						if flipCoin() then
							plankRot[count] = maxB
						else
							plankRot[count] = -maxB
				) else (random 0 1;random 0 1)
				
				-- Calculate tiling direction and space				
				if useTilt then (										
					rot = random 0.0 360.0
					q = quat rot zAxis
					p1 -= center; p2 -= center; p3 -= center; p4 -= center;
					p1 *= q; p2 *= q; p3 *= q; p4 *= q					
					
					minL = maxL = p1.x
					if p2.x < minL then minL = p2.x else if p2.x > maxL then maxL = p2.x
					if p3.x < minL then minL = p3.x else if p3.x > maxL then maxL = p3.x
					if p4.x < minL then minL = p4.x else if p4.x > maxL then maxL = p4.x					
						
					plankTilt[count] = rot
					plankTiltStr[count] = rand p_Tilt p_TiltR (1.0 - SPINNER_TiltS.value)
					plankLenMin[count] = minL
					plankLenMax[count] = maxL - minL					
				) else (random 0 1;random 0 1)
				
				count += 1				
				totalLength += z + w
			)						
			
			row += 1
			totalWidth += x + y			
		)
	)
	
	fn applyMapping = (
		-- Clean the mesh		
		meshop.deleteIsoVerts floorObject

		-- This gives us 1:1 with map vertices and geometry vertices				
		meshop.makeMapPlanar floorObject 1

		local uvwMatrix = Matrix3 ([p_Length,0,0]) ([0,p_Width,0]) [0,0,1] [0,0,0]						
		local vertSel,o,p,matID,faceSel
		local faceDone = #{}		
		local vertDone = #{}
		faceDone.count = getNumFaces floorObject
		vertDone.count = getNumVerts floorObject
		local uFlip = #()
		local vFlip = #()
		local count = plankPos.count
		uFlip.count = vFlip.count = count		
		local groups = #()		
		local num = (getNumFaces floorObject)
		
		for i in 1 to count do append groups #()		
		for i in 1 to num do (						
			append groups[(getFaceMatID floorObject i) - 1] i
		)		
		for matID in 1 to count where groups[matID].count > 0 do (
			vertSel = meshop.getVertsUsingFace floorObject groups[matID]			
			
			if vertSel.count > 0 then (								
				o = plankPos[matID]
				uvwMatrix.row4 = o								
				if uFlip[matID] == undefined then
					uFlip[matID] = flipCoin()
				if vFlip[matID] == undefined then
					vFlip[matID] = flipCoin()
				
				for j in vertSel where vertDone[j] == false do (										
					vertDone[j] = true
					
					-- Set mapping					
					p = ((getVert floorObject j) * (inverse uvwMatrix))					
					p.x += .5
					p.y += .5					
					
					if CHECKBOX_FlipU.checked and uFlip[matID] then
						p.x = 1.0 - p.x						
					if CHECKBOX_FlipV.checked and vFlip[matID] then						
						p.y = 1.0 - p.y					
		
					if CHECKBOX_OffU.checked then
						p.x += plankUOff[matID]
				
					if CHECKBOX_OffV.checked then						
						p.y += plankVOff[matID]
					
					meshop.setMapVert floorObject 1 j p					
					
					-- Apply deformations										
					p = (getVert floorObject j) - o										
					if useTilt then if p.z > .001 then ( -- Tilt						
						p *= quat plankTilt[matID] zAxis						
						p.z += (p.x - plankLenMin[matID]) / plankLenMax[matID] * plankTiltStr[matID]						
						p *= quat -plankTilt[matID] zAxis
					)
					if useRot then -- Rotation
						p *= quat plankRot[matID] zAxis			
					setVert floorObject j (p+o)
				)				
			)			
		)
	)
	
-- #############################################################################################
-- #################################/ The "main"               \################################
-- #############################################################################################	
		
	-- #################### // Create Floor \\ ####################
	fn createFloor obj oldFloor:undefined = ( try (
		timeStart "Creating Floor"
		
		seed (SPINNER_Seed.value)
		resetUtils()
		timeStart "Initialize"
		disableSceneRedraw()		
		
		local p = obj.pos
				
		-- Evaluate scale
		evaluateParameters()					
		
		-- Create transformation matrix and quat for the floor
		createMatrix3 p
		
		-- Create helpers and empty floor geometry node
		initNodes obj oldFloor:oldFloor
				
		-- Calculate bounding box for base geometry
		calcBoundingBox()
		
		timeStop "Initialize"
		timeStart "Create pattern"
		
		-- Create the pattern geometry, planks
		createPattern_01()		
		
		timeStop "Create pattern"
		timeStart "Boolean"
		
		-- Move to correct place and intersect with base mesh		
		rotate floorObject (quat -SPINNER_Direction.value zAxis)
		floorObject.pos = [p.x, p.y, 0.0]
		addModifier base (Shell innerAmount:1. outerAmount:1.)
		floorObject * base

		timeStop "Boolean"
		timeStart "Weld, Extrude, Bevel"

		-- Weld	
		local all = #{}
		all.count = getNumVerts floorObject
		all = -all				
		if CHECKBOX_Weld.checked then
			meshop.weldVertsByThreshold floorObject all p_Weld		
		
		-- Extrude and bevel faces				
		all = #{}
		all.count = getNumFaces floorObject
		all = -all

		if CHECKBOX_Extrude.checked then
			meshop.extrudeFaces floorObject all p_Extrude 0.0 dir:zAxis		
		if CHECKBOX_Bevel.checked then
			meshop.extrudeFaces floorObject all p_Bevel (-p_Outline) dir:zAxis
		
		timeStop "Weld, Extrude, Bevel"
		timeStart "UVW, Tilt, Rotate"
		
		-- UVW Map		
		floorObject.pos = [0,0,0]
		rotate floorObject (quat SPINNER_Direction.value zAxis)		
		applyMapping()
		rotate floorObject (quat -SPINNER_Direction.value zAxis)
		floorObject.pos = [p.x, p.y, zOffset]
		
		timeStop "UVW, Tilt, Rotate"
		
		-- Clean up
		delete base		
		plankPos = #()
		plankRot = #()
		plankTilt = #()
		plankTiltStr = #()
		plankLenMin = #()
		plankLenMax = #()
		
		enableSceneRedraw()			
		storeSettings obj
		floorObjectOld = floorObject
		objOld = obj
		LABEL_ObjName.text = "地板创建在: < " + obj.name + " >模型上"
		timeStop "Creating Floor"
	) catch (
		format "Warning! Error occured while creating the floor!\n"
		enableSceneRedraw()
	))
	
	-- #################### // Update Floor \\ ####################
	fn updateFloor = (
		if floorObjectOld == undefined or objOld == undefined or isDeleted objOld then (
			format "There is no floor to update!\n"
			return 0				
		)
		if not (isDeleted floorObjectOld) then (
			--local col = floorObjectOld.wirecolor
			--local mat = floorObjectOld.material
			--local nam = floorObjectOld.name
			--delete floorObjectOld
			
			createFloor objOld oldFloor:floorObjectOld
			for i in 1 to oldModifiers.count do 
				addModifier floorObject oldModifiers[i] before:i
			oldModifiers = #()
			
			--floorObject.wirecolor = col
			--floorObject.material = mat
			--floorObject.name = nam
		) else (
			createFloor objOld
		)			
	)
	
	fn valChanged = (
		-- Mirror changes to locked values, length/width handled in limitUI()
		if CHECK_RandomL.checked then (
			SPINNER_RandomY.value = SPINNER_RandomX.value
			SPINNER_RandomYR.value = SPINNER_RandomXR.value
			SPINNER_RandomYS.value = SPINNER_RandomXS.value
		)
		if CHECK_BevelL.checked then (
			SPINNER_Outline.value = SPINNER_Bevel.value
		)
		if CHECK_GapL.checked then (
			SPINNER_GapWidth.value = SPINNER_GapLength.value
		)
		
		DEBUGMODE=false
		if CHECK_Update.checked then updateFloor()
	)

-- #############################################################################################
-- #################################/ Buttons                  \################################
-- #############################################################################################	
	on BUTTON_Create pressed do undo off (
		if selection.count == 0 then ( 
			format "Nothing selected!\n"
			return 0
		)
		DEBUGMODE=true
		createFloor selection[1]
	)
	
	on BUTTON_Update pressed do undo off (				
		DEBUGMODE=true
		updateFloor()
	)	
	
	on BUTTON_Load pressed do undo off (		
		if selection.count == 0 then ( 
			format "Nothing selected!\n"
			return 0
		)		
		loadSettings selection[1]
	)		
	
	on FloorGenerator open do enableUI()
)

-- #############################################################################################
-- #################################/ Initialize               \################################
-- #############################################################################################

-- #################### // Create Dialog \\ ####################
CreateDialog FloorGenerator lockWidth:true style:#(#style_toolwindow, #style_resizing, #style_sysmenu)
