try (destroyDialog obj_Spacing_spline ) catch()
rollout obj_Spacing_spline "物体阵列到线 By:黑马设计网" width:180 height:273
(
	multiListBox mlbx_1 " 需要阵列的物体:" width:100 height:9
	button but_add "╋"	width:50 height:50 Offset:[55,-130] tooltip:"添加选择物体"
	button but_del "━"	width:50 height:50		Offset:[55,18] tooltip:"右键可快速去除物体 "
	label lb1 "对齐方式："   across:2	 Offset:[-15,3]
	radiobuttons radbts "" labels:#("前 ","中 ","后 ") default:2 columns:3	 Offset:[-5,3]
	spinner spi_o "偏 移 距 离:" fieldwidth:80 range:[-999999,999999,0]  type:#integer Offset:[0,3]
	spinner spi_d "自 动 段 数:" fieldwidth:60 range:[1,999,6]  type:#integer across:2 Offset:[58,5] enabled:false
	checkbox ckbx_1 ""   width:20 height:15  Offset:[65,5] tooltip:"弧形线段 自动弯曲"
	button but_ok "ＯＫ 确 定 阵 列"	width:150 height:30 
	HyperLink  hyli1	"[黑马设计网]出品"  align:#center color:(color 150 0 0) Offset:[0,0]  address:"http://www.3dheima.com" 

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
fn getspileng spi = (	-- 获取线条每段长度 和 比例
	try(
	-- lastdiv 点的位置比例 divlen 各线段长度比例 seglen 各线段长度	len 线条总长度
	splen=(getSegLengths spi 1)
	divlen=for i in 1 to (splen.count-1)/2 collect splen[i]
	seglen=for i in  (splen.count-1)/2+1 to (splen.count-1) collect splen[i]
	len=splen[splen.count]
	lastdiv=#()
	lastdiv[1]=start=0 
	join lastdiv (for i in 1 to divlen.count collect (start+=divlen[i]))
	#(lastdiv,divlen,seglen,len)	
	)catch()
)
fn spipostrfom spi Sval val dis = (		-- 直线线段的对位
	pos = interpCurve3D  spi Sval val
	dirx = tangentCurve3D   spi Sval val
	dirz=spi.dir
	diry=cross dirz  dirx
	pos = pos+(diry*dis)
	tra=matrix3 dirx diry -dirz pos
)

fn biliget spi Sval v1 v2 leng = 	(	-- 直曲 自动判断
	start = true
	pos1 =(interpCurve3D spi Sval v1)
	pos2 =(interpCurve3D spi Sval v2)
	dis = distance pos1 pos2
	dis1 = dis+(dis * 0.001)
	dis2 = dis-(dis * 0.001)
--	if dis == leng then start = true else start = false
	if dis2 <=leng  and dis1>=leng then start = true else start =  false		-- 加入误差排除
		start
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
	pos = (interpCurve3D spi 1 val)
	if dis != 0 then (
		dirx = tangentCurve3D spi 1 val 
		dirz=spi.dir;diry=cross dirz  dirx
		pos = pos+(diry*dis)
	)
	pos
)
fn qujianbili v1 v2 val = (
	v1+((v2-v1)*val)
)
on ckbx_1 changed State do spi_d.enabled =  State
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
	try(
	if selection.count == 1 and not(Source_filt selection[1]) then(
		if obj_arry.count != 0 then (
			timeStart=timestamp();max create mode;ResetXForm obj_arry;ConvertToPoly obj_arry  --  ResetXForm 重置属性 [0,0,1]
			maxmin = getobjmaxmin obj_arry ; polyoffset = getpolyoffset maxmin[4]
			posMax = maxmin[1] ; posMin = maxmin[2] ; objlenght = maxmin[3]
			segtposx = getobjSegtposx posMin.x objlenght spi_d.value 
			--selspi = offspile selspi spi_o.value 
			selspi = selection[1] ; spisegleng = getspileng selspi
			spiver = spisegleng[1] ; spiseg = spisegleng[2]; segleng = spisegleng[3]
			for s = 1 to spiseg.count do (
				duan = segleng[s]/objlenght	-- 计算最少段数 
				duan_1 = (dotNetObject "System.Single" duan).toString "0.0" as float
				duan = (dotNetObject "System.Single" duan_1).toString "0" as integer -- 精确到 后一位数值
				numseg = spiseg[s]/duan  ; segval = numseg/2 ; segleng_val = segleng[s]/duan	
				if ckbx_1.checked then (
					onf = biliget selspi 1 spiver[s] (spiver[s]+spiseg[s]) segleng[s]
				) else onf = true
				for i = 1 to duan do (
					if onf then (
						pv = ((numseg*i)-segval)+spiver[s]
						posdir = spipostrfom selspi 1 pv spi_o.value
						scaleval = segleng_val/objlenght
						if keyboard.shiftPressed then(
							maxops.clonenodes obj_arry cloneType:#reference newNodes:&ins;obj=ins
						)else(
							maxops.clonenodes obj_arry cloneType:#instance newNodes:&ins;obj=ins
						)
					--	obj = for o in obj where(Source_filt o)collect o
						obj.pivot = case radbts.state of (
							1:[(posMin.x+posMax.x)/2.0,posMin.y,posMin.z]
							2:[(posMin.x+posMax.x)/2.0,(posMin.y+posMax.y)/2.0,posMin.z]
							3:[(posMin.x+posMax.x)/2.0,posMax.y,posMin.z]
						)
					--	for i in obj do (			-- 看看能不能省下时间
							obj.Transform = posdir
							obj.scale.x = scaleval
					--	)
					)else(
						maxops.clonenodes obj_arry cloneType:#copy newNodes:&ins;obj=ins
						obj = for o in obj where(Source_filt o)collect o
						for o in obj do (
							setobjSegt o segtposx spi_d.value 
							numvert = o.numverts
							for v = 1 to numvert do (
								pp = polyop.getVert o v
								vstpro = getobjposprop objlenght posMax posMin pp polyoffset
								v1 = ((numseg*i)-numseg)+spiver[s] ; v2 = (numseg*i)+spiver[s]
								pos = get_spi_porpos selspi (qujianbili v1 v2 vstpro[1]) vstpro[2] 
								newpos = [pos.x,pos.y,pos.z+vstpro[3]]
								polyop.setVert o v newpos
							)
						)
					)
				)
			)
			redrawViews(); timeEnd=timestamp()
			format "阵列用时%秒\n" ((timeEnd-timeStart)/1000.0)
		)else messagebox "跟随物体为 空" title:"Ace 提示"
	)else MessageBox "选择一个跟随路径物体( 二维线物体 )" title:"Ace 提示"
	)catch(MessageBox "请选择一个SPLINE类型的线型")
)
)
createdialog obj_Spacing_spline  style:#(#style_toolwindow, #style_sysmenu)

