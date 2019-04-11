
try(destroydialog PolyGradientMosaic) catch()
rollout PolyGradientMosaic "随机渐变马赛克【黑马设计网】出品" width:200  height:100
(
	
label lab1 "比例尺:"  align:#left  Offset:[-8,5]	 across:3
slider sli1 ""  width:115 range:[0,100,100]  Offset:[-20,0]	orient:#horizontal ticks:20
label labt "100%"  align:#right  Offset:[8,5]
spinner spi1 "区域分段：" fieldwidth:50  range:[1,100,20] type:#integer align:#center 
button  but_OK "选择马赛克" width:150 height:30 	align:#center 

local maxv,minv
	
on sli1 changed val do ( 
	labt.text = (val as String+"%")  
	PolyGradientMosaic.but_OK.pressed()
)
on spi1 changed val do ( 
	PolyGradientMosaic.but_OK.pressed()
)
on but_OK pressed do (
	if classOf $ == Editable_Poly then	(
		maxv = $.max.z;minv = $.min.z
		height = ((maxv-minv)/100)*sli1.value
		allface = #{1..($.getNumFaces())} as array
		vs = spi1.value;rr =(100/vs as float)
		for i = 1 to vs do execute ( "VV"+ i as String+"= #()")	
		new_sel_array = #()	
		for f in allface do (
			pp = ((polyop.getFaceCenter $ f).z)-minv
			dd = height/vs
			cc = ceil(pp/dd)
			for a = 1 to vs do (
				if cc == a do (append (execute("VV"+ a as String)) f ; exit)
			)
		)
		for i = 1 to vs do (
			face_arry = execute("vv"+ ((vs+1)-i) as String)
			count = face_arry.count
			for s =1 to (((count as float/100) *(rr*i)) as integer) do(
				rnd = random 1 face_arry.count
				append new_sel_array face_arry[rnd]
				deleteItem face_arry rnd
			)
		)
		polyop.setfaceselection $ new_sel_array
		update $
	)
)	
)
createdialog PolyGradientMosaic 

/*
	for i = 1 to vs do (
		execute("format \"v"+i as String+": % \n \" vv"+ i as String)
	)	
*/