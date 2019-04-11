
rollout coolcolor "兰海波"
(
	group  "单色渲染"
	(
	button  delmat  "全变单色"
	button  back  "恢复材质"
	button  rendersub "渲染子材质"
	)
button  zrender "干活"
on coolcolor open do
	(	
		global zall=#()
		global oldmat=#()
		
		for i in $* do 
			(if (superclassof i)==geometryclass 	do append zall i) 
			for i=1 to zall.count do oldmat[i]=zall[i].material
		
	)
/*on bianse pressed do 
	(
	set animate on
	slidertime +=1
	clearselection()
		
		for i in $* do 
		( 
		 rcolor = random (color 0 0 0) (color 255 255 255)
			     zm = standardmaterial selfIllumAmount:100\
				 		ambient:rcolor diffuse:rcolor
		if i.material==undefined do i.material=zm
		)
	
	
	for x=1 to scenematerials.count do 
		(
		 rcolor = random (color 0 0 0) (color 255 255 255)
		     zm = standardmaterial selfIllumAmount:100\
			 		ambient:rcolor diffuse:rcolor
		
			for i in zall do 
			(if i.material==scenematerials[x] do i.material=zm)
		)
	--max quick render
	for i=1 to zall.count do zall[i].material=oldmat[i]
	slidertime -=1
	
	set animate off
	)

on notback pressed do 
	(
	set animate on
	slidertime +=1
	clearselection()

		for i in $* do 
		( 
		 rcolor = random (color 0 0 0) (color 255 255 255)
			     zm = standardmaterial selfIllumAmount:100\
				 		ambient:rcolor diffuse:rcolor
		if i.material==undefined do i.material=zm
		)


	
	for x=1 to scenematerials.count do 
		(
		 rcolor = random (color 0 0 0) (color 255 255 255)
		     zm = standardmaterial selfIllumAmount:100\
			 		ambient:rcolor diffuse:rcolor
		
			for i in zall do 
			(if i.material==scenematerials[x] do i.material=zm)
		)
	--max quick render
	--for i=1 to zall.count do zall[i].material=oldmat[i]
	slidertime -=1
	
	set animate off
	)
*/
on delmat pressed do 
	(
			for i in $* do 
			( 
			 rcolor = random (color 0 0 0) (color 255 255 255)
				     zm = standardmaterial selfIllumAmount:100\
					 		ambient:rcolor diffuse:rcolor
			if i.material==undefined do i.material=zm
			)
	
		for x=1 to scenematerials.count do 
			(
			 rcolor = random (color 0 0 0) (color 255 255 255)
			     zm = standardmaterial selfIllumAmount:100\
				 		ambient:rcolor diffuse:rcolor
			
				for i in zall do 
				(if i.material==scenematerials[x] do i.material=zm)
			)
	
	
	)

on back pressed do (for i=1 to zall.count do zall[i].material=oldmat[i])



on rendersub pressed do 
	(
	set animate on
	slidertime +=1
	clearselection()
	for i in $* do 
			( 
			 rcolor = random (color 0 0 0) (color 255 255 255)
				     zm = standardmaterial selfIllumAmount:100\
					 		ambient:rcolor diffuse:rcolor
			if i.material==undefined do i.material=zm
			)
	for x=1 to scenematerials.count do 
		(
		 rcolor = random (color 0 0 0) (color 255 255 255)
		     zm = standardmaterial selfIllumAmount:100\
			 		ambient:rcolor diffuse:rcolor
		
			for i in zall do 
			(
			if i.material==scenematerials[x] do
				( 
				if ((classof i.material)==multimaterial)
				 then  
					(
					     rcolorlan = random (color 0 0 0) (color 255 255 255)
		     				zmlan = multimaterial  selfIllumAmount:100 numsubs:(i.material.numsubs)\
			 						ambient:rcolorlan diffuse:rcolorlan
						 for j=1 to  i.material.numsubs  do
						 	(
							
							 rcolorlanx = random (color 0 0 0) (color 255 255 255)
			     				zmlanx = standardmaterial selfIllumAmount:100\ 
				 						ambient:rcolorlanx diffuse:rcolorlanx
	
													
							zmlan[j]=zmlanx
							)
	

				 i.material=zmlan
					 
					 )
				else i.material=zm
				)
			
			)
		)
	--max quick render
	--for i=1 to zall.count do zall[i].material=oldmat[i]
	slidertime -=1
	set animate off
	)

on zrender pressed do ( max quick render )

)
createdialog coolcolor