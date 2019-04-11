
--  破 解 脚 本 的 朋 友 注 意 了！！！！！！！！！！！！！！！！！！！！1

--  你可以破解，我不会骂你，不会鄙视你，因为我用的很多东西也都是破解的，

--  只希望你不要上传到网上去，如果发现网上出现此脚本的破解版，以后都不会再更新，谢谢

------------------Bingo  QQ:330798701 ---------------- 

try(closeRolloutFloater aoTuSegmentsFloater)catch()
aoTuSegmentsFloater = newRolloutFloater "线段方凹 Bingo" 220 240

	
rollout aoTuSegmentsRollout "线段方凹" 
(
	 checkbox chkBili "按中间段的比例：" pos:[10,10] width:110 height:14 checked:true toolTip:"使中间凹凸段所占该线段比例相等"
	 spinner spnBili "" pos:[125,10] width:72 height:16 range:[0,1.0,0.5] type:#float scale:0.01 visible:true toolTip:"调节中间凹凸段所占线段的比例"
     
	 checkbox chkShuzhi01 "按中间段的长度：" pos:[10,30] width:110 height:14 checked:false toolTip:"使中间凹凸段的长度相等"
	 spinner spnShuzhi01 "" pos:[125,30] width:72 height:16 range:[0,999999,10] type: #worldunits  scale:0.01 visible:true enabled:false toolTip:"调节中间凹凸段所占线段的长度"
	 
	 checkbox chkShuzhi02 "按端部段的长度：" pos:[10,50] width:110 height:14 checked:false toolTip:"使某一端部的长度相等"
	 spinner spnShuzhi02 "" pos:[125,50] width:72 height:16 range:[-999999,999999,20] type: #worldunits  scale:0.01 visible:true enabled:false toolTip:"调节端部段所占线段的长度"
	 
	 label lblLidu "凹凸力度：" pos:[64,110] width:65 height:14 toolTip:""
	 spinner spnLidu "" pos:[125,110] width:72 height:16 range:[-999999,999999,0] type: #worldunits  scale:0.01 visible:true toolTip:"调节中间段凹凸的数值"
     
	 label lblPianYi "凹凸偏移：" pos:[64,90] width:65 height:14 toolTip:""
	 spinner spnPianYi "" pos:[125,90] width:72 height:16 range:[-1.0,1.0,0] type:#float scale:0.01 visible:true toolTip:"调节中间凹凸段的偏移值"
	 
	 label lblGeshu "每条线段凹凸个数：" pos:[16,70] width:120 height:14 toolTip:""
	 spinner spnGeshu "" pos:[125,70] width:72 height:16 range:[1,9999,1] type:#integer scale:1 visible:true toolTip:"调节所选择线段中每条线段将凹凸多少个"
     
	 label lblFangxiang "凹凸方向：" pos:[64,130] width:80 height:14 toolTip:""
	 dropDownList ddlFangxiang "" pos:[125,127] width:72 items:#("统一方向","间隔相反")
	 
	 label lblTixing "梯形变化：" pos:[64,150] width:65 height:14 toolTip:""
	 spinner spnTixing1 "" pos:[125,150] width:72 height:16 range:[-1.0,1.0,0] type:#float scale:0.01 visible:true toolTip:"调节中间凹凸段梯形变形的比例"
	 spinner spnTixing2 "" pos:[125,170] width:72 height:16 range:[-1.0,1.0,0] type:#float scale:0.01 visible:true toolTip:"调节中间凹凸段梯形变形的比例"
	 
	 button btnQueding "确 定" pos:[10,190] width:46 height:25 toolTip:"应用当前凹凸形状，并退出"
	 button btnYingyong "应 用" pos:[57,190] width:46 height:25 toolTip:"应用当前凹凸形状，且继续凹凸"
	 button btnHuanyuan "还 原" pos:[104,190] width:46 height:25 toolTip:"还原为当次凹凸前的形状，记住，只能还原一次凹凸"
	 button btnQuxiao "取 消" pos:[151,190] width:46 height:25 toolTip:"点击按钮取消凹凸，并退出"
	 
	 local bili=undefined
	 local shuzhi01=undefined
	 local shuzhi02=undefined
	 local lidu=undefined
	 local pianyi=undefined
	 local geshu=undefined
	 local fangxiang=undefined
	 local tixing1=undefined
	 local tixing2=undefined
	 local shuzhi01=undefined
	 local shuzhi02=undefined
	 local type=undefined
	 
	 local _selectSegmentsArray=#()      ----储存凹凸前所选择的线段，此数组会根据用户再次选择线段而变化
	 local _selectSegmentsArray0=#()     ----储存凹凸前用户所选择的线段，用于还原，此数组获取线段后永远不变
	 local _allKnotsArray=#()            ----原始的所有的点
	 
	 local _yingyong=false   ---判断是否点击了应用
	 local _queding=false    ---判断是否点击了确定
	 
	 global unitK=1.0;
	 
	 fn UIContrl =
	    (
			 spnLidu.value=-20 * unitK
			 --spnLidu.scale=1 * unitK
			 spnShuzhi01.value=10 * unitK
			 spnShuzhi02.value=20 * unitK
			 
		)
	 fn unitTY=                           ---全局定义一个变量unitK来作为单位转换的参数
        (
			case units.MetricType of
		    (
			 #millimeters:(   ---毫米
							 unitK=1.0;
				             UIContrl()
				            )
							
             #centimeters:( ---厘米
							unitK=0.1;
							UIContrl()
							) 
							
             #meters:(     ---米
							unitK=0.001 ;
							UIContrl()
							) 
							
             #kilometers:(    ---千米
							unitK=0.000001;
							UIContrl()
							) 
			 
             default:(        ---毫米
				            unitK=1.0;
				             UIContrl()
				    ) 
            )
	    )
	 
	 fn init =    ------初始化各参数
	    (
			unitTY()   ---统一单位
          
			bili=undefined
	        shuzhi01=undefined
	        shuzhi02=undefined
	        lidu=undefined
	        pianyi=undefined
	        geshu=undefined
			fangxiang=undefined
			tixing1=undefined
			tixing2=undefined
			shuzhi01=undefined
			shuzhi02=undefined
			type=undefined
	               
	        _selectSegmentsArray=#() 
			_selectSegmentsArray0=#()
			_allKnotsArray=#()
			
			_yingyong=false 
			_queding=false
			
		)
	 
	 fn getAllValue=  -----获取所有参数的值
		(
			 bili=spnBili.value
			 shuzhi01=spnShuzhi01.value
			 shuzhi02=spnShuzhi02.value
			 
			 lidu=spnLidu.value
			 
			 pianyi=spnPianYi.value
			 geshu=spnGeshu.value
			 
			 tixing1=spnTixing1.value
			 tixing2=spnTixing2.value
		)
		
	 fn noSelectKnotOfShape _Shape=    ---------------------不选点--------------------------
	    (
			 select _Shape
		     for i in 1 to numSplines _Shape do
			 (
			 max modify mode
			 modPanel.setCurrentObject _Shape
             subobjectLevel = 1
             setKnotSelection _Shape i #()  keep:false
             subobjectLevel = 2
			 )
	    )
	 fn noSelectSegmentOfShape _Shape=     ----------------------不选线段----------------------
	    (
			 for i in 1 to numSplines _Shape do     --空选线段
                    (
		                setSegSelection _Shape i #() keep:false   
	                )
		)
	 fn selectKnotsByArray _Shape _knotsArray=     ----------------------根据数组来选择点----------------------
	    (
			 for i in 1 to numSplines _Shape do     
                    (
		                setKnotSelection _Shape i _knotsArray[i] keep:true   
	                )
		)
	 fn selectSegmentByArray _Shape _segmentsArray=     ----------------------根据数组来选择线段----------------------
	    (
			 for i in 1 to numSplines _Shape do     
                    (
		                setSegSelection _Shape i _segmentsArray[i] keep:true   
	                )
		)
    fn deleteKnotOfShape _Shape _SplineIndex _KnotArray=    ---------------------按数组删除线条上的点----------------------------
	    (
			 select _Shape
			 max modify mode
			 modPanel.setCurrentObject _Shape
             subobjectLevel = 1
             setKnotSelection _Shape _SplineIndex _KnotArray  keep:false
			 max delete 
             subobjectLevel = 0
	    )
	 
    fn isHasSelectSegments _Shape =   ---判断 _Shape 是否有选择的线段
	        (
			     --convertToSplineShape _Shape
				 
				 local _hasSelectSegment=false
			     
			     for i in 1 to numSplines _Shape do
	             (
					 if (getSegSelection _Shape i).count!=0 then (_hasSelectSegment=true;exit)
	             )
			     return _hasSelectSegment
			     
		    )

    fn lengthOfSeg _Shape _SplineIndex _SegmentIndex =    --获取shape的某一条样条线的某一个线段的长度
	(
		local _L=getSegLengths _Shape _SplineIndex
		return _L[(numSegments _Shape _SplineIndex) + _SegmentIndex]
	)
     
	 fn InvertArray _arrayBig _arraySmall=     -----在 _arrayBig 里删掉 _arraySmall的元素 
        (
	     for i in 1 to _arrayBig.count do  -----反选数组
			(
				for s in _arraySmall[i] do
					(
						_index=findItem _arrayBig[i] s
						if _index != 0 then deleteItem _arrayBig[i] _index
					)
			)
	    )
	 fn getAllKnots _Shape =   ----获取线条 _Shape 所有的点的数组
	        (
			     local _allKnotsArray=#() 
                 for i in 1 to numSplines _Shape do
                 (
                     append _allKnotsArray #()
					 for j in 1 to numKnots _Shape do
					    (
							 append _allKnotsArray[i] j
						)
                 )
                 
			     return _allKnotsArray
		    )
    fn getSelectSegments _Shape =   ----获取线条 _Shape 选择的线段的序号和选择线段所在样条线的序号 得到一个数组 #(#(样条线1里面所选的线段),#(样条线2里面所选的线段))
	        (
			     local _arrSelectSegments=#()  --- #(#(样条线1  _SegmentIndex,_SegmentIndex...),#(样条线2  _SegmentIndex,_SegmentIndex...),...)
												--   #(#(1,2),#(2,4)...)
                 local _numSelectSegments=0
	             
                 for i in 1 to numSplines _Shape do
                 (
                     append _arrSelectSegments(getSegSelection _Shape i)
                 )
                 
			     return _arrSelectSegments
		    )
     
    fn divideSegment _Shape _SplineIndex _SegmentIndex _n=   ----给线条 _Shape 的指定线段  划分为 _n 段
	        (
 				 subdivideSegment _Shape _SplineIndex _SegmentIndex (_n-1)	
			     updateShape _Shape
		    )
	fn divideSegment2 _Shape _SplineIndex _SegmentIndex _proportion _offset=   ----按比例来给线条 _Shape 的指定线段  
																--划分3段 中间段比例为 _proportion (0.0~1.0) _offset(-1.0~1.0)
             (
				 o=_offset   ---偏移所占第一段的比例
				 
				 p0=_proportion   ---中间段所占比例
				 p1=(1-p0)/2 * (1-o)     ---第一段所占比例
				 p2=p0/(1-p1)      ---第三段所占比例
				 
				 refineSegment _Shape _SplineIndex _SegmentIndex p1
				 refineSegment _Shape _SplineIndex (_SegmentIndex+1) p2
				 
				 updateShape _Shape
			 )	

    ------凹凸线条上的某一条线段  线、样条线序号、线段序号、凹凸个数、凹凸段占该单个凹凸的比例、凹凸段在单个凹凸的偏移值、凹凸的量值  按哪种类型凹凸、凹凸的方向、凹凸梯形变形
    fn aoTuSegment _Shape _SplineIndex _SegmentIndex _geshu _proportion _offset _amount _type:1 _fangxiang:1 _tixing1:0 _tixing2:0 =  
    (
	 local _IndexSpline=_SplineIndex
	 local _IndexSegment=_SegmentIndex
	 
	 local _IndexSegment0=_SegmentIndex
	 
	 divideSegment _Shape _SplineIndex _SegmentIndex _geshu  --先将线段划分为3段
	 
	 local _tx1=_tixing1
	 local _tx2=_tixing2
	 
	 local _bili=_proportion
	 local _lengthSeg=lengthOfSeg _Shape _IndexSpline _IndexSegment
		
	 if _type==1 then _bili=_proportion
	 else if _type==2 then _bili=shuzhi01/_lengthSeg
	 else if _type==3 then _bili=(1-2*shuzhi02/_lengthSeg)
	 
	 
	 
	 for g = 1 to _geshu do
	 (
	    for i = 1 to 2 do   --划分线段2次
		    (
			     divideSegment2 _Shape _IndexSpline _IndexSegment _bili _offset    ----将选择的线段按比例细分为 3 段  中间段比例为 _proportion
			     
			     _IndexSegment+=1
		    )
		 	
		 --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		 --------------------------将新生成的点转换成角点----------------
		setKnotType _Shape _IndexSpline (_IndexSegment-1) #corner 
		setKnotType _Shape _IndexSpline _IndexSegment #corner 
		setKnotType _Shape _IndexSpline (_IndexSegment+1) #corner 
		setKnotType _Shape _IndexSpline (_IndexSegment+2) #corner 
		
		------------------------计算凹凸后的点的位置 P2 P3 ----------------------
		local P1=getKnotPoint _Shape _IndexSpline (_IndexSegment-1)       -----P1为原线段上的一个点
		local P4=getKnotPoint _Shape _IndexSpline (_IndexSegment+2)    -----P4为原线段上的另一个点
		
		local P2=[0,0,0]    -----P2为原线段上从 P1 偏移后的点
		local P3=[0,0,0]   -----P3为原线段上从 P4 偏移后的点
		
		local _dis=distance P1 P4
		local θ=(acos ((P4.x-P1.x)/_dis))   ---计算出选择的线段的Z轴上旋转的角度
		--------------------------------------------------------------------------------------------------------------------------------@间隔方向
		local _amount2=_amount
		if _fangxiang==2 then       ---当选择间隔相反时，让凹凸的方向在偶数时反向
		    (
				 if (Mod g 2) == 0 then _amount2=-_amount   ---当g是偶数时，将凹凸力度的值变为负数
			)
		--------------------------------------------------------计算凹凸后的点的位置坐标------------------------------------------------------------------------@
		if P4.y <= P1.y then
			(
				P2.x=P1.x + _amount2 * (sin θ)
				P2.y=P1.y + _amount2 * (cos θ)
				P2.z=P1.z
				
				P3.x=P4.x + _amount2 * (sin θ)
				P3.y=P4.y + _amount2 * (cos θ)
				P3.z=P4.z
				
				--------------------------------------------------------------------------------------------------------------------------------@梯形变化
		        P2.x+=0.5 * _dis * _tx1 * (cos θ)
		        P2.y+=-0.5 * _dis * _tx1 * (sin θ)
		        
		        P3.x+=-0.5 * _dis * _tx2 * (cos θ)
		        P3.y+=0.5 * _dis * _tx2 * (sin θ)
		        --------------------------------------------------------------------------------------------------------------------------------@
				
			)
		else 
			(
				P2.x=P1.x - _amount2 * (sin θ)
				P2.y=P1.y + _amount2 * (cos θ)
				P2.z=P1.z
				
				P3.x=P4.x - _amount2 * (sin θ)
				P3.y=P4.y + _amount2 * (cos θ)
				P3.z=P4.z
				
				--------------------------------------------------------------------------------------------------------------------------------@梯形变化
		        P2.x+=0.5 * _dis * _tx1 * (cos θ)
		        P2.y+=0.5 * _dis * _tx1 * (sin θ)
		        
		        P3.x+=-0.5 * _dis * _tx2 * (cos θ)
		        P3.y+=-0.5 * _dis * _tx2 * (sin θ)
		        --------------------------------------------------------------------------------------------------------------------------------@
				
			)
		 
		------------------------接下来就是移动点到凹凸后的位置--------------
		setKnotPoint _Shape _IndexSpline _IndexSegment P2
		setKnotPoint _Shape _IndexSpline (_IndexSegment+1) P3
			
		 --+++++++++++++++++++++++++++++++++++++   删除废点   +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		 if g >=2 then 
		    (
				 deleteKnot _Shape _IndexSpline (_IndexSegment-2)
				 _IndexSegment+=2
			)
		 else
			(
	             _IndexSegment+=3
			)
		 
		 -----------------------------------选择凹凸后的生成的所有新的点，以备还原操作-----------------------
		 setKnotSelection _Shape _IndexSpline #((_IndexSegment0+1+4*(g-1)),(_IndexSegment0+2+4*(g-1)),(_IndexSegment0+3+4*(g-1)),(_IndexSegment0+4+4*(g-1)))  keep:true
		 
		 -----------------------------------选择凹凸后的线段，以供第二次继续凹凸-----------------------------------------
		 setSegSelection _Shape _IndexSpline #((_IndexSegment0+2+4*(g-1))) keep:true  ---选择中间那根新的线段凹凸后的
			
	   )
		 
		updateShape _Shape
		
    )
	
	fn aoTu _Shape =    --开搞
		(
                 
				 local _segmentsArray=deepcopy _selectSegmentsArray  ----首先获取所有被选择的线段，得到一个包括 线段序号 的数组
			     
				 noSelectSegmentOfShape $ --空选线段
				 --noSelectKnotOfShape $   ---空选点
			     
			     
                 for l in 1 to _segmentsArray.count do    ---将选择的线段一个个的凹凸
                    (
						 setKnotSelection _Shape l #()  keep:false  ---空选点
						 
						 for s in 1 to _segmentsArray[l].count do
		                     (
								 aoTuSegment _Shape l (_segmentsArray[l][s]) geshu bili pianyi lidu _type:type _fangxiang:fangxiang _tixing1:tixing1 _tixing2:tixing2 
				                 
				                 if s<_segmentsArray[l].count then _segmentsArray[l][s+1]+=4*geshu*s
			                )
	                )
	    )
	 
	fn deleteKnotsByArray _Shape _knotsArray =   ---根据点的数组  _knotsArray  还原为原来形状
	    (
			 for i in 1 to _knotsArray.count do
			    (
					 deleteKnotOfShape _Shape i _knotsArray[i]
				)
		)
	 fn huanyuan2=  ----另一种方法还原  在复制后的线上凹凸  还原只需删掉复制的线  选择之前的线即可
	    (
			 if _huanyuan then
			    (
					 delete _tempShape
					 _tempShape=undefined
					 select myShape
				)
		)
	fn huanyuan3=  --根据之前已经选择的那些点，直接删除就OK了
	    (
			/*if _yingyong then 
			     (
					 _yingyong=false
				 )
			else(*/
			         max modify mode
			         modPanel.setCurrentObject $
                     subobjectLevel = 1
                     max delete
                     subobjectLevel = 2
					 
					 --noSelectKnotOfShape $   ---空选点    还原是否还原彻底   有这句就不会彻底
				     
			    --)
			selectSegmentByArray $ _selectSegmentsArray   ---还原后选择用户选择的线段
		)

	 fn FuckJanpan =  --整个流程
	    (
			 if (selection.count==1 and superClassOf($.baseObject)==Shape) then
		        (
			        if (isHasSelectSegments $) then
				        (
							 ----如果没有重新选择线段
 							 huanyuan3()   ----设置为如果另外选择线段了 就不用这句
							 --aoTu $
							 
							 ----如果重新选择了线段
							 --_selectSegmentsArray=getSelectSegments $     ----首先获取所有被选择的线段，得到一个包括 线段序号 的数组
							 aoTu $
                        )
			        else (messagebox ("请选择要凹凸的线段！！");_queding=true;closeRolloutFloater aoTuSegmentsFloater)
		        )
	        else (messagebox ("请选择 ! 一个 ! 有线堆栈的物体！！");_queding=true;closeRolloutFloater aoTuSegmentsFloater)
		)
		
	 on aoTuSegmentsRollout open  do  --   使输入框获取焦点       初始化各参数设置，使参数都有默认值
	(
	   undo on
		(
			 --try(
			 init()  ---初始化各参数
			 if (selection.count==1 and superClassOf($.baseObject)==Shape) then
		        (
			        if (isHasSelectSegments $) then
				        (
							 getAllValue()  -----更新获取所有参数的值
							 
							 _selectSegmentsArray=getSelectSegments $     ----首先获取所有被选择的线段，得到一个包括 线段序号 的数组
							 _selectSegmentsArray0=deepcopy _selectSegmentsArray  ----这个是永远不会变的，是用户选择的那些线段用来还原
							 
							 noSelectKnotOfShape $   ---空选点
							 
							 aoTu $
                        )
			        else (messagebox ("请选择要凹凸的线段！！");_queding=true;closeRolloutFloater aoTuSegmentsFloater)
		        )
	        else (messagebox ("请选择 ! 一个 ! 有线堆栈的物体！！");_queding=true;closeRolloutFloater aoTuSegmentsFloater)
			--)
			--catch (messagebox ("请确定选择的是否为可编辑样条线，且是否选择了要凹凸的线段！！");_queding=true;closeRolloutFloater aoTuSegmentsFloater)
			 
		)
	)
	on aoTuSegmentsRollout close  do  --   使输入框获取焦点       初始化各参数设置，使参数都有默认值
	(
	   undo on
		(
			 if _queding then
			    (
				     
				)
			 else
				(
					huanyuan3()
				 )
		)
	)
	on chkBili changed state do
		(
			case chkBili.checked of
				(
				false:( 
					 
				)
				true:( 
					 chkShuzhi01.state=false
					 chkShuzhi02.state=false
					 
					 spnBili.enabled=true
					 
					 spnShuzhi01.enabled=false
					 
					 spnShuzhi02.enabled=false
					 
					 type=1
			         bili=spnBili.value
			         FuckJanpan()
				)
			)
	)
	on chkShuzhi01 changed state do
		(
			case chkShuzhi01.checked of
				(
				false:( 
					 
				)
				true:( 
					 chkBili.state=false
					 chkShuzhi02.state=false
					 
					 spnBili.enabled=false
					 
					 spnShuzhi01.enabled=true
					 
					 spnShuzhi02.enabled=false
					 
					 type=2
			         shuzhi01=spnShuzhi01.value
			         FuckJanpan()
				)
			)
	)
	on chkShuzhi02 changed state do
		(
			case chkShuzhi02.checked of
				(
				false:( 
					 
				)
				true:( 
					 chkBili.state=false
					 chkShuzhi01.state=false
					 
					 spnBili.enabled=false
					 
					 spnShuzhi01.enabled=false
					 
					 spnShuzhi02.enabled=true
					 
					 type=3
			         shuzhi02=spnShuzhi02.value
			         FuckJanpan()
				)
			)
	)
	
	
	
	on spnBili changed _val do    
	(
		undo off
		(
			 type=1
			 bili=_val
			 FuckJanpan()
		)
	)
	on spnShuzhi01 changed _val do    
	(
		undo off
		(
			 type=2
			 shuzhi01=_val
			 FuckJanpan()
		)
	)
	on spnShuzhi02 changed _val do    
	(
		undo off
		(
			 type=3
			 shuzhi02=_val
			 FuckJanpan()
		)
	)
	
	on spnLidu changed _val do    
	(
		undo off
		(
			 lidu=_val
			 FuckJanpan()
		)
	)
	on spnPianyi changed _val do    
	(
		undo off
		(
			 pianyi=_val
			 FuckJanpan()
		)
	)
	on spnGeshu changed _val do    
	(
		undo off
		(
			 geshu=_val
			 FuckJanpan()
		)
	)
	on spnTixing1 changed _val do    
	(
		undo off
		(
			 tixing1=_val
			 FuckJanpan()
		)
	)
	on spnTixing2 changed _val do    
	(
		undo off
		(
			 tixing2=_val
			 FuckJanpan()
		)
	)
	on ddlFangxiang selected _val do 
		undo off
		(
			 fangxiang=_val
			 FuckJanpan()
		)
	on btnQueding pressed do    
	(
		undo on
		(
			 _queding=true
			 closeRolloutFloater aoTuSegmentsFloater
		)
	)
     on btnYingyong pressed do    
	(
		undo on
		(
			 _selectSegmentsArray=getSelectSegments $
			 
			 aoTu $
			 
			 _yingyong=true
		)
	)
	on btnHuanyuan pressed do    
	(
		undo on
		(
			 huanyuan3()
		)
	)
	on btnQuxiao pressed do    
	(
		undo on
		(
			 _yingyong=false
			 huanyuan3()
			 
			 closeRolloutFloater aoTuSegmentsFloater
		)
	)
)

addrollout aoTuSegmentsRollout aoTuSegmentsFloater 
--setFocus aoTuSegmentsRollout.spnExtrude