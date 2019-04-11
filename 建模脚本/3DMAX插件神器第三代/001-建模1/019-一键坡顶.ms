-- RoofGen Copyright 2015 - 【黑马设计网】

(	-- start script
	
global mwRoofGeometry,mwRoofGeometryhelp
try destroyDialog mwRoofGeometry catch()
try destroyDialog mwRoofGeometryhelp catch()
global RGVersion = "1.22"
global fullVersion = ("v" + RGVersion + "  -  2015.5.14")
rollout mwRoofGeometry ("任意坡顶生成 v" + RGVersion) width:200
(
	fn geometryFilter obj = 
	(
		(superClassOf obj == shape)
	)	
		hyperLink hyp1 "【黑马设计网】出品" address:"http://www.3dheima.com" align:#center
		label lbl1 fullVersion
		hyperLink hyp2 "www.3dheima.com" address:"http://www.3dheima.com" align:#center
	group ""
	(
		--pickButton pbObject "Pick Outline Shape" width:180 height:25 filter:geometryFilter tooltip:"Roof Outline Shape"
		--spinner spnError "Error Threshold" width:110 height:16 range:[0.0,1.0,0.5] type:#float enabled:false
		spinner spnAngle "坡屋顶角度 " 	width:120 height:16 range:[5,60,30] type:#float align:#center offset:[10,0] across:2 
		button btn_help 	"?"			width:18 height:18 tooltip:"说明" align:#right
		button btnCreate "创建坡屋顶"	width:180 height:25 tooltip:"选择样条线后直接按此按钮创建" 
	)
	
	--local theObject
		
	fn splineCorners obj  =
	(
		converttosplineshape obj
		for i = 1 to (numsegments obj 1) do
		(
			setknottype obj 1 i #corner
		)
	)

	
	fn flattenShape splObj =
	(
		for s = 1 to (numSplines splObj) do
		(
			for k = 1 to (numKnots splObj s) do
			(
			  knt = in coordsys splObj getKnotPoint splObj s k
			  in_vec = in coordsys splObj getInVec splObj s k
			  out_vec = in coordsys splObj getOutVec splObj s k
			  knt.z = in_vec.z = out_vec.z = 0
			  in coordsys splObj setInVec splObj s k in_vec
			  in coordsys splObj setOutVec splObj s k out_vec
			  in coordsys splObj setKnotPoint splObj s k knt
			)--end k loop
		)--end s loop
		updateshape splObj
	)
	
	mapped fn createRoof splObj =
	(
		safeSize = ((splObj.max.x - splObj.min.x)+(splObj.max.y - splObj.min.y))/2
		roofAngle = spnAngle.value
		
		
		maxops.clonenodes splObj newnodes:&roofBorder
		converttosplineshape roofBorder[1]
		roofBorder[1].name = "temp_MW_roofGen_roof"
		roofBorder[1].position.z = 0
		splineCorners(roofBorder[1])
		flattenShape(roofBorder[1])
		roofBorder[1].render_displayRenderMesh = false
		converttopoly roofBorder[1]
		bevHeight = tan(roofAngle)*safeSize
		polyop.bevelfaces roofBorder[1] 1 bevHeight (safeSize*-1)
		polyop.deletefaces roofBorder[1] 1
		for i = polyop.getnumfaces roofBorder[1] to 1 by -1 do
		(
			polyop.detachfaces roofBorder[1] i delete:true asnode:true name:(uniquename("temp_MW_roofGen_Plane_"))
		)
		tempPlanes = for i = $temp_MW_roofGen_Plane_* collect i
		
		selArray = #()
		for i = 1 to tempPlanes.count do
		(									
			test = polyop.getsafefacecenter tempPlanes[i] 1
			if test == undefined then (append selArray tempPlanes[i])
			else ()
		)
		
		for i = 1 to selArray.count do
		(
			-- print selArray[i]
			moveVerts = undefined
			moveVerts = #()
			cutEdges = undefined
			cutEdges = #()
			for v = 1 to polyop.getnumverts selArray[i] do
			(
				if (polyop.getvert selArray[i] v).z != 0.0 do append moveVerts v
			)
			
			for s = 1 to 4 do
			(
				edgeverts = undefined
				edgeverts = #()
				edgeverts = polyop.getVertsUsingEdge selArray[i] s as array
				if (distance [(polyop.getVert selArray[i] edgeverts[1]).z,0.0] [(polyop.getVert selArray[i] edgeverts[2]).z,0.0]) > 0.01 do append cutEdges s
				--if ((polyop.getVert selArray[i] edgeverts[1]).z != (polyop.getVert selArray[i] edgeverts[2]).z) do append cutEdges s
			)
			polyop.createShape selArray[i] cutEdges[1] name:"TEMP_RoofGen_edge_01"
			polyop.createShape selArray[i] cutEdges[2] name:"TEMP_RoofGen_edge_02"
			edgeOne = getnodebyname "TEMP_RoofGen_edge_01"
			edgeTwo = getnodebyname "TEMP_RoofGen_edge_02"
			addmodifier edgeOne (Extrude())
			addmodifier edgeTwo (Extrude())
			edgeOne.modifiers[#Extrude].amount = safeSize*0.1
			edgeTwo.modifiers[#Extrude].amount = safeSize*0.1
			
			boolObj.createBooleanObject edgeOne
			boolObj.setBoolOp edgeOne 5
			boolObj.setBoolCutType edgeOne 1
			boolObj.SetOperandB edgeOne edgeTwo 4 2
			converttopoly edgeOne
			edgeIntersect = if (polyop.getVert edgeOne 5).z < (polyop.getVert edgeOne 6).z then (polyop.getVert edgeOne 5) else (polyop.getVert edgeOne 6) 
			delete edgeOne
				
			polyop.setvert selArray[i] moveVerts[1] edgeIntersect
			polyop.setvert selArray[i] moveVerts[2] edgeIntersect
			polyop.collapseverts selArray[i] #{moveVerts[1],moveVerts[2]}
		)
		
		for i = 1 to tempPlanes.count do
		(
			polyop.extrudefaces tempPlanes[i] 1 0.0
			move tempPlanes[i].faces[#{1}] [0,0,safeSize*3]
			polyop.capHolesByVert tempPlanes[i] 2
		)
		
		bools = #()
		
		for i = 2 to tempPlanes.count do
		(
			append bools tempPlanes[i]
		)
		-- BOOLEANING
		
		bCount = 0
		
		for b = 1 to bools.count do
		(
			if bCount == 15 then 
			(
				ProBoolean.SetOperandB tempPlanes[1] bools[b] 0 0
				converttopoly tempPlanes[1]
				bCount = 0
			)
			else
			(
				if bCount == 0 then (
					ProBoolean.createBooleanObjects tempPlanes[1] bools[b] 0 0 0
					bCount = bCount +1
				)
				else
				(
				ProBoolean.SetOperandB tempPlanes[1] bools[b] 0 0
				bCount = bCount +1
				)
			)
		)
		converttomesh tempPlanes[1]
		maxops.cloneNodes splObj newNodes:&borderObj
		borderObj[1].name = "temp_MW_roofGen_border"
		borderObj[1].position.z = 0
		splineCorners(borderObj[1])
		flattenShape(borderObj[1])
		
		addmodifier borderObj[1] (Extrude())
		borderObj[1].modifiers[#Extrude].amount = safeSize*2
		ProBoolean.createBooleanObject borderObj[1] tempPlanes[1] 2 0 0
		converttomesh borderObj[1]
		borderObj[1].name = uniquename("RoofGen_Geometry")
		select borderObj[1]
	)
	/*
	on pbObject picked obj do
	(
		pbObject.text = obj.name
		theObject = obj
		spnAngle.enabled = true
		--spnError.enabled = true
		btnCreate.enabled = true
		btnCreate.tooltip = "Create Roof"
			
		when obj deleted do
		(
			btnCreate.enabled = false
			btnCreate.tooltip = pbObject.text + " has been deleted!"
			pbObject.text = "Pick Outline Shape"
		)
		
	)
	*/
	on btnCreate pressed do
	(
		--if $ != undefined do deselect $
		arrShape = for i in selection where superclassof i == shape collect i
		if arrShape.count > 0 then
		(
			max create mode
			with redraw off
			(
				try
				(	undo off 
					(
						createRoof arrShape
						try (delete $temp_MW_roofGen*;delete $TEMP_RoofGen*) catch()
					)
				)
				catch
				(
					messagebox "产生错误，请检查样条线."
					delete $temp_MW_roofGen*
					delete $TEMP_RoofGen*
				)
			)
		)else messagebox "选择的物体中没有样条线物体."
	)
	on btn_help pressed do
	(
		try destroyDialog mwRoofGeometryhelp catch()
		rollout mwRoofGeometryhelp "任意坡顶生成器说明" width:320
		(
			group""
			(
				label lbl1 "" align:#center width:290 height:245
			)
			button btn_close "确定" width:100 height:22
			on mwRoofGeometryhelp open do
			(
				t = ""
				t += "　　　　　　　　　插件介绍　　　　　　　　　　　\n"
				t += "　本插件功能跟天正里面的任意坡顶的功能是一样的，\n"
				t += "但是在生成一些过于复杂屋顶时会出错，这时还是需要\n"
				t += "借助天正。\n\n"
				t += "　　　　　　　　　使用约定　　　　　　　　　　　\n"
				t += "　系统单位最好为厘米或者毫米，使用过大的单位时生\n"
				t += "成屋顶比较容易出错，这一点可自行测试。\n"
				t += "　样条线要封闭，可批量操作。\n\n"
				t += "　　　　　　　　　汉化说明　　　　　　　　　　　\n"
				t += "　原版插件操作方式比较逗逼，汉化时做了适当的修改\n"
				t += "操作起来更加流畅方便。\n\n\n"
				t += "本插件版权归原作者所有　　【黑马设计网】，欢迎传播\n\n"
				t += "　　　　望保留作者及汉化作者信息，谢谢　　　　　\n"
				lbl1.text = t
			)
			on btn_close pressed do
			(
				try destroyDialog mwRoofGeometryhelp catch()
			)
		)
		createDialog mwRoofGeometryhelp 
		--messagebox t beep:off title:"任意坡顶生成器说明"
	)
	
)	-- end rollout mwRoofGeometry


createDialog mwRoofGeometry

)	-- end script