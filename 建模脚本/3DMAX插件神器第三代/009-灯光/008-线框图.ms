-- -- -- -- About
-- Updated 05/06/2010
-- Created by John Martini
-- www.JokerMartini.com
-- JokerMartini@hotmail.com
-- -- -- -- Installation
-- Place Folder in the Scripts folder found in the 3ds Max directory.
-- ex. C:\Program Files\Autodesk\3ds Max #\Scripts\JokerMartini
-- -- -- -- Use
-- In 3ds Max go to the Customize tab and assign a keyboard shortcut or make the script a button in the toolbar.

-- -- -- -- Wireframe
-- 	macroScript msWireframe
-- 	category:"JokerMartini" 
-- 	tooltip:"Wireframe-v2"
-- 	Icon:#("JokerMartini",28) silentErrors:hideErrors

(
--// Main UI Dialog
	try (destroyDialog ::roWireframe)catch()
	rollout roWireframe "Wireframe"
	(
		
		/* Functions
		--------------------------------------------------*/
		/*Vray Active Render Check*/
			-- To see if V-Ray is INSTALLED on the system, you can call
			-- isVRayInstalled() returns TRUE if V-Ray is among the available renderer classes, false otherwise.*/
		fn isVRayInstalled = ((for o in rendererClass.classes where matchPattern (o as string) pattern:"*V_RAY*" collect o).count > 0)
			--If you want to know whether the CURRENT renderer is V-Ray, you can do something similar:
		fn isVRayCurrent = (matchPattern (renderers.current as string) pattern:"*V_RAY*")
			--You can also check against the ClassID.
		fn isVRayCurrent2 = (renderers.current.classid as string == "#(1941615238, 2012806412)")
		
		/* Locals
		--------------------------------------------------*/
		local BKGDColor
		local ObjectsColor
		local WiresColor
		local WireSizeValue

		groupbox gpColors width:125 height:94 pos:[7,3]
		label lbWires "Wires:" across:2 pos:[25,22]
		colorPicker cpWires width:49 height:20 color:[255,255,255] pos:[55,19]
		label lbObjects "Objects:" pos:[16,45]
		colorPicker cpObjects width:49 height:20 color:[0,0,0] pos:[55,42]
		label lbBKGD  "Bkgd:" pos:[26,67]
		colorPicker cpBackground width:49 height:20 color:[0,0,0] pos:[55,65]
		button btnSwitchWireObj ")" height:20 width:15 pos:[107,31]
		button btnSwitchObjBkgnd ")" height:20 width:15 pos:[107,54]
		groupbox gpWireParameters width:125 height:45 pos:[7,90]
		spinner spnWireSize "Wire Size: " width:90 range:[0,100,1] type:#float pos:[30,108]
		groupbox gpRenderer width:125 height:48 pos:[7,128]
		label lbRenderer "Renderer:" pos:[19,140]
		radiobuttons rbRenderType "" columns:1 labels:#("Vray","MRay") pos:[75,140]
		button btnRender "Render" width:125 height:24 pos:[7,178]



--//Functions
		fn fnWireFrame =
		(
			holdMaxFile() -- Temp hold file
				
			--//Universal Prep Settings
			backgroundColor = BKGDColor
			useEnvironmentMap = false
			lights.enabled = false
			delete lights
			re = maxOps.GetCurRenderElementMgr()
			re.SetElementsActive false
			
			--// Turns off Exposure Control 
			exposureControl=SceneExposureControl.exposureControl
			SceneExposureControl.exposureControl=()
			
			case rbRenderType.state of (
				1: (--//Vray Specific settings
						if (isVRayInstalled()) then
						(
							--//Vray Edges Texture creation
							wireMat = VRayLightMtl color:ObjectsColor
							wireMat.name = "Wireframe"
							wireMat.multiplier = 1
							--renderers.current.filter_kernel = --(VRayLanczosFilter:())
							wireMat.texmap = VRayEdgesTex edgesColor:WiresColor pixelWidth: WireSizeValue
							--//Render setup
							theRenderer = renderers.current = VRay()
							renderers.current.adaptiveSubdivision_minRate = 1
							renderers.current.adaptiveSubdivision_maxRate = 4
							theRenderer.options_overrideMtl_on = true
							renderers.current.filter_on = true
							theRenderer.options_overrideMtl_mtl = wireMat
							)else(
							return "Vray Renderer is not Installed"
						)
					)
				2: (--//Mental Ray specific settings
						
						-- //Material creation Settings for Wireframe Color and Wire Size
						wireMat = compositeMaterial baseMaterial:(standardMaterial diffuse:ObjectsColor selfIllumAmount:100)
						wireMat.name = "Wireframe"
						wireMat.materialList[2] = standardMaterial diffuse:WiresColor selfIllumAmount:100 wire:on wireSize:WireSizeValue
						--Render setup
						theRenderer = renderers.current = mental_ray_renderer()
						theRenderer.MinimumSamples = 0
						theRenderer.MaximumSamples = 2
						theRenderer.filter = 3
						theRenderer.FinalGatherEnable2 = false
						theRenderer.Enable_Material_Override = true
						-- // Create Wireframe Material and Place in Material Override
						theRenderer.Override_Material = wireMat 
					)
			)
			max quick render
			fetchMaxFile quiet:true
		)



--//Switch Actions
		on btnSwitchWireObj pressed do
		(
			swap cpwires.color cpObjects.color
		)
		on btnSwitchObjBkgnd pressed do
		(
			swap cpBackground.color cpObjects.color
		)

--// The Button Actions
		on btnRender pressed do
		(
			BKGDColor = cpBackground.color
			ObjectsColor = cpObjects.color
			WiresColor = cpWires.color
			WireSizeValue = spnWireSize.value
			fnWireFrame()
		)
		
	)
	try(destroyDialog roWireframe )catch()
	createDialog roWireframe 140 211 style:#(#style_SysMenu, #style_ToolWindow)	
)