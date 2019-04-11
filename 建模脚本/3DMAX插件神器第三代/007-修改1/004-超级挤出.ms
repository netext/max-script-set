
--  破 解 脚 本 的 朋 友 注 意 了！！！！！！！！！！！！！！！！！！！！1

--  你可以破解，我不会骂你，不会鄙视你，因为我用的很多东西也都是破解的，

--  只希望你不要上传到网上去，如果发现网上出现此脚本的破解版，以后都不会再更新，谢谢

------------------Bingo  QQ:330798701 ----------------
(	
try(closeRolloutFloater superExtrudeFloater)catch()
superExtrudeFloater = newRolloutFloater "超级挤出 -----Bingo" 325 125

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
	
rollout superExtrudeRollout "Extrude 添加和修改于一体" 
(
	fn filterHasExtrudeMod _node =        -----过滤器   过滤掉那些没有挤出修改器的物体
		  (
			  (for kk in _node.modifiers where kk.classid[1]==160 or kk.classid[1]==4119 collect kk).count>0
		 )
		 
     fn filterGeometry obj = superclassof obj == GeometryClass --过滤器  创建一个GeometryClass类型过滤
	
	
	label lblExtrude "挤 出：" pos:[10,10] width:65 height:14 toolTip:""
	spinner spnExtrude "" pos:[45,10] width:62 height:16 range:[-999999999,999999999,0] type:#worldunits scale:1 toolTip:"挤出数值"
	label lblExtrude2 "~" pos:[110,10] width:10 height:14 visible:false
	spinner spnExtrude2 "" pos:[122,10] width:62 height:16 range:[-999999999,999999999,(30000 * unitK)] type:#worldunits scale:1 visible:false toolTip:"挤出数值的随机取值范围"
	checkbox chkExtrudeSJ "随机" pos:[110,10] width:50 height:14 checked:false toolTip:"随机取值范围内挤出"
	 --checkbox chkExtrudeSJBS "倍数" pos:[235,10] width:50 height:14 checked:false toolTip:"倍数设置为1000mm，前面2个参数设置为 1 和 5 就可以用来随机取（1000,2000,3000,4000,5000）里面的数"
	
	 label lblExtrude3 "×" pos:[187,10] width:10 height:14 visible:false
	 spinner spnExtrude3 "" pos:[197,10] width:62 height:16 range:[-999999999,999999999,3000] type:#integer scale:1 visible:false toolTip:"倍数值，如果倍数值设置为3000（一层楼的高度），即可制作随机1~30层的高度"
	 
	checkbox chkCapStart "CapStart  封闭底面" pos:[10,30] width:120 height:14 checked:true toolTip:"底面封闭"
	checkbox chkCapEnd "CapEnd    封闭顶面" pos:[10,50] width:120 height:14 checked:true toolTip:"顶面封闭"
	checkbox chkInstance "关联修改器" pos:[10,70] width:120 height:14 checked:true toolTip:"选择多个物体时，是否关联修改器"
	
	--button btn1 "Extrude" pos:[10,90] width:120 height:40 toolTip:"点击此按钮添加或者修改挤出参数，它会自动删掉之前的挤出Extrude命令，有Edit Mesh或者Edit Poly命令的物体不作任何改动"
	--button btn2 "删除  Extrude" pos:[137,90] width:120 height:40 toolTip:"点击此按钮删除所选物体（有Edit Mesh或者Edit Poly命令的物体除外）的挤出Extrude命令"
	 button btn2 "删除挤出..." pos:[225,70] width:78 height:20 toolTip:"点击此按钮删除所选物体（有Edit Mesh或者Edit Poly命令的物体除外）的挤出Extrude命令"
	
	--Pickbutton btn3 "挤出跟随选择物体的挤出..." pos:[143,30] width:160 height:20 filter:filterHasExtrudeMod toolTip:"点击此按钮使挤出的高度跟随指定物体挤出的数值"
	Pickbutton btn3 "获取挤出..." pos:[225,30] width:78 height:20 filter:filterHasExtrudeMod toolTip:"点击此按钮使挤出的数值跟随指定物体挤出的数值"
	Pickbutton btn4 "挤出跟随选择物体的高度..." pos:[143,50] width:160 height:20 filter:filterGeometry toolTip:"点击此按钮使挤出的数值跟随指定物体的高度"
	

	
	local haveEditArray=#()--已添加编辑命令的物体不适合修改挤出命令，搜集这类物体
	local haveExtrudeArray=#()
	local noExtrudeArray=#()
	 
	 local hasUVWArray=#()  --有UVW的 物体 和它的UVW
     
	fn herModifiers _node =      -------用来寄存物体的修改器（Edit Spline除外）
	    (
			local _ModArray=#()
			
			for m in _node.modifiers where (m.name!="Edit Spline" and m.name!="编辑样条线") do insertItem m _ModArray 1 
			return _ModArray
		)
	fn deleteHerModifiers _node =      -------用来删除物体的修改器（Edit Spline除外）
	    (
			for i in 1 to _node.modifiers.count do
			(
				for m in _node.modifiers where (m.name!="Edit Spline" and m.name!="编辑样条线") do deleteModifier _node m 
			)
		)
	fn addHerModifiers _node _ModArray =        ------给物体添加之前寄存的修改器
	     (
			 for m in _ModArray do (if validModifier _node m then  addModifier _node m)
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
	fn creatExtrudeMod _amount:100 _capStart:true _capEnd:true =   -----创建一个新的挤出修改器
	     (
			 _extrudeMod=Extrude()
			 _extrudeMod.amount=_amount
			 _extrudeMod.capStart=_capStart
			 _extrudeMod.capEnd=_capEnd
			 return _extrudeMod
		 )
	fn deleteExtrudeMod _nodeArray =    --区分好类型，并删掉那些没编辑命令物体的Extrude命令，已添加编辑命令的物体是不可以删的添加进haveEditArray，有Extrude命令的 添加进haveExtrudeArray，没有的添加进noExtrudeArray
	(
		noExtrudeArray=#()
		haveExtrudeArray=#()
		haveEditArray=#()
		
		for i in _nodeArray do
			(
				 local num=i.modifiers.count
				 
				 if superclassof i.baseobject ==shape then
				 (
				 
				    if (num==0 or i.modifiers[1].name=="Edit Spline" or i.modifiers[1].name=="编辑样条线" or (not(hasModifier i "Extrude") and not(hasModifier i "挤出")))then 
				         (
							 appendIfUnique noExtrudeArray i
							 continue
						 )
				    else
					(
				     for j in 1 to num do
						 (
							for m in i.modifiers do
								(
									if (m.name=="Edit Mesh" or m.name=="Edit Poly" or m.name=="编辑网格" or m.name=="编辑多边形") then 
									     (
											 appendIfUnique haveEditArray i
											 exit
										 )
									else
										 (
									         if (m.name=="Extrude" or m.name=="挤出") then 
									            (
										             appendIfUnique haveExtrudeArray i
													 deleteModifier i m
									             )
								        )
								)
						) 
					)
				)
			)
	)
	fn zhengliHasUVW _nodeArray=   --判断是否有UVWMapping修改器，有则将 物体 和 UVWMapping 添加进 hasUVWArray 的二维数值里
	(
		 for i in _nodeArray do
		 (
			 
			 )
	)
	fn deleteUVWMod _nodeArray =    --判断是否有UVWMapping修改器，有则将 物体 和 UVWMapping 添加进 hasUVWArray 的二维数值里,删掉UVWMapping修改器
	(
		 hasUVWArray=#(#(),#())
		 
		 for i in _nodeArray do
		     (
				 local num=i.modifiers.count
				 local _herUVWs=#()
				 local _hasUVW=false
				 
				 for j in 1 to num do
		            (
				         for m in i.modifiers where (m.name=="UVW Map" or m.name=="UVW 贴图" or m.name=="UVW Mapping") do (_hasUVW=true;append _herUVWs m)
				         
				    )
				 if _hasUVW then
				 (
				      append hasUVWArray[1] i 
				     append hasUVWArray[2] _herUVWs[1]
				 )
			 )
		 
		 for i in selection do --遍历所有物体,删掉UVWMapping修改器
	        ( 
	             local num=i.modifiers.count
		         
		         for j in 1 to num do
		            (
				         for m in i.modifiers where (m.name=="UVW Map" or m.name=="UVW 贴图" or m.name=="UVW Mapping") do deleteModifier i m
				    )
	        )
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
	 
     fn getHeightOfObj _node =   --获取物体的高度
	     (
			 local bb= nodeLocalBoundingBox _node
			 local _height=abs(bb[2].z - bb[1].z)
			 return _height
		 )
	 fn getExtrudeHeightOfObj _node =   --获取物体的挤出高度
	     (
			 local _height=_node.modifiers[#Extrude].amount
			 return _height
		 )
	 
	 fn jichu _amount:0 =  ---挤出
	     (
			if selection.count==1 and hasModifier $ "Extrude" then    ----如果只是选了一个有挤出修改器的物体，那么就只修改挤出的数值，不重新删掉再添加了，目的防止破坏修改器关联
			(
				 if superExtrudeRollout.chkExtrudeSJ.checked then    ---如果选择随机挤出
				     (
						 $.modifiers[#Extrude].amount =(Random (superExtrudeRollout.spnExtrude.value as integer) (superExtrudeRollout.spnExtrude2.value as integer)) * superExtrudeRollout.spnExtrude3.value
				         $.modifiers[#Extrude].capStart=superExtrudeRollout.chkCapStart.state
				         $.modifiers[#Extrude].capEnd=superExtrudeRollout.chkCapEnd.state
				         
						 if _amount!=0 then ($.modifiers[#Extrude].amount=_amount;superExtrudeRollout.spnExtrude.value=_amount / superExtrudeRollout.spnExtrude3.value)
					 )
				 else 
					 (
				         $.modifiers[#Extrude].amount =superExtrudeRollout.spnExtrude.value
				         $.modifiers[#Extrude].capStart=superExtrudeRollout.chkCapStart.state
				         $.modifiers[#Extrude].capEnd=superExtrudeRollout.chkCapEnd.state
				         
						 if _amount!=0 then ($.modifiers[#Extrude].amount=_amount;superExtrudeRollout.spnExtrude.value=_amount)
					 )
			)
			 else
			(
				
			  deleteUVWMod selection     --先删UVW命令
			 
			 deleteExtrudeMod selection                --然后删Extrude命令
			 
			 join noExtrudeArray haveExtrudeArray    --合并这2个数组
             
			 local newNoExtrudeArray=filtInstanceArray noExtrudeArray  --过滤相关联的物体
			 
			 if superExtrudeRollout.chkExtrudeSJ.checked then    ---如果选择随机挤出
				(
					for i in newNoExtrudeArray do
			     		  ( 
							  local _herMods=herModifiers i  ---先将它的线层级以上的修改器存储到数组
							  deleteHerModifiers i    --删除它的线层级以上的修改器
							  
							  if validModifier i Extrude then addModifier i (Extrude ())  --添加挤出修改器
							  
							  addHerModifiers i _herMods  --还原它原来的修改器
							  
							 local _n=findItem hasUVWArray[1] i
							  if _n !=0 then addModifier i (hasUVWArray[2][_n])  --判断i是否有UVW，有的就加上它的UVW
							  
							  i.modifiers[#Extrude].amount =(Random (superExtrudeRollout.spnExtrude.value as integer) (superExtrudeRollout.spnExtrude2.value as integer)) * superExtrudeRollout.spnExtrude3.value
			        		   i.modifiers[#Extrude].capStart=superExtrudeRollout.chkCapStart.state
							  i.modifiers[#Extrude].capEnd=superExtrudeRollout.chkCapEnd.state
							 
							 if _amount!=0 then (i.modifiers[#Extrude].amount=_amount;superExtrudeRollout.spnExtrude.value=_amount / superExtrudeRollout.spnExtrude3.value)
				 		  )
				)
			 else
				(
			     if superExtrudeRollout.chkInstance.checked then
		            (
						local extrudeMod=undefined
						 extrudeMod =creatExtrudeMod _amount:superExtrudeRollout.spnExtrude.value \
						_capStart:superExtrudeRollout.chkCapStart.state _capEnd:superExtrudeRollout.chkCapEnd.state  --创建一个它们一起共用的挤出修改器
			         --以下是关联添加修改器
					  for i in newNoExtrudeArray do
			     		  ( 
							  local _herMods=herModifiers i  ---先将它的线层级以上的修改器存储到数组
							  deleteHerModifiers i    --删除它的线层级以上的修改器
							  
							  if validModifier i Extrude then addModifier i extrudeMod  --添加挤出修改器
							  
							  addHerModifiers i _herMods  --还原它原来的修改器
							  
							  local _n=findItem hasUVWArray[1] i
							  if _n !=0 then addModifier i (hasUVWArray[2][_n])  --判断i是否有UVW，有的就加上它的UVW
				 		  )
					  --extrudeMod.amount=superExtrudeRollout.spnExtrude.value
			 		  --extrudeMod.capStart=superExtrudeRollout.chkCapStart.state
			 		  --extrudeMod.capEnd=superExtrudeRollout.chkCapEnd.state
					 
					 if _amount!=0 then (extrudeMod.amount=_amount;superExtrudeRollout.spnExtrude.value=_amount)
			 		  
				    )
			     else
				    (
			 		  --以下是不关联添加修改器
			 		  for i in newNoExtrudeArray do
			     		  ( 
							  local _herMods=herModifiers i  ---先将它的线层级以上的修改器存储到数组
							  deleteHerModifiers i    --删除它的线层级以上的修改器
							  
							  if validModifier i Extrude then addModifier i (Extrude ())  --添加挤出修改器
							  
							  addHerModifiers i _herMods  --还原它原来的修改器
							  
							  local _n=findItem hasUVWArray[1] i
							  if _n !=0 then addModifier i (hasUVWArray[2][_n])  --判断i是否有UVW，有的就加上它的UVW
							  
							  i.modifiers[#Extrude].amount = superExtrudeRollout.spnExtrude.value 
			        		   i.modifiers[#Extrude].capStart=superExtrudeRollout.chkCapStart.state
							  i.modifiers[#Extrude].capEnd=superExtrudeRollout.chkCapEnd.state
							 
							 if _amount!=0 then (i.modifiers[#Extrude].amount=_amount;superExtrudeRollout.spnExtrude.value=_amount)
				 		  )
				    )
				)
			)
		 )
	 --  初始化设置
	on superExtrudeRollout open  do  --   使输入框获取焦点       初始化各参数设置，使参数都有默认值
	(
	   undo on
		(
			 
			 
		)
	)
	 
	on chkExtrudeSJ changed state do
		(
			undo on
			(
			case chkExtrudeSJ.checked of
				(
				true:(
					 chkExtrudeSJ.pos.x=262
					 
			         lblExtrude2.visible=true
					 spnExtrude2.visible=true
					 
					 lblExtrude3.visible=true
					 spnExtrude3.visible=true
					 
					 spnExtrude.value=1000*unitK
					 
					 jichu()
					 
				)
				false:( 
					 chkExtrudeSJ.pos.x=110
			         lblExtrude2.visible=false
					 spnExtrude2.visible=false
					 
					 lblExtrude3.visible=false
					 spnExtrude3.visible=false
					 
					 spnExtrude.value=0
					 
					 jichu()
					
				)
	         
			)
		)
	)
	
	on chkCapStart changed state do jichu()
	on chkCapEnd changed state do jichu()
	on chkInstance changed state do jichu()


	on spnExtrude entered do   ----响应回车键
	    (
		
		undo on
		(
			 jichu()
			 --closeRolloutFloater superExtrudeFloater   ---回车后关掉对话框
		)
	)
	on spnExtrude2 entered do   ----响应回车键
	    (
		
		undo on
		(
			 jichu()
			 --closeRolloutFloater superExtrudeFloater   ---回车后关掉对话框
		)
	)
	on spnExtrude3 entered do   ----响应回车键
	    (
		
		undo on
		(
			 jichu()
			 --closeRolloutFloater superExtrudeFloater   ---回车后关掉对话框
		)
	)
	on btn1 pressed do    
	(
		
		undo on
		(
			 jichu()
		)
	)
	
	on btn2 pressed do    
	(
		
		undo on
		(
			 deleteExtrudeMod selection
			 if haveEditArray.count==0 then (print "已经全部删掉挤出Extrude命令")
			 else
				 (
			         select haveEditArray
			         messageBox ("能删的都删了，但您所选物体中有些已经添加 网格编辑EditMesh 或者 多边形编辑EditPoly 命令，此类物体没作任何修改，已经为您选择到这些物体！") title:"请仔细检查您所选择的物体是否需要删Extrude命令" beep:false	
		         )
		)
	)
	on btn3 picked obj  do     ----跟随选择到的物体的挤出值
	(
		
		undo on
		(
			jichu _amount:(getExtrudeHeightOfObj obj as float)
		)
	)
	on btn4 picked obj  do     ----跟随选择到的物体的高度
	(
		
		undo on
		(
			jichu _amount:(getHeightOfObj obj as float)
		)
	)

)


addrollout superExtrudeRollout superExtrudeFloater 
setFocus superExtrudeRollout.spnExtrude
)