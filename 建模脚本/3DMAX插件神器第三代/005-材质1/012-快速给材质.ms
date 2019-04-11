(
	local theMatFile="";
	local  iniPath_wb="$Scripts\\Bingo_tools\\KuaiJie_tool\\libs\\Bingo_Tools.ini";
rollout xw_Quickmaterial "快速给材质材质【黑马设计网】出品" height:500
  
(
 button xw_openmatlib01 "导入材质库"
    button xw_openmatlib02 "MAX2008标准材质库" 
 listbox xw_matl "材质:" items:#() height:31
	
	
	
	
 on xw_openmatlib01 pressed do
 (--fileopenmatlib();
	filename = getOpenFileName \
	caption:"加载材质库文件" \
	filename:(getDir #renderPresets + @"\") \
	types:"Material Libraries(*.mat)|*.mat" --historyCategory:"RTTObjectPresets"
	
	if filename!=undefined then 
	(
		theMatFile=filename;
		
		loadMaterialLibrary theMatFile;	 
 a=for i in currentmateriallibrary collect i.name
 xw_matl.items=a
 matcu=a.count
 xw_matl.caption = "材质:"+matcu as string +"个"
 
 setIniSetting iniPath_wb "Quickmaterial" "theMatFile" theMatFile;
	)

 )
    on xw_openmatlib02 pressed do
  (loadMaterialLibrary "E:\材质\标准材质库2008-64新.mat"
 a=for i in currentmateriallibrary collect i.name
 xw_matl.items=a 
 matcu=a.count
 xw_matl.caption = "材质:"+matcu as string +"个"
)
 on xw_matl doubleClicked itm do 
 selection.material=currentmateriallibrary[itm]
 
 on xw_Quickmaterial open do
 (
	theMatFile=getIniSetting iniPath_wb "Quickmaterial" "theMatFile";
	 if theMatFile!="" then
	 (
	 loadMaterialLibrary theMatFile;
 a=for i in currentmateriallibrary collect i.name
 xw_matl.items=a 
 matcu=a.count
 xw_matl.caption = "材质:"+matcu as string +"个"
 )
)
)
createdialog xw_Quickmaterial width:300

)