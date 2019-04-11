-- 黑马设计 发布
-- 2018.10.21
-- v1.0
-- 免费脚本
-- 如要修改或提取，请获得作者同意

try destroyDialog selSpc catch()
rollout selSpc "选择特殊"
(
	button btn1 "最多面物体" height:25 across:2 offset:[-5,0]
	button btn2 "选择空物体" height:25 offset:[5,0]
	button btn3 "无材质物体" height:25 across:2 offset:[-5,0]
	button btn4 "未塌陷文字" height:25 offset:[5,0]
	hyperLink hyperi1 "渲梦工厂生产" address:"http://www.3dheima.com" color:(color 50 150 200) hoverColor:(color 250 50 0) align:#center
	label lab "更多好功能尽在黑马"
	on btn1 pressed do
	(
		local facenum = #()
		local maxfaces = #()
		for o in $Geometry where not o.isHiddenInVpt and classof o != Targetobject do
			append facenum (getPolygonCount o)[1]
		for o in $Geometry where not o.isHiddenInVpt and classof o != Targetobject do
			if (getPolygonCount o)[1] == amax facenum then
				append maxfaces o
		thawSelection()
		clearselection()
		select maxfaces
	)
	on btn2 pressed do
	(
		local nonface = #()
		for o in geometry where (getPolygonCount o)[1] == 0 or classof o == LinkComposite do
			append nonface o
		for s in shapes where classof s == PolymorphicGeomshape or classof s == LinkCompositeshape do
			append nonface s
		nonface = for o in nonface where o.children.count == 0 collect o
		thawSelection()
		clearselection()
		select nonface
	)
	on btn3 pressed do
	(
		local nonmat = for o in $* where not o.isHiddenInVpt and (getPolygonCount o)[1] != 0 and o.material == undefined collect o
		thawSelection()
		clearselection()
		select nonmat
	)
	on btn4 pressed do
	(
		local texts = for o in $* where not o.isHiddenInVpt and (getclassinstances text target:o).count > 0 collect o
		thawSelection()
		clearselection()
		select texts
	)
)
createdialog selSpc 145 110