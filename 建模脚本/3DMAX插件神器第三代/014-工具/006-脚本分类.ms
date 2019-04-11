(
	local filedirs=getDirectories  (getFilenamePath (getSourceFileName())+"*")
	local filebtn=#()
	local MSEfiles=#()
	
	local tempIniPath999_00="$Scripts\\999\\999.ini"
	local iniDir999_00=getFilenamePath tempiniPath999_00 
	local iniPath999_00=iniDir999_00+"999.ini"
	local iniDic999_00="setUI"
	
	local scriptName999="脚本分类工具"	--插件的名称
	local widthRollout=240   	--界面的宽度
	local heightRollout=600	--界面的高度
	local numLie=3   			--每排的按钮个数
	local heightFenlei=50		--上边分类按钮的高度
	local heightMse=30			--下边脚本按钮的高度
	local disMseBtn=10			--上边分类按钮与下边插件按钮间的间隔距离
	local disRightBtn=18		--上边分类按钮与界面右侧的间隔距离	
	
	
	
	try
	(
		tempFlag=(getINISetting iniPath999_00 iniDic999_00 "tempFlag")as booleanClass;
		scriptName999=getINISetting iniPath999_00 iniDic999_00 "edtName";
		widthRollout=(getINISetting iniPath999_00 iniDic999_00 "spn_widthRollout")as integer;
		heightRollout=(getINISetting iniPath999_00 iniDic999_00 "spn_heightRollout")as integer;
		numLie=(getINISetting iniPath999_00 iniDic999_00 "spn_numLie")as integer;
		heightFenlei=(getINISetting iniPath999_00 iniDic999_00 "spn_heightFenlei")as integer;
		heightMse=(getINISetting iniPath999_00 iniDic999_00 "spn_heightMse")as integer;
		disMseBtn=(getINISetting iniPath999_00 iniDic999_00 "spn_disMseBtn")as integer;
		disRightBtn=(getINISetting iniPath999_00 iniDic999_00 "spn_disRightBtn")as integer;
	)
	catch
	(
		scriptName999="脚本分类工具"
		widthRollout=240   
		heightRollout=600	
		numLie=3   			
		disMseBtn=10			
		heightFenlei=50		
		heightMse=30			
		disRightBtn=18			
	)
	--------------------------------------------------------------------------------------------------------------
	
	local numPai=0   --有多少排按钮，这里是根据 文件夹的个数/numLie 来确定的
	local widthButton=widthRollout/numLie
	
	for i = 1 to filedirs.count do
	(
		aa=(filterString filedirs[i] "\\")
		append filebtn aa[aa.count]
		tempa=for i in getfiles (filedirs[i]+"*.ms*") collect i
		append MSEfiles tempa
	)
	if (mod filebtn.count numLie)>0 then (numPai=(filebtn.count/numLie)as integer +1) else (numPai=filebtn.count/numLie)
	
	str="global MunnamedRollout999\n"
	str+="global myFloater999\n"
	str+="global ScriptsToolss999\n"
	str+="global setUI999\n"
	
	/*
	local tempiniPath999="$Scripts\\999\\999.ini"
	local iniDir999=getFilenamePath tempiniPath999
	local iniPath999=iniDir999+"999.ini"
	*/
	str+="tempiniPath999=\"$Scripts\\999\\999.ini\" \n"
	str+="iniDir999=getFilenamePath tempiniPath999 \n"
	str+="iniPath999=iniDir999+\"999.ini\" \n"
	str+="iniDic999=\"setUI\" \n"
	str+="makeDir iniDir999 \n"
	
	str+="try (closeRolloutFloater myFloater999) catch()\n"
	
	------------------------------------------------------------------------------------------------------------------新增Rollout
	str+="rollout setUI999 \"界面设置\" width:250 height:200 \n"
	str+="(\n"
	str+="HyperLink lblTip \"所有界面设置重启插件后生效\" color:(color 255 255 0) enabled:false \n"
	str+="edittext edtName \"插件名称：\" text:\"脚本分类工具\"  \n"
	str+="spinner spn_widthRollout \"界面宽度：\" range:[100,4000,240] scale:1 type:#integer \n"
	str+="spinner spn_heightRollout \"界面高度：\" range:[300,4000,600] scale:1 type:#integer \n"
	str+="spinner spn_numLie \"分类列数：\" range:[1,20,3] scale:1 type:#integer \n"
	str+="spinner spn_heightFenlei \"分类按钮高度：\" range:[10,100,50] scale:1 type:#integer \n"
	str+="spinner spn_heightMse \"脚本按钮高度：\" range:[10,100,30] scale:1 type:#integer \n"
	str+="spinner spn_disMseBtn \"分类与脚本间距：\" range:[0,100,10] scale:1 type:#integer \n"
	str+="spinner spn_disRightBtn \"按钮右侧空隙：\" range:[0,100,18] scale:1 type:#integer \n"
	str+="on setUI999 open do \n"	
	str+="(\n"
	str+="try(\n"
	str+="tempFlag=(getINISetting iniPath999 iniDic999 \"tempFlag\")as booleanClass; \n"
	str+="edtName.text=getINISetting iniPath999 iniDic999 \"edtName\"; \n"
	str+="spn_widthRollout.value=(getINISetting iniPath999 iniDic999 \"spn_widthRollout\")as integer; \n"
	str+="spn_heightRollout.value=(getINISetting iniPath999 iniDic999 \"spn_heightRollout\")as integer; \n"
	str+="spn_numLie.value=(getINISetting iniPath999 iniDic999 \"spn_numLie\")as integer; \n"
	str+="spn_heightFenlei.value=(getINISetting iniPath999 iniDic999 \"spn_heightFenlei\")as integer; \n"
	str+="spn_heightMse.value=(getINISetting iniPath999 iniDic999 \"spn_heightMse\")as integer; \n"
	str+="spn_disMseBtn.value=(getINISetting iniPath999 iniDic999 \"spn_disMseBtn\")as integer; \n"
	str+="spn_disRightBtn.value=(getINISetting iniPath999 iniDic999 \"spn_disRightBtn\")as integer; \n"
	str+=")\n"
	str+="catch(edtName.text=\"脚本分类工具\";spn_widthRollout.value=240;spn_heightRollout.value=600;spn_numLie.value=3;spn_heightFenlei.value=50;spn_heightMse.value=30;spn_disMseBtn.value=10;spn_disRightBtn.value=18;)\n"
	str+=")\n"
	str+="on setUI999 close do \n"
	str+="(\n"
	str+="setINISetting iniPath999 iniDic999 \"edtName\" (setUI999.edtName.text as string); \n"
	str+="setINISetting iniPath999 iniDic999 \"spn_widthRollout\" (setUI999.spn_widthRollout.value as string); \n"
	str+="setINISetting iniPath999 iniDic999 \"spn_heightRollout\" (setUI999.spn_heightRollout.value as string); \n"
	str+="setINISetting iniPath999 iniDic999 \"spn_numLie\" (setUI999.spn_numLie.value as string); \n"
	str+="setINISetting iniPath999 iniDic999 \"spn_heightFenlei\" (setUI999.spn_heightFenlei.value as string); \n"
	str+="setINISetting iniPath999 iniDic999 \"spn_heightMse\" (setUI999.spn_heightMse.value as string); \n"
	str+="setINISetting iniPath999 iniDic999 \"spn_disMseBtn\" (setUI999.spn_disMseBtn.value as string); \n"
	str+="setINISetting iniPath999 iniDic999 \"spn_disRightBtn\" (setUI999.spn_disRightBtn.value as string); \n"
	
	str+="setINISetting iniPath999 iniDic999 \"tempFlag\" (true as string); \n"
	
	str+=")\n"
	str+=")\n"
	-----------------------------------------------------------------------------------------------------------------------------------
	
	
	--str+="try(DestroyDialog ScriptsToolss999)catch()\n"
	str+="rollout ScriptsToolss999 \"脚本分类\" width:250 height:38\n"
	
	str+="(\n"
	
	tempX="";
	tempY="";
	for i =1 to numPai do
	(
		for j=1 to numLie do
		(
			ji=(j+(i-1)*numLie);
			if ji <= filebtn.count then
			(
				tempX=(2+widthButton*(j-1))as String;
				tempY=(2+heightFenlei*(i-1))as String;
				str+="checkbutton ckb" + ji as String + "\""+filebtn[ji]+"\" pos:[" + tempX + "," + tempY + "] width:"+ widthButton as String+" height:"+heightFenlei as String+" checked:false\n"
			)
		)
	)
	tempY=(numPai*heightFenlei+13)as String
	str+="groupBox gbLine \"\" pos:[-1,-5] width:"+(widthRollout+disRightBtn)as String+" height:"+tempY+" \n"
	
	/*str+="checkbutton ckb1 \""+filebtn[1]+"\" pos:[0,2] width:50 height:16 checked:false\n"
	str+="checkbutton ckb2 \""+filebtn[2]+"\" pos:[50,2] width:50 height:16 checked:false\n"
	str+="checkbutton ckb3 \""+filebtn[3]+"\" pos:[100,2] width:50 height:16 checked:false\n"
	str+="checkbutton ckb4 \""+filebtn[4]+"\" pos:[0,19] width:50 height:16 checked:false\n"
	str+="checkbutton ckb5 \""+filebtn[5]+"\" pos:[50,19] width:50 height:16 checked:false\n"
	str+="checkbutton ckb6 \""+filebtn[6]+"\" pos:[100,19] width:50 height:16 checked:false\n"
	*/
	
	str+="on ScriptsToolss999 close do (setinisetting iniPath999 \"Main\" \"Pos\" (myFloater999.pos as String))\n"
	
	str+="fn closeallchk sel=(for a in ScriptsToolss999.controls where classof a == CheckButtonControl and a.name != sel do (a.checked=false);for a in ScriptsToolss999.controls where classof a == ButtonControl do (tempArr=filterString a.name \"b\";tempIndex=tempArr[2];if sel==\"ckb\"+tempIndex then (a.visible=true)else(a.visible=false)))\n"
	str+="fn AboutMaster=(\n"
	str+="try(DestroyDialog MunnamedRollout999)catch()\n"
	str+="rollout MunnamedRollout999 \"关于\" width:229 height:108\n"
	str+="(	HyperLink btn1 \"欢迎使用脚本分类工具\" pos:[3,8] width:228 height:19 color:(color 255 255 0) enabled:false\n"
	str+="HyperLink btn10 \"作者：某某某\" pos:[3,26] width:228 height:19 border:false color:(color 255 255 0) enabled:false\n"
	str+="label lbl1 \"好东西，请珍惜！！\" pos:[36,47] width:200 height:57)\n"
	str+="createdialog MunnamedRollout999 style:#(#style_sysmenu, #style_toolwindow))\n"
	for i = 1 to filebtn.count do
	(
		str+="on ckb"+i as string+" rightclick do (AboutMaster())\n"
		str+="on ckb"+i as string+" changed state do (if state then (closeallchk \"ckb"+i as string+"\";ScriptsToolss999.height="+(disMseBtn+numPai*heightFenlei+MSEfiles[i].count*heightMse) as string+")else(ScriptsToolss999.height="+ (7+numPai*heightFenlei)as String +"))\n"
	)
	for i = 1 to MSEfiles.count do 
	(
		for a = 1 to MSEfiles[i].count do 
		(
			str+="button ckb"+i as string+"btn"+a as string+"\" "+getFilenameFile MSEfiles[i][a]+"\" pos:[0,"+(disMseBtn+numPai*heightFenlei + (a-1)*heightMse) as string+"] align:#left border:false  height:"+heightMse as String+" visible:false\n"
			str+="on ckb"+i as string+"btn"+a as string+" pressed do try(filein @\""+MSEfiles[i][a]+"\")catch(messagebox \"该文件不正常！请删除或修复脚本文件\")\n"
			--str+="on ckb"+i as string+"btn"+a as string+" pressed do filein @\""+MSEfiles[i][a]+"\"\n"
		)
	)
	str+=")\n"
	
	str+="pos0 = execute (getinisetting iniPath999 \"Main\" \"Pos\")"
	str+="if classof pos0 != Point2 then pos0 = [200,200];"
	--str+="createdialog ScriptsToolss999 pos:"+(pos0 as String)+"  style:#(#style_sysmenu,#style_minimizebox,style_maximizebox,#style_toolwindow,#style_titlebar, #style_border)\n"

	str+="myFloater999 = newRolloutFloater \""+scriptName999+"\" "+(widthRollout+disRightBtn)as String+" "+heightRollout as String+" \n"
	str+="addRollout setUI999 myFloater999 rolledUp:true \n"
	str+="addRollout ScriptsToolss999 myFloater999 \n"
	str+="myFloater999.pos=pos0; \n"
	
	
	
	execute str
)