try(Destroydialog Poly_Random_matID)catch()
rollout Poly_Random_matID "自定义马赛克 黑马设计网 出品" width:220 height:80
(
	spinner spi_1 "最少面数: "  fieldwidth:35 range:[1,30,4] type:#integer  across:2  Offset:[-5,0]
	spinner spi_2 "最多面数: "  fieldwidth:35 range:[1,30,10] type:#integer  Offset:[7,0]
	spinner ID_1 "随机ID范围："  fieldwidth:40 range:[1,30,1] type:#integer  across:2  Offset:[25,0]
	spinner ID_2 ""  fieldwidth:40 range:[5,30,5] type:#integer  Offset:[-10,0]
	button btn_ok "确认马赛克"   width:150 height:30

	local IDarry = #(),IDaay=#()
	
fn ringedgearry obj edge_ary ringval:true = (
	local val,vv = 1,IDaay=#()
	if ringval == true then val = 1 else val = -1
	edge_1 = edge_ary
	for i = 1 to IDarry.count do IDaay[i] = IDarry[i] 
	polyop.setedgeSelection obj edge_ary
	obj.setRingShift val true false	
	edge_2 =polyop.getEdgeSelection obj
	numbers = (edge_1 * edge_2).numberset 
	if numbers != 0 then (
		val = -val 
		polyop.setedgeSelection obj edge_1
	)else polyop.setedgeSelection obj edge_1
	numvalID = 0
	while (not keyboard.escPressed) do (
		local edge_start,edge_end,numbers,aa
		num = random  spi_1.value spi_2.value
		numID = random ID_1.value ID_2.value
	if vv-1 == 0 then (
		while numID == numvalID or numID == IDaay[vv] or numID == IDaay[vv+1] do numID = random ID_1.value ID_2.value
		aa = 1
	)else(
		if vv < IDarry.count then (
			while numID==numvalID or numID==IDaay[vv-1] or numID==IDaay[vv] or numID==IDaay[vv+1] do numID = random ID_1.value ID_2.value
			aa = 2
		)else (
			while numID == numvalID or numID == IDaay[vv-1] or numID == IDaay[vv] do numID = random ID_1.value ID_2.value
			aa = 3
		)
	)
		numvalID = numID
		IDarry[vv] = numID 
		vv += 1
		for s = 1 to num do (
			edge_start = (polyop.getEdgeSelection obj)
			obj.setRingShift val true false
			edge_end = (polyop.getEdgeSelection obj)
			numbers = (edge_start * edge_end).numberset
			if numbers == 0 then (
				fff = polyop.getfacesUsingedge obj (polyop.getEdgeSelection obj)
				polyOp.setFaceMatID obj fff numID
				
			) else exit
		)
		if numbers != 0 then exit
			
	)
)	 

fn loopedgearry obj edge_ary loopval:true = (
	local loop_edge = #(),val
	if loopval == true then val = 1 else val = -1
	edge_1 = edge_ary
	for i in edge_ary do append loop_edge i
	obj.setLoopShift val true false	
	edge_2 =polyop.getEdgeSelection obj
	numbers = (edge_1 * edge_2).numberset 
	if numbers != 0 then (
		val = -val 
		polyop.setedgeSelection obj edge_1
	)else (
		for i in edge_2 do append loop_edge i
	)
	while  (not keyboard.escPressed) do (
		edge_start = polyop.getEdgeSelection obj
		obj.setLoopShift val true false
		edge_end = polyop.getEdgeSelection obj
		numbers = (edge_start * edge_end).numberset
		if numbers == 0 then (
			if (edge_end * loop_edge as BitArray).numberset == 0 then (
				for i in edge_end do append loop_edge i
			)else exit --(for i in edge_end do append loop_edge i ; exit)
		)else exit
	)
	loop_edge
)	
	
	
on btn_ok pressed do undo on (
	if classOf $ == Editable_Poly then	(
		edges = (polyop.getEdgeSelection $) as array
		if edges.count == 1 then (
			if subobjectlevel == 2 then (
				loop_edge_arry = loopedgearry $ (polyop.getEdgeSelection $)
				for s in loop_edge_arry do (
					ringedgearry $ #{s}
				)
			)else messageBox "请选择子命令2" title:"黑马提示"
		)else messageBox "请选择Poly物体的一个边" title:"黑马提示"
	)
)

)
createdialog Poly_Random_matID





