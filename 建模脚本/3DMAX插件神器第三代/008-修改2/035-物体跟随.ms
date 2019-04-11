try (destroyDialog obj_defoto_spline ) catch()
rollout obj_defoto_spline "物体跟随到线 黑马设计网 出品" width:180 height:273
(
	multiListBox mlbx_1 " 需要跟随的物体:" width:100 height:9
	button but_add "╋"	width:50 height:50 Offset:[55,-130] tooltip:"添加选择物体"
	button but_del "━"	width:50 height:50		Offset:[55,18] tooltip:"右键可快速去除物体 "
	label lb1 "对齐方式："   across:2	 Offset:[-15,3]
	radiobuttons radbts "" labels:#("前 ","中 ","后 ") default:2 columns:3	 Offset:[-5,3]
	spinner spi_o "偏 移 距 离:" fieldwidth:80 range:[-999999,999999,0]  type:#integer Offset:[0,3]
	spinner spi_d "自 动 段 数:" fieldwidth:80 range:[1,999,20]  type:#integer Offset:[0,5]
	button but_ok "ＯＫ 确 定 跟 随"	width:150 height:30
	HyperLink  hyli1	"黑马设计网 出品"  align:#center color:(color 150 0 0) Offset:[0,0]  address:"http://www.3dheima.com" 

local obj_arry = #()

fn Source_filt obj = isKindOf obj GeometryClass 

fn getobjmaxmin obj = (		-- 计算物体最大 坐标
	posx=#();posy=#();posz=#()
	for i in obj do (
		append posx i.min.x;append posx i.max.x	;append posz i.max.z	
		append posy i.min.y;append posy i.max.y	;append posz i.min.z	
	)
	lenght =abs(((amin posx)-(amax posx))) ; width = abs(((amin posy)-(amax posy)))
	maxmin = #([amax posx,amax posy],[amin posx,amin posy,amin posz],lenght,width)
)
fn getpolyoffset width = (
	val = case radbts.state of (
		1: width-spi_o.value 
		2: (width/2.0)-spi_o.value 
		3: 0.0-spi_o.value 
	)
	val
)
fn getobjSegtposx Minx disval val = (	--	自动 切断 段数坐标
	dis_x = disval/val ; posx = #()
	for i= 1 to (val-1) do (
		pos_X= Minx+(dis_x*i)	
		append posx pos_X
	)
	posx
)
fn setobjSegt obj posx val = (	--	自动物体 切断
	objmax = obj.max ; objmin = obj.min
--	ConvertToPoly obj
	if classof obj != Editable_Poly then ConvertToPoly obj
	for i= 1 to (val-1) do (
		if posx[i]>objmin.x and posx[i]<objmax.x then(
			pos_X=[posx[i],0,0]	
			pos_dir = ray pos_X [1,0,0]
			polyop.slice obj obj.Faces pos_dir	
		)
	)
)

fn getobjposprop lenght posMax posMin vertpos tui = (
	prop = dis = 0
	vertdis = abs(vertpos.x-posMax.x) ;  dis = abs(vertpos.y-posMax.y)-tui
	width = abs(vertpos.z-posMin.z)
	prop = vertdis/lenght 
	#(prop,dis,width)
)

fn get_spi_porpos spi val dis = (
	newpos = [0,0,0]
	if classof spi != line and classof spi != SplineShape then ConvertToSplineShape spi
	pos = (interpCurve3D spi 1 val)
	if dis != 0 then (
		dirx = tangentCurve3D spi 1 val 
		dirz=spi.dir;diry=cross dirz  dirx
		pos = pos+(diry*dis)
	)
	pos
)

on but_add pressed do (
	if selection.count != 0 then(
		for o in selection where ( finditem obj_arry o ) == 0 and Source_filt o do(
			appendifunique obj_arry o 
		)		
		newlist = for o in obj_arry collect o.name
		mlbx_1.items = newlist
		mlbx_1.selection = newlist.count	
	)
)
on but_del pressed do (
	list = mlbx_1.items
	sel_val = mlbx_1.selection
	for i=list.count to 1 by -1 where sel_val[i] do (
		deleteItem list i
		deleteItem obj_arry i
	)
	mlbx_1.items = list	
)
on but_del rightclick  do (
	if selection.count != 0 then(
		list = mlbx_1.items
		for o in selection where ( finditem obj_arry o ) != 0 do(
			val = finditem obj_arry o
			deleteItem list val
			deleteItem obj_arry val
		)
		mlbx_1.items = list		
	)
)
on but_ok pressed do undo on (
	if selection.count == 1 and not(Source_filt selection[1]) then(
		if obj_arry.count != 0 then (
			maxmin = getobjmaxmin obj_arry ; selspi = selection[1]; polyoffset = getpolyoffset maxmin[4]
			posMax = maxmin[1] ; posMin = maxmin[2] ; lenght = maxmin[3]
			maxops.clonenodes obj_arry cloneType:#copy newNodes:&ins; obj=ins
			obj = for o in obj where(Source_filt o)collect o
			segtposx = getobjSegtposx posMin.x lenght spi_d.value  
			max create mode
			for oo in obj do (
				setobjSegt oo segtposx spi_d.value  
				numvert = oo.numverts
				for v = 1 to numvert do (
					pp = polyop.getVert oo v
					vstpro = getobjposprop lenght posMax posMin pp polyoffset
					pos = get_spi_porpos selspi vstpro[1] vstpro[2] 
					newpos = [pos.x,pos.y,pos.z+vstpro[3]]
					polyop.setVert oo v newpos
				 )
			)
			redrawViews()
		)else messagebox "跟随物体为 空" title:"Ace 提示"
	)else MessageBox "选择一个跟随路径物体( 二维线物体 )" title:"Ace 提示"
	

)

)
createdialog obj_defoto_spline  style:#(#style_toolwindow, #style_sysmenu)

