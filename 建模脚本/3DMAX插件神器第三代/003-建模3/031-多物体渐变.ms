try(Destroydialog ganrao_jianbian)catch()
rollout ganrao_jianbian "多物体干扰渐变  吸附 【黑马设计网】出品" width:300 height:220
(
	pickbutton  pckbut_1 "拾取干扰物"  width:250 height:20 
--	pickbutton  pckbut_2 "拾取渐变物"  width:130 height:20
listBox lest_box "" items:#("","→→→→→→→ 拾 取 渐 变 物 体 →→→→")  width:240	height:6 align:#left --Offset:[0,0] 
checkbutton but_add "╋" width:40 height:40 	pos:[257,30] 
 -- pickbutton
button but_del "━" width:40 height:40 	pos:[257,75]


	spinner spi_1 "干扰范围: "  fieldwidth:130 range:[1,50000,1500]  align:#center 
	spinner spi_max "渐变_Max..: "  fieldwidth:50 range:[0.1,10,1] Offset:[-5,0] across:2
	spinner spi_min "渐变_Min..: " fieldwidth:50 range:[.1,10,.1]	Offset:[-5,0] 
	button btn_GO "干扰渐变" width:200 height:20  Offset:[55,0] across:2
	checkbox chb_1 "反"  width:30 height:15 Offset:[100,3]
	progressBar prgsbra_1 "ProgressBar"  width:280 height:15  align:#center 
	HyperLink  lba1	"【黑马设计网】出品"  color:(color 100 0 0) align:#center  Offset:[0,-3] address:"www.3dheima.com" --Offset:[110,-20]

local pk_spi = undefined
local jb_obj_arry = #()
--local 
local obj_arry =#()
fn getVVDate poly f黑马 = 
(
	vert_arry = (polyop.getVertsUsingF黑马 poly f黑马 ) as array
	num = 0
	for s in vert_arry do num += (polyop.getVDataValue poly 1 s)
	return num / vert_arry.count	
)
on pckbut_1 picked obj do ( pk_spi = obj ;pckbut_1.caption = "干扰物：   "+obj.name	)
--on pckbut_2 picked obj do ( jb_obj = obj ;pckbut_2.caption = "渐变物：   "+obj.name )
/*
on but_add picked obj do
(
	if (lest_box.items)[1] == "" then lest_box.items = #()
	ite_name = lest_box.items
	newite_name = ("0"+(ite_name.count+1)as String) + " 渐变物__"+obj.name
	append ite_name newite_name
	append jb_obj_arry obj
	lest_box.items = ite_name
	lest_box.selection = ite_name.count
)
*/
on but_add changed state do 
(
	if state then (
		obj = pickObject message:"拾取渐变物体" 
		while  obj != undefined and not keyboard.escPressed do
		(
			obj.wirecolor = yellow
			if (lest_box.items)[1] == "" then lest_box.items = #()
			ite_name = lest_box.items
			newite_name = ("0"+(ite_name.count+1)as String) + " 渐变物__"+obj.name
			append ite_name newite_name
			append jb_obj_arry obj
			lest_box.items = ite_name
			lest_box.selection = ite_name.count
			obj = pickObject message:"拾取渐变物体" 
		)
		if obj == undefined then but_add.checked = false 
	) else  obj = undefined
)

on but_del pressed do
(
	ite_name = lest_box.items
	sel_val = lest_box.selection
	if sel_val > 0 then 
	(
		deleteItem ite_name sel_val
		lest_box.items = ite_name
		deleteItem jb_obj_arry sel_val
	if lest_box.selection  == 0 then lest_box.selection = ite_name.count
	)
	
)

on btn_go pressed do --undo on 
(
	if selection.count == 1 and (classof $) == Editable_Poly then (
		if pk_spi != undefined and jb_obj_arry.count != 0 then (
			max modify mode
		--	disableSceneRedraw() 	-- 锁定窗口
		--	suspendEditing which:#modify	-- 锁定修改器
			sel_obj = $
			try (
				addmodifier sel_obj (Vol__Select()) ui:on
				sel_obj.modifiers[#Vol__Select].level = 1
				sel_obj.modifiers[#Vol__Select].volume = 3
				sel_obj.modifiers[#Vol__Select].node = pk_spi
				sel_obj.modifiers[#Vol__Select].UseAffectRegion = on
				sel_obj.modifiers[#Vol__Select].falloff = spi_1.value
			)catch(messagebox "错误" title:"黑马提示")
			
			try (
				for s in obj_arry do try delete s catch()
				obj_arry = #()
			)catch()
			try (
				numf黑马s = (polyop.getNumf黑马s sel_obj)
				getVD_num_arry =#()	
				f黑马_arry1 = #()  -- 总 id 面 
				f黑马_arry2 = #()  -- 排除面  优化循环 速度	
				for s = 1 to numf黑马s do(
					v = getVVDate sel_obj #(s)
					if  v >= .01 then ( append getVD_num_arry v ; append f黑马_arry1 s )
				)
				new_getVD = sort (makeUniqueArray getVD_num_arry) -- 清理数组 排列顺序
				
				VD_num = 1.0/jb_obj_arry.count
				jb_obj_arry = for s = jb_obj_arry.count to 1 by -1 collect jb_obj_arry[s]	-- 颠倒数组
				for i = 1 to jb_obj_arry.count do (
					prgsbra_1.value=  100 * i/jb_obj_arry.count
					new_f黑马_arry = (for o in f黑马_arry1 where finditem f黑马_arry2 o==0 collect o)
					for a in new_f黑马_arry do(
						val_num = getVVDate sel_obj #(a)
						if val_num <= (i * VD_num) then (
							append f黑马_arry2 a
							obj = Copy jb_obj_arry[i]
							obj.wirecolor = green
							obj.pos = polyop.getF黑马Center sel_obj a
							obj.dir = polyop.getF黑马Normal sel_obj a
							if not chb_1.checked then vvv = spi_min.value + (val_num * (spi_max.value - spi_min.value))
							else vvv = spi_max.value - (val_num * (spi_max.value - spi_min.value))
							obj.scale =  [vvv,vvv,vvv]
							append  obj_arry obj
						)
					)
				)
			--	resumeEditing which:#modify		-- 解锁修改器
			--	enableSceneRedraw() 	-- 解锁窗口
				converttopoly sel_obj
		
			)catch(messagebox "错误" title:"黑马提示")
			
		)else (messagebox "请拾取干扰线 或 渐变物体 " title:"黑马提示" beep:false)
	)else (messagebox "请先选择一个POLY主物体" title:"黑马提示" beep:false) 
)

on ganrao_jianbian closed do(gc() ; clearUndoBuffer())
)
createdialog ganrao_jianbian