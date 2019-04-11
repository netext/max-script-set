try(destroydialog Poly_ruanbao) catch()
rollout Poly_ruanbao "黑马设计网-软包制作" width:280 height:185
(
	button btn_sel  "黑马设计网 选 棋格点" width:150  Offset:[15,0] across:2
	checkbox chk_s "忽略边缘点"   width:90 Offset:[40,3] checked:true tooltip:"拼条制作"
	spinner spi_1 "软包纽扣宽度: " fieldwidth:40 range:[0,9999,100]  type:#worldunits  Offset:[-5,3] across:2
	spinner spi_11 "软包纽扣深度: " fieldwidth:40 range:[-9999,9999,-80]  type:#worldunits Offset:[8,3]
	spinner spi_2 "软包拼缝宽度: " fieldwidth:40  range:[0,9999,30]  type:#worldunits  Offset:[-5,3] across:2
	spinner spi_22 "软包拼缝深度: " fieldwidth:40  range:[-9999,9999,-30]  type:#worldunits 	Offset:[8,3]
	checkbox chk_1 "制作纽扣:→"   width:130 Offset:[5,0] across:2 checked:true tooltip:"纽扣制作"
	spinner spi_r "软包纽扣大小: " width:160 range:[0,9999,40] Offset:[-15,0]  type:#worldunits
	checkbox chk_2 "制作拼条:→"   width:130 Offset:[5,0] across:2 checked:true tooltip:"拼条制作"
	spinner spi_wh "软包拼条大小: " width:160 range:[0,9999,5] Offset:[-15,0]  type:#worldunits
	spinner spi_3 "软包突出距离: " width:160 range:[-9999,9999,300]  type:#worldunits Offset:[10,0] across:2
	spinner spi_S "细分级别: " fieldwidth:30 range:[1,3,2]  type:#integer
	checkbox chk_E "菱形连边"   width:80 Offset:[-5,3] checked:true across:3 tooltip:"自动连边" 
	button btn_ok  "确    定" width:120 height:23 Offset:[10,0] 
	checkbox chk_G "修改"   width:50 Offset:[40,3] tooltip:"修改数据"
	
	HyperLink  lb1	"www.3dheima.com"  align:#center color:(color 150 0 0) address:"http://www.3dheima.com" 

local ruanbaooo , pintiaooo , niukouoo ,objary = #() ,posarry = #()	
	
fn openvert obj = (
	verts = #()
	opeedge  = (polyop.getOpenEdges $)as array
	verts = polyop.getvertsUsingedge obj opeedge
	verts
)
fn Invert_vert obj = (
	allvert = #{1..(polyop.getNumVerts obj)}
	getedges = polyop.getEdgeSelection obj
	verts = polyop.getVertsUsingedge $ getedges
	faces = polyop.getFacesUsingVert $ verts
	verts = polyop.getVertsUsingFace $ faces
	vvv = (for o in allvert where finditem verts o==0 collect o)	
	vvv
)
on chk_1 changed state do spi_r.enabled =  state
on chk_2 changed state do spi_wh.enabled =  state

on spi_r changed val do Undo on(
	if chk_G.checked then (
		if niukouoo != undefined then (
			try(
				objary = #() ; delete niukouoo
				for p in posarry do (
					copyobj = Sphere radius:val segs:8 pos:p
					append objary copyobj
				)
				niukouoo = ConverttoPoly objary[1]
				for i = 2 to objary.count do objary[1].EditablePoly.attach objary[i] objary[1]
				niukouoo.material = ruanbaooo.material
			)catch()
		)
	)
)
on spi_wh changed val do Undo on(
	if chk_G.checked then (
		if pintiaooo != undefined then (
			try(pintiaooo.modifiers[#Sweep][#Cylinder_Section].radius = val)catch()
		)
	)

)
on spi_3 changed val do Undo on(
	if chk_G.checked then (
		if ruanbaooo != undefined then (
			try(ruanbaooo.modifiers[#Push].Push_Value = val)catch()
		)
	)
)
on spi_S changed val do Undo on(
	if chk_G.checked then (
		if ruanbaooo != undefined then (
			try(ruanbaooo.modifiers[#MeshSmooth].iterations = val)catch()
		)
	)	
)

on btn_sel pressed do Undo on (
	if selection.count == 1 and (classof $) == Editable_Poly then (
		verts = (polyop.getVertSelection $)as array
		maxver = if ((maxVersion())[1]/1000) < 12 then true else false 
		if subobjectlevel == 1 and verts.count == 1 then(
			allvert = (#{1..(polyop.getNumVerts $)}) as array
			try(
				while (not keyboard.escPressed) do (
					vert_1 = (polyop.getVertSelection $)as array
					if maxver then macros.run "PolyBoost" "Checker" 
						else macros.run "PolyTools" "Checker"
					vert_2 = (polyop.getVertSelection $)as array
					if vert_1.count + vert_2.count == allvert.count then exit
				)
				if chk_s.checked then (
					vertss = polyop.getVertSelection $
					openvv = openvert $
					vvv = (for o in vertss where finditem openvv o==0 collect o)	
					polyop.setVertSelection $ vvv
				)
				update $
			)catch(messageBox "错误： 未找到PB插件 " title:"Ace提示")
		)else (messageBox "请先选择1个点做为参考" title:"Ace提示")
	)
)
on btn_ok pressed do Undo on (
	if selection.count == 1 and (classof $) == Editable_Poly then (
		objary = #() ; obj = ruanbaooo = $
		verts = (polyop.getVertSelection $)as array
		if subobjectlevel == 1 and verts.count != 0 then(
			vert_1 = polyop.getVertSelection obj
			if chk_E.checked then(
				obj.EditablePoly.ConnectVertices ()
			)else (
				edges = polyop.getedgesUsingvert obj vert_1
				obj.tesselateBy = 1
				obj.EditablePoly.tessellate #Vertex
				polyop.setedgeSelection obj edges
				polyop.setvertSelection obj vert_1
			)
			obj.vertexExtrudeHeight = spi_11.value
			obj.vertexExtrudeWidth = spi_1.value/2
			obj.EditablePoly.buttonOp #Extrude
			polyop.setVertSelection obj vert_1
			subobjectLevel = 2
			obj.edgeExtrudeHeight = spi_22.value
			obj.edgeExtrudeWidth = spi_2.value/2
			obj.EditablePoly.buttonOp #Extrude
			obj.EditablePoly.collapse #Vertex
			getverts = polyop.getVertSelection obj
			pushvert = Invert_vert obj
			openvv = openvert obj
			vvv = (for o in pushvert where finditem openvv o==0 collect o)	
			polyop.setVertSelection obj vvv
			subobjectLevel = 1
			modPanel.addModToSelection (Push ()) ui:on
			obj.modifiers[#Push].Push_Value = spi_3.value
			modPanel.addModToSelection (meshsmooth ()) ui:on
			obj.modifiers[#MeshSmooth].subdivMethod = 2
			obj.modifiers[#MeshSmooth].iterations = 2
			modPanel.addModToSelection (Edit_Poly ()) ui:on	
			if chk_1.checked then (
				for p in getverts do (
					pos = polyop.getVert obj p
					append posarry pos
					copyobj = Sphere radius:spi_r.value segs:8 pos:pos
					append objary copyobj
				)
			niukouoo = ConverttoPoly objary[1]
				for i = 2 to objary.count do objary[1].EditablePoly.attach objary[i] objary[1]
				niukouoo.material = obj.material	
			)
			if chk_2.checked then (
				try(
				obj.modifiers[#Edit_Poly].CreateShape "tiaoShape"
				select $tiaoShape;tiao_new = pintiaooo = $;tiao_new.name = "软包拼条"
				modPanel.addModToSelection (sweep ()) ui:on
				tiao_new.modifiers[#Sweep].CurrentBuiltInShape = 4
				tiao_new.modifiers[#Sweep][#Cylinder_Section].steps = 3	
				tiao_new.modifiers[#Sweep][#Cylinder_Section].radius = spi_wh.value
				tiao_new.modifiers[#Sweep].PivotAlignment = 4
				)catch(format " 出错 选择不当 \n")
			)
			obj.name = uniquename "软包";select obj
		)
	)
)


)
createDialog Poly_ruanbao 
