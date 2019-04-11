try destroydialog mdzy catch()
rollout mdzy "黑马问题模型查找V0.2"
(
	group "查找范围"
	(
		radiobuttons sel "" labels:#("场景","选择")
	)
	group "大面物体"
	(
		spinner hmn "面数大于:" range:[1000,999999,20000] type:#integer pos:[30,75] width:90 scale:1000
		
		button  sech "查找"  pos:[125,70] width:65 height:30 tooltip:"大面物体"
	)
	--
	group "问题物体"
	(
		checkbox delo "删除" pos:[10,137] checked:true
		button eobj "查找空物体" width:130 height:30 pos:[60,130] tooltip:"空物体"
		checkbox rpd "修复" pos:[10,172] checked:true
		button badv "死点、死线、死面物体" width:130 height:30 pos:[60,165] tooltip:"死点、死边、死面物体"
		
		
	)
	--
	hyperlink hszt "室内设计交流论坛［好设之图］" color:red address:"http://www.hsztbbs.com/?fromuser=%E4%BA%91%E6%A2%A6" pos:[25,205]
	button add "↑" pos:[5,202] width:15 height:18 tooltip:"关闭广告"
	activeXControl ax "http://www.3dheima.com" align:#left width:190 height:20 pos:[5,225]
	-----
	
	on sech pressed do
	(
		zymd = #()
		if sel.state == 1 then 
		(
			for i in geometry do try if i.numfaces >= hmn.value then append zymd i catch()
			sech.caption = "找到" + zymd.count as string + "个"
			select zymd
		) else
		(
			for i in selection do try if i.numfaces >= hmn.value then append zymd i catch()
			sech.caption = "找到" + zymd.count as string + "个"
			select zymd
		)
	)
	--
	on eobj pressed do
	(
		zymd = #()
		if sel.state == 1 then 
		(
			for i in geometry do try if i.numfaces == 0 then append zymd i catch()
			eobj.caption = "找到/删除" + zymd.count as string + "个空物体"
			if delo.checked == true then delete zymd else select zymd
		) else
		(
			for i in selection do try if i.numfaces == 0  then append zymd i catch()
			eobj.caption = "找到/删除" + zymd.count as string + "个空物体"
			if delo.checked == true then delete zymd else select zymd
		)
	)
	--
	on badv pressed do
	(
		zymd = #()
		if sel.state == 1 then 
		(
			for i in geometry do try if polyop.GetHasDeadStructs i != 0 then append zymd i catch()
			badv.caption = "找到/修复" + zymd.count as string + "个坏物体"
			if rpd.checked == true then (for j = 1 to zymd.count do ( polyop.CollapseDeadStructs j)) else select zymd
		) else
		(
			for i in selection do try if polyop.GetHasDeadStructs i != 0  then append zymd i catch()
			badv.caption = "找到/修复" + zymd.count as string + "个坏物体"
			if rpd.checked == true then (for j = 1 to zymd.count do ( polyop.CollapseDeadStructs j)) else select zymd
		)
		
	)
	---
	on add pressed do
	(
		if mdzy.height == 250 then 
		(
			add.caption = "↓"
			mdzy.height = 225 
		)
		else 
		(
			add.caption = "↑"
			mdzy.height = 250
		)
	)
)
createdialog mdzy 200 250