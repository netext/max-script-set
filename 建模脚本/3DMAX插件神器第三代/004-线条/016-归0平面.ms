										
	fn update_shape  h  old_pos =
	(
	
	num=numknots $ 1
	for f = 1 to num do
	(
	ha=h/(num-1)
	new_pos=old_pos[f]+[0,0,ha*(f-1)]
	setknotpoint $ 1 f new_pos
	)
	updateshape $
	)
	
										
	fn update_shape_2  h  old_pos =
	(
	
	num=numknots $ 1
	for f = num to 1 by -1 do
	(
	ha=h/(num-1)
	new_pos=old_pos[f]+[0,0,ha*(f-1)]
	setknotpoint $ 1 f new_pos
	)
	updateshape $
	)

	
	fn yabian =
	(
			   new_z = $.pos.z 
		
		    for s = 1 to (numSplines $) do 
		
		    ( 
		
		      for k = 1 to (numKnots $ s) do 
		
		      ( 
		
		        knt = getKnotPoint $ s k 
		
		        in_vec = getInVec $ s k 
		
		        out_vec = getOutVec $ s k 
		
		        knt.z = in_vec.z = out_vec.z = new_z 
		
		        setInVec $ s k in_vec 
		
		        setOutVec $ s k out_vec 
		
		        setKnotPoint $ s k knt 
		
		      )
		    )
			
	    updateshape $ 
	)
	
	rollout poxian "坡线" width:150 height:127
	(
	     local pt=#()
		pickbutton btn1 "拾取线型" pos:[45,10] width:73 height:20
		spinner gao "高度：" pos:[18,43] width:125 height:16 range:[-1e+007,1e+007,0] scale:1
		label lbl1 "【3dheima.com】" pos:[20,105] width:87 height:18
		label lbl2 "" pos:[88,106] width:95 height:16
		button btn15 "压平" pos:[45,73] width:73 height:20				
		
		on btn1 picked obj do
		(
		    pt=#()
			btn1.text=obj.name
			select obj
		
			num=numknots obj 1
			for f = 1 to num do
			(	
			original_pos=getknotpoint obj 1 f
			append pt original_pos
			)
		gao.value=0
		)
		
		on gao changed val do
		(
		undo on
		(
		try
		(
		update_shape val pt
		)catch()
		)
		)
		
		on btn15 pressed do
		(
		try
		(
              yabian()
		     pt=#()
			num=numknots $ 1
			for f = 1 to num do
			(	
			original_pos=getknotpoint $ 1 f
			append pt original_pos
			)
			gao.value=0
			)catch()
		)
		
	)
	mtl=newrolloutfloater "坡线" 170 160
	addrollout poxian mtl