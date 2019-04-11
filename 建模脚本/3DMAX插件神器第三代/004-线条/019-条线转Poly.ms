--macroScript zoa_spline2poly
	--category: "zoa scripts"

--------------------------------------
--	zoa spline2ploy
--	2011 by zoa                    
--	Andras Balogh (balogh.andras@zoa.hu)
--	www.zoa3d.com                   
--------------------------------------
--	v 1.00
--	Last Modified On: 07/11/2011
--	Created On: 07/11/2011
---------------------------------------


-------------------------------------------------------------------------------
--   	Description:
--	
--	Select a bunch of shapes and turn them into an editable poly by creating the interior intersections
-------------------------------------------------------------------------------
--	Notes and limitations:
--
--	No limitations yet... Found a bug? Report it!
-------------------------------------------------------------------------------
--	Revision History:
--
--	v 1.00 - 07.11.2011 - Created the original script
-------------------------------------------------------------------------------







(
global tmp_selection=#()	
------------------------------------------------------------------------------------------------------------------

	
------------------------------------------------------------------------------------------------------------------
-- fn turntopoly
------------------------------------------------------------------------------------------------------------------	
	
fn turntopoly treshold=
	(	
	zerotime= (timeStamp()/1000)
	zerotime2=zerotime
------------------------------------------------------------------------------------------------------------------
--intersections
------------------------------------------------------------------------------------------------------------------
	undo off
	tmp_lines=#()
	tmp_points=#()
		
	tmp2_lines=#()
	for obj in tmp_selection do 
		(
		for s = 1 to (numSplines obj) do
			(
			for k = 1 to (numSegments obj s) do
				(
				l=k+1
				if k==(numKnots obj s) then l=1
				spline_shape = SplineShape ()	
				addNewSpline spline_shape
				addKnot spline_shape 1 #corner #line (getKnotPoint obj s k)
				addKnot spline_shape 1 #corner #line (getKnotPoint obj s l)
				updateShape spline_shape
				spline_shape.render_displayRenderMesh=true
				append tmp_lines spline_shape						
				)
			)
		)
			
	for i=1 to tmp_lines.count do
		(
		a= copy tmp_lines[i]
		tmp2_lines[i]=a
		for s = 1 to (numSplines a) do
			(
			for k = 1 to (numKnots a s) do
				( 
				setKnotPoint a s k [(getKnotPoint a s k)[1],  (getKnotPoint a s k)[2], 0]
				)
			)
		)
		
	DummyDataCA = attributes DummyData
		(
		parameters main rollout:params
			(
			node1 type:#node
			node2 type:#node
			)
		rollout params "neighbour points"
			(
			)
		)	
				
	for i=1 to tmp_lines.count do
		(
		for j=i+1 to tmp_lines.count do
			(
			if (intersects tmp2_lines[i] tmp2_lines[j]) ==true then
				(
				
				p1=(getKnotPoint tmp_lines[i] 1 1)
				p2=(getKnotPoint tmp_lines[i] 1 2)
				p3=(getKnotPoint tmp_lines[j] 1 1)
				p4=(getKnotPoint tmp_lines[j] 1 2)

				if abs(p1[1]-p2[1])>abs(p1[2]-p2[2]) then --elso vonal nem fuggoleges
					(
					a=(p1[2]-p2[2])/(p1[1]-p2[1])	
					b=p1[2]-a*p1[1]
					a2=(p1[3]-p2[3])/(p1[1]-p2[1])	
					b2=p1[3]-a2*p1[1]
						
						
					if abs(p3[1]-p4[1])>abs(p1[2]-p2[2])  then -- masodik vonal nem fuggoleges
						(
						
						c=(p3[2]-p4[2])/(p3[1]-p4[1])	
						d=p3[2]-c*p3[1]
						c2=(p3[3]-p4[3])/(p3[1]-p4[1])	
						d2=p3[3]-c2*p3[1]
							
						if a!=c then
							(
							x5=(d-b)/(a-c)
							y5=a*x5+b
							z5=(a2*x5+b2)/2+(c2*x5+d2)/2
							p5=[x5,y5,z5] as point3
							if (nodeLocalBoundingBox tmp_lines[i])[1][1]<=x5+treshold/2 and (nodeLocalBoundingBox tmp_lines[i])[2][1]>=x5-treshold/2 and (nodeLocalBoundingBox tmp_lines[j])[1][1]<=x5+treshold/2 and (nodeLocalBoundingBox tmp_lines[j])[2][1]>=x5-treshold/2 then
								(
								PP= point pos:[x5,y5,z5]  size:5
								pp.name=("pont_1_"+tmp_lines[i].name as string + "___" + tmp_lines[j].name as string )
								custAttributes.add pp DummyDataCA	
								pp.node1=tmp_lines[i]
								pp.node2=tmp_lines[j]
								append tmp_points pp
								)
							)
							
						)else(--masodik vonal fuggoleges
						c=(p3[1]-p4[1])/(p3[2]-p4[2])		
						d=(p3[1]- c*p3[2])
						c2=(p3[3]-p4[3])/(p3[2]-p4[2])	
						d2=p3[3]-c2*p3[2]
						x5=(c*b+d)/(1-c*a)
						y5=a*x5+b	
						z5=(a2*x5+b2)/2+(c2*y5+d2)/2
						p5=[x5,y5,z5] as point3
						if (nodeLocalBoundingBox tmp_lines[i])[1][2]<=y5+treshold/2 and (nodeLocalBoundingBox tmp_lines[i])[2][2]>=y5-treshold/2 and (nodeLocalBoundingBox tmp_lines[j])[1][2]<=y5+treshold/2 and (nodeLocalBoundingBox tmp_lines[j])[2][2]>=y5-treshold/2 then
							(
							PP= point pos:[x5,y5,z5]  size:5
							pp.name=("pont_2_"+tmp_lines[i].name as string + "___" + tmp_lines[j].name as string )
							custAttributes.add pp DummyDataCA	
							pp.node1=tmp_lines[i]
							pp.node2=tmp_lines[j]
							append tmp_points pp
							)
						)
					)else(
					--elso vonal fuggoleges, de masodik nem
					if p3[1]!=p4[1] then 
						(
						a=(p1[1]-p2[1])/(p1[2]-p2[2])		
						b=(p1[1]- a*p1[2])
						c=(p3[2]-p4[2])/(p3[1]-p4[1])	
						d=p3[2]-c*p3[1]	
						x5=(a*d+b)/(1-a*c)
						y5=c*x5+d
						a2=(p1[3]-p2[3])/(p1[2]-p2[2])	
						b2=p1[3]-a2*p1[2]
						c2=(p3[3]-p4[3])/(p3[1]-p4[1])	
						d2=p3[3]-c2*p3[1]
						z5=(a2*y5+b2)/2+(c2*x5+d2)/2	
						p5=[x5,y5,z5] as point3
						if (nodeLocalBoundingBox tmp_lines[i])[1][2]<=y5+treshold/2 and (nodeLocalBoundingBox tmp_lines[i])[2][2]>=y5-treshold/2 and (nodeLocalBoundingBox tmp_lines[j])[1][2]<=y5+treshold/2 and (nodeLocalBoundingBox tmp_lines[j])[2][2]>=y5-treshold/2 then
							(
							PP= point pos:[x5,y5,z5] size:5
							pp.name=("pont_3_"+tmp_lines[i].name as string + "___" + tmp_lines[j].name as string )
							custAttributes.add pp DummyDataCA	
							pp.node1=tmp_lines[i]
							pp.node2=tmp_lines[j]
							append tmp_points pp
							)
						)
					)
				)			
			)		
		)
		
		
	for i in tmp_points do
		(
		lin=#()
		lin[1]= i.node1
		lin[2]= i.node2
		for j=1 to 2 do
			(
			if  (numKnots lin[j] 1)>2 then
				(
				p=#()
				if abs((getKnotPoint lin[j] 1 1)[1]-(getKnotPoint lin[j] 1 (numKnots lin[j] 1))[1])>abs((getKnotPoint lin[j] 1 1)[2]-(getKnotPoint lin[j] 1 (numKnots lin[j] 1))[2]) then --ha nem fuggoleges
					(
					for k = 1 to (numKnots lin[j] 1) do	
						(
						if 	i.pos[1]>(getKnotPoint lin[j] 1 k)[1] then p[k]=true else  p[k]=false
						)
					)else(
					for k = 1 to (numKnots lin[j] 1) do	
						(
						if 	i.pos[2]>(getKnotPoint lin[j] 1 k)[2] then p[k]=true else  p[k]=false
						)
					)
				
				for k = 1 to (numKnots lin[j] 1)-1 do	
					(
					if 	p[k]!=p[k+1] then 
						(
						subdivideSegment lin[j] 1 k 1
						setKnotPoint lin[j] 1 (k+1) i.pos
						)
					)
				)else(
				subdivideSegment lin[j] 1 1 1
				setKnotPoint lin[j] 1 2 i.pos
				)
			)
		delete i	
		)
		
	spline_shape = SplineShape ()	
	s=0	
	 for i in  tmp_lines do 
		 (
		addNewSpline spline_shape 
		s+=1
		for k = 1 to (numKnots i 1) do
			 (
			 addKnot spline_shape s #corner #line (getKnotPoint i 1 k)
			 )
		updateShape spline_shape	 
		 )
		 
	spline_shape.render_displayRenderMesh=false
	select spline_shape
	spline_shape.name="ujvonal"
		 
	 for i in  tmp_lines do 
		 (
			delete i
		 )	
		 
	for i in  tmp2_lines do 
		 (
			delete i
		 )	
	 print ("intersections:  " + ((timeStamp()/1000)-zerotime) as string + " sec")
	 zerotime=(timeStamp()/1000)
------------------------------------------------------------------------------------------------------------------
--create points and the TMP array
------------------------------------------------------------------------------------------------------------------
	 
	p_a=#()
	obj=spline_shape	

		select obj
		subobjectlevel=1
		actionMan.executeAction 0 "40021"
		weldSpline obj  (treshold/100)
		actionMan.executeAction 0 "40021"
		weldSpline obj (treshold/100)
		subobjectlevel=0
		
		tmp=#()
		i=0
			for s = 1 to (numSplines obj) do
				(

				for k = 1 to (numSegments obj s) do
					(
					i+=1
						vert_pos1=	getKnotPoint obj s k
						a1= Point pos:vert_pos1
						append p_a a1	
						a1_n=p_a.count
						if (numKnots obj s)==(numSegments obj s) and k==(numSegments obj s)  then l=1 else l=k+1
						vert_pos2=	getKnotPoint obj s l
						a2= Point pos:vert_pos2
						append p_a a2	
						a2_n=p_a.count
						tmp[i]= #()
						tmp[i][1]=a1_n
						tmp[i][2]=#(a2_n)
						i+=1
						tmp[i]= #()
						tmp[i][1]=a2_n
						tmp[i][2]=#(a1_n)
					)
				)	
				
	delete obj
	print ("create points:  " + ((timeStamp()/1000)-zerotime) as string + " sec")
	zerotime=(timeStamp()/1000)
	  
	  
------------------------------------------------------------------------------------------------------------------
-- calculate to collapse
------------------------------------------------------------------------------------------------------------------	

	tmp_points=#()
	tmp2_points=#()
	
	for i =1 to tmp.count do 
		(
		tmp_points[i]=#()
		tmp_points[i][1]=tmp[i][1]
		if tmp2_points[i]==undefined then (tmp2_points[i]=i)

		for j=i+1 to  tmp.count do 
				(
				pos1=p_a[tmp[i][1]].pos
				pos2=p_a[tmp[j][1]].pos
				if (distance [pos1[1],pos1[2],0]  [pos2[1],pos2[2],0] )<treshold then
					(
					appendifunique tmp_points[tmp2_points[i]] tmp[j][1]
					tmp2_points[j]=tmp2_points[i]
					)
				)
		)
		
	to_delete=#()	
	for i=1 to tmp_points.count do
		(
		if tmp2_points[i]==i then
			(
			new_pos=[0,0,0]
			for j=1 to tmp_points[i].count do
				(
				new_pos=new_pos+p_a[tmp_points[i][j]].pos			
				)
			new_pos=new_pos/tmp_points[i].count 
			p_a[tmp_points[i][1]].pos=new_pos
				
			)else(
			j=tmp2_points[i]	
			join tmp[j][2] tmp[i][2]

			tmp[tmp[i][2][1]][2][(finditem tmp[tmp[i][2][1]][2] i)]=j
			
			append to_delete i	
			
			)
			
			
		)	
		
		
	for i = 1 to p_a.count do p_a[i].name=("pont_"+i as string)	
		
	for i= to_delete.count to 1 by -1 do
		(
		tmp[to_delete[i]	][2]=#()
		)
	print ("collapse:       " + ((timeStamp()/1000)-zerotime) as string + " sec")
	zerotime=(timeStamp()/1000)

------------------------------------------------------------------------------------------------------------------
-- delete unused points
------------------------------------------------------------------------------------------------------------------

	for i=1 to tmp.count do
		(  
		for j=tmp[i][2].count to 1 by -1 do
			(
			if tmp[i][1]==tmp[i][2][j] then 
				(
				deleteitem tmp[i][2] j
				)
			)
		)
	  
	for i=1 to tmp.count do
		(
		for j=1 to tmp[i][2].count-1 do
			(
			for k=tmp[i][2].count to j+1 by -1 do
				(
				if tmp[i][2][j]==tmp[i][2][k] then
					(
					deleteitem tmp[i][2] k
					)
				)
			)
		)	

	for i=tmp.count to 1 by -1 do
		(
		k=i	
		k2=i
		tovabb=true
		while tovabb	do
			(	
			k=k2
			tovabb=false
			if tmp[k][2].count==1 then
				(
				deleteitem tmp[k][2] 1
					
				for j=1 to tmp.count do
					(
					
					if (findItem tmp[j][2] k)!=0 then 
						(
						deleteitem tmp[j][2] (findItem tmp[j][2] k)	
						k2=j
						tovabb=true
						)
					)
				)
			)
		)

	for i=1 to tmp.count do
		(
		for j=1 to tmp[i][2].count-1 do
			(
			for k=tmp[i][2].count to j+1 by -1 do
				(
				if tmp[i][2][j]==tmp[i][2][k] then
					(
					deleteitem tmp[i][2] k
					)
				)
			)
		)	

	print ("unused points:  " + ((timeStamp()/1000)-zerotime) as string + " sec")
	zerotime=(timeStamp()/1000)

----------------------------------------------------------------------------------------------------------------
-- calculate the angles between points
----------------------------------------------------------------------------------------------------------------
for i=1 to tmp.count do
	(
	tmp[i][3]=#()
	if tmp[i][2].count>1 then
		(
		for j=1 to tmp[i][2].count do
			(
			tmp[i][3][j]=(atan2 (p_a[tmp[i][1]].pos-p_a[tmp[i][2][j]].pos)[2] (p_a[tmp[i][1]].pos-p_a[tmp[i][2][j]].pos)[1])
			)	
		)
	)

	print ("angles:         " + ((timeStamp()/1000)-zerotime) as string + " sec")
	zerotime=(timeStamp()/1000)

----------------------------------------------------------------------------------------------------------------
-- create splines and convert to poly
----------------------------------------------------------------------------------------------------------------

	i=1
	tmp_poly=#()
	nulla=0
	s=0

	for i = 1 to tmp.count do
		(
		---------------select 2nd point
		if tmp[i][2].count>0 then
			(
			while tmp[i][2].count>0 do
				(
				pos_array=#()	
				pos_array[1]=i	
				j=1
				j_old=i
				j=tmp[i][2][j]
				--------------- select next point again and again
				append pos_array j	
				nulla=tmp[j_old][3][1]-180
				deleteItem tmp[i][2] 1
				deleteItem tmp[i][3] 1 				
				if nulla<0 then nulla+=360
				
				while j!=i do
					(
					min=360
					min_i=1
					x=0
					for k=1 to tmp[j][2].count do
						(
						if tmp[j][2][k]!=j_old then
							(
							x=tmp[j][3][k]-nulla
							if x<0 then x+=360
							if x<0 then x+=360
							if x>=360 then x-=360
							if x<min then 
								(
								min=x
								min_i=k
								)
							)
						)	
					j_old=j
					j=tmp[j][2][min_i]	
					nulla=tmp[j_old][3][min_i]-180
					if nulla<0 then nulla+=360
					append pos_array j
					deleteItem tmp[j_old][2] min_i
					deleteItem tmp[j_old][3] min_i 	
					)
				spline_shape2 = SplineShape ()	
				addNewSpline spline_shape2
					
				for m=1 to (pos_array.count-1) do	
					(
					addKnot spline_shape2 1 #corner #line p_a[pos_array[m]].pos
					)
				close spline_shape2 1	
				updateShape spline_shape2
					
				convertto spline_shape2 Editable_Poly

				append tmp_poly spline_shape2	
					
				)
			)
		)

	print ("create splines: " + ((timeStamp()/1000)-zerotime) as string + " sec")
	zerotime=(timeStamp()/1000)
  
----------------------------------------------------------------------------------------------------------------
-- delete points and dummys, attach polys
----------------------------------------------------------------------------------------------------------------
	
	   	for i in p_a do delete i

	select tmp_poly[1]

if tmp_poly.count>1 then
	(
	for i=2 to tmp_poly.count do 
		(
		$.EditablePoly.attach tmp_poly[i] $
		)
	
	
	maxx=0
	maxi=0
	for i=1 to (polyop.getNumFaces $) do
		(
		if (polyop.getFaceArea $ i)>maxx then
			(
			maxx=(polyop.getFaceArea $ i)
			maxi=i
			)
		)
	polyop.deleteFaces $ maxi	
	)

	print ("finalization:   " + ((timeStamp()/1000)-zerotime) as string + " sec")
	print ("summa:          " + ((timeStamp()/1000)-zerotime2) as string + " sec")
	)	
	

----------------------------------------------------------------------------------------------------------------
-- fn div_spline
----------------------------------------------------------------------------------------------------------------	
	
fn div_spline treshold=
	(	
	div=#()
	undo off
	for obj in tmp_selection do
		(
		for s = 1 to (numSplines obj) do
			(
			div[s]=#()
 			for k = 1 to (numSegments obj s) do
 				(
				l=k+1
				if k==(numKnots obj s) then l=1
				p1=(getKnotPoint obj s k)
				p4=(getKnotPoint obj s (l))
				p2 = getOutVec obj s k	
				p3= (getInVec obj s (l))
				Angle0 = atan2 (p4-p1)[2] (p4-p1)[1]
				Angle3 = atan2 (p2-p1)[2] (p2-p1)[1]
				Angle4 = atan2 (p4-p3)[2] (p4-p3)[1]	
				a1=angle0-angle3
				a2=angle4-angle0
				if length (p1-p2)<treshold/10 then a1=0
				if length (p4-p3)<treshold/10 then a2=0
				if a1<=-180 then a1+=360 
				if a2<=-180 then a2+=360 
				if a1>180 then a1-=360 
				if a2>180 then a2-=360 
				a3=(abs(a1+a2)+abs(a1-a2)) 
				div[s][k]=(a3/treshold)-1 as integer
				)
			)

		undo on
		for s = 1 to (numSplines obj) do
			(
 			for k = (numSegments obj s) to 1 by -1 do
 				(
				if div[s][k]>0 then (subdivideSegment obj s k (div[s][k]))
 				)
			)	
		)
	)
	
----------------------------------------------------------------------------------------------------------------
-- fn sel2spline
----------------------------------------------------------------------------------------------------------------	
	
fn sel2spline =
	(	
	tmp_selection=#()
	for i in selection do
		(
		if (superclassof i) == shape do
			(
				a= copy i
				convertToSplineShape a
				append tmp_selection a
			)
		)
	)
	

----------------------------------------------------------------------------------------------------------------
-- rollout
----------------------------------------------------------------------------------------------------------------
	
rollout spline2poly "spline2poly" width:130 height:110
	(
		spinner sp "angle" pos:[5,5] range:[0,180,5] width:120
		button div "just divide" pos:[5,30] width:120 --height:20
		spinner ts "treshold" pos:[5,55]  range:[0,1000,0.1] width:120
		button s2p "turn to poly" pos:[5,80] width:120 --height:20
		
	on div pressed do
		(
		sel2spline ()
		div_spline sp.value
		select tmp_selection
		modPanel.addModToSelection (Edit_Spline ()) ui:on
		subobjectLevel = 1

		)
		
	on s2p pressed do
		(
		sel2spline ()
		div_spline sp.value
		turntopoly ts.value 
		delete tmp_selection
		)		
	)	
	
----------------------------------------------------------------------------------------------------------------
-- other
----------------------------------------------------------------------------------------------------------------
	
try(destroyDialog spline2poly)catch()
createdialog spline2poly style:#( #style_sysmenu, #style_resizing, #style_minimizebox, #style_titlebar ) pos:[100,100]	
	
)  