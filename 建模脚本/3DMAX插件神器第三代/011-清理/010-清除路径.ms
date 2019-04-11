--VRay路径清除器
--BY 飞浪
--2008-8-26
--更多脚本尽在CG++论坛:
--http://3dheima.com

try destroydialog fl_clearVrayFiles catch()
--判断渲染器是否关闭
fn fl_ifRendererClose =
(
	if not renderSceneDialog.isOpen() then return true
	else 
	(	messagebox "本操作需要关掉渲染框才能使用，请确定已关掉！"
		return false
	)
)
rollout fl_clearVrayFiles "VRay路径清除器" width:179 height:391
(
	GroupBox grp1 "Render Output" pos:[4,4] width:170 height:83
	button btn_maxDefault "清除MAX 默认Render Output" pos:[10,21] width:157 height:18
	button btn_rawImage "清除VRay raw image file" pos:[10,42] width:157 height:18
	button btn_renderChannel "清除Split render channels" pos:[10,64] width:157 height:18
	GroupBox grp8 "Irradiance map文件" pos:[5,89] width:167 height:63
	button btn_irrClearFrom "清除导入路径" pos:[11,109] width:157 height:18
	button btn_irrClearSave "清除自动保存路径" pos:[11,131] width:157 height:18
	GroupBox grp9 "Photo map文件" pos:[6,155] width:170 height:62
	button btn_pmClearFrom "清除导入路径" pos:[13,171] width:157 height:18
	button btn_pmClearSave "清除自动保存路径" pos:[13,193] width:157 height:18
	GroupBox grp16 "Light cache文件" pos:[7,218] width:168 height:64
	button btn_lcClearFrom "清除导入路径" pos:[12,237] width:157 height:18
	button btn_lcClearSave "清除自动保存路径" pos:[12,259] width:157 height:18
	GroupBox grp21 "Caustics文件" pos:[6,282] width:168 height:63
	button btn_caClearFrom "清除导入路径" pos:[12,299] width:157 height:18
	button btn_caClearSave "清除自动保存路径" pos:[11,320] width:157 height:18
	button btn_clearAll "清除以上所有路径" pos:[13,348] width:157 height:18
	HyperLink hplBBS "www.3dheima.com" pos:[22,372] width:150 height:15 color:(color 255 127.5 0) hovercolor:(color 0 0 255) visitedcolor:(color 0 0 255) address:"http://www.3dheima.com"
	on btn_maxDefault pressed do
	(
		if fl_ifRendererClose () then
		try rendOutputFilename = "" catch()
	)
	on btn_rawImage pressed do
	(
		if fl_ifRendererClose () then
		try (renderers.current).output_rawFileName = "" catch()
	)
	on btn_renderChannel pressed do
	(
		if fl_ifRendererClose () then
		try (renderers.current).output_splitfilename = "" catch()
	)
	on btn_irrClearFrom pressed do
	(
		if fl_ifRendererClose () then
		try (renderers.current).adv_irradmap_loadFileName = "" catch()
	)
	on btn_irrClearSave pressed do
	(	
		if fl_ifRendererClose () then
		try (renderers.current).adv_irradmap_autoSaveFileName = "" catch()
	)
	on btn_pmClearFrom pressed do
	(
		if fl_ifRendererClose () then
		try (renderers.current).photonMap_loadFileName = "" catch()
	)
	on btn_pmClearSave pressed do
	(
		if fl_ifRendererClose () then
		try (renderers.current).photonMap_autoSaveFileName = "" catch()
	)
	on btn_lcClearFrom pressed do
	(
		if fl_ifRendererClose () then
		try (renderers.current).lightcache_loadFileName = "" catch()
	)
	on btn_lcClearSave pressed do
	(
		if fl_ifRendererClose () then
		try (renderers.current).lightcache_autoSaveFileName = "" catch()
	)
	on btn_caClearFrom pressed do
	(
		if fl_ifRendererClose () then
		try (renderers.current).caustics_loadFileName = "" catch()
	)
	on btn_caClearSave pressed do
	(
		if fl_ifRendererClose () then
		try (renderers.current).caustics_autoSaveFileName = "" catch()	
	)
	on btn_clearAll pressed do
	(
		if fl_ifRendererClose () then
		(
			btn_maxDefault.pressed()
			btn_rawImage.pressed()
			btn_renderChannel.pressed()
			btn_irrClearFrom .pressed()
			btn_irrClearSave .pressed()
			btn_pmClearFrom .pressed()
			btn_pmClearSave .pressed()
			btn_lcClearFrom .pressed()
			btn_lcClearSave .pressed()
			btn_caClearFrom .pressed()
			btn_caClearSave .pressed()
		)
	)
)

createdialog fl_clearVrayFiles