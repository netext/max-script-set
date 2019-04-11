(
local theFloater
local windowFrame
local progDoit
rollout windowFrame "窗框(3dheima.com)"
(	
	local preview=false
	local prev01
	local prev02
	local prev03
	---------函数-------------------------------------------------------------------------
	fn delPrev pv1 pv2 pv3=(
		if  IsValidNode pv1 !=false do delete pv1
		if  IsValidNode pv2 !=false do delete pv2
		if  IsValidNode pv3 !=false do delete pv3
	)	
	fn isCurve spl=(
		local tmpLine=copy spl
		local rt=true
		if tmpLine.modifiers[#extrude] ==undefined do rt=false
		while tmpLine.modifiers.count !=0 do deleteModifier tmpLine 1
		convertToSplineShape tmpLine
		local n=numSegments tmpLine 1	
		local pType	
		for i in 1 to n do (
			pType=getSegmentType tmpLine 1 i
			if pType !=#curve do (rt=false exit)
		)
		delete tmpLine
		rt
	)
	fn sorta v1 v2 sn:1= ( if v1[sn]>v2[sn] then 1 else -1)--升序
	fn sortb v1 v2 sn:1= ( if v1[sn]<v2[sn] then 1 else -1)--降序
	fn sortxy v1 v2 sn:1=( if v1[1][sn]>v2[1][sn] then  1 else  -1	)----升序
	--删除多余网格面
	fn SelFacefromNormal obj num xyzIndex=(
		for i in 1 to num do (
			local fNormal=in coordsys obj getFaceNormal obj i
			if abs fNormal[xyzIndex]  ==1 do setFaceSelection obj #{i} keep:true
		)
	)	
	--获取点
	fn getShapePiont spl=(	 
		local ptarr=#()				
		for i=1 to numSplines spl do( 
		--收集每条线的点,使每条线的四个点都按左下左上右上右下顺序排列	
			local n=numKnots spl i
			local tmp=for j in 1 to n collect in coordsys spl (getKnotPoint spl i j)
			case tmp.count of
			(
				0:()
				1:()
				2:(
				local p1=tmp[1]+[0,100,0]
				local p2=tmp[2]+[0,100,0]
				append tmp p1
				append tmp p2
				)
				3:(
				tmp[3]=tmp[1]+[0,100,0]
				local p2=tmp[2]+[0,100,0]				
				append tmp tmp[3]
				append tmp p2
				)
				4:()
				default:(tmp=for i in 1 to tmp.count collect tmp[i])
			)
			qsort tmp sorta sn:1--把四个点按X轴排序，初步左右分开，下面即按列分开
			sortX=#(tmp[1],tmp[2])
			sortY=#(tmp[3],tmp[4])
			qsort sortX sorta sn:2--把每列按行从下到上顺序
			qsort sortY sortb sn:2--把每列按行从下到上顺序
			local newp=#(sortX[1],sortX[2],sortY[1],sortY[2])--组合
			append ptarr newp
		)---end for 
		return ptarr
	)---end fn 

	--按x轴或y轴是否相等重新组织数组
	fn xyzSort ptarr sn tol =
	(	
		local lastp=#(),tmp=#()	
		if ptarr.count==1 then append lastp #(ptarr[1])
		else (	
			for i=1 to ptarr.count-1 do
			(	
					local v1=ptarr[i][1][sn]		
					local v2=ptarr[i+1][1][sn]	
					if v1<=v2+tol and v1>=v2-tol then( 		
						append tmp ptarr[i] 		
					)
					else(
						append tmp ptarr[i]
						append lastp tmp
						tmp=#()
					)
					if i==ptarr.count-1 do (
						append tmp ptarr[i+1]
						append lastp tmp
					)
				)--end for
			)--end if
		return lastp
	)--end fn
	
	fn LRsort ptarr sn tol =
	(	
		local lastp=#(),tmp=#()	
		if ptarr.count==1 then append lastp ptarr[1]
		else (	
			for i=1 to ptarr.count-1 do
			(	
					local v1=ptarr[i][1][1][sn]		
					local v2=ptarr[i+1][1][1][sn]
					local c1=ptarr[i].count
					local c2=ptarr[i+1].count
					local v1R=ptarr[i][c1][1][sn]
					local v2R=ptarr[i+1][c2][1][sn]
					--format "v2 %\n" v2		
					if v1<=v2+tol and v1>=v2-tol and v1R<=v2R+tol and v1R>=v2R-tol 
					then( for j in ptarr[i] do append tmp j	)
					else(				
					   for j in  ptarr[i] do append tmp j
						append lastp tmp
						tmp=#()
					)
					if i==ptarr.count-1 do (
						--append tmp ptarr[i+1]
						for j in ptarr[i+1] do append tmp j
						append lastp tmp
					)
				)--end for
			)--end if
		return lastp
	)--end fn

	--再一次按x轴或y轴重新组织数组，在xyzSort函数之后处理
	fn secondSort ptarr sn=	(
		for i in 1 to ptarr.count do qsort ptarr[i] sortxy  sn:sn
	)
	
	fn createSplineShape ptArr prog=
	(
		local ss =SplineShape pos:[0,0,0]				
		for i in 1 to ptArr.count do
		(	
			addNewSpline ss	
				-- ptArr[i].count 总是为4
			for j in 1 to 4  do  addKnot ss i #corner #line ptArr[i][j] 	
			close ss i
			--进度条
			prog.value=100.*i/ptArr.count
			--
	)		
		return ss
	)--end fn
	---------------------
	----窗框样式函数
	---------------------	
	--第一种
	fn pSty01 ptarr rwidth cwidth=
	(	
		local ptRow=#(),ptCol=#()
		local sc=1/3.0
		for p in ptarr do
		(
			local h=distance p[1] p[2]
			local w=distance p[1] p[4]	
			--行点
			local p1=#(p[1],p[1]+[0,rwidth,0],p[4]+[0,rwidth,0],p[4])			
			local p2=#(\--第二框
			p[1]+[0,h*sc-rwidth/2.0,0],p[1]+[0,h*sc+rwidth/2.0,0],\
			p[4]+[0,h*sc+rwidth/2.0,0],p[4]+[0,h*sc-rwidth/2.0,0])
			
			local p3=#(\--第三框
			p[2]+[0,-rwidth,0],p[2],p[3],p[3]+[0,-rwidth,0])
			
			append ptRow p1
			append ptRow p2
			append ptRow p3
			--列点
			local pb1=#(p[1],p[2],p[2]+[cwidth,0,0],p[1]+[cwidth,0,0])		
	
			local pb2=#(\
			p[1]+[w/2.0-cwidth/2.0,h*sc-rwidth/2.0,0],\
			p[2]+[w/2.0-cwidth/2.0,0,0],\
			p[2]+[w/2.0+cwidth/2.0,0,0],\
			p[1]+[w/2.0+cwidth/2.0,h*sc-rwidth/2.0,0])			
			local pb3=#(p[4]+[-cwidth,0,0],p[3]+[-cwidth,0,0],p[3],p[4])
			append ptCol pb1			
			append ptCol pb2
			append ptCol pb3	
		)--end for
		return #(ptRow,ptCol)
	)---end fn 
	
	fn pSty01con rowpts colpts rwidth cwidth=
	(	
		local sc=1.0/3.0
		local ptRow=#(),ptCol=#()
		--行点
		for i in 1 to rowpts.count do (
			local col=rowpts[i].count
			local h=distance rowpts[i][1][1] rowpts[i][1][2]
			local p1=#(\--第一框
				rowpts[i][1][1],\
				rowpts[i][1][1]+[0,rwidth,0],\
				rowpts[i][col][4]+[0,rwidth,0],rowpts[i][col][4])	
			local p2=#(\--第二框
				rowpts[i][1][1]+[0,h*sc-rwidth/2.0,0],\
				rowpts[i][1][1]+[0,h*sc+rwidth/2.0,0],\
				rowpts[i][col][4]+[0,h*sc+rwidth/2.0,0],\
				rowpts[i][col][4]+[0,h*sc-rwidth/2.0,0])		
			local p3=#(\--第三框
				rowpts[i][1][2]+[0,-rwidth,0],\
				rowpts[i][1][2],\
				rowpts[i][col][3],\
				rowpts[i][col][3]+[0,-rwidth,0])
			append ptRow p1
			append ptRow p2
			append ptRow p3
		)--end for
		--列点
		for i in 1 to colpts.count do (
			local row=colpts[i].count
			local h=distance colpts[i][1][1] colpts[i][1][2]
			local w=distance colpts[i][1][1] colpts[i][1][4]
			local pc1=#(\
				colpts[i][1][1],\
				colpts[i][row][2],\
				colpts[i][row][2]+[cwidth,0,0],\
				colpts[i][1][1]+[cwidth,0,0]
			)		
			for j in 1 to row do (
				local pc2=#(\			
					colpts[i][j][1]+[w/2.0-cwidth/2.0,h*sc-rwidth/2.0,0],\
					colpts[i][j][2]+[w/2.0-cwidth/2.0,0,0],\
					colpts[i][j][2]+[w/2.0+cwidth/2.0,0,0],\
					colpts[i][j][1]+[w/2.0+cwidth/2.0,h*sc-rwidth/2.0,0]
				)
				append ptCol pc2
			)--end for j
			
			local pc3=#(\
				colpts[i][1][1]+[w-cwidth,0,0],\
				colpts[i][row][2]+[w-cwidth,0,0],\
				colpts[i][row][2]+[w,0,0],\
				colpts[i][1][1]+[w,0,0])
			append ptCol pc1
			append ptCol pc3
		)--end for
		return #(ptRow,ptCol)
	)---end fn 
	
	--第二种
	fn pSty02 ptarr rwidth cwidth=
	(	
		--local ptborder=#()
		local sc=1/3.0
		local ptRow=#(),ptCol=#()
		for p in ptarr do
		(
			local h=distance p[1] p[2]
			local w=distance p[1] p[4]	
			--行点
			local p1=#(p[1],p[1]+[0,rwidth,0],p[4]+[0,rwidth,0],p[4])		
	
			local p2=#(\--第二框
			p[1]+[0,h/2.0-rwidth/2.0,0],\
			p[1]+[0,h/2.0+rwidth/2.0,0],\
			p[1]+[w/2.0+cwidth/2.0,h/2.0+rwidth/2.0,0],\
			p[1]+[w/2.0+cwidth/2.0,h/2.0-rwidth/2.0,0])
			
			local p3=#(\--第三框
			p[2]+[0,-rwidth,0],p[2],p[3],p[3]+[0,-rwidth,0])
			
			append ptRow p1
			append ptRow p2
			append ptRow p3
			
			--列点
			local pb1=#(p[1],p[2],p[2]+[cwidth,0,0],p[1]+[cwidth,0,0])	
			local pb2=#(\
			p[1]+[w/2.0-cwidth/2.0,0,0],\
			p[2]+[w/2.0-cwidth/2.0,0,0],\
			p[2]+[w/2.0+cwidth/2.0,0,0],\
			p[1]+[w/2.0+cwidth/2.0,0,0])			
			local pb3=#(p[4]+[-cwidth,0,0],p[3]+[-cwidth,0,0],p[3],p[4])
			append ptCol pb1			
			append ptCol pb2
			append ptCol pb3	
		)--end for
		return #(ptRow,ptCol)
	)---end fn 
	--
	fn pSty02con rowpts colpts rwidth cwidth=
	(	
		local sc=1/3.0
		local ptRow=#(),ptCol=#()
		--行点
		for i in 1 to rowpts.count do (
			local col=rowpts[i].count
			local h=distance rowpts[i][1][1] rowpts[i][1][2]
			local w=distance rowpts[i][1][1] rowpts[i][1][4]
			local p1=#(\--第一框
				rowpts[i][1][1],\
				rowpts[i][1][1]+[0,rwidth,0],\
				rowpts[i][col][4]+[0,rwidth,0],\
				rowpts[i][col][4]
			)
			for j in 1 to col do (	
				local p2=#(\--第二框
					rowpts[i][j][1]+[0,h/2.0-rwidth/2.0,0],\
					rowpts[i][j][1]+[0,h/2.0+rwidth/2.0,0],\
					rowpts[i][j][1]+[w/2.0+cwidth/2.0,h/2.0+rwidth/2.0,0],\
					rowpts[i][j][1]+[w/2.0+cwidth/2.0,h/2.0-rwidth/2.0,0]
				)	
				append ptRow p2
			)	
			local p3=#(\--第三框
				rowpts[i][1][2]+[0,-rwidth,0],\
				rowpts[i][1][2],\
				rowpts[i][col][3],\
				rowpts[i][col][3]+[0,-rwidth,0]
			)
			append ptRow p1			
			append ptRow p3
		)--end for
		--列点
		for i in 1 to colpts.count do (
			local row=colpts[i].count
			local h=distance colpts[i][1][1] colpts[i][1][2]
			local w=distance colpts[i][1][1] colpts[i][1][4]
			local pc1=#(\
				colpts[i][1][1],\
				colpts[i][row][2],\
				colpts[i][row][2]+[cwidth,0,0],\
				colpts[i][1][1]+[cwidth,0,0])		
		
			local pc2=#(\			
				colpts[i][1][1]+[w/2.0-cwidth/2.0,0,0],\
				colpts[i][row][2]+[w/2.0-cwidth/2.0,0,0],\
				colpts[i][row][2]+[w/2.0+cwidth/2.0,0,0],\
				colpts[i][1][1]+[w/2.0+cwidth/2.0,0,0]	)

			local pc3=#(\
				colpts[i][1][1]+[w-cwidth,0,0],\
				colpts[i][row][2]+[w-cwidth,0,0],\
				colpts[i][row][2]+[w,0,0],\
				colpts[i][1][1]+[w,0,0]	)
			append ptCol pc1
			append ptCol pc2
			append ptCol pc3
		)--end for
		return #(ptRow,ptCol)
	)---end fn 
	
	--第三种
	fn pSty03 ptarr rwidth cwidth=
	(	
		--local ptborder=#()
		local sc=1/3.0
		local ptRow=#(),ptCol=#()
		for p in ptarr do
		(
			local h=distance p[1] p[2]
			local w=distance p[1] p[4]	
			--行点
			local p1=#(p[1],p[1]+[0,rwidth,0],p[4]+[0,rwidth,0],p[4])		
	
			local p2=#(\--第二框
			p[1]+[w/2.0-cwidth/2.0,h/2.0-rwidth/2.0,0],\
			p[1]+[w/2.0-cwidth/2.0,h/2.0+rwidth/2.0,0],\
			p[4]+[0,h/2.0+rwidth/2.0,0],\
			p[4]+[0,h/2.0-rwidth/2.0,0])
			
			local p3=#(\--第三框
			p[2]+[0,-rwidth,0],p[2],p[3],p[3]+[0,-rwidth,0])
			
			append ptRow p1
			append ptRow p2
			append ptRow p3
			
			--列点
			local pb1=#(p[1],p[2],p[2]+[cwidth,0,0],p[1]+[cwidth,0,0])		
	
			local pb2=#(\
			p[1]+[w/2.0-cwidth/2.0,0,0],\
			p[2]+[w/2.0-cwidth/2.0,0,0],\
			p[2]+[w/2.0+cwidth/2.0,0,0],\
			p[1]+[w/2.0+cwidth/2.0,0,0]
			)			
			local pb3=#(p[4]+[-cwidth,0,0],p[3]+[-cwidth,0,0],p[3],p[4])
			append ptCol pb1			
			append ptCol pb2
			append ptCol pb3	
		)--end for
		return #(ptRow,ptCol)
	)---end fn 
	--
	fn pSty03con rowpts colpts rwidth cwidth=
	(	
		local sc=1/3.0
		local ptRow=#(),ptCol=#()
		for i in 1 to rowpts.count do (
			local col=rowpts[i].count
			local h=distance rowpts[i][1][1] rowpts[i][1][2]
			local w=distance rowpts[i][1][1] rowpts[i][1][4]
			local p1=#(\--第一框
				rowpts[i][1][1],\
				rowpts[i][1][1]+[0,rwidth,0],\
				rowpts[i][col][4]+[0,rwidth,0],\
				rowpts[i][col][4])	
			for j in 1 to col do (	
				local p2=#(\--第二框
					rowpts[i][j][1]+[w/2.0-cwidth/2.0,h/2.0-rwidth/2.0,0],\
					rowpts[i][j][1]+[w/2.0-cwidth/2.0,h/2.0+rwidth/2.0,0],\
					rowpts[i][j][4]+[0,h/2.0+rwidth/2.0,0],\
					rowpts[i][j][4]+[0,h/2.0-rwidth/2.0,0])	
				append ptRow p2
			)	
			local p3=#(\--第三框
				rowpts[i][1][2]+[0,-rwidth,0],\
				rowpts[i][1][2],\
				rowpts[i][col][3],\
				rowpts[i][col][3]+[0,-rwidth,0]
			)
			append ptRow p1
			append ptRow p3
		)--end for
		
		--列点
		for i in 1 to colpts.count do (
			local row=colpts[i].count
			local h=distance colpts[i][1][1] colpts[i][1][2]
			local w=distance colpts[i][1][1] colpts[i][1][4]
			local pc1=#(\
				colpts[i][1][1],\
				colpts[i][row][2],\
				colpts[i][row][2]+[cwidth,0,0],\
				colpts[i][1][1]+[cwidth,0,0]
			)		
		
			local pc2=#(\			
				colpts[i][1][1]+[w/2.0-cwidth/2.0,0,0],\
				colpts[i][row][2]+[w/2.0-cwidth/2.0,0,0],\
				colpts[i][row][2]+[w/2.0+cwidth/2.0,0,0],\
				colpts[i][1][1]+[w/2.0+cwidth/2.0,0,0]
			)

			local pc3=#(\
				colpts[i][1][1]+[w-cwidth,0,0],\
				colpts[i][row][2]+[w-cwidth,0,0],\
				colpts[i][row][2]+[w,0,0],\
				colpts[i][1][1]+[w,0,0]
			)
			append ptCol pc1
			append ptCol pc2
			append ptCol pc3
		)--end for
		return #(ptRow,ptCol)
	)---end fn 
	--第四种
	fn pSty04 ptarr rwidth cwidth rowNum:false colNum:false  rowSpa:false colSpa:false rDiv:0 cDiv:0 DivW:0=
	(	
		local RowPt=#(),ColPt=#(),DivLine=#()	
		local tmpRow,tmpCol
		if rowSpa !=false do(local tmrowSC=rowSpa;local tmcolSC=colSpa)	
		for p in ptarr do
		(	
			local h=distance p[1] p[2]
			local w=distance p[1] p[4]	
			local rowSC,colSC			
			if rowNum !=false  then (	
				rowSC=h/(rowNum+1.0);
				colSC=w/(colNum+1.0)
				tmpRow=rowNum
				tmpCol=colNum
				overplusR=0
				overplusC=0
			)else(				
				tmpRow=floor(h/rowSpa)+1
				tmpCol=floor(w/colSpa)+1
				rowSC=rowSpa
				colSC=colSpa
				overplusR=(mod h rowSpa)/2.0-rowSpa	
				overplusC=(mod w colSpa)/2.0-colSpa	
			)
			--行点---------------------------------------------------
			local p1=#(p[1],p[1]+[0,rwidth,0],p[4]+[0,rwidth,0],p[4])	
			for i in 1 to tmpRow do (
					local p2=#(\--第二框
					p[1]+[0,rowSC*i-rwidth/2.0+overplusR,0],\
					p[1]+[0,rowSC*i+rwidth/2.0+overplusR,0],\
					p[4]+[0,rowSC*i+rwidth/2.0+overplusR,0],\
					p[4]+[0,rowSC*i-rwidth/2.0+overplusR,0]
				)
				append RowPt p2
			)
			local p3=#(\--第三框
			p[2]+[0,-rwidth,0],p[2],p[3],p[3]+[0,-rwidth,0])
			
			append RowPt p1			
			append RowPt p3
			--分线
			if cDiv>0 do (
				for i in 1 to tmpRow do (
					local divPt=#(\
						p[1]+[0,rowSC*i-DivW/2.0+overplusR+overplusR,0],\
						p[1]+[0,rowSC*i+DivW/2.0+overplusR+overplusR,0],\
						p[4]+[0,rowSC*i+DivW/2.0+overplusR+overplusR,0],\
						p[4]+[0,rowSC*i-DivW/2.0+overplusR+overplusR,0]
					)
					append DivLine divPt
				)
			)


			--列点---------------------------------------------------
			local pb1=#(p[1],p[2],p[2]+[cwidth,0,0],p[1]+[cwidth,0,0])		
			for i in 1 to tmpCol do (
				local pb2=#(\
					p[1]+[colSC*i-cwidth/2.0+overplusC,0,0],\
					p[2]+[colSC*i-cwidth/2.0+overplusC,0,0],\
					p[2]+[colSC*i+cwidth/2.0+overplusC,0,0],\
					p[1]+[colSC*i+cwidth/2.0+overplusC,0,0]
				)
				append ColPt pb2
			)			
			local pb3=#(p[4]+[-cwidth,0,0],p[3]+[-cwidth,0,0],p[3],p[4])
			append ColPt pb1
			append ColPt pb3	
			--分线
			if cDiv>0 do (
				for i in 1 to tmpCol do (
					local divPt=#(\
						p[1]+[colSC*i-DivW/2.0+overplusC,0,0],\
						p[2]+[colSC*i-DivW/2.0+overplusC,0,0],\
						p[2]+[colSC*i+DivW/2.0+overplusC,0,0],\
						p[1]+[colSC*i+DivW/2.0+overplusC,0,0]
					)
					append DivLine divPt
				)
			)
		)--end for
		return #(RowPt,ColPt,DivLine)
	)---end fn 
	--
	fn pSty04con rowpts colpts rwidth cwidth rowNum:false colNum:false rowSpa:false colSpa:false rDiv:0 cDiv:0 DivW:0=
	(	
		local RowPt=#(),ColPt=#(),DivLine=#(),sc=1/3.0
		--行点
		for i in 1 to rowpts.count do (
			local col=rowpts[i].count
			local h=distance rowpts[i][1][1] rowpts[i][1][2]
			local tmpRow,rowSC,overplus
			if rowSpa !=false then(				
				tmpRow=floor(h/rowSpa)+1
				rowSC=rowSpa
				overplus=(mod h rowSpa)/2.0-rowSC			
			)else(					
				tmpRow=rowNum
				rowSC=h/(rowNum+1.0)
				overplus=0
			)	

			local p1=#(\--第一框
				rowpts[i][1][1],\
				rowpts[i][1][1]+[0,rwidth,0],\
				rowpts[i][col][4]+[0,rwidth,0],\
				rowpts[i][col][4]) 

			for j in 1 to tmpRow do (
					local p2=#(\--第二框
					rowpts[i][1][1]+[0,rowSC*j-rwidth/2.0+overplus,0],\
					rowpts[i][1][1]+[0,rowSC*j+rwidth/2.0+overplus,0],\
					rowpts[i][col][4]+[0,rowSC*j+rwidth/2.0+overplus,0],\
					rowpts[i][col][4]+[0,rowSC*j-rwidth/2.0+overplus,0])					
					append RowPt p2
			)			
			local p3=#(\--第三框
				rowpts[i][1][2]+[0,-rwidth,0],\
				rowpts[i][1][2],\
				rowpts[i][col][3],\
				rowpts[i][col][3]+[0,-rwidth,0]
			)
			append RowPt p1
			append RowPt p3
			--分线
			if rDiv==1 do (
				for j in 1 to tmpRow do (	
					local divPt=#(\
					rowpts[i][1][1]+[0,rowSC*j-DivW/2.0+overplus,0],\
					rowpts[i][1][1]+[0,rowSC*j+DivW/2.0+overplus,0],\
					rowpts[i][col][4]+[0,rowSC*j+DivW/2.0+overplus,0],\
					rowpts[i][col][4]+[0,rowSC*j-DivW/2.0+overplus,0])	
					append DivLine divPt
				)
			)
		)--end for
		
		--列点
		for i in 1 to colpts.count do (
			local row=colpts[i].count
			local w=distance colpts[i][1][1] colpts[i][1][4]
			local tmpCol,colSC,overplus
			
			if colSpa !=false then(					
				tmpCol=floor(w/colSpa)+1
				colSC=colSpa
				overplus=(mod w colSpa)/2.0-colSpa				
			)else(					
				tmpCol=colNum
				colSC=w/(colNum+1.0)	
				overplus=0
			)
			local pc1=#(\
				colpts[i][1][1],\
				colpts[i][row][2],\
				colpts[i][row][2]+[cwidth,0,0],\
				colpts[i][1][1]+[cwidth,0,0]
			)		
			for j in 1 to tmpCol do (
					local pc2=#(\			
						colpts[i][1][1]+[colSC*j-cwidth/2.0+overplus,0,0],\
						colpts[i][row][2]+[colSC*j-cwidth/2.0+overplus,0,0],\
						colpts[i][row][2]+[colSC*j+cwidth/2.0+overplus,0,0],\
						colpts[i][1][1]+[colSC*j+cwidth/2.0+overplus,0,0]
					)
					append ColPt pc2
			)
			local pc3=#(\
				colpts[i][1][1]+[w-cwidth,0,0],\
				colpts[i][row][2]+[w-cwidth,0,0],\
				colpts[i][row][2]+[w,0,0],\
				colpts[i][1][1]+[w,0,0]
			)
			append ColPt pc1
			append ColPt pc3
			--分线
			if cDiv==1 do (
				for j in 1 to tmpCol do (
					local divPt=#(\			
						colpts[i][1][1]+[colSC*j-DivW/2.0+overplus,0,0],\
						colpts[i][row][2]+[colSC*j-DivW/2.0+overplus,0,0],\
						colpts[i][row][2]+[colSC*j+DivW/2.0+overplus,0,0],\
						colpts[i][1][1]+[colSC*j+DivW/2.0+overplus,0,0]
					)
					append DivLine divPt
				)
			)
		)--end for
		return #(RowPt,ColPt,DivLine)
	)---end fn 

	-----------------------
	---窗框样式函数 结束
	-----------------------

--材质函数
	fn matborder matName bmpfile=
	(
		local mat=Standardmaterial ()
		mat.name=matName
		mat.adLock=off
		mat.Diffuse = color 97 124 115
		mat.ambient = color 57 73 68
		mat.specularLevel = 135
		mat.glossiness = 40
		mat.reflectionMapAmount = 70
		if bmpfile !=undefined do (mat.reflectionMap=Bitmaptexture fileName:bmpfile
		mat.reflectionMap.coords.Blur_Offset = 0.1
		)
		mat.shaderType = 2
		mat.adTextureLock = on
		return mat
	)
	fn matGlass matName=
	(
		local mat=Standardmaterial()
		mat.name=matName
		mat.Diffuse = color 228 236 242
		mat.opacity = 35
		mat.specularLevel = 136
		mat.glossiness = 32
		mat.Soften = 0.1
		return mat
	)
	fn clearArray theArray =
	(
		for i=1 to theArray.count do (
			for j=theArray.count to (i+1) by -1 do (
				if theArray[j]==theArray[i] do deleteitem theArray j
			)			
		)
		return theArray
	)
	fn loader newMats=
	(	--max mtledit
		local oldMats=for i in 1 to 24 collect meditMaterials[i]
		local mats=newMats+oldMats
		clearArray mats
		local n=int(mod mats.count 24)
		for i in 1 to 24 do (meditMaterials[i]=Standardmaterial())
		for i in 1 to n do (meditMaterials[i]=mats[i])

	)
	
	fn line_filt obj=superClassof obj.baseObject==Shape
	fn msg=(
		a="非法使用或者没有授权，请按如下方式联系\n 姓名：戴希亮\n "
		b="Email：mediastime@126.com\n webSite:Http://www.8media.com"
		messageBox(a+b)
	)

	
	---------界面-------------------------------------------------------------------------	
	pickbutton pkLine "拾取线型" width:120 filter:line_filt
	progressBar progDoit  color:blue width:149 height:10 align:#left

	group "住宅窗框"
	(	
		checkbutton ckSty01 "" highlightColor:(yellow) across:3 checked:true width:26 height:26
		checkbutton ckSty02 "" highlightColor:(yellow) width:26 height:26
		checkbutton ckSty03 "" highlightColor:(yellow) width:26 height:26 
		
		spinner spnRFW "行框宽度:" range:[0,100000.0,5.0] type:#worldunits
		spinner spnCFW "列框宽度:" range:[0,100000.0,5.0] type:#worldunits
		spinner spnDepth "厚度:" range:[0,100000.0,5.0] type:#worldunits
		
	)
	group "幕墙窗框"
	(
		checkbutton ckSty04 "" highlightColor:(yellow) width:26 height:26 across:2
		checkbutton ckSty05 "" highlightColor:(yellow) width:26 height:26
		spinner spnWRFW "行框宽度:" range:[0,100000.0,5.0] type:#worldunits
		spinner spnRDepth "厚度:" range:[0,100000.0,5.0] type:#worldunits
		spinner spnRBack "后退:" range:[-100000.0,100000.0,0.0] type:#worldunits
		radiobuttons radRow "" labels:#("无","外挑", "内挑") height:20 columns:3

		spinner spnWCFW "列框宽度:" range:[0,100000.0,5.0] type:#worldunits
		spinner spnCDepth "厚度:" range:[0,100000.0,5.0] type:#worldunits
		spinner spnCBack "后退:" range:[-100000.0,100000.0,0.0] type:#worldunits
		radiobuttons radCol "" labels:#("无","外挑", "内挑")  height:20 columns:3
		checkBox ckRDivLine "行分线" across:2
		checkBox ckCDivLine "列分线"
		spinner spnDivLineW "分线宽度:" range:[0,100000.0,2.0] type:#worldunits
		spinner spnDivLineD "分线距离:" range:[0,100000.0,1.0] type:#worldunits 
		spinner spnBaseLine "内外挑基点:" range:[0,100000.0,2.5] type:#worldunits
		
		checkBox ckNum "数目"  checked:true		 
		spinner spnRow "行:" range:[0,10000,2] type:#integer	across:2
		spinner spnCol "列:" range:[0,10000,2] type:#integer
		
		checkBox ckSpa "间距"
		spinner spnRSpa "行间距:" range:[0,100000.0,160.0] type:#worldunits enabled:false
		spinner spnCSpa "列间距:" range:[0,100000.0,100.0] type:#worldunits enabled:false
		
	)

	group "通用参数"
	(	
		spinner spnTol "平行偏差:" range:[0.0,1000.0,0.001] type:#worldunits
		checkbox ckbDelBack "删除背部 " checked:true align:#center
		checkbox ckbConnect "是否连通 " checked:true align:#center
	)
	button btReset "重置" across:3
	button btApply "应用" 
	button btCancel "取消"
	button createWF "创建窗框" height:1 visible:false
	---------事件----------------------------------------------------------------------

	on windowFrame open do
	(	-----filein funFile
		local bw=20
		local bh=20
		local br=2
		local bp1=bitmap bw bh
		for  i=1 to bw do (
			for j=1 to bh do (
				if i<br or i>=(bw-br)  or j<br or j>=(bh-br) or (j>=(bh-br)/2.0 and \
				j<(bh+br)/2.0) or (i>=(bw-br)/2.0 and i<(bw+br)/2.0 and j<(bw/2.0))
		 		then
				(
					setpixels bp1 [i,j] #(black)
				)else(
					setpixels bp1 [i,j] #(white)
				)
			)
		)
		local bp2=bitmap bw bh
		for  i=1 to bw do (
			local tmp=#()
			for j=1 to bh do (
				if  i<br or i>=(bw-br)  or j<br or j>=(bh-br) or (j>=(bw-br)/2.0 and  \
				j<(bw+br)/2.0 and i<(bw/2.0)) or (i>=(bw-br)/2.0 and i<(bh+br)/2.0)
		 		then
				(
					setpixels bp2 [i,j] #(black)
				)else(
					setpixels bp2 [i,j] #(white)
				)
			)
		)
		local bp3=bitmap bw bh
		for  i=1 to bw do (
			for j=1 to bh do (
				if  i<br or i>=(bw-br)  or j<br or j>=(bh-br) or (j>=(bw-br)/2.0 and \
				j<(bw+br)/2.0	and i>(bw/2.0)) or (i>=(bw-br)/2.0 and i<(bh+br)/2.0)
		 		then
				(
					setpixels bp3 [i,j] #(black)
				)else(
					setpixels bp3 [i,j] #(white)
				)
			)
		)
		local bp4=bitmap bw bh
		for  i=1 to bw do (
			for j=1 to bh do (
				if  i<br or i>=(bw-br)  or j<br or j>=(bh-br) or (j>=(bh/3.0-br/2.0) and \
				j<(bh/3.0+br/2.0)) or (j>=(bw/3.0*2.0-br/2.0) and j<(bw/3.0*2.0+br/2.0)) \
				or (i>=(bw/3.0-br/2.0) and i<(bw/3.0+br/2.0))\
				or (i>=(bw/3.0*2.0-br/2.0) and i<(bh/3.0*2.0+br/2.0))\
		 		then
				(
					setpixels bp4 [i,j] #(black)
				)else(
					setpixels bp4 [i,j] #(white)
				)
			)
		)
		local bp5=bitmap bw bh
		for  i=1 to bw do (
			for j=1 to bh do (
				local y=3*sin(19*i)
				if (j<=y+9 and j>=y+7)  or (j<=y+14 and j>=y+12) \
				or (i>5 and i<8) or (i>12 and i<15) or i<2  or i>17 or j<2 or j>17
				then			
				setpixels bp5 [i,j] #(black)			
				else	
				setpixels bp5 [i,j] #(white)				
			)
		)
		ckSty01.images=#(bp1, undefined,1, 1, 1, 1, 1)
		ckSty02.images=#(bp2, undefined,1, 1, 1, 1, 1)
		ckSty03.images=#(bp3, undefined,1, 1, 1, 1, 1)
		ckSty04.images=#(bp4, undefined,1, 1, 1, 1, 1)
		ckSty05.images=#(bp5, undefined,1, 1, 1, 1, 1)
		ckSty01.enabled=false
		ckNum.enabled=false
		ckSpa.enabled=false
		spnRow.enabled=false
		spnCol.enabled=false
		spnRSpa.enabled=false
		spnCSpa.enabled=false
		btApply.enabled=false	
	)
	on windowFrame close do (
		delPrev prev01 prev02 prev03	
		--removeRollout windowFrame theFloater
		--closeRolloutFloater theFloater
		--windowFrame=undefined
		--theFloater=undefined
	)

	on pkLine picked obj do (
		max create mode
		pkLine.caption=obj.name	
		delPrev prev01 prev02 prev03			
		preview=true
		if isCurve obj==true then (
			ckSty05.checked=true;ckSty05.changed true
		)else createWF.pressed()	
		--当类型转换时也出错
		deleteAllChangeHandlers 	id:#ff
		when name obj change id:#ff obj do pkLine.caption=obj.name		
		when obj deleted id:#ff obj do ( 
			pkLine.caption="拾取线形"
			delPrev prev01 prev02 prev03
			preview=false
		)
		if btApply.enabled==false do btApply.enabled=true
	)
	on btApply pressed do (
		prev01=undefined; prev02=undefined;prev03=undefined
		btApply.enabled=false
	)
	on btCancel pressed do (closeRolloutFloater theFloater)
	--
	--重新设置所有参数
	on btReset pressed do (
		spnRFW.value=5.0
		spnCFW.value=5.0
		spnDepth.value=5.0
		spnWRFW.value=5.0
		spnRDepth.value=5.0
		spnRBack.value=0.0
		radRow.state=1

		spnWCFW.value=5.0
		spnCDepth.value=5.0
		spnCBack.value=0.0
		
		radCol.state=1
		ckRDivLine.checked=false
		ckCDivLine.checked=false
		spnDivLineW.value=2
		spnDivLineD.value=1
		spnBaseLine.value=2.5
		--ckNum.checked=true		 
		spnRow.value=2
		spnCol.value=2		
		--ckSpa.checked=false
		spnRSpa.value=50.0
		spnCSpa.value=50.0
		if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed())
	)
	
	on spnRFW changed val do
	(if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed()))
	
	on spnCFW changed val do
	(if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed()))
	
	on spnDepth changed val do
	(if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed()))	
	--
	on spnWRFW changed val do
	(if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed()))
	
	on spnRDepth changed val do
	(if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed()))
	
	on spnRBack changed val do
	(if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed()))
	
	on spnWCFW changed val do
	(if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed()))
	
	on spnCDepth changed val do
	(if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed()))
	
	on spnCBack changed val do
	(if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed()))
	
	on radRow changed val do
	(if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed()))
	
	on radCol changed val do
	(if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed()))	
	
	on ckRDivLine changed val do
	(if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed()))
	
	on ckCDivLine changed val do
	(if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed()))
	
	on spnDivLineW changed val do
	(if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed()))
	
	on spnDivLineD changed val do
	(if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed()))
	
	on spnBaseLine changed val do
	(if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed()))
	
	on spnRow changed val do
	(	
		if spnRow.value==21 and spnCol.value==111 do msg()
		if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed())		
	)
	
	on spnCol changed val do
	(
		if spnRow.value==21 and spnCol.value==111 do msg()
		if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed())
	)
	
	on spnRSpa changed val do
	(if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed()))
	
	on spnCSpa changed val do
	(if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed()))
	
	on ckbConnect changed val do
	(if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed()))
	
	on spnTol changed val do
	(if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed()))
	on ckbDelBack changed val do
	(if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed()))
	
	
	on ckNum changed theState do (
		ckNum.checked=true
		ckSpa.checked=false
		spnRow.enabled=true
		spnCol.enabled=true
		spnRSpa.enabled=false
		spnCSpa.enabled=false
		if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed())
	)
	on ckSpa changed theState do (
		ckSpa.checked=true
		ckNum.checked=false
		spnRow.enabled=false
		spnCol.enabled=false
		spnRSpa.enabled=true
		spnCSpa.enabled=true
		if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed())
	)
	on ckSty01 changed theState do (
		ckSty01.enabled=false
		ckSty02.enabled=true
		ckSty03.enabled=true
		ckSty04.enabled=true
		ckSty05.enabled=true
		ckSty02.checked=false
		ckSty03.checked=false
		ckSty04.checked=false	
		ckSty05.checked=false
		--
		ckNum.enabled=false
		ckSpa.enabled=false
		spnRow.enabled=false
		spnCol.enabled=false
		spnRSpa.enabled=false
		spnCSpa.enabled=false	
		--btApply.enabled=true
		if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed())
	)
	
	on ckSty02 changed theState do (
		ckSty01.enabled=true
		ckSty02.enabled=false
		ckSty03.enabled=true
		ckSty04.enabled=true
		ckSty05.enabled=true
		ckSty01.checked=false
		ckSty03.checked=false
		ckSty04.checked=false
		ckSty05.checked=false
		--
		ckNum.enabled=false
		ckSpa.enabled=false
		spnRow.enabled=false
		spnCol.enabled=false
		spnRSpa.enabled=false
		spnCSpa.enabled=false
		--btApply.enabled=true
		if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed())
	)
	
	on ckSty03 changed theState do (
		ckSty01.enabled=true
		ckSty02.enabled=true
		ckSty03.enabled=false
		ckSty04.enabled=true
		ckSty05.enabled=true
		ckSty01.checked=false
		ckSty02.checked=false
		ckSty04.checked=false	
		ckSty05.checked=false
		--
		ckNum.enabled=false
		ckSpa.enabled=false
		spnRow.enabled=false
		spnCol.enabled=false
		spnRSpa.enabled=false
		spnCSpa.enabled=false	
		--btApply.enabled=true	
		if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed())
	)
	
	on ckSty04 changed theState do (
		ckSty01.enabled=true
		ckSty02.enabled=true
		ckSty03.enabled=true
		ckSty04.enabled=false	
		ckSty05.enabled=true
		ckSty01.checked=false
		ckSty02.checked=false
		ckSty03.checked=false
		ckSty05.checked=false
		--
		ckNum.enabled=true
		ckSpa.enabled=true
		spnRow.enabled=true
		spnCol.enabled=true	
		--btApply.enabled=true
		if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed())
	)

	on ckSty05 changed theState do (
		ckSty01.enabled=true
		ckSty02.enabled=true
		ckSty03.enabled=true
		ckSty04.enabled=true	
		ckSty05.enabled=false
		ckSty01.checked=false
		ckSty02.checked=false
		ckSty03.checked=false
		ckSty04.checked=false
		--
		ckNum.enabled=true
		ckSpa.enabled=true
		spnRow.enabled=true
		spnCol.enabled=true	
		--btApply.enabled=true
		if preview==true do (delPrev prev01 prev02 prev03;createWF.pressed())
	)
	on createWF pressed do 
	(	
		if pkLine.object !=undefined do (local s=pkLine.object)
		if IsValidNode s==true do (	
		if spnCol.value==21 and spnRow.value==111 then msg() else (
			undo off ( 			
 			
			--恒定变量-要用单位函数转换一下
			local divToGlassDis=spnDivLineD.value--分线离玻璃的距离
			local divWidth=spnDivLineW.value--分线的宽度
			local baseLine=spnBaseLine.value--2.5外挑时用的起点
			---------------------------------------
			local theRwidth=spnRFW.value
			local theCwidth=spnCFW.value
			local depth=spnDepth.value
			--			
			local wRfw=spnWRFW.value
			local RDep=spnRDepth.value
			local RBack=spnRBack.value
	
			local wCfw=spnWCFW.value 
			local CDep=spnCDepth.value 
			local CBack=spnCBack.value 		

			local theRow=spnRow.value
			local theCol=spnCol.value
			local RSpa=spnRSpa.value
			local CSpa=spnCSpa.value		
			--
			local theTol=spnTol.value/100.0
			--local theck=ckbDelBack.checked		
			local con=ckbConnect.checked
			local stylept,glasspt	
			--开始创建窗框		
-----------------------------------------------------------------------
--创建弧形窗框
-----------------------------------------------------------------------		
			if ckSty05.checked==true then (	
			local msg="这条线没有增加 Extrude 修改器，要继续吗？\n点击确定会自动增加 Extrude 修改器"
			local h
			if s.modifiers[#extrude] !=undefined or queryBox(msg)==true do (
				if s.modifiers[#extrude] ==undefined do
				(	
					h=600
					addModifier s (extrude amount:h capEnd:off capStart:off)				
				)
				h=s.modifiers[#extrude].amount
				
				--沿路径复制列对象并返回复制对象的数组			
				fn copyobj sobj  ss n lineWidth spa:1 perOver:0=(
					local objs=#()					
					for i in 1 to n do (
						local  percent=1.0*(i*spa+perOver)/lineWidth
						local  posVert=lengthInterp ss 1 percent
						local  tanVert=lengthTangent ss 1 percent
						local  bi=copy sobj pos:posVert
						bi.dir=tanvert
						append objs bi
						progDoit.value=100.*i/n
					)
					return objs
				)--end fn
			
				local tmpRow
				local rowBor,colBor,rDivLine,cDivLine,linePath
				local rowObjs=#(),rDivLineObjs=#(),cDivLineObjs=#()

				
				--create row--------------------------------------------------------
				local rowspa
				if ckNum.checked ==true then (
					tmpRow=theRow
					rowspa=h/(tmpRow+1)
					overplus=0					
				)else(
					if RSpa>(h-2*wRFW) do (spnRSpa.value=h-2*wRFW;RSpa=spnRSpa.value)
					tmpRow=floor(h/RSpa)+1
					rowspa=RSpa					
					overplus=(mod h RSpa)/2.0-RSpa---wRFW/2.0
				)
				linePath=copy s
				while linePath.modifiers.count !=0 do deleteModifier linePath 1								
				--行分线
				if ckRDivLine.checked==true do (	
					--第一条行分线				
					rDivLine=copy linePath
					rDivLine.name=uniqueName "建筑＝窗框分线"
					addModifier rDivLine (extrude amount:divWidth)					
					convertToMesh rDivLine
					in coordsys s move rDivLine [0,-divToGlassDis,0]
					--中间行分线
					for i in 1 to tmpRow do(--之所以少一根，是把原rDivLine也算进去
							local p=rDivLine.pos+[0,0,rowspa*i+overplus]
							local tmp=copy rDivLine pos:p
							append rDivLineObjs tmp
							progDoit.value=100.*i/(tmpRow)
					)
					--顶部行分线
					tmpGen=copy rDivLine
					tmpGen.pos=rDivLine.pos+[0,0,h]
					append rDivLineObjs tmpGen
					for i in rDivLineObjs do meshop.attach rDivLine i targetNode:rDivLine
					rDivLine.wireColor= color 0 0 0
				)
				--行框
				--第一条行框
				rowBor=copy linePath
				rowBor.name=uniqueName "建筑＝窗框"
				addModifier rowBor (extrude amount:wRfw capEnd:off capStart:off)
				convertToMesh rowBor
				local n01,n02,n03,n04,fList01,fList02,fSel03,fList04,tmpDep
				--外拉，把拉伸的面拉伸到指定位置后，把新增加的面全部删除
				n01=getNumFaces rowBor				
				fList01=setFaceSelection rowBor #{1..n01}
				case radRow.state of
				(
					2:(tmpDep=(RDep-baseLine-RBack))
					3:(tmpDep=(baseLine-RBack))
					default:(tmpDep=(RDep/2.0-RBack))				
				)				
				meshop.extrudeFaces rowBor fList01 tmpDep 0
				n02=getNumFaces rowBor
				fList02=setFaceSelection rowBor #{(n01+1)..n02}				
				meshop.deleteFaces rowBor fList02
				--复制此刚才拉伸的面作为反向拉伸的面
				fList01=setFaceSelection rowBor #{1..n01}
				meshop.cloneFaces rowBor fList01
				n03=getNumFaces rowBor
				fSel03=getFaceSelection rowBor
				
				--内缩
				meshop.flipNormals rowBor fSel03				
				meshop.extrudeFaces rowBor fSel03 RDep 0
				fList04=setFaceSelection rowBor #{(n01+1)..n03}
				if ckbDelBack.checked==true do meshop.deleteFaces rowBor fList04	--是否删除背部
				meshop.weldVertsByThreshold rowBor #all 0.01 --合并多余的顶点
				--copy row and 合并行
				--顶部行框
				local tmpRowBor=copy rowBor --pos:[0,0,h-wRfw]
				tmpRowBor.pos=rowBor.pos+[0,0,h-wRfw]	
				append rowObjs tmpRowBor
				--中间行框
				progDoit.value=0
				for i in 1 to tmpRow do(
					local p=rowBor.pos+[0,0,rowspa*i+overplus-wRfw/2.0]
					local tmp=copy rowBor pos:p
					append rowObjs tmp
					progDoit.value=100.*i/(tmpRow)
				)
				--合并行框
				for i in rowObjs do meshop.attach rowBor i targetNode:rowBor
				
				---rowBor.pos.y=rowBor.pos.y+RBack
				rowBor.wireColor= color 97 124 115
				rowObjs=undefined
				rDivLineObjs=undefined	
				
				--create col------------------------------------------------------------------------
				
				
				--列分线
				local lineW,tmpCol,overplusC,colspa
				lineW=curveLength linePath
				if ckNum.checked ==true then (
					tmpCol=theCol
					--colspa=lineW/(theCol+1)
					overplusC=0										
				)else(
					if CSpa>=lineW-2*wCFW do (spnCSpa.value=abs(lineW-2*wCFW);CSpa=spnCSpa.value)
					tmpCol=floor(lineW/CSpa)+1
					colspa=CSpa			
					overplusC=(mod lineW CSpa)/2.0-colspa --wCFW/2.0
				)

				if ckCDivLine.checked==true do(
				--第一条列分线
					cDivLine=rectangle length:h width:0
					cDivLine.pivot=cDivLine.pivot+[CDep/2.0,-h/2.0,0]
					cDivLine.name=uniqueName  "分线col"
					addModifier cDivLine (extrude amount:DivWidth)
					in coordsys s move cDivLine [0,-divToGlassDis,0]
					cDivLine.pos=lengthinterp linePath 1 0
					cDivLine.dir=lengthTangent linePath 1 0
					convertToMesh cDivLine					
					local cDivLineObj	
					--中间列分线				
					if ckNum.checked ==true then (
					 cDivLineObj =copyobj cDivLine linePath tmpCol (tmpCol+1)					
					)else(
					cDivLineObj =copyobj cDivLine linePath tmpCol lineW spa:colspa perOver:overplusC
					)
					--最后列分线
					local tmp=copy cDivLine
					tmp.pos=lengthinterp linePath 1 1
					tmp.dir=lengthTangent linePath 1 1
					append cDivLineObj tmp
					--合并
					for i in cDivLineObj do meshop.attach cDivLine i targetNode:cDivLine
					cDivLine.wireColor= color 0 0 0
				)
				---如果行列都有时，合并行列分线
				if ckRDivLine.checked==true and ckCDivLine.checked==true  then(
					meshop.attach rDivLine cDivLine targetNode:rDivLine
					prev02=rDivLine
				)else(
					if ckRDivLine.checked==true then prev02=rDivLine else prev02=cDivLine
				)
				--列框
				--第一条列框
				colBor=rectangle length:h width:CDep
				case radCol.state of
				(
					2:(colBor.pivot=colBor.pivot+[CDep/2.0-baseLine-CBack,-h/2.0,wCfw/2.0])
					3:(colBor.pivot=colBor.pivot+[baseLine-CDep/2.0-CBack,-h/2.0,wCfw/2.0])
					default:(colBor.pivot=colBor.pivot+[-CBack,-h/2.0,wCfw/2.0])				
				)				
				addModifier colBor (extrude amount:wCfw)
				convertToMesh colBor				    	
				if ckbDelBack.checked==true do meshop.deleteFaces colBor #(7,8)
				colBor.pos=lengthinterp linePath 1 0
				colBor.dir=lengthTangent linePath 1 0
				 
				--中间列框
				--copy and 合并列框				
				if ckNum.checked ==true then (
				 colObjs =copyobj colBor linePath tmpCol (tmpCol+1)
				)else(
				 colObjs =copyobj colBor linePath tmpCol lineW spa:colspa perOver:overplusC
				)
				--最后的列框
				local tmp
				tmp=copy colBor
				 tmp.pos=lengthinterp linePath 1 1
				 tmp.dir=lengthinterp linePath 1 1
				 append colObjs tmp
				delete linePath
				for i in colObjs do meshop.attach colBor i targetNode:colBor
				--合并行框和列框	
				meshop.attach rowBor colBor  targetNode:rowBor
				--材质
				local borderMatName="建筑＝窗框（墨绿色金属）"
				local borderBmpName=undefined--"\\\\Server-5\\建筑部服务器\\
				--标准材质\\map\\703000 副本.jpg"	
						
				rowBor.material=matborder borderMatName borderBmpName			
				local theMatArray=#(rowBor.material)
		         loader theMatArray				 
				progDoit.value=0
				prev01=rowBor
			)
-----------------------------------------------------------------------
--创建弧形窗框，完成
-----------------------------------------------------------------------
			)else(
			---其它窗户开始
			local tmpLine=copy s
			while tmpLine.modifiers.count !=0 do deleteModifier tmpLine 1
			convertToSplineShape tmpLine	
			local msg="这条线少于四个点，不适合做窗框，要继续吗？"			
			if  numKnots tmpLine 1>=4 or queryBox(msg)==true do
			(
	---001 按顺时针排序	
			pt=getShapePiont tmpLine
			
	--002 分Z轴
			qsort pt sortxy sn:3	
			local rowpt=xyzSort pt 3 theTol
			local colpt=xyzSort pt 3 theTol			

	--003 分行列	
			secondSort rowpt 2
			secondSort colpt 1
			
			newRows=#()--最终的行点
			for i in 1 to rowpt.count do (
				local tmp=xyzSort rowpt[i] 2 theTol
				for j in tmp do append newRows j
			)
			secondSort newRows 1
			
			newCols=#()--最终的列点
			for i in 1 to colpt.count do (
				local tmp=xyzSort colpt[i] 1 theTol
				for j in tmp do append newCols j
			)
			secondSort newCols 2

			--
			local rcp=#()
			if con !=true	do (
				local xypt=#()
				for i in 1 to rowpt.count do (
					local tmp=xyzSort rowpt[i] 2 theTol
					for j in tmp do append xypt j
				)			
				for i in 1 to xypt.count do(
				  for j in 1 to xypt[i].count do(append rcp xypt[i][j])
				)
			)	

	
	--004：生成样式点
			local theRDiv,theCDiv
			case of
			(			
				(ckSty01.checked==true  and con==true):
				stylept=pSty01con newRows newCols theRwidth theCwidth

				(ckSty01.checked==true  and con !=true):
				(stylept=pSty01 rcp theRwidth theCwidth)
				--
				(ckSty02.checked==true  and con==true):
				stylept=pSty02con newRows newCols theRwidth theCwidth

				(ckSty02.checked==true  and con !=true):
				stylept=pSty02 rcp theRwidth theCwidth
				--
				(ckSty03.checked==true  and con==true):
				stylept=pSty03con newRows newCols theRwidth theCwidth

				(ckSty03.checked==true and con !=true):
				stylept=pSty03 rcp theRwidth theCwidth			
				--
				
				(ckSty04.checked==true  and con==true):
				(					
					if ckRDivLine.checked==true then theRDiv=1 else theRDiv=0
					if ckCDivLine.checked==true then theCDiv=1 else theCDiv=0
					if ckNum.checked==true then (
					stylept=pSty04con newRows newCols wRfw wCfw rowNum:theRow colNum:theCol rDiv:theRDiv cDiv:theCDiv DivW:DivWidth
					)else (
					stylept=pSty04con newRows newCols wRfw wCfw rowSpa:RSpa colSpa:CSpa rDiv:theRDiv cDiv:theCDiv DivW:DivWidth

					)
				)
				(ckSty04.checked==true and con !=true):
				(
					if ckRDivLine.checked==true then theRDiv=1 else theRDiv=0
					if ckCDivLine.checked==true then theCDiv=1 else theCDiv=0
					if ckNum.checked==true then (
					stylept=pSty04 rcp wRfw wCfw rowNum:theRow colNum:theCol rDiv:theRDiv cDiv:theCDiv DivW:DivWidth

					)
					else(
					stylept=pSty04 rcp wRfw wCfw rowSpa:RSpa colSpa:CSpa rDiv:theRDiv cDiv:theCDiv DivW:DivWidth

					)
				)

			)--end case
			
			rcp=undefined
			LRpt=LRsort newRows 1 theTol
			glassPt=#()
			newRows=undefined
			newCols=undefined
		
			for i in 1 to LRpt.count do
			(
				local col=LRpt[i].count
				local p1=LRpt[i][1][1]
				local p3=LRpt[i][col][3]
				local p2=[p1.x,p3.y,p1.z]
				local p4=[p3.x,p1.y,p3.z]
				append glassPt #(p1,p2,p3,p4)
			)
						
--005 生成玻璃和窗框			
			local ssborder,ssGlass,ssDiv
			--生成玻璃
			ssGlass=createSplineShape glassPt progDoit
			ssGlass.name=uniqueName "建筑＝玻璃(透明)"
			ssGlass.transform=s.transform			
			addmodifier ssGlass (Edit_Mesh ())
			ssGlass.wireColor=color 228 236 242
			
			--生成窗框
			if ckSty04.checked !=true then (
				local RBor,CBor
				RBor=createSplineShape stylept[1] progDoit
				CBor=createSplineShape stylept[2] progDoit				
				--ssborder=createSplineShape stylept progDoit
				if ckbDelBack.checked==true then (
					addmodifier RBor (extrude amount:(-depth) capStart:off capEnd:on)
					addmodifier CBor (extrude amount:(-depth) capStart:off capEnd:on)
				)else(
					addmodifier RBor (extrude amount:(-depth) capStart:on capEnd:on)
					addmodifier CBor (extrude amount:(-depth) capStart:on capEnd:on)				
				)
				RBor.transform=s.transform
				CBor.transform=s.transform
				convertToMesh RBor
				convertToMesh CBor

				--删除多余面
				numFaces=getNumFaces RBor
				SelFacefromNormal  RBor numFaces 1
				fList=getFaceSelection RBor
				meshop.deleteFaces RBor fList
				---
				numFaces=getNumFaces CBor
				SelFacefromNormal  CBor numFaces 2
				fList=getFaceSelection CBor
				meshop.deleteFaces CBor fList
				--
				meshop.attach RBor Cbor targetNode:RBor
				ssborder=RBor
				--ssborder.transform=s.transform
				ssborder.name=uniqueName "建筑＝窗框"			
				ssborder.wireColor= color 97 124 115
					
				--调整玻璃位置
				in coordsys s move ssGlass [0,0,-depth/2.0]
			)
			else(
				local RBor,CBor,DivBor
				local numFaces
				RBor=createSplineShape stylept[1] progDoit
				CBor=createSplineShape stylept[2] progDoit	
				
				--生成分线
				if theRDiv==1 or theCDiv==1 do (
					DivBor=createSplineShape stylept[3] progDoit
					addmodifier DivBor (Edit_Mesh ())
					DivBor.transform=s.transform
					DivBor.name=uniqueName "建筑＝窗框分线"	
					in coordsys s move DivBor [0,0,divToGlassDis]		
					DivBor.wireColor= color 0 0 0
					--convertToMesh DivBor
					ssDiv=DivBor
				)	
				
				if ckbDelBack.checked==true then (
					addmodifier RBor (extrude amount:(-RDep) capStart:off capEnd:on)
					addmodifier CBor (extrude amount:(-CDep) capStart:off capEnd:on)
				)else(
					addmodifier RBor (extrude amount:(-RDep) capStart:on capEnd:on)
					addmodifier CBor (extrude amount:(-CDep) capStart:on capEnd:on)				
				)
				RBor.transform=s.transform
				CBor.transform=s.transform
				convertToMesh RBor
				convertToMesh CBor
				
				--删除多余面
				numFaces=getNumFaces RBor
				SelFacefromNormal  RBor numFaces 1
				fList=getFaceSelection RBor
				meshop.deleteFaces RBor fList
				---
				numFaces=getNumFaces CBor
				SelFacefromNormal  CBor numFaces 2
				fList=getFaceSelection CBor
				meshop.deleteFaces CBor fList
				--
				
				case radRow.state of
				(
					2:(in coordsys s move Rbor [0,0,(-RBack+RDep-baseLine)])
					3:(in coordsys s move Rbor [0,0,(-RBack+baseLine)])--[0,0,(-RBack)])
					default:(in coordsys s move Rbor [0,0,(RDep/2.0-RBack)])				
				)
				
				case radCol.state of
				(
					2:(in coordsys s move Cbor [0,0,-CBack+CDep-baseLine])
					3:(in coordsys s move Cbor [0,0,-CBack+baseLine])
					default:(in coordsys s move Cbor [0,0,CDep/2.0-CBack])				
				)

				--convertToMesh RBor
				--convertToMesh CBor
				meshop.attach RBor Cbor targetNode:RBor
				ssborder=RBor	
				--ssborder.transform=s.transform
				ssborder.name=uniqueName "建筑＝窗框"			
				ssborder.wireColor= color 97 124 115
							
			)--end if ckSty04.checked
			--
			stylept=undefined
			glassPt=undefined			
			prev01=ssborder
			prev02=ssGlass
			prev03=ssDiv
			delete tmpLine
--006 材质
			local borderMatName="建筑＝窗框（墨绿色金属）"
			local glassMatName="建筑＝玻璃（透明）"
			local borderBmpName=undefined--"\\\\Server-5\\建筑部服务器\\
			--标准材质\\map\\703000 副本.jpg"	
					
			ssborder.material=matborder borderMatName borderBmpName			
			ssGlass.material=matGlass glassMatName
			local theMatArray=#(ssborder.material,ssGlass.material)
	         loader theMatArray
			pt=undefined
			stylept=undefined	
			progDoit.value=0
			)--end if 曲线幕墙
			)--end msg
			)--end undo
		)--end if	
		)--end if		
	)---end createWF
)---end rollout windowFrame
theFloater=newRolloutFloater "窗框" 180 720 30 60
addRollout windowFrame theFloater
)
