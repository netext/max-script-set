
try(destroydialog Poly_edge_da) catch()
rollout Poly_edge_da "边 扩大【黑马设计网】出品" 
(
	spinner spi_1 "扩大距离:" fieldwidth:60 range:[-9999999,9999999,100] across:2  Offset:[20,0]
	checkbox chk_1 "保留线"  Offset:[40,0]
	button btn_ok  "确定" width:150 
	HyperLink  lb1	"【黑马设计网】出品"  align:#center color:(color 150 0 0) address:"http://www.3dheima.com" 
	local trues = false
	
fn edge_kuoda obj val = (
	obj.edgeExtrudeHeight = 1
	obj.edgeExtrudeWidth = 0
	obj.EditablePoly.buttonOp #Extrude
	obj.edgeExtrudeHeight = -val
	obj.edgeExtrudeWidth = 0
	obj.EditablePoly.buttonOp #Extrude
	obj.edgeExtrudeHeight = -1
	obj.edgeExtrudeWidth = 0
	obj.EditablePoly.buttonOp #Extrude
	edge1 = (polyop.getEdgeSelection obj) as array
	if chk_1.checked then (
		obj.setRingShift 2 false true  
		obj.setRingShift -2 false true
	) else (
		obj.setRingShift 3 false true  
		obj.setRingShift -3 false true
	)
	edge2 = (polyop.getEdgeSelection obj) as array
	edge_ab = (for o in edge2 where finditem edge1 o==0 collect o)
	polyop.setedgeselection obj edge_ab
	polyop.setVertSelection obj (polyop.getvertsUsingedge obj  edge_ab)
	obj.GrowSelection selLevel:#Vertex
	obj.GrowSelection selLevel:#Vertex
	obj.weldThreshold = 0.1
	obj.EditablePoly.weldFlaggedVertices()
	obj.EditablePoly.ConvertSelection #Edge #Vertex	
	obj.EditablePoly.Remove selLevel:#edge
	obj.EditablePoly.Remove selLevel:#Vertex
)	
	
fn edge_xiao obj val = (	
	obj.edgeExtrudeHeight = 0
	obj.edgeExtrudeWidth = -val
	obj.EditablePoly.buttonOp #Extrude
	obj.EditablePoly.ConvertSelection #Edge #face
	obj.setRingShift 1 false true  
	obj.setRingShift -1 false true
	obj.EditablePoly.delete #Face
	
)

on spi_1 changed val do	(
	if trues == true then (max undo;Poly_edge_da.btn_ok.pressed())
)

on btn_ok pressed do Undo on (
	if classOf $ == Editable_Poly then	(
		if  subObjectLevel == 2 or subObjectLevel == 3 do (
			edges = (polyop.getEdgeSelection $) as array
			if edges.count != 0 then (
				if spi_1.value > 0 then (
					edge_kuoda $ spi_1.value
				)else (
					edge_xiao $ spi_1.value
				)
				trues = true
			)
		)
	)
)

)
createDialog Poly_edge_da 230 70 
