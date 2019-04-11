


--  大家彼此多多学习，以下是功能说明

------------------【黑马设计网】出品  QQ群: 46879535 ----------------我的网站地址  http://www.3dheima.com.
/*
功能：
1.输入数值回车，即可添加UVW

2.也可以点击预设的按钮添加相应的UVW，如果按各自体积添加UVW，则是对于各个所选择的物体分别添加一个自身体积大小的UVW,此方法只作用于所选择的物体，不会对场景中其它物体操作

  “获取UVW”此按钮即是将之后获取的UVW赋给所选择的所有物体，会根据下面的选项是否对场景中其它同材质的物体操作，赋给物体的UVW与获取物体的UVW不会关联
  
3.整个添加UVW的过程是，先会删除原来的UVW，再添加新的UVW

4.可以选择多个物体（所选择的物体可以有多种材质）

5.可以不用打开所有组，但所选择的物体不能包括组

6.当勾选“作用所有同材质物体”时，会根据所选择物体的材质的种类分别对整个场景中与所选物体同材质的物体一起添加UVW，

  由此可以只选择一个物体，运行脚本后，会对整个场景中有该种材质的所有物体添加统一的UVW，如果勾选“沿用之前的UVW”，且所选的物体原来有UVW(只选择单个物体时)，运行后，仍然会沿用原来的UVW，而不会响应所输入的数值或按钮，
  
  如果你不想这样，那就不勾选“沿用之前的UVW”或者选择一个无UVW的物体。整个过程无需打开所有组
  
  也可以选择两个或多个不同材质的物体，运行脚本后，会对整个场景中有这些材质的所有物体添加统一的UVW
  
7.当勾选“不同材质间关联UVW”时，针对当有多个不同材质物体选择时，各个材质的物体的UVW是否关联，不勾选则不关联，但无论怎样，同种材质的物体间的UVW都是关联的
*/
(
try(closeRolloutFloater superUVWMapFloater)catch()
superUVWMapFloater = newRolloutFloater "UVWMap -----Bingo" 160 210

	local unitK=1.0;
	 fn unitTY=                           ---全局定义一个变量unitK来作为单位转换的参数
        (
			case units.MetricType of
		    (
			 #millimeters:(   ---毫米
							 unitK=1.0;
				            )
							
             #centimeters:( ---厘米
							unitK=0.1;
							) 
							
             #meters:(     ---米
							unitK=0.001 ;
							) 
							
             #kilometers:(    ---千米
							unitK=0.000001;
							) 
			 
             default:(        ---毫米
				            unitK=1.0;
				    ) 
            )
	    )
	 unitTY()
	
rollout superUVWMapRollout "添加 or 修改 UVW" 
(
     fn filterHasUVWMod _node =        -----过滤器   过滤掉那些没有UVWMap修改器的物体
		  (
			  (for kk in _node.modifiers where kk.name=="UVW Map" or kk.name=="UVW 贴图" or kk.name=="UVW Mapping" or kk.classid[1]==1012401 collect kk).count>0
		 )
	
	label lblUVW "数 值：" pos:[10,10] width:40 height:14 toolTip:""
	spinner spnUVW "" pos:[50,10] width:62 height:16 range:[-999999999,999999999,0] type:#float scale:1 toolTip:"挤出数值"
	label lblUVW2 "mm" pos:[118,10]
	 
	button btn3000 "3000" pos:[10,30] width:63 height:20 toolTip:"点击此按钮为 所选择的物体 或者 跟选择物体同材质的所有物体 添加一个3000的UVW命令"
	button btn6000 "6000" pos:[73,30] width:63 height:20 toolTip:"点击此按钮为 所选择的物体 或者 跟选择物体同材质的所有物体 添加一个6000的UVW命令"
	
	button btn9000 "9000" pos:[10,50] width:63 height:20 toolTip:"点击此按钮为 所选择的物体 或者 跟选择物体同材质的所有物体 添加一个9000的UVW命令"
	button btn10000 "10000" pos:[73,50] width:63 height:20 toolTip:"点击此按钮为 所选择的物体 或者 跟选择物体同材质的所有物体 添加一个10000的UVW命令"
	
	button btnAnTiJi "各自体积" pos:[10,70] width:63 height:20 toolTip:"只作用于所选择的物体，点击此按钮为 所选择的物体 或者 跟选择物体同材质的所有物体 分别添加一个各自体积大小的UVW命令"
	pickButton btnGetUVW "获取UVW" pos:[73,70] width:63 height:20 filter:filterHasUVWMod toolTip:"点击此按钮为 所选择的物体 或者 跟选择物体同材质的所有物体 添加一个获取别个物体的UVW命令，获取的UVW跟被获取的不会关联"
	
	
	checkbox chkAllObj "作用所有同材质物体" pos:[10,95] width:130 height:14 checked:false toolTip:"如果勾选，只要跟所选择物体的材质相同的物体都会添加UVW，所以只要选择一个物体即可给所有同材质物体添加UVW"
		 checkbox chkPreUVW "沿用所选的UVW" pos:[30,115] width:130 height:14 checked:false toolTip:"如果勾选，会沿用所选物体的第一个物体的之前的UVW"
		 
	checkbox chkInstance "不同材质间关联UVW" pos:[10,135] width:130 height:14 checked:true toolTip:"如果勾选，且选择的物体有超过2种的材质，则它们会一起关联一个UVW，不勾选，则只是同材质的物体关联UVW"
	
	hyperLink lblLOGO "【黑马设计网】出品" pos:[10,160] width:150 height:14 toolTip:"点击进入我的博客" address:@"http://www.3dheima.com" hovercolor: (color 0 255 255)  Color:(color 0 200 200) visitedcolor: (color 0 200 200)
	
	local amount=0
	local allObj=false    --是否收集所有同材质物体
	local guanlian=true  --不同材质之间的UVW是否关联
	 
	local hasUVW=true      --是否之前有UVW
	local preUVW=undefined --之前的UVW
	
	local pickUVW=undefined  --获取到的UVW
	
	local usePreUVW=false   --是否沿用之前的UVW
	 
	 
	 fn notHiddenOrFrozen obj = not (obj.isHidden or obj.isFrozen)
	 fn openGroups obj =
		(
	         sourceObj = for i in obj where not isOpenGroupHead i collect i
	         if sourceObj.count != 0 then for o in sourceObj do setGroupOpen o true else return true
			 for j in 1 to sourceObj.count do openGroups sourceObj
        )
	 fn openAllGroups=
		(
			 obj = for i in objects where notHiddenOrFrozen i and isGroupHead i collect i
			 openGroups obj
		)
	 
	 fn hasModifier _node _str =    ----判断物体是否有某个修改器
        (
             local _bool=false
             
             for m in _node.modifiers do
			     (
					 if m.name==_str then 
					     (
							 _bool=true
							 exit
						 )
				 )
			 return _bool
        )	
		
	 fn filtInstanceArray _array =         -----过滤掉那些相关联的物体
	     (
			 local _newArray=#()
			 for i in 1 to _array.count do
			     (
			         _instanceArray=for n in _array where (areNodesInstances _array[i] n) collect n
					 appendIfUnique _newArray _instanceArray[1]
				 )
               return _newArray
			 --InstanceMgr.GetInstances $ &rptInstances           --获取跟选择物体相关联物体的个数
             --trueInstances = for n in rptInstances where (areNodesInstances $ n) collect n       得到与之相关联物体的数组
		 )
	 fn creatUVWMod _amount:3000 =   -----创建一个新的UVWMap修改器
	     (
			 _UVWMod=Uvwmap()
			 _UVWMod.maptype = 4
			 _UVWMod.length = _amount * unitK
			 _UVWMod.width = _amount * unitK
			 _UVWMod.height = _amount * unitK
			 return _UVWMod
		 )
	 fn deleteUVW _nodesArray=   ---删掉UVW
	    (
			 for i in _nodesArray do
				(
					 local _num=i.modifiers.count
				     
				     for j in 1 to _num do
		                (
				             for m in i.modifiers where (m.name=="UVW Map" or m.name=="UVW 贴图" or m.name=="UVW Mapping") do deleteModifier i m
				         
				        )
				)
		)
	 fn fenleiToArray _nodesArray=   ---按材质分好类后形成一个数组#(#(材质1的物体),#(材质2的物体),...)
	    (
			 local _ObjByMatArray=#()
			 local _matArray=#()
			for i in _nodesArray do
				(
				    if i.material!=undefined then  ---按材质来把物体添加进组  _ObjByMatArray
                        (
	                         if _ObjByMatArray==#() then (append _ObjByMatArray #();append _ObjByMatArray[1] i;insertItem i.material _matArray 1 )
							 else
							     (
									 local _i=findItem _matArray i.material
									 if _i>0 then append _ObjByMatArray[_i] i
									 else
										(
											 insertItem #() _ObjByMatArray 1
											 append _ObjByMatArray[1] i
											 insertItem i.material _matArray 1
										)
								 )
				        )
				)
			return _ObjByMatArray
		)
	 fn addUVWtoNodes _nodesArray _amount:3000 _Instance:true=   --给数组里的每一个物体添加UVW，这种是不收集所用同材质的物体
	    (
			 if _Instance then
				(
					 local _UVWMod=undefined
					 if usePreUVW and hasUVW then _UVWMod=preUVW else _UVWMod=creatUVWMod _amount:_amount
					 
					 select _nodesArray
					 modPanel.addModToSelection _UVWMod ui:on
				)
			 else
				(
				     local _ObjArray=#()
					 _ObjArray=fenleiToArray _nodesArray
					 
					 for s = 1 to _ObjArray.count do   --根据材质的种类的个数来生成多少个种类的UVW
			            (
					         local _UVWMod=undefined
					         if usePreUVW and hasUVW  then _UVWMod=copy preUVW else _UVWMod=creatUVWMod _amount:_amount
							 
							 select _ObjArray[s]
							 modPanel.addModToSelection _UVWMod ui:on
						)
				)
		)
	fn addUVWtoNodes2 _ObjArray _amount:3000 _Instance:true=   --给数组里的每一个物体添加UVW，_ObjArray是已经分类号的数组
	    (	
		     if _Instance then
				(
					 local _UVWMod=undefined
					 if usePreUVW and hasUVW then _UVWMod=preUVW else _UVWMod=creatUVWMod _amount:_amount
					 
					 local _ObjArray2=#()
					 for s = 1 to _ObjArray.count do  
			            (
							 for i = 1 to _ObjArray[s].count do append _ObjArray2 _ObjArray[s][i]
						)
					 select _ObjArray2
					 modPanel.addModToSelection _UVWMod ui:on
				)
			 else
				(
					 for s = 1 to _ObjArray.count do   --根据材质的种类的个数来生成多少个种类的UVW
			            (
					         local _UVWMod=undefined
					         if usePreUVW and hasUVW  then _UVWMod=copy preUVW else _UVWMod=creatUVWMod _amount:_amount
							 
				             select _ObjArray[s]
							 modPanel.addModToSelection _UVWMod ui:on
						)
				)
		)
	fn fuckJapan =  ---整个流程
	    (
			 try(
			 
			 if allObj then openAllGroups()   --首先打开所有组
			 
			 local _selection = selection as array
			 
			 
			 hasUVW=true      
			 preUVW=undefined 
			 
			 --if (hasModifier _selection[1] "Uvw Map") then preUVW=_selection[1].modifiers[#UvwMap] else hasUVW=false
			 preUVW=_selection[1].modifiers[#UvwMap]
			 if preUVW==undefined then hasUVW=false
			 
			 if allObj then  ---如果勾选收集所有同材质物体，那就先收集，然后删UVW，然后按选项是否关联添加UVW
			    (
					 local _newObjArray=fenleiToArray _selection
					 --local _newObjArray2=#()
					 
					 for m = 1 to _newObjArray.count do    ---将场景里所有的物体遍历一遍，按同材质分类归纳到数组里
					 (
					     for i in geometry where (notHiddenOrFrozen i and i.material != undefined) do
						    ( 
	                             if i.material.name == _newObjArray[m][1].material.name then appendIfUnique _newObjArray[m] i 
                            )
						 deleteUVW _newObjArray[m]
					 )
					 
					 
					 addUVWtoNodes2 _newObjArray _amount:amount _Instance:guanlian
				)
			 else            ---如果不勾选收集所有同材质物体，那就先删UVW，然后按选项是否关联添加UVW
				(
					 deleteUVW _selection
					 
					 addUVWtoNodes _selection _amount:amount _Instance:guanlian
				)
				
			 redrawViews()
			 
			 --actionMan.executeAction 0 "40143"  -- Groups: Group Close
			 
			 clearSelection()
			 select _selection
			 
			)
			catch (messagebox "请选择一个或者多个物体，但不要包括组！！")
		)	
		
     
	 --  初始化设置
	on superUVWMapRollout open  do  --  初始化各参数设置，使参数都有默认值
	(
	   undo on
		(
			 if chkAllObj.checked then allObj=true else allObj=false
		)
	)
	 
	 on spnUVW entered do   ----响应回车键
	    (
		
		undo on
		(
			 amount=spnUVW.value
			 fuckJapan()
			 --closeRolloutFloater superUVWMapFloater   ---回车后关掉对话框
		)
	)
	 
	 on btn3000 pressed do    
	(
		undo on
		(
			 amount=3000
			 fuckJapan()
			 --closeRolloutFloater superUVWMapFloater   
		)
	)
	on btn6000 pressed do    
	(
		undo on
		(
			 amount=6000
			 fuckJapan()
			 --closeRolloutFloater superUVWMapFloater   
		)
	)
	on btn9000 pressed do    
	(
		undo on
		(
			 amount=9000
			 fuckJapan()
			 --closeRolloutFloater superUVWMapFloater  
		)
	)
	on btn10000 pressed do    
	(
		undo on
		(
			 amount=10000
			 fuckJapan()
			 --closeRolloutFloater superUVWMapFloater  
		)
	)
	 
	 on btnAnTiJi pressed do    
	(
		undo on
		(
			 local _selection = filtInstanceArray selection   ---首先过滤掉那些相关联的
			 deleteUVW _selection
			 for i in _selection do (addmodifier i (Uvwmap());i.modifiers[#UVW_Map].mapType=4)
			 redrawViews()
			 --closeRolloutFloater superUVWMapFloater  
		)
	)
	 on btnGetUVW picked obj  do     ----跟随选择到的物体的挤出值
	(
		
		undo on
		(
			if allObj then openAllGroups()   --首先打开所有组
			 
			 local _selection = selection as array
			
			pickUVW=copy obj.modifiers[#UVW_Map]
			
			if allObj then  ---如果勾选收集所有同材质物体，那就先收集，然后删UVW，然后按选项是否关联添加UVW
			    (
					 local _newObjArray=fenleiToArray _selection
					 local _newObjArray2=#()
					 
					 for m = 1 to _newObjArray.count do    ---将场景里所有的物体遍历一遍，按同材质分类归纳到数组里
					 (
					     for i in geometry where (notHiddenOrFrozen i and i.material != undefined) do
						    ( 
	                             if i.material.name == _newObjArray[m][1].material.name then appendIfUnique _newObjArray[m] i 
                            )
						 deleteUVW _newObjArray[m]
					 )
					 
					 -------------------------------------------addUVWtoNodes2 _newObjArray _amount:amount _Instance:guanlian--------------------------------------------------
					 if guanlian then
				        (
					        local _UVWMod=undefined
					        _UVWMod=pickUVW
					         
					        local _ObjArray2=#()
					         for s = 1 to _newObjArray.count do  
			                     (
									for i = 1 to _newObjArray[s].count do append _ObjArray2 _newObjArray[s][i]
						        )
					         select _ObjArray2
					         modPanel.addModToSelection _UVWMod ui:on
				        )
			         else
				        (
					         for s = 1 to _newObjArray.count do   --根据材质的种类的个数来生成多少个种类的UVW
			                    (
					                local _UVWMod=undefined
					                _UVWMod=copy pickUVW
							        
				                    select _newObjArray[s]
							        modPanel.addModToSelection _UVWMod ui:on
						        )
				        )
					 ----------------------------------------------------------------------------------------------------------------------------------------------------------
				)
			 else            ---如果不勾选收集所有同材质物体，那就先删UVW，然后按选项是否关联添加UVW
				(
					 deleteUVW _selection
					 
					 -------------------------------------------addUVWtoNodes _selection _amount:amount _Instance:guanlian----------------------------------------------------
					 if guanlian then
						(
					         local _UVWMod=undefined
					         _UVWMod=pickUVW
					         
					         select _selection
					         modPanel.addModToSelection _UVWMod ui:on
				        )
			         else
						(
				            local _ObjArray=#()
					        _ObjArray=fenleiToArray _selection
					        
					        for s = 1 to _ObjArray.count do   --根据材质的种类的个数来生成多少个种类的UVW
			                    (
									local _UVWMod=undefined
					                _UVWMod=copy pickUVW
							        
							        select _ObjArray[s]
							         modPanel.addModToSelection _UVWMod ui:on
								)
				        )
					 ---------------------------------------------------------------------------------------------------------------------------------------------------------
				)
			 select _selection
		)
	)
	 
	on chkAllObj changed state do   
		(
		undo on
		(
			 allObj=state 
			 
			 if state then (chkPreUVW.enabled=true) else (chkPreUVW.enabled=false;chkPreUVW.checked=false;usePreUVW=false)
		)
	)
	on chkPreUVW changed state do  
		(
		undo on
		(
			 usePreUVW=state 
		)
	)
	
	on chkInstance changed state do  
		(
		undo on
		(
			 guanlian=state 
		)
	)
)


addrollout superUVWMapRollout superUVWMapFloater 
setFocus superUVWMapRollout.spnUVW
)