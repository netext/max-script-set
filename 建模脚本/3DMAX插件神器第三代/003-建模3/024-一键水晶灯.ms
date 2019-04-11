try destroydialog ymdd catch()
rollout ymdd "黑马水晶吊灯 V0.2"
(
	--
	local xiantiao = #()
	--
	dropdownlist yxfx "吊灯类型:"  items:#("圆形层叠","方形层叠","圆形旋转") width:145 selection:1
	--
	spinner yxbj "圆形直径" pos:[15,50] width:140 range:[0.1,999999,3000] type:#worldunits
	--
	spinner fxcc "方形长度" pos:[15,70] width:140 range:[0.1,999999,2000] type:#worldunits enabled:false
	spinner fxkk "方形宽度" pos:[15,90] width:140 range:[0.1,999999,3000] type:#worldunits enabled:false
	spinner ddgd "吊灯高度" pos:[15,110] width:140 range:[0.1,999999,4000] type:#worldunits
	spinner ddcc "吊灯层次" pos:[15,130] width:140 range:[3,6,3] type:#integer
	spinner sjmd "水晶密度" pos:[15,150] width:140 range:[16,40,24] type:#integer
	
	button doit "生成水晶吊灯" width:100 height:40
	----
	activeXControl ax "http://www.3dheima.com" align:#left  height:20
	---
	
	on doit pressed do
	(
		xiantiao = #()
		--
		if yxfx.selection == 1 then --圆形
		(
			yx1 = Circle radius:(yxbj.value/2) pos:[0,0,0]
			sj = GeoSphere pos:[0,0,0] radius:(yxbj.value*pi/400) baseType:2 segs:2 smooth:off
			--
			append xiantiao yx1
			--
			for i = 1 to (ddcc.value - 1) do
			(
				yx2 = copy yx1
				yx2.radius = yx1.radius - ((yx1.radius/(ddcc.value+1))*i)
				append xiantiao yx2
			)
			--sort xiantiao
			
			for j = 1 to xiantiao.count do ---- 生成水晶
			(
				for k = 1 to sjmd.value do
				(
					sjj = copy sj
					sjj.radius = (curvelength xiantiao[j] / (sjmd.value*4))
					--print sjj.radius
					sjj.pos.controller=path path:xiantiao[j] follow:on percent:((100.00/sjmd.value)*k)
					deleteKeys sjj  #allKeys
					--
					num = (ddgd.value/(sjj.radius*2)/xiantiao.count)*j
					--print num
					
					for l = 1 to num do
					(
					sjj2 = instance sjj
					sjj2.pos.controller = Position_XYZ()
					sjj2.pos.z = -(sjj.radius*l*2)
					)
				)
			) 
		) 
		---
		if yxfx.selection == 2 then --------方形
		(
			fx1 =Rectangle length:fxcc.value width:fxkk.value pos:[0,0,0]
			sj = GeoSphere pos:[0,0,0] radius:(yxbj.value*pi/400) baseType:2 segs:2 smooth:off
			--
			append xiantiao fx1
			--
			for i = 1 to (ddcc.value - 1) do
			(
				fx2 = copy fx1
				fx2.length = fx1.length - ((fx1.length/(ddcc.value+1))*i)
				fx2.width = fx1.width - ((fx1.width/(ddcc.value+1))*i)
				append xiantiao fx2
			)
			--sort xiantiao
			
			for j = 1 to xiantiao.count do ---- 生成水晶
			(
				for k = 1 to sjmd.value do
				(
					sjj = copy sj
					sjj.radius = ((curvelength xiantiao[j])/(sjmd.value*4))
					--print sjj.radius
					sjj.pos.controller=path path:xiantiao[j] follow:on percent:((100.00/sjmd.value)*k)
					deleteKeys sjj  #allKeys
					--
					num = (ddgd.value/(sjj.radius*2)/xiantiao.count)*j
					--print num
					
					for l = 1 to num do
					(
					sjj2 = instance sjj
					sjj2.pos.controller = Position_XYZ()
					sjj2.pos.z = -(sjj.radius*l*2)
					)
				)
			) 
		) 
		---------------------------------------------
		if yxfx.selection == 3 then 
		(
			yxb = Helix radius1:(yxbj.value/2) radius2:((yxbj.value/2)/ddcc.value) height:0 turns:ddcc.value pos:[0,0,0]
			sj = GeoSphere pos:[0,0,0] radius:(yxbj.value*pi/400) baseType:2 segs:2 smooth:off
			for i = 1 to ((sjmd.value * 4)/2) do
			(
				sjj = copy sj
				--
				sjj.radius = (curvelength yxb)/(sjmd.value*10) - (((curvelength yxb)/(sjmd.value*10))/(sjmd.value * ddcc.value))*(i/1.75)
				--
				sjj.pos.controller=path path:yxb follow:on percent:(100.00/(sjmd.value *2)*i)
				deleteKeys sjj  #allKeys
				--
				for j = 1 to i do
				(
					sjj2 = instance sjj
					sjj2.pos.controller = Position_XYZ()
					sjj2.pos.z = -(sjj.radius*j*2)
				)
			)
			
		)
	)
	
	----
	on yxfx selected sel do
	(
		if yxfx.selection == 1 or yxfx.selection == 3 then 
		(
			fxcc.enabled = false
			fxkk.enabled = false
			yxbj.enabled = true
		) else
		(
			yxbj.enabled = false
			fxcc.enabled = true
			fxkk.enabled = true
		)
	)
)
createdialog ymdd 180 240