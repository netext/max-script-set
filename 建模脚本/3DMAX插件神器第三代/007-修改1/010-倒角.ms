--20110413 06:19
--20110419 14:37
--20121029 zy qq 313703763
try destroydialog dologo catch()
rollout dologo "简易倒角-zy V1.2"
	
(	
	
	GroupBox g "简易倒角(EasyBevel)" pos:[5,5] width:170 height:215
	pickbutton gl "一、拾取轮廓  (Pick Profile)" pos:[10,25] width:160 height:35 tooltip:"仅限样条曲线。(Only for spline)"
	--
	spinner ll  pos:[100,70] width:70 height:16 range:[0.01,9999999,20]  type:#worldunits  --厚度
	spinner ls pos:[100,95] width:70 height:16 range:[0.01,9999999,4] type:#worldunits  --大小
	spinner ld  pos:[100,120] width:70 height:16 range:[1,20,5] type:#integer--精度
	--
	label llw "挤压厚度(Extrude)" pos:[10,70]
	label lsw "倒角大小(-----Size)" pos:[10,95]
	label ldw "倒角精度(Smooth)" pos:[10,120]
	--
	button rf "二、刷        新   (Refresh)" pos:[10,145] width:160 height:30 tooltip:"请先阅读使用帮助!"
	button dl "三、调整完毕   (--Done--)" pos:[10,180] width:160 height:30
	----
	button abt "关于&帮助 (About & Help)" pos:[5,220] width:170 height:16 border:false
	-- 
	hyperLink hyl5 "此脚本经由黑马设计网发布" color:green  address:"http://www.3dheima.com"-- pos:[20,240]
	
	local bf
	
	on ls changed value do ls.range.y = 2*ll.value
   
	on gl picked obj do 
		
	(   if superclassOf obj == shape then
		gl.text = "已选择  "+obj.name
		else messagebox "仅拾取样条曲线。(You can only pick the shape)" title:"ZY提示"
		
	)
	on rf pressed do
	(
		try delete bf catch()
	
		undo "easybevel" on
	
		(
			if gl.object == undefined   then messagebox "请先拾取样条曲线。(Please pick a shape at first)" title:"ZY提示"
			else 
			try
				(
					bf = copy gl.object
					bf.render_renderable = true
					bf.render_displayRenderMesh = true
					bf.render_thickness = ls.value
					bf.render_sides = (ld.value*4 + 2)
					addmodifier bf (SliceModifier ())
					bf.slice.name = "s1"
					bf.s1.slice_type = 3
					bf.s1.Faces___Polygons_Toggle = 0
					bf.s1.slice_plane.pos.z = (ls.value/100)
					convertTo bf (editable_poly)
					select bf 
					max modify mode
					subobjectLevel = 3
					actionMan.executeAction 0 "40021"
					ConvertSelectionToBorder
					in coordsys local move bf.Selectededges [0,0,(-ll.value)]
					ff = copy gl.object
					convertto ff (editable_poly)
					in coordsys local move ff [0,0,(0.5*ls.value)]
					bf.attach ff bf
					bf.Pivot.z = bf.min.z+0.5*(bf.max.z-bf.min.z);bf.Pivot.x = bf.min.x+0.5*(bf.max.x-bf.min.x);bf.Pivot.y = bf.min.y+0.5*(bf.max.y-bf.min.y)
					--
					addmodifier bf (symmetry ())
					bf.symmetry.name = "s2"
					bf.s2.axis = 2
					bf.s2.mirror.position.z = -(ll.value/2)
					actionMan.executeAction 0 "40043"  -- Selection: Select None
					convertto bf (editable_poly)
						
				)	catch()
		)
	)
	
	on dl pressed do
	(	
		if gl.object == undefined   then messagebox "请先拾取样条曲线。(Please pick a shape at first)" title:"ZY提示" else
		if superclassof bf != GeometryClass then messagebox "请先刷新LOGO样式。(Before you do this,Please refresh the style.)" title:"ZY提示"
		bf = bfnew
		gl.caption = "一、拾取轮廓  (Pick Profile)"
	)
	
	
	
	rollout ah "简易倒角(Easy Bevel V1.2)" 
	(	
		local psw_z = (hardwarelockid  as string )
		hyperLink hyl1 "                   --------关于脚本--------" color:[0,0,255] enabled:false
		label ab5 "本脚本可将平面线条变成立体形状并自动"
		label ab6 "倒角，适用于简单logo，字体的快速创建"
		hyperLink hyl2 "                   --------使用须知--------" color:[255,0,0] enabled:false
		label ab1 "一，使用脚本前请保存或备份场景文件"
		label ab2 "二，建议拾取同平面内封闭无交错曲线"
		label ab3 "三，生成的模型会按倒角大小略微变大"
		label ab4 "四，参数调整完毕后务必点击生成按钮"
		-----
		activeXControl ax "http://www.zhouyangcg.com/msad/MS.html" align:#left  height:20
		-----
		
	)
	on abt pressed do 
		(   
		PosA = getdialogpos dologo 
		createDialog ah pos:[PosA[1]+195,PosA[2]+10] width:240 height:180
		)
	on dologo moved pos do
		
		(
		PosA = getdialogpos dologo 
		SetDialogPos ah [PosA[1]+195,PosA[2]+10]
		)
	
)

createdialog dologo 180 260 
