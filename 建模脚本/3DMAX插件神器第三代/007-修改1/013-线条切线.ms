try(destroydialog Spline_Quick) catch()
rollout Spline_Quick "线条切线 黑马设计网" width:200 height:95 
(
	Fn pkShape obj = ( superclassof obj == shape and not obj.isTarget )
	pickbutton Pick_but "拾取线条"  width:150 height:25 toolTip:"拾取切割辅助线" filter:pkShape
	radiobuttons rab ""  height:18 labels:#("Front","Top","Left") default:1 columns:3 across:2 Offset:[50,0]
	checkbox chck_1 ""  width:30 height:15 toolTip:"强制方向" Offset:[80,0]
	button btn_ok  "快速切线" width:150 height:25
	
local pick_patch = undefined
	
on Pick_but picked obj do 
(
	pick_patch = obj
	Pick_but.caption = "切线： " + obj.name
)
on btn_ok pressed do undo on (
	if pick_patch != undefined then(
		for o in selection do (
			for i = 1 to (numSplines pick_patch) do(
				pos = (interpCurve3D pick_patch i 0)
				dir = (tangentCurve3D pick_patch i 0)
				nr = ray [0.000,0.000,0.000] [0.000,0.000,0.000]
				nr.pos = pos 
				if rab.state == 1 then (
					if chck_1.checked then nr.dir = [dir[3],0,-dir[1]] else nr.dir = [0,0,1]
				)
				if rab.state == 2 then (
					if chck_1.checked then nr.dir = [dir[2],-dir[1],0] else nr.dir = [0,1,0]
				)
				if rab.state == 3 then (
					if chck_1.checked then nr.dir = [0,-dir[3],dir[2]] else nr.dir = [0,0,1]
				)	
				if (o.selectedFaces).count != 0 and (subobjectLevel == 4 or subobjectLevel == 5) then polyop.slice o o.selectedFaces nr
				else polyop.slice o o.Faces nr
			)
			update o
		)
	)
)
)
createDialog Spline_Quick --style:#(#style_toolwindow,#style_sysmenu)