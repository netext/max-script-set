try destroydialog zywood catch()
rollout zywood "简易树桩_黑马"
(
	local tfa = 0,tfb = 0,wd
	--
	group "黑马设计网制定_V0.2"
	(
	spinner wdg "树桩高度" pos:[10,25] width:140 range:[0.1,9999999,1400] type:#worldunits
	spinner wdr "树桩大小"  pos:[10,45] width:140 range:[0.1,9999999,400] type:#worldunits
	spinner wds "树桩精度"  pos:[10,65] width:140 range:[1,10,3] type:#integer
	spinner zjv "枝节密度"  pos:[10,85] width:140 range:[1,100,50] type:#integer
	spinner zdx "枝节粗细" pos:[10,105] width:140 range:[1,10,5] type:#integer
	spinner zcd "枝节长度" pos:[10,125] width:140 range:[0.1,9999999,200] type:#worldunits
	spinner ccv "肌理大小" pos:[10,145] width:140 range:[1,100,30] type:#integer
	button add "↑" pos:[10,165] width:10 height:30
	button doit "刷新树桩样式" width:80 height:30 pos:[20,165]
	button yesdo "确认生成" width:60 height:30 pos:[100,165]
	)
	hyperlink hszt "室内设计交流论坛［黑马设计网］" color:red address:"www.3dheima.com" pos:[5,205]
	activeXControl ax "http://www.3dheima.com" align:#left width:160 height:20 pos:[5,225]
	---
	fn fl_ifSelectPoly =
	(
		if fl_JudgeTheSelection() == 1 then return true
		else (
		messagebox "请选择一个EPoly物体并设置当前修改器在Editable Poly下！" title:fl_tips01 beep:off
		return false
		)
	)
	---
	on doit pressed do
	(
		try delete wd catch()
		--
		wd = Cone smooth:on heightsegs:(wds.value * 2) sides:(wds.value * 4) height:wdg.value radius1:(wdr.value/2) radius2:((wdr.value/2) * 0.7)
		wd.name = uniqueName "云梦wood"
		convertto wd (editable_poly)
		tFa = polyOp.getNumfaces wd
		--
		select wd
		max modify mode
		subobjectLevel = 1
		(
			tV = polyOp.getNumVerts $  --total vertexs
			sB = #()
			while sB.count/tV as float*100 < (zjv.value/5) do --collect select vertexs
			(
				tI = random 1 tV
				if finditem sB tI == 0 then
				(
					append sB tI
				)
			)-- end while
			polyOp.setVertSelection $ (sB as bitarray)
			
		)
		--
		$.vertexChamfer = ((wdr.value*pi)/(wds.value*40))*zdx.value
		$.EditablePoly.buttonOp #chamfer
		--
		tfb = polyOp.getNumfaces $
		subobjectLevel = 4
		for j = tfa+1 to tfb do
		(
		polyOp.setfaceSelection $ #(j)--( #{(tfa+1)..tfb} )
		$.extrudeFaces (random (zcd.value/2) (zcd.value))
		move $.selectedFaces [0,0,wdg.value*0.07]
		$.extrudeFaces (zcd.value/100)
		)
		polyOp.setfaceSelection $ #((tfa-1),(tfa))
		$.extrudeFaces (wdr.value/100)
		subobjectLevel = 0
		addmodifier wd (TurboSmooth iterations:1)
		addmodifier wd (Noisemodifier scale:(200/ccv.value) strength:[wdr.value/5,wdr.value/5,wdr.value/10])
		addmodifier wd (TurboSmooth iterations:1)
		convertto wd (editable_poly)
		--wd.name = uniqueName "云梦wood"
		max views redraw
	)
	--
	on yesdo pressed do
	(
		wd = newwd
	)
	--
	on add pressed do
	(
		if zywood.height == 250 then 
		(
			add.caption = "↓"
			zywood.height = 225 
		)
		else 
		(
			add.caption = "↑"
			zywood.height = 250
		)
	)
)
createdialog zywood 170 250