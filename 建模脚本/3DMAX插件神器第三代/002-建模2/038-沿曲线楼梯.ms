--o=$sphere01
rollout ys172 "沿曲线楼梯" width:196 height:199
(
	spinner spn1 "宽" pos:[109,19] width:64 height:16 range:[0,100,40]
	spinner spn2 "高" pos:[109,52] width:64 height:16 range:[0,100,10]
	pickButton btn1 "拾取曲线" pos:[10,45] width:78 height:27
	button btn2 "生成" pos:[41,121] width:88 height:27
	
	
	
	local w=spn1.value
	local h=spn2.value
	local arrp1=#()
   local  arrp2=#()
    local arrp3=#()
fn point1 oa ta =(
	
      x1=oa.x
      y1=oa.y

      dy=ta.y-oa.y
          dx=ta.x-oa.x
            k=dy/dx
            bb=y1+x1/k
	
           a=(1/k)^2+1
           b=-2*x1*(1+1/k^2)
           c=(x1^2)*(1+1/k^2)-w^2

x=(-b+sqrt (b^2-4*a*c))/(2*a)
xo=(-b-sqrt (b^2-4*a*c))/(2*a)

y=(-1/k*x)+bb
yo=(-1/k*xo)+bb

--sb1=sphere pos:[x,y,oa.z] radius:4  wirecolor:red
--sb2=sphere pos:[xo,yo,oa.z] radius:4 wirecolor:blue
append arrp3 [x,y,oa.z]
append arrp3 [x,y,(oa.z+h)]
append arrp2 [xo,yo,oa.z]
append arrp2 [xo,yo,(oa.z+h)]

                   )

	
   local line=undefined


    on btn1 picked obj do
	 (   
		 line=obj
		 btn1.text=obj.name
		 
		 
		 )

				   
			on btn2 pressed do	   
			( 
				w=spn1.value
	          h=spn2.value
				  arrp1=#()
           arrp2=#()
      arrp3=#()
	  
	 loopnum=((line.max.z-line.min.z)/h +1) as integer

        format " loopnum=%\n"  loopnum
				   
           append arrp1 0.01
			o=lengthinterp line 0.00   
			t=lengthinterp line 0.01	   
           -- sb3=sphere pos:o radius:4  wirecolor:black
				 point1 o t
				   
      for ii=1 to loopnum do
	  (         anum=arrp1[arrp1.count]
             for u=anum to 0.99 by 0.01 do 
   ( 
	bpos=lengthinterp line anum
	o=lengthinterp line u
	u1=u+0.01
	 t=lengthinterp line u1
	dz=o.z-bpos.z
	
	if  dz>=h then 
	(		--sb3=sphere pos:o radius:4  wirecolor:black
	    point1 o t
		 append arrp1 u
		  exit
	)
	

     )
 )
           
            --o=lengthinterp $line01  0.99
			--t=lengthinterp $line01  1.0
             
            --  point1 o t
             deleteitem arrp3  arrp3.count
             deleteitem arrp2  arrp2.count

          n_verts = 2*arrp3.count
	      n_faces = n_verts - 2 
		  m = mesh numVerts:n_verts numFaces:n_faces


        nv = 1
	  for iii = 1 to n_verts by 2 do
	   (
		setVert m iii arrp3[nv]
		setVert m (iii+1) arrp2[nv]
		nv += 1
	   )
	
	 
	for i = 1 to n_faces by 2 do
	(
		setFace m i [i+2, i+1, i]
		setEdgeVis m i 2 on; setEdgeVis m i 3 on
		setFace m (i+1) [i+3, i+1, i+2]
		setEdgeVis m (i+1) 1 on; setEdgeVis m (i+1) 3 on
	)
	
	-- update mesh caches & display, return it
	
	--m

   mfn= getnumfaces m
      for mn=1 to mfn do 
    setfacesmoothgroup m mn 0
   update m

     format " arrp3.count=%\n"  arrp3.count






  )



)


 CreateDialog ys172




