try (destroyDialog HQBS) catch()

rollout HQBS "黑马_护墙板" width:140 height:325
(
	label HQBS_gd "护墙板高度:" pos:[5,10] width:65 height:20
	spinner HQBS_gds "" pos:[70,10] width:65 height:20 range:[-999999,999999,0] type:#worldunits
	label HQBS_fd "护墙板块数:" pos:[5,35] width:65 height:20
	spinner HQBS_fds "" pos:[70,35] width:65 height:20 range:[-999999,999999,0] type:#integer
	label F "--------------------------------" pos:[5,52] width:200 height:20
	listbox JMList " 截面列表:" pos:[5,65] width:130 height:10 items:#()
	button HQBS_cj "左键.创建----右键.刷新" pos:[5,225] width:130 height:30 tooltip:"必须是多边形对象" 
	label F1 "截面列表没有自动刷新的"  pos:[5,259] width:200 height:20 
	label F2 "右键点击上面的按钮刷新"  pos:[5,275] width:200 height:20
	hyperLink ZX "黑马设计网免费分享" pos:[20,293] color:blue hoverColor:[255,255,255] visitedColor:[0,0,0] address:"http://www.3dheima.com"
	hyperLink XJ "www.3dheima.com" pos:[20,309] color:blue hoverColor:[255,255,255] visitedColor:[0,0,0] address:"http://www.3dheima.com"
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------http://blog.sina.com.cn/u/2010865412
function SXList =
		(
			JMs = getFiles (getFilenamePath (getSourceFileName()) + "*.max")
			JMnames = #()
			for b=1 to JMs.count do
			(
				n = getFilenamefile JMs[b]
				append JMnames n
			)
			sort JMnames
			JMList.items = JMnames
		)
	
		on HQBS open  do(SXList())
		on HQBS_cj rightclick do (SXList())
--------------------------------------------------------------------------------------上面的是（自动读取脚本路径下的3d文件到列表中）
--------------------------------------------------------------------------------------
on HQBS_cj pressed do 
(
$.EditablePoly.createShape "过程" off $
select $过程
$.name = "过程中"
modPanel.addModToSelection (Extrude ()) ui:on
$.modifiers[1].amount = HQBS_gds.value
macros.run "Modifier Stack" "Convert_to_Poly"
subobjectLevel = 2
$.EditablePoly.SetSelection #Edge #{1}
$.EditablePoly.SelectEdgeRing ()

$.connectEdgeSegments = (HQBS_fds.value-1)   --------------------------------------这个数值控制分段数
$.EditablePoly.ConnectEdges ()
$.EditablePoly.splitEdges ()
actionMan.executeAction 0 "40021"
$.EditablePoly.createShape "过程线" off $
subobjectLevel = 0
actionMan.executeAction 0 "40020"
--------------------------------------------------------------------------------------上面是创建截面线
--------------------------------------------------------------------------------------
mergeMAXFile (getFilenamePath (getSourceFileName())+ JMList.selected + ".max") #useSceneMtlDups #mergeDups #select #noRedraw ---导入文件
J=$
select $过程线
modPanel.addModToSelection (sweep ()) ui:on
$.modifiers[1].CustomShape = 1
$.modifiers[1].PivotAlignment = 2
$.modifiers[1].SmoothPath = off
$.modifiers[1].MirrorXZPlane = off
$.modifiers[1].GenerateMappingCoords = on
$.modifiers[1].shapes[1] = J
-------------------------------------------------------------------------------------上面的是（使用扫描修改器加载截面）	
macros.run "Modifier Stack" "Convert_to_Poly"
subobjectLevel = 3
actionMan.executeAction 0 "40021"
$.EditablePoly.capHoles #Edge
-------------------------------------------------------------------------------------上面的是（转多边形-封补面）	
macros.run "Modifier Stack" "Convert_to_Poly"
$.name = "护墙板"
for m in selection do m.pivot=[m.center.x,m.center.y,m.min.z]
max create mode
select J
actionMan.executeAction 0 "40020"  -- Edit: 删除对象
)
-------------------------------------------------------------------------------------
)
createDialog HQBS