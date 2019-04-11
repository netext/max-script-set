global changecolor = 1

fn chawirecolor =   --换物体线框颜色
(
	if (keyboard.controlPressed == true)then(for a in selection do a.wirecolor = (color (random 20 150) (random 20 150) (random 20 150)))
	else
	(
		if changecolor == 1
		then(for a in selection do a.wirecolor = (color (random 50 175) (random 20 50) (random 20 50))  --红色系
			changecolor = 2)
		else (
			if changecolor == 2
			then(for a in selection do a.wirecolor = (color (random 20 50) (random 50 175) (random 20 50))  --绿色系
				changecolor = 3)
			else (
				if changecolor == 3
				then(for a in selection do a.wirecolor = (color (random 20 50) (random 20 50) (random 50 175))  --蓝色系
					changecolor = 4)
				else(
					if changecolor == 4
					then(for a in selection do a.wirecolor = (color (random 50 175) (random 50 175) (random 20 50))  --橙色系
						changecolor = 5)
					else(
						if changecolor == 5
						then(for a in selection do a.wirecolor = (color (random 20 50) (random 50 175) (random 50 175))  --青色系
							changecolor = 6)
						else(
							if changecolor == 6
							then(for a in selection do a.wirecolor = (color (random 50 175) (random 20 50) (random 50 175))  --紫色系
								changecolor = 1)
							)
						)
					)
				)
			)
	)					
)

try (destroydialog colorchang_roll) catch()
rollout colorchang_roll "换色" width:150 height:55
(
	button btn1 ">>变色<<" pos:[22,5] width:105 height:24 toolTip:"ctrl+左键还有惊喜哦！"
	HyperLink gongsilink "CG4A-DMCG" pos:[45,33] width:131 height:15 color:(color 250 150 0) hovercolor:(color 100 100 150) visitedcolor:(color 200 150 0) address:"http://www.3dheima.com/"
	
	on btn1 pressed do 
	(
		if selection.count > 0 then
		(chawirecolor())
		else(messagebox "请先选择物体" title:"选择警告！")
	)
	
)
createdialog colorchang_roll