--by qq 260592419
--zhouyang_28@yahoo.com
--20140719
try closeRolloutFloater zymat1 catch()
--
global ffww = 1
--
rollout czfw "选择操作范围*"
(
	radiobuttons czfwa "" labels:#("场景中的【所有】材质    ","仅【选择】物体的材质") default:1
	on czfw open do	ffww = czfwa.state
	on czfwa changed val do 
	(
		if czfwa.state == 2 do messagebox 	"此功能在部份选项中可能只在2012以后版本生效。" title:"黑马提醒" beep:off
		ffww = czfwa.state
		
	)
)
rollout vraymt "Vray材质调节"
(
	----
	groupbox diff "Diffuse" pos:[0,0] width:335 height:70
	--
	colorpicker vrdiff "Diffuse" pos:[10,20] height:18 width:90 color:(color 128 128 128)
	button setdiff "统一漫反射↑" pos:[10,40] height:20 width:90
	button deldiff "←清贴图" pos:[105,20] height:40 width:55
	--
	spinner roug "Roughness" pos:[210,20] width:60 range:[0.0,1.0,0]
	button setroug "统一粗糙值↑" pos:[170,40] width:100
	button delroug "←清贴图" pos:[275,20] width:55 height:40
	----
	groupbox refl "Reflection" pos:[0,70] width:335 height:220
	--
	colorpicker refle "Reflect" pos:[10,90] height:18 width:90 color:(color 0 0 0)
	button setrefl "统一反射色↑" pos:[10,110] height:20 width:90
	button delrefl "←清贴图" pos:[105,90] height:40 width:55
	--
	spinner hilight "Hilight glos." pos:[50,140] width:50 range:[0.0,1.0,1.0]
	button sethilight "统一高光值↑" pos:[10,160] height:20 width:90
	button delhilight "←清贴图" pos:[105,140] height:40 width:55
	--
	checkbox fres "Fresnel reflections" pos:[170,140]
	button setfres "统一菲涅尔开关↑" pos:[170,160] height:20 width:110
	--
	spinner reflgls "Refl.glos" pos:[50,190] width:50 range:[0.0,1.0,1.0]
	button setreflgls "统一反.模糊↑" pos:[10,210] height:20 width:90
	button delreflgls "←清贴图" pos:[105,190] height:40 width:55
	--
	spinner freior "Fresnel IOR" pos:[210,190] width:60 range:[0.0,100,1.6]
	button setfreior "统一菲.折射率↑" pos:[170,210] width:100 height:20
	button delfreior "←清贴图" pos:[275,190] width:55 height:40
	--
	spinner fresub "Subdivs" pos:[40,240] width:60 range:[1,1000,8] type:#integer
	button setfresub "统一反.细分↑" pos:[10,260] width:90
	--
	spinner fredep "Max Depth" pos:[155,240] width:50 range:[1,1000,5] type:#integer
	button setfredep "统一最大深度↑" pos:[115,260] width:90 height:20
	--
	checkbox freinter "Use interpolation" pos:[220,240] width:110
	button setfreinter "统一使用差值开关↑" pos:[220,260] width:110 height:20
	----
	groupbox refra "Refraction" pos:[0,290] width:335 height:170
	--
	colorpicker refract "Refract" pos:[10,310] width:90 height:18 color:(color 0 0 0)
	button setrefract "统一折射色↑" pos:[10,330] width:90 height:20 
	button delrefract "←清贴图" pos:[105,310] width:55 height:40
	--
	spinner fraior "IOR" pos:[190,310] width:60 range:[0.0,100.0,1.6]
	button setfraior "统一折射率↑" pos:[170,330] width:80 height:20
	button delfraior "←清贴图" pos:[255,310] width:55 height:40
	--
	spinner fraglos "Glossiness" pos:[40,360] width:60 range:[0.0,1.0,1.0]
	button setfraglos "统一折.模糊↑" pos:[10,380] width:90 height:20
	button delfraglos "←清贴图" pos:[105,360] width:55 height:40
	--
	spinner fradep "Max depth" pos:[210,360] width:60 range:[1,1000,5] type:#integer
	button setfradep "统一最大深度↑" pos:[170,380]
	--
	spinner frasub "Subdivs" pos:[50,410] width:50 range:[1,1000,8] type:#integer
	button setfrasub "统一折射细分↑" pos:[10,430] width:90 height:20
	--
	checkbox frainter "Use interpolation" pos:[110,410]
	button setfrainter "统一差值开关↑" pos:[110,430] width:100
	--
	checkbox affectsd "Affect shadows" pos:[220,410]
	button setaffectsd "统一影响阴影开关↑" pos:[220,430] width:110
	----
	groupbox selfi "Self-illumination" pos:[0,460] width:335 height:70
	--
	colorpicker vrself "Self-illu" pos:[10,480] height:18 width:90 color:(color 0 0 0)
	button setself "统一自发光↑" pos:[10,500] height:20 width:90
	button delself "←清贴图" pos:[105,480] height:40 width:55
	--
	checkbox vrmtgi "GI" pos:[170,480] checked:true
	button setvrmtgi "统一开关GI↑" pos:[170,500] height:20 width:75
	--
	spinner mult "Mult" pos:[265,480] width:65 range:[0.0,10000000,1.0]
	button setmult "统一GI值↑" pos:[250,500] width:80 height:20
	----
	groupbox maps "Maps" pos:[0,530] width:335 height:80
	--
	button delbump "清除凹凸(Bump)贴图" pos:[10,550] width:155 height:20
	button deldisp "清除置换(Displace)贴图" pos:[170,550] width:155 height:20
	button delopac "清除透明(Opacity)贴图" pos:[10,580] width:155 height:20
	button delenvi "清除环境(Environment)贴图" pos:[170,580] width:155 height:20
	--
	------------------------------------------------------------------------------------------------------------------------------------
	on setdiff pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.Diffuse = vrdiff.color) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.Diffuse = vrdiff.color
				) catch()
			)
	)
	--
	on deldiff pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.texmap_diffuse = undefined) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.texmap_diffuse = undefined
				) catch()
			)
	)
	--
	on setroug pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.diffuse_roughness = roug.value) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.diffuse_roughness = roug.value
				) catch()
			)
	)
	--
	on delroug pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.texmap_roughness = undefined) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.texmap_roughness = undefined
				) catch()
			)
	)
	-------------------------------------------------
	on setrefl pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.Reflection = refle.color) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.Reflection = refle.color
				) catch()
			)
	)
	--
	on delrefl pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.texmap_reflection = undefined) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.texmap_reflection = undefined
				) catch()
			)
	)
	--
	on sethilight pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.hilight_glossiness = hilight.value) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.hilight_glossiness = hilight.value
				) catch()
			)
	)
	--
	on delhilight pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.texmap_hilightGlossiness = undefined) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.texmap_hilightGlossiness = undefined
				) catch()
			)
	)
	--
	on setfres pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.reflection_fresnel = fres.state) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.reflection_fresnel = fres.state
				) catch()
			)
	)
	--
	on setreflgls pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.reflection_glossiness = reflgls.value) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.reflection_glossiness = reflgls.value
				) catch()
			)
	)
	--
	on delreflgls pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.texmap_reflectionGlossiness = undefined) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.texmap_reflectionGlossiness = undefined
				)catch()
			)
	)
	--
	on setfreior pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.reflection_ior = freior.value) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.reflection_ior = freior.value
				) catch()
			)
	)
	--
	on delfreior pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.texmap_reflectionIOR = undefined) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.texmap_reflectionIOR = undefined
				) catch()
			)
	)
	--
	on setfresub pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.reflection_subdivs = fresub.value) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.reflection_subdivs = fresub.value
				) catch()
			)
	)
	--
	on setfredep pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.reflection_maxDepth = fredep.value) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.reflection_maxDepth = fredep.value
				) catch()
			)
	)
	--
	on setfreinter pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.reflection_useInterpolation = freinter.state) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.reflection_useInterpolation = freinter.state
				) catch()
			)
	)
	-------------------------------------------------
	on setrefract pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.Refraction = refract.color) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.Refraction = refract.color
				) catch()
			)
	)
	--
	on delrefract pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.texmap_refraction = undefined) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.texmap_refraction = undefined
				) catch()
			)
	)
	--
	on setfraior pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.refraction_ior = fraior.value) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.refraction_ior = fraior.value
				) catch()
			)
	)
	--
	on delfraior pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.texmap_refractionIOR = undefined) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.texmap_refractionIOR = undefined
				) catch()
			)
	)
	--
	on setfraglos pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.refraction_glossiness = fraglos.value) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.refraction_glossiness = fraglos.value
				) catch()
			)
	)
	--
	on delfraglos pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.texmap_refractionGlossiness = undefined) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.texmap_refractionGlossiness = undefined
				) catch()
			)
	)
	--
	on setfradep pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.refraction_maxDepth = fradep.value) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				( 
					l.refraction_maxDepth = fradep.value
				) catch()
			)
	)
	--
	on setfrasub pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.refraction_subdivs = frasub.value) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.refraction_subdivs = frasub.value
				) catch()
			)
	)
	--
	on setfrainter pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.refraction_useInterpolation = frainter.state) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.refraction_useInterpolation = frainter.state
				) catch()
			)
	)
	--
	on setaffectsd pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.refraction_affectShadows = affectsd.state) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.refraction_affectShadows = affectsd.state
				) catch()
			)
	)
	--
	on delbump pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.texmap_bump = undefined) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.texmap_bump = undefined
				)catch()
			)
	)
	on deldisp pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.texmap_displacement = undefined) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.texmap_displacement = undefined
				) catch()
			)
	)
	on delopac pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.texmap_opacity = undefined) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.texmap_opacity = undefined
				) catch()
			)
	)
	on delenvi pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.texmap_environment = undefined) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.texmap_environment = undefined
				) catch()
			)
	)
	-------------------------------------------------
	on setself pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.selfIllumination = vrself.color) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.selfIllumination = vrself.color
				) catch()
			)
	)
	on delself pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.texmap_self_illumination = undefined) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.texmap_self_illumination = undefined
				) catch()
			)
	)
	--
	on setvrmtgi pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.selfIllumination_gi = vrmtgi.state) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.selfIllumination_gi = vrmtgi.state
				) catch()
			)
	)
	--
	on setmult pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VrayMtl ) do try (v.selfIllumination_multiplier = mult.value) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VrayMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.selfIllumination_multiplier = mult.value
				) catch()
			)
	)
	--------------------------------------------------
)
rollout stdmt "Standard材质调节"
(
	colorpicker stddiff "Diffuse:" height:18 width:85 color:(color 150 150 150 ) pos:[5,10]
	button setstddiff "统一漫反射↑" height:20 width:85 pos:[5,30]
	button delstddiff "←清贴图" height:40 width:55 pos:[90,10]
	--
	colorpicker stdself "Self-I.Col." height:18 width:90 color:(color 0 0 0) pos:[155,10]
	spinner stdselfv "" width:35 pos:[245,11] range:[0,100,0] type:#integer
	button setstdself "统一自发光色或值↑" height:20 width:125 pos:[155,30]
	button delstdself "←清贴图" height:40 width:55 pos:[280,10]
	--
	checkbox side_2 "2-Sided" pos:[5,60]
	button setside2 "统一双面值↑" pos:[5,80] height:20 width:85
	--
	spinner stdopa "Opacity:" pos:[130,60] width:60 range:[0,100,100] type:#integer
	button setstdopa "统一不透值↑" pos:[100,80] height:20 width:90
	button delstdopa "←清贴图" pos:[190,60] height:40 width:55
	--
	spinner stdspe "Spec.Lv." pos:[285,60] width:50 range:[0,999,0] type:#integer
	button setstdspe "统一高光值↑" pos:[250,80] height:20 width:85
	------
	button delstdbum "清除凹凸(Bump)贴图" pos:[5,120] width:155 height:24
	button delstdfle "清除反射(Reflection)贴图" pos:[175,120] width:155 height:24
	button delstdfra "清除折射(Refraction)贴图" pos:[5,150] width:155 height:24
	button delstddis "清除置换(Displacement)贴图" pos:[175,150] width:155 height:24
	-------------------------------------------------------------------------------------------------------------------------
	on setstddiff pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances Standard ) do try (v.Diffuse = stddiff.color) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances Standard target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.Diffuse = stddiff.color
				) catch()
			)
	)
	--
	on delstddiff pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances Standard ) do try (v.Diffusemap = undefined) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances Standard target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.Diffusemap = undefined
				) catch()
			)
	)
	--
	on setstdself pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances Standard ) do try 
				(
					v.selfIllumColor = stdself.color
					v.selfIllumAmount = stdselfv.value
				) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances Standard target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.selfIllumColor = stdself.color
					l.selfIllumAmount = stdselfv.value
				) catch()
			)
	)
	--
	on delstdself pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances Standard ) do try (v.selfillumMap = undefined) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances Standard target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.selfillumMap = undefined
				) catch()
			)
	)
	--
	on setside2 pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances Standard ) do try (v.twoSided = side_2.state) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances Standard target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.twoSided = side_2.state
				) catch()
			)
	)
	--
	on setstdopa pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances Standard ) do try (v.opacity = stdopa.value) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances Standard target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.opacity = stdopa.value
				) catch()
			)
	)
	--
	on delstdopa pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances Standard ) do try (v.opacityMap = undefined) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances Standard target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.opacityMap = undefined
				) catch()
			)
	)
	--
	on setstdspe pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances Standard ) do try (v.specularLevel = stdspe.value) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances Standard target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.specularLevel = stdspe.value
				) catch()
			)
	)
	--
	on delstdbum pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances Standard ) do try (v.bumpMap = undefined) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances Standard target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.bumpMap = undefined
				) catch()
			)
	)
	on delstdfle pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances Standard ) do try (v.reflectionMap = undefined) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances Standard target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.reflectionMap = undefined
				) catch()
			)
	)
	on delstdfra pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances Standard ) do try (v.refractionMap = undefined) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances Standard target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.refractionMap = undefined
				) catch()
			)
	)
	on delstddis pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances Standard ) do try (v.displacementMap = undefined) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances Standard target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.displacementMap = undefined
				) catch()
			)
	)
)
rollout othermt "更多材质功能"
(
	local matyy,mat,mcount,nsn,num = 1
	--
	button clsrtc "关Raytrace消息框" pos:[5,10] height:25 width:120
	--
	spinner vrltval "VRay发光材质:" pos:[195,14] width:55 range:[0.0,100000.0,1.0]
	button setvrltval "←统一发光值" pos:[250,10] height:25 width:85
	--
	button randcol "物体随机自发光(标)" pos:[5,45] height:25 width:120
	--
	spinner sssval "SSS(2)渲染级:" pos:[190,52] width:60 range:[-100,100,-3] type:#integer 
	button sss2o "←统一渲染级" pos:[250,45] width:85 height:25
	--
	button vrl2stds "VRayLightMtl材质转Standard自发光材质" pos:[5,80] width:230 height:30 tooltip:"仅单层材质有效、仅同步贴图和颜色。"
	button stds2vrl "←→反向转换" pos:[235,80] width:95 height:30 tooltip:"Standard自发光到VRayLight,仅单层材质有效、仅同步贴图和颜色。"
	--
	spinner vrmapv "VRayMap值:" pos:[55,128] width:60 range:[0,100,30] type:#integer
	button rtc2vrm "Raytrace贴图转Raymap贴图" pos:[120,120] width:210 height:30 tooltip:"仅两层级材质以内、仅对反射贴图为Raytrace有效。"
	--
	groupbox gbselmat "按材质类型导出材质" pos:[0,155] width:335 height:60 
	materialbutton mba "请选择材质类型" pos:[5,175] width:200 height:30 tooltip:"点击选择材质类型"
	button mba2medit "导出到编辑器" pos:[205,175] width:80 height:30
	button mbanext "下一屏" pos:[285,175] width:45 height:30
	--
	groupbox gbcopymat "跨文件拷材质、贴图" pos:[0,220] width:335 height:200
	--
	checkbutton mt1 "A" pos:[10,240] height:50 width:60 checked:true
	checkbutton mt2 "B" pos:[75,240] height:50 width:60
	checkbutton mt3 "C" pos:[140,240] height:50 width:60	
	checkbutton mt4 "D" pos:[205,240] height:50 width:60
	label lab1 "名称：N/A" --pos:[10,295]
	button delmc "←清空" pos:[270,245] height:36 width:60
	--
	button getmt "复制材质编辑器选中的材质" pos:[10,320] height:40 width:200 tooltip:"复制材质编辑器中选中材质到粘贴板"
	pickbutton fromobj "从物体复制" pos:[215,320] height:40 width:110
	button setmt "粘贴材质到编辑器选中位置" pos:[10,370] height:40 width:200 tooltip:"粘贴材质到编辑器中"
	button toobj "粘贴到物体" pos:[215,370] height:40 width:110
	
	----------------------------------------------------------------------------------------------------------------
	-----
	on clsrtc pressed do 
	(
	closertc = RaytraceGlobalSettings()
	closertc.enable_raytracing = false
	closertc.showMessages = false
	closertc.showProgressDlg = false
	)
	--
	on setvrltval pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VRayLightMtl ) do try (v.multiplier = vrltval.value) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VRayLightMtl target:k) do (append arrayaa v)
				)
				for l in arrayaa do try
				(
					l.multiplier = vrltval.value
				) catch()
			)
	)
	--
	on randcol pressed do undo on
	(
		if ffww == 1 then 
		(
			for i in objects do try
				(
					zfg = Standardmaterial Diffuse:(color (random 0 255) (random 0 255) (random 0 255)) selfIllumAmount:100
					zfg.name = uniquename "zyMat"
					i.material = zfg
						
				) catch()
		)else
		(
			for i in selection do try
				
				(
					zfg = Standardmaterial Diffuse:(color (random 0 255) (random 0 255) (random 0 255)) selfIllumAmount:100
					zfg.name = uniquename "zyMat"
					i.material = zfg
				) catch()
					
		)
	)
	--
	on sss2o pressed do undo on
	(
		if ffww == 1 then 
			(
				for v in (getClassInstances VRayFastSSS ) do try (v.prepass_rate = sssval.value) catch()
				for v in (getClassInstances VRayFastSSS2 ) do try (v.prepass_rate = sssval.value) catch()
			)else
			(
				arrayaa = #()
				arraybb = selection as array
				for k in arraybb do
				(
					for v in (getClassInstances VRayFastSSS target:k) do (append arrayaa v)
					for w in (getClassInstances VRayFastSSS2 target:k) do (append arrayaa w)
				)
				for l in arrayaa do try
				(
					l.prepass_rate = sssval.value
				) catch()
			)
	)
	--
	on vrl2stds pressed do undo on
	(
		if ffww == 1 then 
		(
			vrlarray = for v in scenematerials where classof v == VRayLightMtl collect v
			for x in vrlarray do
			(
				vrlobjs = for w in objects where w.material == x collect w
				namevl = x.name
				difftemp = x.texmap
				diffcol = x.color
				for u in vrlobjs do
				(
				u.material = Standardmaterial ()
				u.material.name = namevl
				u.material.diffuseMap = difftemp
				u.material.Diffuse = diffcol
				u.material.selfIllumAmount = 100
				)
				
			)
		)else
		(
			vrlarray = for v in scenematerials where classof v == VRayLightMtl collect v
			for x in vrlarray do
			(
				vrlobjs = for w in selection where w.material == x collect w
				namevl = x.name
				difftemp = x.texmap
				diffcol = x.color
				for u in vrlobjs do
				(
				u.material = Standardmaterial ()
				u.material.name = namevl
				u.material.diffuseMap = difftemp
				u.material.Diffuse = diffcol
				u.material.selfIllumAmount = 100
				)
				
			)
		)
		
	)
	--
	on stds2vrl pressed do undo on
	(
		if ffww == 1 then 
		(
			vrlarray = for v in scenematerials where (classof v == Standardmaterial and v.selfIllumAmount == 100) collect v
			for x in vrlarray do
			(
				vrlobjs = for w in objects where w.material == x collect w
				namevl = x.name
				difftemp = x.diffuseMap
				diffcol = x.Diffuse
				for u in vrlobjs do
				(
				u.material = VRayLightMtl ()
				u.material.name = namevl
				u.material.texmap = difftemp
				u.material.color = diffcol
				u.material.multiplier = 1
				)
				
			)
		)else
		(
			vrlarray = for v in scenematerials where (classof v == Standardmaterial and v.selfIllumAmount == 100) collect v
			for x in vrlarray do
			(
				vrlobjs = for w in selection where w.material == x collect w
				namevl = x.name
				difftemp = x.diffuseMap
				diffcol = x.Diffuse
				for u in vrlobjs do
				(
				u.material = VRayLightMtl ()
				u.material.name = namevl
				u.material.texmap = difftemp
				u.material.color = diffcol
				u.material.multiplier = 1
				)
				
			)
		)
		
	)
	--
	on rtc2vrm pressed do undo on
	(
		if ffww == 1 then 
			(
		
				for i in scenematerials do if superclassof i != textureMap do
					(
						if getNumSubMtls i == 0 do 
						try (
							if classof i.reflectionMap == Raytrace then
								(
									i.reflectionMapAmount = vrmapv.value
									i.reflectionMap = VRayMap ()
								)
						)catch()
						--
						if getnumsubmtls i != 0 do
							(
								for k = 1 to (getnumsubmtls i) do
								try(
									if classof (getSubMtl i k).reflectionMap == Raytrace then
									(
										(getSubMtl i k).reflectionMapAmount = vrmapv.value
										(getSubMtl i k).reflectionMap = VRayMap ()
									)
								)catch()
							)
					)
			)else
			(
				for i in selection do try
					
					(
						if getNumSubMtls i.material == 0 do 
						try (
							if classof i.material.reflectionMap == Raytrace then
								(
									i.material.reflectionMapAmount = vrmapv.value
									i.material.reflectionMap = VRayMap ()
								)
						)catch()
						--
						if getnumsubmtls i.material != 0 do
							(
								for k = 1 to (getnumsubmtls i.material) do
								try(
									if classof (getSubMtl i.material k).reflectionMap == Raytrace then
									(
										(getSubMtl i.material k).reflectionMapAmount = vrmapv.value
										(getSubMtl i.material k).reflectionMap = VRayMap ()
									)
								)catch()
							)
					) catch()
			)
	)
	--
	on mba picked mat do 
	(
		if ffww == 1 then
		(
			matyy = #()
			for i in scenematerials do if classof i == (classof mat) do
			(
				append matyy i
				
			)
			--print matyy.count
		)else
		(
			matyy = #()
			for i in selection do if classof i.material == (classof mat) do
			(
				append matyy i.material
				--print matyy.count
			)
		)
		mba.caption = "选中 " + (classof mat)as string + " 类型 " + (matyy.count as string)
		nsn = 0
	)
	--
	on mba2medit pressed do if matyy != undefined do
	(
		if matyy.count != 0 do mcount = matyy.count/24 + 1
		print mcount
		if mcount > 0 do try
		(
			MatEditor.Open()
			macros.run "Medit Tools" "clear_medit_slots"
			for j = 1 to 24 do setMeditMaterial j matyy[j]
			nsn = 1
		) catch()
	)
	--
	on mbanext pressed do try if mcount > 1 then
	(
		MatEditor.Open()
		macros.run "Medit Tools" "clear_medit_slots"
		for j = (24*nsn + 1) to (24*nsn + 24)  do setMeditMaterial (j - 24*nsn) matyy[j]
		nsn = nsn + 1
		
	) else(messagebox "当前没有更多要导出到编辑器的材质。" title:"黑马提醒" beep:off)
	catch(messagebox "当前没有更多要导出到编辑器的材质。" title:"黑马提醒" beep:off)
	----
	--
	on getmt pressed do
	(
		if mt1.checked == true do num = "1"
		if mt2.checked == true do num = "2"
		if mt3.checked == true do num = "3"
		if mt4.checked == true do num = "4"
		--
		try makeDir (getdir #scripts +"\\zycopym\\") catch(print "code03")
		mtzy = materialLibrary ()
		append mtzy meditMaterials[activeMeditSlot]
		try saveTempMaterialLibrary mtzy(getdir #scripts + "\\zycopym\\" + num + ".mat") catch(print "code04")
		--
		try setinisetting (getdir #scripts +"\\zycopym\\ZY_copy_mtl.ini") "Copylist" num (meditmaterials[activemeditslot].name)  catch(print "code05")
		try lab1.text = getinisetting (getdir #scripts +"\\zycopym\\ZY_copy_mtl.ini") "Copylist" num catch()
		--
		try
		(
			rm = renderMap meditMaterials[activeMeditSlot].Diffusemap size:[40,40] fileName:((getdir #scripts +"\\zycopym\\")+ num +".bmp") 
			save rm
			close rm
			try if mt1.checked == true do mt1.images = #(((getdir #scripts) +"\\zycopym\\1.bmp"),((getdir #scripts) +"\\zycopym\\1.bmp"),1, 1, 1, 1, 1) catch(mt1.images = undefined )
			try if mt2.checked == true do mt2.images = #(((getdir #scripts) +"\\zycopym\\2.bmp"),((getdir #scripts) +"\\zycopym\\2.bmp"),1, 1, 1, 1, 1) catch(mt1.images = undefined )
			try if mt3.checked == true do mt3.images = #(((getdir #scripts) +"\\zycopym\\3.bmp"),((getdir #scripts) +"\\zycopym\\3.bmp"),1, 1, 1, 1, 1) catch(mt1.images = undefined )
			try if mt4.checked == true do mt4.images = #(((getdir #scripts) +"\\zycopym\\4.bmp"),((getdir #scripts) +"\\zycopym\\4.bmp"),1, 1, 1, 1, 1) catch(mt1.images = undefined )
			
		)catch()
	)
	--
	on fromobj picked obj do
	(
		if mt1.checked == true do num = "1"
		if mt2.checked == true do num = "2"
		if mt3.checked == true do num = "3"
		if mt4.checked == true do num = "4"
		--
		try makeDir (getdir #scripts +"\\zycopym\\") catch(print "code03")
		mtzy = materialLibrary ()
		append mtzy obj.material
		try saveTempMaterialLibrary mtzy(getdir #scripts + "\\zycopym\\" + num + ".mat") catch(print "code04")
		--
		try setinisetting (getdir #scripts +"\\zycopym\\ZY_copy_mtl.ini") "Copylist" num (meditmaterials[activemeditslot].name)  catch(print "code05")
		try lab1.text = getinisetting (getdir #scripts +"\\zycopym\\ZY_copy_mtl.ini") "Copylist" num catch()
		--
		try
		(
			rm = renderMap obj.material.Diffusemap size:[40,40] fileName:((getdir #scripts +"\\zycopym\\")+ num +".bmp") 
			save rm
			close rm
			try if mt1.checked == true do mt1.images = #(((getdir #scripts) +"\\zycopym\\1.bmp"),((getdir #scripts) +"\\zycopym\\1.bmp"),1, 1, 1, 1, 1) catch(mt1.images = undefined )
			try if mt2.checked == true do mt2.images = #(((getdir #scripts) +"\\zycopym\\2.bmp"),((getdir #scripts) +"\\zycopym\\2.bmp"),1, 1, 1, 1, 1) catch(mt1.images = undefined )
			try if mt3.checked == true do mt3.images = #(((getdir #scripts) +"\\zycopym\\3.bmp"),((getdir #scripts) +"\\zycopym\\3.bmp"),1, 1, 1, 1, 1) catch(mt1.images = undefined )
			try if mt4.checked == true do mt4.images = #(((getdir #scripts) +"\\zycopym\\4.bmp"),((getdir #scripts) +"\\zycopym\\4.bmp"),1, 1, 1, 1, 1) catch(mt1.images = undefined )
			
		)catch()
	)
	--
	on setmt pressed do try 
	(
		if mt1.checked == true do num = "1"
		if mt2.checked == true do num = "2"
		if mt3.checked == true do num = "3"
		if mt4.checked == true do num = "4"
		if MatEditor.isOpen() == false then MatEditor.Open()
		ymmt = loadTempMaterialLibrary (getdir #scripts + "\\zycopym\\" + num + ".mat")
		setMeditMaterial activeMeditSlot ymmt[1]
	) catch()
	--
	on toobj pressed do undo on try 
	(
		if mt1.checked == true do num = "1"
		if mt2.checked == true do num = "2"
		if mt3.checked == true do num = "3"
		if mt4.checked == true do num = "4"
		ymmt = loadTempMaterialLibrary (getdir #scripts + "\\zycopym\\" + num + ".mat")
		try for j in selection do j.material = ymmt[1] catch()
	) catch()
	------
	on mt1 changed state do if mt1.checked == true then
	(
		try lab1.text = getinisetting (getdir #scripts +"\\zycopym\\ZY_copy_mtl.ini") "Copylist" "1" catch()
		mt2.checked = false
		mt3.checked = false
		mt4.checked = false
	)else mt1.checked = true
		
	
	on mt2 changed state do if mt2.checked == true then
	(
		try lab1.text = getinisetting (getdir #scripts +"\\zycopym\\ZY_copy_mtl.ini") "Copylist" "2" catch()
		mt1.checked = false
		mt3.checked = false
		mt4.checked = false
	)else mt2.checked = true
		
	on mt3 changed state do if mt3.checked == true then
	(
		try lab1.text = getinisetting (getdir #scripts +"\\zycopym\\ZY_copy_mtl.ini") "Copylist" "3" catch()
		mt1.checked = false
		mt2.checked = false
		mt4.checked = false
	)else mt3.checked = true
	on mt4 changed state do if mt4.checked == true then
	(
		try lab1.text = getinisetting (getdir #scripts +"\\zycopym\\ZY_copy_mtl.ini") "Copylist" "4" catch()
		mt1.checked = false
		mt3.checked = false
		mt2.checked = false
	)else mt4.checked = true
	-------
	on delmc pressed do
	(
	try deletefile (getdir #scripts + "\\zycopym\\ZY_copy_mtl.ini") catch()
	try deletefile (getdir #scripts + "\\zycopym\\1.mat") catch()
	try deletefile (getdir #scripts + "\\zycopym\\2.mat") catch()
	try deletefile (getdir #scripts + "\\zycopym\\3.mat") catch()
	try deletefile (getdir #scripts + "\\zycopym\\4.mat") catch()
	try deletefile (getdir #scripts + "\\zycopym\\1.bmp") catch()
	try deletefile (getdir #scripts + "\\zycopym\\2.bmp") catch()
	try deletefile (getdir #scripts + "\\zycopym\\3.bmp") catch()
	try deletefile (getdir #scripts + "\\zycopym\\4.bmp") catch()
	--
	mt1.images = undefined 
	mt2.images = undefined 
	mt3.images = undefined 
	mt4.images = undefined 
	--
	lab1.text = "名称：N/A"
	)
	on othermt open do
	(
		try  mt1.images = #(((getdir #scripts) +"\\zycopym\\1.bmp"),((getdir #scripts) +"\\zycopym\\1.bmp"),1, 1, 1, 1, 1) catch(mt1.images = undefined )
		try  mt2.images = #(((getdir #scripts) +"\\zycopym\\2.bmp"),((getdir #scripts) +"\\zycopym\\2.bmp"),1, 1, 1, 1, 1) catch(mt2.images = undefined )
		try  mt3.images = #(((getdir #scripts) +"\\zycopym\\3.bmp"),((getdir #scripts) +"\\zycopym\\3.bmp"),1, 1, 1, 1, 1) catch(mt3.images = undefined )
		try  mt4.images = #(((getdir #scripts) +"\\zycopym\\4.bmp"),((getdir #scripts) +"\\zycopym\\4.bmp"),1, 1, 1, 1, 1) catch(mt4.images = undefined )
		--
		try lab1.text = getinisetting (getdir #scripts +"\\zycopym\\ZY_copy_mtl.ini") "Copylist" "1" catch()
	)
)
rollout obt "关于"
(
	hyperlink helpa "联系作者" address:"http://3dheima.com" color:red
	activeXControl ax "http://www.3dheima.com" align:#left  height:20 width:350 
)
zymat1 = newRolloutFloater "黑马材质整理1.0.1" 350 750
addrollout czfw zymat1
addRollout vraymt zymat1
addrollout stdmt zymat1
addrollout othermt zymat1
addrollout obt zymat1
czfw.open = true
vraymt.open = true
stdmt.open = false
othermt.open = false
obt.open = false
