
rollout haha "地形检查工具 黑马设计网" width:200 height:150
(
button btn_1 "选择开放点"  width:100 height:20 Offset:[8,0] across:2
button btn_2 "焊接"  width:50 height:20 Offset:[8,0]
button btn_3 "选起始点"  width:85 height:20 across:2 
button btn_4 "选终始点"  width:85 height:20 	
button btn1 "选择开放线"  width:85 height:20 across:2
button btn2 "关闭开放线"  width:85 height:20	
button btn3 "标记线头"  width:85 height:20	across:2
button btn4 "删除标记"  width:85 height:20	
button btn5 "分离线"  width:85 height:20	Offset:[15,0] across:3
button weld_spline "合并线"  width:40 height:20 Offset:[22,0] tooltip:"合并多条二维线、自动焊接 ps:按Shift键闭合线"
spinner spi_spline ""    width:45 range:[0.0,1000.0,0.1] Offset:[-7,2] type:#float 	

fn sel_ver val=
(
--	local jk,chenhui1 
jk=selection[1] 
if selection.count==1 and (ClassOf jk==line or ClassOf jk==SplineShape) and SuperClassOf ( modPanel.getCurrentObject())!=modifier and not jk.baseobject.renderable do(
			if getCommandPanelTaskMode() != #modify do setCommandPanelTaskMode mode:#modify
		    if (getSplineSelection jk).count>=1 then(subObjectLevel=1
			                                        max select none
			                                        chenhui1=getSplineSelection jk   
			                                       if val==1 then for ss=1 to chenhui1.count do setKnotSelection jk chenhui1[ss] #(1)
												         else  for ss=1 to chenhui1.count do setKnotSelection jk chenhui1[ss] #(numKnots jk chenhui1[ss]))   
										else(subObjectLevel=1
										     max select none
										    if val==1 then for h=1 to numSplines jk do setKnotSelection jk h #(1) keep:true
											            else for h=1 to numSplines jk do(setKnotSelection jk h #(numKnots jk h) keep:true)))
 )
 
on btn_1 pressed do undo on
(
if  selection.count ==1 and classof $ == splineshape or classof $ == line and subobjectLevel == 1 then 
	(	
	updateShape $
	max modify mode
	subobjectLevel = 1
	splinecount=numSplines $
	for i = 1 to splinecount do
	(
    numbervet = (numSegments $ i)+1
    if isClosed $ i
    then continue
    else setKnotSelection $ i #(1,numbervet)
	) 
	updateShape $
	)
)

on btn_2 pressed do undo on
(
		if subobjectlevel == undefined then max modify mode
		if subobjectlevel != 1 then subobjectlevel = 1
		Try(ApplyOperation Edit_Spline Splineops.Fuse)Catch()	
		ApplyOperation Edit_Spline Splineops.Weld
)

on btn_3 pressed do undo on
(
sel_ver 1
)
on btn_4 pressed do undo on
(
sel_ver 2
)

on btn1 pressed do undo on
(	
if  selection.count ==1 and classof $ == splineshape or classof $ == line  then
(	
	arry = #()
	max modify mode 
	for s in 1 to (numsplines $) do
	(	
		if isClosed $ s != true then
		(
			append arry (s as integer)
		) else ()
	)
	if 	arry.count != 0 then
	(
	subobjectlevel = 3
	setsplineselection $ arry
	updateShape $
	)else messagebox "没有开放线了哦" title:"Ace脚本收集" beep:false
)else messagebox "亲,咱选择样条线行吗" title:"Ace脚本收集"	
)

on btn2 pressed do undo on
(
if  selection.count ==1 then
(
	if superclassOf $ == shape then
	(
splineOps.close $
updateShape $
)else messagebox "亲,咱选择样条线行吗" title:"Ace脚本收集"
)
)
	
	on btn3 pressed do  undo  on
(
if  selection.count ==1 then
(
		if superclassOf $ == shape then
		(
		for s in 1 to (numsplines $) do
		(	
			if numknots $ s != numsegments $ s then 
			(
			ver_pos = for aa = 1 to s collect getKnotPoint $ s 1
			poit = Point pos:ver_pos[1] wirecolor:red
			poit.centermarker = off
			poit.axistripod = off						
			poit.cross = off
			poit.Box = on 	
			poit.size = 8
			poit.constantscreensize = on
			poit.drawontop = off	
			poit.name = uniquename "线头标记_"
			)
		)
		)else messagebox "亲,咱选择样条线行吗" title:"Ace脚本收集"
)else  messageBox "请选择1个物体" title:"Ace脚本收集"
)

on btn4 pressed do undo on
(
	delete $线头标记_*
)		
	
on btn5 pressed do undo on
(
	Shapes_to_Process = selection as array
		Detached_Splines = #()
	for i = 1 to Shapes_to_Process.count do
		(
		Original_shape=Shapes_to_Process[i]
		if Original_shape.category != #shape then Converttosplineshape Original_shape				
	
		for pns = 1 to numSplines Original_shape do																
		(			tmp_shape = splineShape name:("Spline"+ pns as string); tmp_shape.adaptive=true; tmp_shape.wirecolor=random black white 
					tmp_spline = addNewSpline tmp_shape
					nk = numknots Original_shape pns 											

			for pnk = 1 to nk do															
				(				
					knot_pos1=getknotpoint  Original_shape pns pnk
					in_vec_pos1=getInVec  	Original_shape pns pnk
					out_vec_pos1=getOutvec  Original_shape pns pnk		
					addknot tmp_shape tmp_spline #beziercorner #curve knot_pos1 in_vec_pos1 out_vec_pos1
					if pnk==nk and isClosed Original_shape pns then close tmp_shape 1
					
				)-- number knots in spline
				updateshape tmp_shape
				append Detached_Splines tmp_shape
			tmp_shape.pivot = tmp_shape.center					
		)-- number splines in shape
		delete Original_shape
		)-- selection count
 		--set1= selectionsets ["Detached_Splines" + prefix_no as string ] = Detached_Splines; prefix_no+=1
	( enableSceneRedraw(); redrawViews() )
) 

on weld_spline pressed do undo on
(
ssarr = $
weld = spi_spline.value
converttosplineshape ssarr
ss= for s in ssarr where classof s == splineshape or classof s == line collect s
progressstart "二维线合并中..."	
for i in 2 to ss.count do 
(
progressupdate (100.0 * i / ss.count)
addandweld ss[1] ss[i] 1
)
if ss.count != 0 then updateshape ss[1]
try (if keyboard.shiftPressed then
(
	for i in 1 to numsplines $ do
	(      --  setKnotSelection $ i #()
		sel=for j in 1 to numknots $ i collect j
		setKnotSelection $ i sel
		weldSpline $ weld		
	)
))catch messagebox "亲，这是高版本的新功能" title:"Ace脚本收集"
progressEnd()
--	ss[1]
)
	
) 
createdialog haha 