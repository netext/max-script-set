

try destroyDialog clrPth catch()
rollout clrPth "清理路径"
(
	button btn1 "成图路径" height:25 across:2 offset:[-5,0]
	button btn2 "光子路径" height:25 offset:[5,0]
	hyperLink hyperi1 "设计工厂生产" address:"http://3dheima.com" color:(color 50 150 200) hoverColor:(color 250 50 0) align:#center
	label lab "更多好功能尽在设计"
	on btn1 pressed do
	(
		renderSceneDialog.close()
		rendOutputFilename = ""
		local vr = renderers.current
		vr.output_rawFileName = ""
		vr.output_splitfilename = ""
		messagebox "清理完毕！" title:"设计联盟"
	)
	on btn2 pressed do
	(
		renderSceneDialog.close()
		local vr = renderers.current
		vr.adv_irradmap_loadFileName = ""
		vr.adv_irradmap_autoSaveFileName = ""
		vr.lightcache_loadFileName = ""
		vr.lightcache_autoSaveFileName = ""
		messagebox "清理完毕！" title:"设计联盟"
	)
)
createdialog clrPth 145 80