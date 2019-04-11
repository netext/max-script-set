-----挑选相同的线物体
--作者：Bingo
--QQ:330798701

if selection.count!=0 then
(
	local allShape_array01=#();
	local allShape_array02=#();
	local sameShape_array=#();
	
	--自定义函数 一个获取shape的某一条样条线的某一个线段的长度
	fn lengthOfSeg sh sp seg = 
	(
		TL=getSegLengths sh sp
		return TL[(numSegments sh sp) + seg]
	)
	
	for i in selection do
	(
		if superclassof i==Shape then
		(
			append allShape_array01 i;
			append allShape_array02 i;
		)
	)
	
		for i=1 to allShape_array01.count do
		(
			for j=1 to allShape_array02.count do
			(
				if i!=j then 
				(
					try
					(
						numSegs01=numSegments allShape_array01[i] 1;
						numSegs02=numSegments allShape_array02[j] 1;
						if numSegs02==numSegs01 then
						(
							--if j>i do append sameShape_array allShape_array02[j];
							
							local flagSame=true;
							
							for k=1 to numSegs01 do
							(
								lengthSeg01=lengthOfSeg allShape_array01[i] 1 k;
								lengthSeg02=lengthOfSeg allShape_array02[j] 1 k;
								
								if lengthSeg02!=lengthSeg01 do flagSame=false;
							)
							
							if flagSame and j>i then append sameShape_array allShape_array02[j];
							
							
						)
					)
					catch()
				)
				else
				(
					
				)
			)
		)
	if sameShape_array.count!=0 then select sameShape_array;else messagebox "经检查没找到有相同的线！！"
)
else
messagebox"请先选择要判断的所有线！！"