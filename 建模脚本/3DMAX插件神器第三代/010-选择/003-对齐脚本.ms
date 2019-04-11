rollout 对齐到物体表面 "对齐到物体表面" width:179 height:97
(
	button btn4 "对齐到物体表面" pos:[20,6] width:136 height:27
	label lbl1 "先选需要操作的物体，然后点对齐按钮，最后选择需要对齐到的物体表面【黑马设计网】" pos:[6,50] width:167 height:47
	on btn4 pressed do
	(
	
		obj=getCurrentSelection()
		num_obj=obj.count
		do (
			surf=pickObject prompt:"Select a floor surface" 
			isObj=findItem (geometry as array) surf
			if isObj == 0  do  messageBox "请选择几何体" title:"选择错误"
		   )
		while isObj == 0
		for i=1 to num_obj do
			(
				try (
					pMin= obj[i].min
					pMax= obj[i].max
					rayC=ray [(pMin.x+0.5*(pmax.x-pmin.x)),(pMin.y+0.5*(pmax.y-pmin.y)),(100+surf.max.z)] [0, 0, -1]
					pSurf=intersectRay surf rayC
					move obj[i] [0,0,(pSurf.position.z-pMin.z)]
					)
				 catch continue
			)
	
	)
)
createdialog 对齐到物体表面 style:#(#style_minimizebox, #style_titlebar, #style_sysmenu)
