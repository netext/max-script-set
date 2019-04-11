try (destroyDialog G12) Catch ()
rollout G12 "关闭无用选项 黑马设计网"
(
----------------关闭无用选项------------------------------------------------------
	group "关闭UseInterpolation"
	(
        button btn_fsz "关闭反射折射中UseInterpolation" height:24

        on btn_fsz pressed do
                for y in (getClassInstances VrayMtl) do 
		(y.reflection_useInterpolation = off
         y.refraction_useInterpolation = off
        )
	)
----------------关闭灯光独立波长追踪------------------------------------------
	group "关闭折射中（Dispersion）"
	(
        button btn_gbzsdispersion "关闭"
        on btn_gbzsdispersion pressed do
                for c in (getClassInstances VrayMtl) do (c.refraction_dispersion_on = off)
	)
----------------关闭影响阴影------------------------------------------
	/*group "关闭所有affect shadows"
	(
        button btn_gballaffectshadows "关闭"
        on btn_gballaffectshadows pressed do
                for c in (getClassInstances VrayMtl) do (c.refraction_affectShadows = off)
	)*/
----------------恢复默认interpolation参数-------------------------------
	group "默认interpolation参数"
	(
                label bz_09 "恢复默认反折射中";
                label bz_10 "interpolation参数";
                label bz_11 "-1，-1，0.25，20，0.4";

		button btn_qd "确定" width:64
		
		on btn_qd pressed do
                for a in (getClassInstances VrayMtl) do 
				(a.reflect_minRate = -1
                 a.reflect_maxRate = -1
                 a.reflect_colorThreshold =.25
                 a.reflect_interpSamples =20
                 a.reflect_normalThreshold =.4
                 a.refract_minRate = -1
                 a.refract_maxRate = -1
                 a.refract_colorThreshold =.25
                 a.refract_interpSamples =20
                 a.refract_normalThreshold =.4
                )
    )
	group "vray代理显示"
(
  label bz_dl1 "0-2数值代表vray代理显示类型"; width:180 height:16
  label bz_dl2 "0：box显示、1：模型线框显示"; width:180 height:16
  label bz_dl3 "2：点显示"; width:180 height:16

        button btn_xslx "显示类型" pos:[20,350] width:64 height:24

        spinner spn_xslx "" pos:[90,355] width:64 height:24 range:[0,2,0] type:#integer scale:1

        on btn_xslx pressed do

                for a in geometry where classof a == VRayProxy do a.display = spn_xslx.value
					
		button btn_xzdl "选择代理" pos:[160,350] width:64 height:24
        on btn_xzdl pressed do(
                                select (for e in geometry where classof e ==VRayProxy or classof e ==  VR_代理 collect e))
)
hyperLink xw_bolg "【黑马设计网】出品" address:"http://www.3dheima.com/"   pos:[95,390] color:(color 255 68 0) hoverColor:(color 0 0 255) visitedColor:(color 0 0 255)

)createdialog G12 width:240