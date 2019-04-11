-- 原名 Contour Generator
-- http://www.3dheima.com

try(destroyDialog contourRol)catch()
rollout contourRol "Contour 截面轮廓提取" width:200
(
	local sourceObjs = #()
	fn pickFilt o = superclassof o == geometryClass and findItem sourceObjs o == 0
	
	groupBox sourceGB "提取对象来源" pos:[5,5] width:190 height:135
	listBox sourceList "" pos:[10,23] width:180 height:6
	pickButton objPick "拾取" filter:pickFilt width:60 height:22 pos:[10,109]
	button objAdd "添加..." width:60 height:22 pos:[70,109]
	button objRem "移除" width:60 height:22 pos:[130,109]
		
	groupBox axisGB "提取轴向" width:190 height:35 pos:[5,140] 
	radioButtons axis "" labels:#("X    ","Y    ","Z") pos:[12,155]
	
	groupBox numGB "数量" width:190 height:55 pos:[5,179]
	radioButtons segType "" labels:#("总计","间隔") columns:1 pos:[12,195]
	spinner totalSpn "" type:#integer range:[1,1000,20] pos:[100,195] width:90
	spinner spacingSpn "" type:#worldUnits range:[0.001,1000000.0,1.0] enabled:off pos:[100,212] width:90
	
	groupBox splineOptions "样条线" width:190 height:109 pos:[5,235]
	checkBox weldChk "焊接顶点" pos:[12,255] checked:on
	spinner weldSpn "" type:#worldUnits range:[0,1000000.0,0.01] pos:[100,255] width:90
	checkBox normalizeChk "间距规格化" pos:[12,298] 
	spinner normalizeSpn "" type:#float range:[1.0,1000000.0,2] pos:[100,298] width:90
	checkBox closeSpln "关闭样条线" pos:[12,275]
	checkBox attachSpln "塌陷为一个样条线对象" pos:[12,320] checked:on
	
	
-- 	groupBox modifyGB "样条线可渲染" width:190 height:115 pos:[5,345]
-- 	dropDownList outputDD "" items:#("不渲染","渲染(径向)","渲染(矩形)") width:180 pos:[10,363]
-- 	
-- 	spinner rendRadThickness "厚度:" type:#worldUnits range:[0.001,10000000.0,1.0] fieldwidth:70 pos:[40,390] visible:off
-- 	spinner rendRadSides "    边:" type:#integer range:[3,100,12] fieldwidth:70 pos:[40,410] visible:off
-- 	spinner rendRadAngle "角度:" type:#float range:[-10000000.0,10000000.0,0.0] fieldwidth:70 pos:[40,430] visible:off
-- 	
-- 	spinner rendRectLength "长度:" type:#worldUnits range:[0.001,10000000.0,1.0] fieldwidth:70 pos:[40,390] visible:off
-- 	spinner rendRectWidth "宽度:" type:#worldUnits range:[0.001,10000000.0,1.0] fieldwidth:70 pos:[40,410] visible:off
-- 	spinner rendRectAngle "角度:" type:#float range:[-10000000.0,10000000.0,0.0] fieldwidth:70 pos:[40,430] visible:off
	
	button create "生成截面轮廓线" enabled:off pos:[5,350] width:190 height:30
	hyperLink helphl2 "原作者 rotem 地址" color:(color 160 25 25) address:"http://www.3dheima.com" align:#center hovercolor:(color 160 25 25) visitedcolor:(color 160 25 25)
	hyperLink helphl1 "黑马设计网 地址" color:(color 160 25 25) address:"http://www.3dheima.com" align:#center hovercolor:(color 160 25 25) visitedcolor:(color 160 25 25)
	
	
-- 	fn setRenderability shap =
-- 	(
-- 		shap.render_renderable = shap.render_displayRenderMesh = outputDD.selection > 1
-- 		if outputDD.selection == 2 then
-- 		(
-- 			shap.render_rectangular = off
-- 			shap.render_thickness = rendRadThickness.value
-- 			shap.render_sides = rendRadSides.value
-- 			shap.render_angle = rendRadAngle.value
-- 		)
-- 		else
-- 		(
-- 			shap.render_rectangular = on
-- 			shap.render_aspect_locked = off
-- 			shap.render_length = rendRectLength.value
-- 			shap.render_width = rendRectWidth.value
-- 			shap.render_angle2 = rendRectAngle.value
-- 		)
-- 	)
-- 	
	fn treeAttach objs =
	(
		for x = 1 to (ceil (pow objs.count 0.5)) do
		(
			for i = 1 to (objs.count/2) do
			(
				addAndWeld objs[i] objs[i+1] 0.0
				deleteItem objs (i+1)
			)
		)
		objs[1]
	)
	
	on objPick picked o do if isValidNode o do 
	(
		append sourceObjs o
		sourceList.items = append sourceList.items o.name
		create.enabled=on
	)
	
	on objAdd pressed do
	(
		local newObjs = (selectByName title:"选择来源对象" filter:pickFilt)
		if newObjs!=undefined do
		(
			sourceObjs+=newObjs
			sourceList.items+=for n in newObjs collect n.name
		)
		create.enabled=sourceObjs.count>0
	)
	
	on objRem pressed do
	(
		if sourceList.selection > 0 do 
		(
			deleteItem sourceObjs sourceList.selection
			sourceList.items = deleteItem sourceList.items sourceList.selection			
		)
		create.enabled=sourceObjs.count>0
	)
	
	on segType changed state do 
	(
		totalSpn.enabled = state==1
		spacingSpn.enabled = state==2
	)
	
	on weldChk changed state do
	(
		weldSpn.enabled = closeSpln.enabled = state
	)
	on normalizeChk changed state do normalizeSpn.enabled = state
	
	on outputDD selected arg do
	(
		for c in contourRol.controls where matchPattern c.name pattern:"rendRad*" do c.visible = outputDD.selection==2
		for c in contourRol.controls where matchPattern c.name pattern:"rendRect*" do c.visible = outputDD.selection==3
	)
	
	on create pressed do
	(
		local badObjs = for o in sourceObjs where not isValidNode o collect 1
		if badObjs.count>0 do return (messageBox (badObjs.count as string+" 无效或删除对象."))
		for o in sourceObjs where o.isHiddenInVpt do unhide o
		local otherObjs = for o in objects where not o.isHiddenInVpt  and findItem sourceObjs o == 0 collect o
		hide otherObjs
		select sourceObjs
		local minP = case axis.state of
		(
			1:(selection.min.x)
			2:(selection.min.y)
			3:(selection.min.z)
		)
		local maxP = case axis.state of
		(
			1:(selection.max.x)
			2:(selection.max.y)
			3:(selection.max.z)
		)
		local delta = if segType.state==1 then (maxP - minP) / (totalSpn.value) else spacingSpn.value
		local total = if segType.state==1 then totalSpn.value else (((maxP-minP)/spacingSpn.value) as integer)
		local sRotation = case axis.state of
		(
			1:(quat 0 -0.707107 0 0.707107)
			2:(quat -0.5 -0.5 -0.5 0.5)
			3:(quat 0 0 0 1)
		)
		progressStart ("Generating "+total as string+" contours.")
		local count = 0
		local singleShape
		local contourShapes=#()
		local normalizeMod = Normalize_Spline length:(normalizeSpn.value)
		for currentP = minP to maxP by delta do
		(			
			local p3 = case axis.state of
			(
				1:([currentP,0,0])
				2:([0,currentP,0])
				3:([0,0,currentP])				
			)
			local s = section rotation:sRotation name:(uniqueName "Contour")
			s.pos = p3
			redrawViews()
			convertToSplineShape s
			if weldChk.checked do
			(
				for spl = 1 to s.numSplines do
				(
					setKnotSelection s spl (for k = 1 to (numKnots s spl) collect k)
				)
				weldSpline s 0.001
				weldSpline s weldSpn.value
				updateShape s
				for spl = 1 to s.numSplines do
				(
					for k = 1 to (numKnots s spl) do setKnotType s spl k #corner
				)
			)
			if weldChk.checked and closeSpln.checked do
			(
				for spl = 1 to s.numSplines do close s spl
				updateShape s
			)
			if normalizeChk.checked do
			(
				addModifier s normalizeMod
				convertToSplineShape s
			)
			if not attachSpln.checked then setRenderability s else s.render_displayRenderMesh=off
			append contourShapes s
			count+=1			
			progressUpdate ((count as float/total)*100)
			if (getProgressCancel()) do exit
		)
		if attachSpln.checked then
		(
			local single = (treeAttach contourShapes)
-- 			setRenderability single
			select single
			single.name = uniqueName "Contour"
			(
	        for m in selection do m.pivot=[m.center.x,m.center.y,m.min.z]
			)
		)
		
		else select contourShapes
		unhide otherObjs
		progressEnd()
	)
)
createDialog contourRol