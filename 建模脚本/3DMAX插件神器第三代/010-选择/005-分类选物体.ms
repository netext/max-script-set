-- 黑马设计 发布
-- 2015.10.21
-- v1.0
-- 免费脚本
-- 如要修改或提取，请获得作者同意

try destroyDialog selCls catch()
rollout selCls "分类选择"
(
	button btn1 "VR代理" height:25 across:2 offset:[-5,0] width:55
	button btn2 "点缓存" height:25 offset:[5,0] width:55
	button btn3 "粒子流" height:25 across:2 offset:[-5,0] width:55
	button btn4 "几何体" height:25 offset:[5,0] width:55
	button btn5 "图形" height:25 across:2 offset:[-5,0] width:55
	button btn6 "灯光" height:25 offset:[5,0] width:55
	button btn7 "相机" height:25 across:2 offset:[-5,0] width:55
	button btn8 "组" height:25 offset:[5,0] width:55
	hyperLink hyperi1 "黑马设计生产" address:"http://www.3dheima.com" color:(color 50 150 200) hoverColor:(color 250 50 0) align:#center
	label lab "更多好功能尽在黑马"
	on btn1 pressed do
	(
		thawSelection()
		clearSelection()
		select (for o in $* where not o.isHiddenInVpt and classof o == vrayProxy collect o)
	)
	on btn2 pressed do
	(
		thawSelection()
		clearSelection()
		select (for o in $* where not o.isHiddenInVpt and o.modifiers[#point_cache] != undefined collect o)
	)
	on btn3 pressed do
	(
		thawSelection()
		clearSelection()
		if classof MeshLoader == GeometryClass then 
			select (for o in $* where not o.isHiddenInVpt and (getclassinstances MeshLoader target:o).count > 0 collect o)
	)
	on btn4 pressed do
	(
		thawSelection()
		clearSelection()
		select (for o in $geometry where not o.isHiddenInVpt collect o)
	)
	on btn5 pressed do
	(
		thawSelection()
		clearSelection()
		select (for o in $shapes where not o.isHiddenInVpt collect o)
	)
	on btn6 pressed do
	(
		thawSelection()
		clearSelection()
		select (for o in $lights where not o.isHiddenInVpt collect o)
	)
	on btn7 pressed do
	(
		thawSelection()
		clearSelection()
		select (for o in $cameras where not o.isHiddenInVpt collect o)
	)
	on btn8 pressed do
	(
		thawSelection()
		clearSelection()
		select (for o in $helpers where not o.isHiddenInVpt and o.children.count > 0 collect o)
	)
)
createdialog selCls 145 165