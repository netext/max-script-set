try destroydialog lengjingzhiz catch()
rollout lengjingzhiz "棱镜制作(3dheima.com)" width:152 height:216
(
	local zylj
	
	spinner ljkd "棱镜宽度：" pos:[10,5] width:130 height:16 range:[0,1e+007,800] type:#worldunits
	spinner ljgd "棱镜高度：" pos:[10,26] width:130 height:16 range:[0,1e+007,2000] type:#worldunits
	spinner ljhd "棱镜厚度：" pos:[10,47] width:130 height:16 range:[0,1e+007,10] type:#worldunits
	radiobuttons typ "" pos:[15,69] width:106 height:16 labels:#("平行", "倾斜") default:2 columns:2
	spinner segk "宽分段数：" pos:[10,94] width:130 height:16 range:[2,99,3] type:#integer
	spinner segg "高分段数：" pos:[10,115] width:130 height:16 range:[2,99,6] type:#integer
	spinner bwhd "倒角高度：" pos:[10,136] width:130 height:16 range:[-40,40,1] type:#worldunits
	spinner bwsz "倒角大小：" pos:[10,157] width:130 height:16 range:[0,125,5] type:#worldunits
	button fresh "开始生成棱镜" pos:[8,179] width:140 height:30
	on ljkd changed val do
	(
		bwsz.range = [0,(ljkd.value/segk.value/4),5]
	)
	on ljhd changed val do
	(
		bwhd.range = [-(ljhd.value),ljhd.value,1]
		
	)
	on segk changed val do
	(
		bwsz.range = [0,(ljkd.value/segk.value/4),5]
	)
	on fresh pressed do
	(
		try delete zylj catch()
		zylj =  Plane length:ljgd.value width:ljkd.value lengthsegs:segg.value widthsegs:segk.value transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:on
		zylj.name = uniqueName "棱镜"
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
)
createdialog lengjingzhiz pos:mouse.screenpos style:#(#style_sysmenu, #style_toolwindow)	
