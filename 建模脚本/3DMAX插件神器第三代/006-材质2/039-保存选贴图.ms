 rollout boxCreator "MapsCollector" width:285 height:164
 (
 	label rend "收集选择物体与贴图"     
      global  mysavepath
   
     edittext box_creat "存储路径与文件名:" pos:[13,25]    width:150 height:18 fieldwidth:200 labelOnTop:true  readonly:true
	
	button liulan "浏览" pos:[170,42] width:41 height:19
	on liulan pressed do
    (
      mysavepath=getsavefilename()
	  if  mysavepath==undefined 
	  then
             (  messageBox "未指定路径与文件名 " title:"错误"
			 
		    )
	  else  box_creat.text= mysavepath+".max"
	)
 	  
 	label lbl000 "   "
	button render_cam "存储" 
	on render_cam pressed do 
	(
	 if  mysavepath==undefined 
	  then
             (  messageBox "未指定路径与文件名 " title:"错误"
			 
			 )
			 else
			 (
			 arry_selectobj=for  selobj in selection collect selobj---收集选择的物体到数组arry_selectobj
 saveNodes  arry_selectobj (mysavepath+".max")---保存选择的物体
 
 DABAOpath0=getfilenamepath mysavepath


if  arry_selectobj.count==1 then

(    DABAOmaps=usedmaps($)
     for i=1 to DABAOmaps.count do
    (
      DABAOpath1=DABAOpath0+"\\"+filenamefrompath DABAOmaps[i]
      copyfile DABAOmaps[i]  DABAOpath1 
    
    )
   
)

else 
(

  if arry_selectobj.count>1 then
 (
    for objcuont=1 to arry_selectobj.count do
     (
   select arry_selectobj[objcuont]
  
    DABAOmaps=usedmaps($)


     for i=1 to DABAOmaps.count do
          (
            DABAOpath1=DABAOpath0+"\\"+filenamefrompath DABAOmaps[i]
            copyfile DABAOmaps[i]  DABAOpath1 
          )

     )
 )
     else
	 (
	   messageBox "老大，请先选择物体 " title:"无选择的物体"
	 )

)

)


	)
	
   label lbl24  "使用说明：                                             "
	label lbl28 "先选择一个或多个物体，指"
	label lbl29 "定保存路径，脚本可以存储"
	label lbl38 "选择的物体，并收集选择物"
    label lbl39  "体所用到的贴图到同一个文"
    label lbl40  "件夹。                                    " 
	label lbl41 "   "
	label lbl42 "E-mail:363613301@qq.com"  
	label lbl_updateTime "http://www.3dheima.com/" 


	
 	
 )
 createDialog boxCreator 220 280
 --create a Dialog from the rollout

 
--******************************************************************************
