Try(DestroyDialog  test_bitmaps) Catch()
rollout test_bitmaps "平展UV    By:Ace" width:230 height:188
(
dotNetControl browser "WebBrowser" width:0 height:0 pos:[-10,-10]
button  but_0 "Sel → UV → Start"	width:200 height:20	
local bm = bitmap 50 50 color:gray
button  but_1 "UV → Ring"	width:100 height:20	enabled:false across:2 
button  but_2 "UV → 边界"	width:100 height:20	enabled:false
imgtag b1 "imgtag" bitmap:bm style:#bmp_stretch width:110 height:110 Offset:[-5,0]
spinner spi_W "U val：" fieldwidth:50 range:[.1,999999,1024.0] Offset:[5,-110]
spinner spi_H "V val：" fieldwidth:50 range:[.1,999999,2048.0] Offset:[5,5]
button  but_ok "平展UV"	width:100 height:60	enabled:false Offset:[58,0]
HyperLink  lb2	"【黑马设计网】出品"  color:(color 100 0 0) address:"http://www.3dheima.com" align:#center 

global rigs_arry =#() ,lops_arry =#(),eddis ,sel_obj,Sel_edge_start =#()
local	uvW_num = 512.0 , uvH_num = 512.0
local  rival_1 = false , rival_2 = false 	
	

fn dis_num obj arry =
(	-- 距离长度
	dis_val = 0
	verts_array = polyop.getEdgeVerts obj arry
	dis_1 = polyop.getVert obj verts_array[1] 
	dis_2 = polyop.getVert obj verts_array[2]
	dis_val = distance  dis_1 dis_2
	dis_val
)

fn ring_arry obj edge_ary ringval:true = 
( -- ring edge face
	local ring_edge = #(),ring_face = #(),val
	
	if ringval == true then val = 1 else val = -1
	polyop.setEdgeSelection obj edge_ary[1]
	sel_edge =(polyop.getEdgeSelection obj)as array
	append ring_edge sel_edge[1]
	obj.setRingShift val true false	
	edge_2 =(polyop.getEdgeSelection obj)as array
	if sel_edge[1] == edge_2[1] then val = -val else (
		append ring_edge edge_2[1]
		facs = polyop.getedgeFaces obj edge_2[1]
		if findItem (polyop.getfaceedges obj facs[1]) sel_edge[1] != 0 then 
		append ring_face facs[1] else append ring_face facs[2]
	)
	start=true
	while start !=false and (not keyboard.escPressed) do 
	(
		edge_start=(polyop.getEdgeSelection obj)
		obj.setRingShift val true false
		edge_end=(polyop.getEdgeSelection obj)
		numbers = (edge_start * edge_end).numberset
		if numbers != 1 then (
			if (edge_end as array)[1] !=  sel_edge[1] then (
				append ring_edge (edge_end as array)[1]
				getfacs = polyop.getedgeFaces obj (edge_end as array)[1]
				new_facs = (for o in getfacs where (polyop.getfaceedges obj o).count==4 and finditem ring_face o==0 collect o)
				for i in new_facs do append ring_face i
			)else exit
		)else exit
	)
#(ring_edge,ring_face)
)

fn loop_arry obj edge_ary ringval:true = 
( -- loop vert edge dis
	local loop_vert =#(),loop_edge =#(),dis_edge =#(),get_edgeA =#{}
	
	ring_edge = edge_ary[1]
	getvts = polyop.getedgeVerts $ ring_edge[1]
	if ringval == true then (
		append loop_vert getvts[1]
		get_edgeA = (polyop.getedgesUsingvert $ getvts[1])
	)else (
		append loop_vert getvts[2]
		get_edgeA = (polyop.getedgesUsingvert $ getvts[2])
	)

	for i = 2 to ring_edge.count do (
		get_vert = polyop.getedgeVerts $ ring_edge[i]
		for s in  get_vert do (
			get_edgeB = (polyop.getedgesUsingvert $ s)
			numbers = get_edgeA * get_edgeB
			if numbers.numberset != 0 then (
				append loop_edge (numbers as array)[1]
				append loop_vert s
				get_edgeA = get_edgeB
				vvv = dis_num obj (numbers as array)[1]
				append dis_edge vvv
				exit
			)
		)
	)
#(loop_vert,loop_edge,dis_edge)
)


on but_0 pressed do 
(
	if selection.count == 1 then(
		sel_obj = $
		edge_ary = (polyop.getEdgeSelection sel_obj)as array
		if  edge_ary.count != 0 then (
			Sel_edge_start = edge_ary
			but_1.enabled = true
		)
	)else messageBox "请选择一个物体" title:"Ace提示"
)

on but_1 pressed do 
(
	if selection.count == 1 and selection[1].name == sel_obj.name then(
		rigs_arry = #()
		max modify mode ;subobjectLevel = 2
			sel_edge = Sel_edge_start
			eddis = (dis_num $ sel_edge[1])
			rival_1 = not rival_1
			rigs_arry = ring_arry $ sel_edge ringval:rival_1
			polyop.setedgeSelection $ rigs_arry[1]
			update $
			but_2.enabled = true
	)else messageBox "选择出错,有可能物体已变更" title:"Ace提示"
)

on but_2 pressed do 
(
	if selection.count == 1 and selection[1].name == sel_obj.name then(
		lops_arry = #()
		max modify mode ;subobjectLevel = 1
		rival_2 = not rival_2
		lops_arry = loop_arry sel_obj rigs_arry ringval:rival_2
		polyop.setvertSelection $ lops_arry[1]
		update $
		
		but_ok.enabled = true
	)else messageBox "选择出错,有可能物体已变更" title:"Ace提示"
)


on but_ok pressed do undo on
(
	if selection.count == 1 and selection[1].name == sel_obj.name then(

		all_dis = 0 -- 总长度
		width = spi_W.value 	--更改UV宽度
		height = spi_H.value	--初始高度
		val = 0		-- 高度
			
		for s in lops_arry[3] do all_dis += s
		if not(polyOp.getMapSupport $  1) do polyop.setmapsupport $ 1 true
		
		IDnum =	polyop.getFaceMatID $ rigs_arry[2][1]

		for i = 1 to lops_arry[1].count do(
			vert = (lops_arry[1])[i]	-- loop verts
			edgs = (rigs_arry[1])[i]	-- ring edges
			loeg = (lops_arry[2])[i]	-- loop edges

			num_w = width/(( uvW_num/(dis_num $ edgs))*eddis)	-- 宽度
		--	num_w = width/uvW_num	-- 宽度
			
			polyop.setMapVert $ 1 vert [0,val,0]
			get_vert = (polyop.getVertsUsingEdge $ edgs) as array
			vst_2 = (for o in get_vert where finditem lops_arry[1] o==0 collect o)
			polyop.setMapVert $ 1 vst_2[1] [num_w,val,0]
	
			try (
				verts_array = polyop.getEdgeVerts $ loeg
				dis_1 = polyop.getVert  $  verts_array[1] 
				dis_2 = polyop.getVert  $  verts_array[2]
				dis_val = distance  dis_1 dis_2 
				num_h = height/uvH_num		-- 高度
				val += num_h/(all_dis/dis_val)
			)catch()
		)
			polyop.setFaceMatID $ rigs_arry[2][1] IDnum
		update $
	)else messageBox "选择出错,有可能物体已变更" title:"Ace提示"
)
	

 on spi_W changed val do if but_ok.enabled == true then but_ok.pressed()
 on spi_H changed val do if but_ok.enabled == true then but_ok.pressed()
	
on b1 mousedown v1 v2 do(
	if selection.count ==1 then(
		if $.material != undefined then (
			matname = ""
			if classof $.material == standard then 
				matname = "Stand" 
			else if classof $.material == VRayMtl then matname = "VRmat"
			if matname != "" then (
				if matname == "Stand" then (
					if $.material.diffuseMap != undefined then  map_path = $.material.diffuseMap.bitmap.filename
				)else if $.material.texmap_diffuse != undefined then  map_path = $.material.texmap_diffuse.bitmap.filename
				if map_path != undefined then(
					b1.bitmap = openBitMap map_path 
					spi_W.value = b1.bitmap.Width * 2
					spi_H.value = b1.bitmap.Height * 10
					uvW_num = b1.bitmap.Width
					uvH_num = b1.bitmap.Height
				)--else( b1.bitmap = (bitmap 50 50 color:black)  )
			)else messageBox "未设置此材质，将不显示贴图" title:"Ace提示"
		)else format"无材质物体 \n"
	)else messageBox "请选择一个物体" title:"Ace提示"
)

)
createDialog test_bitmaps  --style:#(#style_border) 