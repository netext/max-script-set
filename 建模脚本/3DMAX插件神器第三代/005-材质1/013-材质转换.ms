global forceUpdate=true

rollout multi_kill "多维材质通道转换小工具V1.2"
(
fn set_color01 =
(  
                color01 = standard name:"材质01" diffuse:(color 255 0 0) selfIllumAmount:100
                   color02 = standard name:"材质02" diffuse:(color 253 161 115)  selfIllumAmount:100
				color03 = standard name:"材质03" diffuse:(color 187 164 7) selfIllumAmount:100
				color04 = standard name:"材质04" diffuse:(color 0 160 174) selfIllumAmount:100
				color05 = standard name:"材质05" diffuse:(color 18 0 255)  selfIllumAmount:100				
				color06 = standard name:"材质06" diffuse:(color 255 0 120) selfIllumAmount:100	
			
				color07 = standard name:"材质07" diffuse:(color 93 106 174) selfIllumAmount:100
				color08 = standard name:"材质08" diffuse:(color 0 65 0) selfIllumAmount:100
				color09 = standard name:"材质09" diffuse:(color 255 115 115) selfIllumAmount:100
				color10 = standard name:"材质10" diffuse:(color 255 135 7) selfIllumAmount:100				
				color11 = standard name:"材质11" diffuse:(color 144 126 7) selfIllumAmount:100
				color12 = standard name:"材质12" diffuse:(color 45 92 7) selfIllumAmount:100
				
				color13 = standard name:"材质13" diffuse:(color 0 112 122) selfIllumAmount:100
				color14 = standard name:"材质14" diffuse:(color 12 0 168) selfIllumAmount:100
				color15 = standard name:"材质15" diffuse:(color 161 0 76)  selfIllumAmount:100				
				color16 = standard name:"材质16" diffuse:(color 0 255 0) selfIllumAmount:100
				color17 = standard name:"材质17" diffuse:(color 222 128 115) selfIllumAmount:100
				color18 = standard name:"材质18" diffuse:(color 197 105 7)  selfIllumAmount:100
				
				color19 = standard name:"材质19" diffuse:(color 98 86 7) selfIllumAmount:100
				color20 = standard name:"材质20" diffuse:(color 68 151 0) selfIllumAmount:100
				color21 = standard name:"材质21" diffuse:(color 0 84 91) selfIllumAmount:100
				color22 = standard name:"材质22" diffuse:(color 120 0 255) selfIllumAmount:100
				color23 = standard name:"材质23" diffuse:(color 82 0 39) selfIllumAmount:100
				color24 = standard name:"材质24" diffuse:(color 126 0 0) selfIllumAmount:100
				
				color25 = standard name:"材质25" diffuse:(color 192 133 114) selfIllumAmount:100
				color26 = standard name:"材质26" diffuse:(color 139 75 7) selfIllumAmount:100
				color27 = standard name:"材质27" diffuse:(color 205 255 7) selfIllumAmount:100
				color28 = standard name:"材质28" diffuse:(color 92 206 0) selfIllumAmount:100
				color29 = standard name:"材质29" diffuse:(color 0 150 255) selfIllumAmount:100
				color30 = standard name:"材质30" diffuse:(color 246 0 255) selfIllumAmount:100
				
				color31 = standard name:"材质31" diffuse:(color 139 142 181) selfIllumAmount:100
				color32 = standard name:"材质32" diffuse:(color 150 136 115) selfIllumAmount:100
				color33 = standard name:"材质33" diffuse:(color 255 223 7) selfIllumAmount:100
				color34 = standard name:"材质34" diffuse:(color 255 135 7) selfIllumAmount:100
				color35 = standard name:"材质35" diffuse:(color 144 164 7) selfIllumAmount:100
				color36 = standard name:"材质36" diffuse:(color 0 105 114) selfIllumAmount:100
				
				color37 = standard name:"材质37" diffuse:(color 0 71 121) selfIllumAmount:100
				color38 = standard name:"材质38" diffuse:(color 89 0 92) selfIllumAmount:100
				color39 = standard name:"材质39" diffuse:(color 95 96 0) selfIllumAmount:100
				color40 = standard name:"材质40" diffuse:(color 139 169 159) selfIllumAmount:100
				color41 = standard name:"材质41" diffuse:(color 0 116 198) selfIllumAmount:100
				color42 = standard name:"材质42" diffuse:(color 172 0 178) selfIllumAmount:100
				
				color43 = standard name:"材质43" diffuse:(color 0 255 255) selfIllumAmount:100
				color44 = standard name:"材质44" diffuse:(color 134 0 91) selfIllumAmount:100
				color45 = standard name:"材质45" diffuse:(color 172 139 139) selfIllumAmount:100
				color46 = standard name:"材质46" diffuse:(color 159 125 115) selfIllumAmount:100
				color47 = standard name:"材质47" diffuse:(color 105 58 7) selfIllumAmount:100
				color48 = standard name:"材质48" diffuse:(color 179 204 7)	selfIllumAmount:100
					
		
color_mat=#(color01,color02,color03,color04,color05,color06,color07,color08,color09,color10,color11,color12,color13,color14,color15,color16,color17,color18,color19,color20,color21,color22,color23,color24,color25,color26,color27,color28,color29,color30,color31,color32,color33,color35,color36,color37,color38,color39,color40,color41,color42,color43,color44,color45,color46,color47,color48)
	--x=1
	select $*
	for i in $* do
	(		
	(--------------
	 
	 if (classof(i.material))==Multimaterial then
	   (
	     mul_count=((i.material).count)
	     for p=1 to mul_count do
		  (
		  i.material[p]=standard name:("材质"+p as string) diffuse:(random black white) selfIllumAmount:100
		  i.material.material1=standard name:("材质"+p as string) diffuse:(random black white) selfIllumAmount:100
         
		  )

	   )
	   
	 else
     (	
	 for m=1 to sceneMaterials.count do 
	  (
	    if m<=color_mat.count then
		(
		 if i.material == sceneMaterials[m] then 
		  (
		   i.material=color_mat[m]
		   exit
		  )
		)
		else
		(
		if i.material == sceneMaterials[m] then 
		  (
		   i.material=color_mat[(mod m (color_mat.count)) as integer+1]
		   exit
		  )

		)
		  
	  )       
	)
	)
	)----------------------
)




button start_con "开始转换场景中的多维材质及非多维材质 →" width:250 pos:[25,13]


hyperlink sm_version "VRay高效全自动效果图渲染工具-莫莫批量渲染" address:"http://download.ytcnc.net/soft/57131.htm" color:(color 133 73 8) hovercolor:(color 252 14 2) visitedcolor:(color 108 120 130) align:#center --offset: [0,-18]
label QQ "QQ:562794142" align:#center
on start_con pressed do
  (
   --max mtledit
   set_color01()	 
  )

)

createdialog multi_kill 300 86
