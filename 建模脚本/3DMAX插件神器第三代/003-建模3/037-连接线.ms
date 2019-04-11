fn units_setup = 
(
	local arr = #(), unitsval, unit
	
	case units.SystemType of -- 获取当前单位系统名称
	(
		#inches:(unitsval=0.03937;unit="in")   ---英寸
		#feet:(unitsval=0.003280;unit="ft")    ---英尺
		#miles:(unitsval=1000.0;unit="μm")     ---微米
		#millimeters:(unitsval=1.0;unit="mm")  ---毫米
		#centimeters:(unitsval=0.1;unit="cm")  ---厘米
		#meters:(unitsval=0.001;unit="m")     ---米
		#kilometers:(unitsval=0.000001;unit="km")---千米
		default:(unitsval=1.0;unit="毫米")     ---毫米
	)
	append arr unitsval; append arr unit
	arr
)

try(destroydialog Poly_connect) catch()
rollout Poly_connect "连接线【黑马设计网】出品"
(
	spinner spi_1 "连接距离:" fieldwidth:60 range:[50,100000,1000]  Offset:[60,0] across:2	
	hyperlink lab1 "mm"  color:(color 200 0 0) Offset:[65,0]	enabled:false
	button btn_ok  "确定" width:150 
	hyperlink hlk_text "黑马设计网改版" Align:#center color:Red hoverColor:blue visitedColor:green address:"http://www.3dheima.com"
	
	local loadUnits = units_setup()
	local edge_arry = #(), backArr = #()
	local connect_edge = #()
	
	on Poly_connect open do 
	(
		lab1.text = loadUnits[2]
	)
		
	on btn_ok pressed do undo on 
	(
		if classOf $ == Editable_Poly and subObjectLevel == 2 then	(
			loadUnits = units_setup(); lab1.text = loadUnits[2]
			connect_edge = #()
			edge_arry = polyop.getEdgeSelection $ as array
			if backArr.count == 0 do backArr = deepCopy edge_arry
			if edge_arry.count != 0 then (
				for i in edge_arry do(
					polyop.setedgeSelection $ i
					$.SelectEdgeRing ()
					verts_array = polyop.getEdgeVerts $ i
					dis_1 = polyop.getVert  $  verts_array[1] 
					dis_2 = polyop.getVert  $  verts_array[2]
					dis_val = distance  dis_1 dis_2 
					val_num = dis_val/(spi_1.value*loadUnits[1])
					num_1 = (dotNetObject "System.Single" val_num).toString "0.0" as float
					num = (dotNetObject "System.Single" num_1).toString "0" as float	-- 精确到 后一位数值
					$.connectEdgeSegments = num-1
					$.ConnectEdges ()
					for s in (polyop.getEdgeSelection $)do append connect_edge s
				)
				polyop.setedgeSelection $ connect_edge
				completeRedraw()
				cc = true
			)
		) else messageBox "操作错误" title:"Ace提示"
	)

	on spi_1 changed val do
	(
		if classOf $ == Editable_Poly and subObjectLevel == 2 then	(
			if backArr.count != 0 then (
				if keyboard.controlPressed then
				(
					$.Remove()
					polyop.setedgeSelection $ backArr
				)
				else
				(
					if classOf $ == Editable_Poly and subObjectLevel == 2 then	
					(
						edge_1 = polyop.getEdgeSelection $
						vert_1 = polyop.getvertsUsingedge $ edge_1
						$.Remove selLevel:#Edge
						polyop.setvertSelection $ vert_1
						$.Remove selLevel:#Vertex
						polyop.setedgeSelection $ backArr
					)
				)
				btn_ok.pressed()
			)else btn_ok.pressed()
		)
	)
)
createDialog Poly_connect 180 70 style:#(#style_toolwindow,#style_sysmenu)