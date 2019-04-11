
if ro_StrictlySelectSimilar != undefined do
	if classOf ro_StrictlySelectSimilar == RolloutClass do
		destroyDialog ro_StrictlySelectSimilar
rollout ro_StrictlySelectSimilar "相似模型【黑马设计网】出品" width:162 height:398
(
	local sObj = undefined
	
	mapped fn oldSizeComapre objArray srcObj isScale &outArray = (
		oldTM = objArray.transform
		oldScale = objArray.scale -- important fix !
		objArray.transform = srcObj.transform
		if isScale do objArray.scale = oldScale -- use original !
		if objArray.max - objArray.min == srcObj.max - srcObj.min do
			append outArray objArray
		objArray.transform = oldTM
	)
	-- get renderable shape mesh faces/verts
	fn getShapeMeshPolyCount obj = (
		oldState = obj.render_renderable -- keep rend. state
		obj.render_renderable = true -- set to true for next operation
		res = (getPolygonCount obj) as string -- get Real mesh (v,f) !
		obj.render_renderable = oldState -- restore state
		res -- return result
	)
	
	GroupBox grp1 "选择物体" pos:[4,7] width:154 height:46
	pickbutton chooseit "基础物体" pos:[11,26] width:140 height:21 autoDisplay:true
	GroupBox grp2 "相似性" pos:[4,58] width:154 height:220
	checkbox sameClass "类型 (层级)" pos:[13,77] width:128 height:15 checked:true
	radiobuttons filtByObjLevel "" pos:[38,97] width:79 height:32 labels:#("修改器 ", "基础物体 ") columns:1
	checkbox sameMtl "相同材质" pos:[13,132] width:100 height:15 checked:false
	radiobuttons filtByType "" pos:[38,151] width:86 height:64 labels:#("实体", "线型", "实体+线型", "所有") columns:1
	checkbox sameSize "相同尺寸" pos:[13,217] width:72 height:15 checked:true
	checkbox sameScale "排除缩放" pos:[33,237] width:72 height:15 enabled:true checked:true 
	checkbox sameMesh "相同网格(点/面)" pos:[13,257] width:137 height:15 checked:true
	GroupBox grp3 "排除" pos:[4,283] width:154 height:40
	checkbox noHidden "隐藏" pos:[13,302] width:48 height:15 checked:true across:2
	checkbox noFrozen "冻结" pos:[81,302] width:48 height:15 checked:true
	GroupBox grp4 "包含" pos:[4,328] width:154 height:40
	checkbox byLayer "激活的图层" pos:[13,347] width:117 height:15 checked:true
	button selSimilar "选择" pos:[11,373] width:140 height:21 enabled:false
	
	on ro_StrictlySelectSimilar open do
	(
		intSel = selection[1]
		if intSel != undefined do (
			chooseit.object = sObj = intSel
			selSimilar.enabled = true
		)
	)
	on chooseit picked obj do
	(
		if isValidNode obj do (
			sObj = obj
			selSimilar.enabled = true
		)
	)
	on chooseit rightClick do
	(
		chooseit.object = sObj = undefined
		selSimilar.enabled = false
	)
	on sameSize changed theState do
	(
		if theState then sameScale.enabled = true
			else (
				sameScale.enabled = false
				sameScale.checked = false
			)
	)
	on selSimilar pressed do
	(
		local sel = #()
		if byLayer.checked then -- check for layer opts
		(
			layer = LayerManager.current
			layer.nodes &sel
			picked = (findItem sel sObj)
			if picked != 0 do deleteItem sel picked
		)
		else
		(
			sel = objects as array -- get all
			deleteItem sel (findItem sel sObj) -- exclude picked
		)
		-- exclude hidden
		if noHidden.checked do (sel = for i in sel where not i.isHidden collect i)
		-- exclude frozen
		if noFrozen.checked do (sel = for i in sel where not i.isFrozen collect i)
		-- compare classes
		if sameClass.checked do (
			case filtByObjLevel.state of (
				1: (sel = for i in sel where classOf i == classOf sObj collect i)
				2: (sel = for i in sel where classOf i.baseObject == classOf sObj.baseObject collect i)
			)
		)
		-- compare material
		if sameMtl.checked do (
			sel = for i in sel where i.material == sObj.material collect i
			-- check other sub-options
			case filtByType.state of (
				1: (sel = for i in sel where isKindOf i GeometryClass and classOf i != Targetobject collect i)
				2: (sel = for i in sel where isShapeObject i collect i)
				3: (sel = for i in sel where isShapeObject i or (isKindOf i GeometryClass and classOf i != Targetobject) collect i)
				4: (sel = sel)
			)
		)
		-- compare 'size'
		if sameSize.checked do
		(
			-- if Max2008+ or AVG found will be used fast method !
			if nodeGetBoundingBox != undefined then
			(
				sel = for i in sel where (nodeGetBoundingBox i i.transform) as string == (nodeGetBoundingBox sObj sObj.transform) as string collect i
				if sameScale.checked do
					sel = for i in sel where i.scale == sObj.scale collect i
			)
			else -- alternative method for Max9 and below w/o AVG
			(
				local res = #()
				with redraw off (
					oldSizeComapre sel sObj sameScale.state &res
				)
				sel = res
			)
		)
		-- compare mesh (verts,faces)
		if sameMesh.checked do (
			local tmpArray = #(), sObjMesh
			-- setup picked object
			if isShapeObject sObj then (
				sObjMesh = getShapeMeshPolyCount sObj -- get Real mesh (v,f) !
			)
			else if classOf sObj == PolyMeshObject or classOf sObj == Editable_Poly then
			(
				sObjMesh = #(sObj.mesh.faces.count, sObj.mesh.verts.count) as string
			)
			else (sObjMesh = (getPolygonCount sObj) as string)
			-- collect similar meshes
			for i in sel do (
				if isShapeObject i then (
					rMesh = getShapeMeshPolyCount i
					if rMesh == sObjMesh do append tmpArray i -- get Real mesh (v,f) !
				)
				else if classOf i == PolyMeshObject or classOf i == Editable_Poly then
				(
					if #(i.mesh.faces.count, i.mesh.verts.count) as string == sObjMesh do append tmpArray i
				)
				else (if (getPolygonCount i) as string == sObjMesh do append tmpArray i)
			)
			sel = tmpArray -- assign result to sel
		)
		append sel sObj; select sel -- final step
		if nodeGetBoundingBox == undefined do redrawViews() -- additional fix for missed AVG
	)
)
CreateDialog ro_StrictlySelectSimilar 162 398 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
