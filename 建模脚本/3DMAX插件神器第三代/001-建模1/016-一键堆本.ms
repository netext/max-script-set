-- Kamil M. (C) 2012
try(destroyDialog stacks_rollout) catch()
rollout stacks_rollout "书本堆叠【黑马设计网】"
(
	
	fn setrot obj rx ry rz =
	(
		local translateMat = transMatrix obj.transform.pos
		local scaleMat = scaleMatrix obj.transform.scale
		obj.transform = scaleMat * translateMat
		rotate obj (angleaxis rx [1,0,0])
		rotate obj (angleaxis ry [0,1,0])
		rotate obj (angleaxis rz [0,0,1])
	)
	
	fn wysokosc obj = (obj.max.z - obj.min.z)
	
	fn stos obiekty liczba pozycja niepowtarzaj rot_x_prob rot_y_prob rot_xy_deg offset=
	(
		nowe = #()
		local poprzedni=0
		for c = 1 to liczba do
		(
			local wylosowany = random 1 (obiekty.count)
			while wylosowany == poprzedni do wylosowany = random 1 (obiekty.count)
			if niepowtarzaj == true then poprzedni = wylosowany
			nowyobj = instance (obiekty[wylosowany]) pos:pozycja
			
			--flip
			local przewr = 0
			local los = random 0.0 100.0
			if (los < rot_x_prob) then
			(
				rotate nowyobj (angleaxis 180 [0,1,0])
				przewr += 1
			)
			los = random 0.0 100.0
			if (los < rot_y_prob) then
			(
				rotate nowyobj (angleaxis 180 [1,0,0])
				przewr += 1
			)
			if przewr == 1 then move nowyobj [0,0,(wysokosc nowyobj)]
			
			--XY rotacja
			los = random (-rot_xy_deg/2.0) (rot_xy_deg/2.0)
			rotate nowyobj (angleaxis los [0,0,1])
			
			--przesuniecie
			los = random (-offset/2.0) (offset/2.0)
			move nowyobj [los,0,0]
			los = random (-offset/2.0) (offset/2.0)
			move nowyobj [0,los,0]
			
			append nowe nowyobj
			pozycja.z+=wysokosc nowyobj
		)
		group nowe
	)
	
	listbox lista "对象: " width:190 height:12 align:#center
	button addbutton "添加" width:80 pos:[30,190] height:25
	button delbutton "删除所有" width:80 pos:[130,190] height:25
	group "参数"
	(
		spinner counter "一共多少本: " type:#integer range:[1,1000000,100] fieldwidth:50 align:#center
		spinner rotxprob "X 翻转概率 (%): " align:#center fieldwidth:40 range:[0,100,25]
		spinner rotyprob "Y 翻转概率 (%): " align:#center fieldwidth:40 range:[0,100,25]
		spinner rotxydeg " XY 旋转角度: " align:#center fieldwidth:45 range:[0,360,5]
		spinner mov "书本 偏移: " fieldwidth:70 type:#worldunits range:[0,100000,1] align:#center
		checkbox dif "相邻不重复" checked:false enabled:false align:#center
		button makebutton "开始 堆叠" width:120 height:30 enabled:false
	)
	
	on rot180 changed val do rot180prob.enabled = val
	on rotxy changed val do rotxydeg.enabled = val
	
	on addbutton pressed do
	(
		local obiekty = lista.items
		for o in selection do appendifunique obiekty o.name
		lista.items = obiekty
		if (lista.items != undefined) then makebutton.enabled=true
		if lista.items.count > 1 then dif.enabled=true
	)
	
	on delbutton pressed do
	(
		lista.items = #()
		makebutton.enabled=false
		dif.enabled=false
	)
	
	on makebutton pressed do
	(
		obiekty = #()
		pos = [0.0,0.0,0.0]
		for o in lista.items do
		(
			obj = getnodebyname o
			setrot obj 0 0 0
			--pivot w dol
			obj.pivot = [obj.pivot.x,obj.pivot.y,obj.min.z]
			pos += obj.pos
			append obiekty obj
		)
		pos /= obiekty.count
		stos obiekty counter.value pos dif.state rotxprob.value rotyprob.value rotxydeg.value mov.value
	)
)
createdialog stacks_rollout width:220
	