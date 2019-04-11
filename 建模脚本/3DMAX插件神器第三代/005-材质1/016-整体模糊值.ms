
---------------------------------------------------------------------------------------------------------
--制作: 天枢星君
--日期：2015-11-30
--交流群：421512172
------------------------------------




try destroydialog BBMOHU catch()
rollout BBMOHU "场景贴图模糊值统一调整" width:210 height:60
(
	spinner spn2 "位图模糊值:" pos:[15,9] width:177 height:16 range:[0,100,0.01] scale:0.01
	button btn2 "确定" pos:[19,33] width:170 height:22
	on btn2 pressed do
	(
	for i in (getclassinstances bitmaptexture) do (i.coords.blur = spn2.value)
	btn2.text="全部调整完毕！！！！！"	
		)
)
createdialog BBMOHU


/*
--调所有stadard固有贴图blur
--BY 飞浪
--2008-08-12
--更多脚本尽在CG++:http://www.cgplusplus.com/bbs
try destroydialog fl_defaultBlur catch()
rollout fl_defaultBlur "场景贴图模糊值统一调整" width:210 height:60
(
	spinner spn1 "Blur:" pos:[20,7] width:67 height:16 range:[0,100,0.01] scale:0.01
	button btn1 "OK" pos:[92,6] width:57 height:18
	

	fn adjustBlur mtl v =
	(	tempclass = classof mtl
		if tempclass == standardmaterial then try mtl.maps[2].coords.blur = v catch()
		else if tempclass == Multimaterial then
		(	for m in mtl.materialList do adjustBlur m v)
		
	)
	on btn1 pressed do
	(	for i in scenematerials  do
		adjustBlur i spn1.value
	)
	
	
	
	
	

)
createdialog fl_defaultBlur

*/