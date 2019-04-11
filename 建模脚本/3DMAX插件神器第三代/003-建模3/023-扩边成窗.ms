try(destroydialog Poly_edge_chuang) catch()
rollout Poly_edge_chuang "扩边成窗 黑马设计网" 
(
	spinner spi_1 "宽度:" fieldwidth:60 range:[0,9999,50] across:2  Offset:[-5,0]
	spinner spi_2 "厚度:" fieldwidth:60 range:[0,9999,50] -- Offset:[20,0]
	button btn_ok  "确定" width:150 
HyperLink  lb1	"【黑马设计网】出品"  align:#center color:(color 150 0 0) address:"http://www.3dheima.com" 

on btn_ok pressed do Undo on (
	if selection.count == 1 and (classof $) == Editable_Poly then (
		if subobjectlevel == 2 or subobjectlevel == 3 then(
			edges = (polyop.getEdgeSelection $) as array
			if edges.count != 0 then (
				$.edgeChamferSegments = 1
				$.edgeChamferOpen = off
				new_obj = copy $
				face1 = #{1..(polyop.getNumFaces new_obj)}as array
				new_obj.EditablePoly.chamferEdges (spi_1.value/2)
				face2 =  #{1..(polyop.getNumFaces new_obj )}as array
				polyop.setfaceselection new_obj (for o in face1 where finditem face2 o!=0 collect o)
				new_obj.EditablePoly.delete #Face
				addModifier new_obj (Shell ()) ui:on
				new_obj.modifiers[#Shell].outerAmount = (spi_2.value/2)
				new_obj.modifiers[#Shell].innerAmount = (spi_2.value/2)
				new_obj.modifiers[#Shell].straightenCorners = on
			)
		)
	)
)

)
createDialog Poly_edge_chuang 230 70 

