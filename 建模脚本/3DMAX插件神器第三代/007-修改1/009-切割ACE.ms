
try(destroydialog ArcSurface_Quick) catch()
rollout ArcSurface_Quick "阵列线条切割【黑马设计网】出品" width:200 height:105 
(
	Fn pkShape obj = ( superclassof obj == shape and not obj.isTarget )
	pickbutton Pick_but "拾取切割线条"  width:150 height:25 toolTip:"拾取切割辅助线" filter:pkShape

	checkbox chck_1 ""  width:30 height:15 toolTip:"保留转折点" Offset:[168,-20]
	
	radiobuttons radbts ""  height:20 labels:#("间距  ", "段数 ") default:1 columns:1 Offset:[-20,0]  across:2 
	
	spinner spi_1 "切割间距:" fieldwidth:60 range:[10,100000,1000]  Offset:[0,0] 
	spinner spi_2 "切割段数:" fieldwidth:60 range:[2,1000,10] type:#integer Offset:[0,-5] enabled:false
	button btn_ok  "确定" width:150 
	
local pick_patch = undefined
	
on Pick_but picked obj do 
(
	pick_patch = obj
	Pick_but.caption = "切线： " + obj.name
)

on radbts changed state do(			
	if radbts.state == 1 then ( spi_2.enabled = false ; spi_1.enabled = true )
	else (	spi_1.enabled = false ; spi_2.enabled = true	)
)

on btn_ok pressed do undo on (
	if pick_patch != undefined then(
		 o = selection[1]
			for n = 1 to (numSplines pick_patch) do (
				if radbts.state == 1 then (
					leng = curvelength pick_patch n
					duan = leng/spi_1.value	-- 计算最少段数 
					duan_1 = (dotNetObject "System.Single" duan).toString "0.0" as float
					duan = (dotNetObject "System.Single" duan_1).toString "0" as integer -- 精确到 后一位数值	
					xxx = 1.0/duan;new_p = 0.0
					for s = 1 to duan do (
						new_p += xxx
						pos = interpCurve3D pick_patch n new_p
						dir = tangentCurve3D  pick_patch n new_p
						nr = ray [0.000,0.000,0.000] [0.000,0.000,0.000]
						nr.pos = pos ; nr.dir = dir
						if (o.selectedFaces).count != 0 and (subobjectLevel == 4 or subobjectLevel == 5) then polyop.slice o o.selectedFaces nr
						else polyop.slice o o.Faces nr
					)
				)else (
					xxx = 1.0/spi_2.value
					for p = 0.0 to 1.0 by xxx do (
						pos = interpCurve3D pick_patch n p
						dir = tangentCurve3D pick_patch n p
						nr = ray [0.000,0.000,0.000] [0.000,0.000,0.000]
						nr.pos = pos ; nr.dir = dir
						if (o.selectedFaces).count != 0 and (subobjectLevel == 4 or subobjectLevel == 5) then polyop.slice o o.selectedFaces nr
						else polyop.slice o o.Faces nr
					)
				)
			)
		update o
	)
)

)
createDialog ArcSurface_Quick style:#(#style_toolwindow,#style_sysmenu)