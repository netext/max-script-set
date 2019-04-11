
	(
	if selection.count == 0 then messagebox "请先选择要编辑贴图的一个或多个物体！" title:"提示："
		else 
	(
maps_array = #()
for v in selection do (
for i in usedmaps (v) do (
	temp_maps = (finditem maps_array i) if temp_maps == 0 then
	(
	append maps_array i
	
		)
		)
	)

if maps_array.count != 0 then for i in maps_array do (try(psOLE = createOLEObject "Photoshop.Application"
	psOLE.open i)catch(messagebox "没有检测到您安装的PS!" tlele:"提示：")
	)
	else
(
		messagebox "当前物体没有贴图，或者贴图已丢失！" title:"提示："

	)
)
)
