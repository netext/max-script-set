Try(DestroyDialog  cytool) Catch()
rollout cytool "POLY建模常用命令" width:66 height:320
(
    local mousedd = false
    local ThePos = [0,0]
	button cytool_5 "移除边" pos:[1,1] width:64 height:20 toolTip:"移除边,点级别的所选点及边."
	button cytool_6 "线上加点" pos:[1,21] width:64 height:20 toolTip:"POLY中加点"
	button cytool_7 "循环" pos:[1,41] width:64 height:20 toolTip:"POLY中循环选择边"
	button cytool_8 "环形" pos:[1,61] width:64 height:20 toolTip:"POLY中环状选择边"
	button cytool_9 "连接1" pos:[1,81] width:64 height:20 toolTip:"POLY中连接1条线"
	button cytool_10 "连接2" pos:[1,101] width:64 height:20 toolTip:"POLY中连接2条线"
	button cytool_12 "切片" pos:[1,141] width:64 height:20 toolTip:"POLY中切片物体"
	button cytool_13 "分离" pos:[1,161] width:64 height:20 toolTip:"POLY中分离物体"
	button cytool_14 "附加" pos:[1,181] width:64 height:20 toolTip:"POLY中附加物体"
	button cytool_15 "切割线" pos:[1,201] width:64 height:20 toolTip:"POLY中切割线"
	button cytool_16 "翻转" pos:[1,221] width:64 height:20 toolTip:"POLY中翻转法线"
	button btn48 "焊接点" pos:[1,241] width:64 height:20 toolTip:"POLY中焊接点"
	button btn49 "封口" pos:[1,261] width:64 height:20 toolTip:"POLY中封口边缘"
	checkbutton ckb2 "切片平面" pos:[1,121] width:64 height:20 highlightColor:(color 238 204 85) toolTip:"POLY中切片平面"
	button BtnC "关闭" pos:[1,281] width:64 height:20 toolTip:"POLY中封口边缘"
	label lbl6 "点我移动" pos:[6,303] width:60 height:16


	on cytool lbuttonup pos do
		mousedd = false ;
	on cytool lbuttondown pos do
		(mousedd = true ; ThePos = pos)
	on cytool mouseMove pos do
		if mousedd do SetDialogPos   cytool  (mouse.screenpos - thePos)
	on cytool_5 pressed do
	(
	try(for i in selection do (i.EditablePoly.SelectEdgeLoop ())
	macros.run "Editable Polygon Object" "EPoly_Convert_Sel_To_Vertex"
	subobjectLevel = 2
	macros.run "Editable Polygon Object" "EPoly_Remove"
	subobjectLevel = 1
	macros.run "Editable Polygon Object" "EPoly_Remove"
	subobjectLevel = 2
	) catch()
	)
	on cytool_6 pressed do
		macros.run "Editable Polygon Object" "EPoly_EInsertVertex"
	on cytool_7 pressed do
		try(for i in selection do (i.EditablePoly.SelectEdgeLoop ())) catch()
	on cytool_8 pressed do
		try(for i in selection do (i.EditablePoly.SelectEdgeRing ())) catch()
	on cytool_9 pressed do
	(
	try(for i in selection do (i.EditablePoly.SelectEdgeRing ())
	for i in selection do (i.connectEdgeSegments = 1)
	for i in selection do (i.EditablePoly.ConnectEdges ())
	) catch()
	)
	on cytool_10 pressed do
	(
	try(for i in selection do (i.EditablePoly.SelectEdgeRing ())
	for i in selection do (i.connectEdgeSegments = 2)
	for i in selection do (i.EditablePoly.ConnectEdges ())
	) catch()
	)
	on cytool_12 pressed do
		macros.run "Editable Polygon Object" "EPoly_Slice"
	on cytool_13 pressed do
		macros.run "Editable Polygon Object" "EPoly_Detach"
	on cytool_14 pressed do
		macros.run "Editable Polygon Object" "EPoly_Attach"
	on cytool_15 pressed do
		macros.run "Editable Polygon Object" "EPoly_Cut"
	on cytool_16 pressed do
		macros.run "Editable Polygon Object" "EPoly_Flip"
	on btn48 pressed do
		macros.run "Editable Polygon Object" "EPoly_Weld"
	on btn49 pressed do
		macros.run "Editable Polygon Object" "EPoly_Cap"
	on ckb2 changed state do
		macros.run "Editable Polygon Object" "EPoly_SlicePlane"
	on BtnC pressed do
		DestroyDialog  cytool
)
CreateDialog cytool 66 320 0 80 Style:#()