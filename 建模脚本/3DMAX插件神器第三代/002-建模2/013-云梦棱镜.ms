
try destroydialog ymlj catch()
rollout ymlj "棱镜生成(www.3dheima.com)"
(
	local zylj
	--
	group ""
	
	(
	---
	label lbc "------------------------------------"
	spinner ljkd "棱镜宽度："  range:[0.0,9999999,5000] type:#worldunits
	spinner ljgd "棱镜高度："  range:[0.0,9999999,3000] type:#worldunits
	spinner ljhd "棱镜厚度："  range:[0.0,9999999,40] type:#worldunits
	label lbd "------------------------------------"
	---
	radiobuttons typ "" labels:#("平行","倾斜") default:2
	---
	label lba "------------------------------------"
	spinner segk "宽分段数：" range:[2,99,10] type:#integer
	spinner segg "高分段数：" range:[2,99,6] type:#integer
	--
	spinner bwhd "倒角高度：" range:[-40,40,10] type:#worldunits
	spinner bwsz "倒角大小：" range:[0,125,20] type:#worldunits
	---
	label lbb "------------------------------------"
	button fresh "刷新棱镜" width:140 height:30
	button creat "生成棱镜" width:140 height:45
		
	)
	
	
	
	on fresh pressed do
	(
		try delete zylj catch()
		zylj =  Plane length:ljgd.value width:ljkd.value lengthsegs:segg.value widthsegs:segk.value transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:on
		zylj.name = uniqueName ""
		addmodifier zylj (Shell innerAmount:0 outerAmount:ljhd.value)
		convertTo zylj (editable_poly)
		max modify mode
		llist = polyop.getEdgesUsingFace zylj #{1..(segk.value * segg.value)}
		subobjectLevel = 2
		polyop.setEdgeSelection zylj llist
		--
		if typ.state == 2 then zylj.EditablePoly.ConnectEdges() else()
		--
		zylj.edgeExtrudeHeight = (-(bwhd.value))
		zylj.edgeExtrudeWidth = bwsz.value
		zylj.EditablePoly.buttonOp #Extrude
		subobjectLevel = 0

	)
	--
	on ljhd changed val do
	(
		bwhd.range = [-(ljhd.value),ljhd.value,10]
		
	)
	--
	on ljkd changed val do
	(
		bwsz.range = [0,(ljkd.value/segk.value/4),20]
	)
	--
	on segk changed val do
	(
		bwsz.range = [0,(ljkd.value/segk.value/4),20]
	)
	--
	on creat pressed do zylj = newlj
)
createdialog ymlj 160 370