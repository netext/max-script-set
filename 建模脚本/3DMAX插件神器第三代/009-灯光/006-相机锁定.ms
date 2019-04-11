rollout unnamedRollout "锁定解锁" width:160 height:88
(
	button btn1 "锁定" pos:[8,8] width:144 height:32
	button btn2 "解锁" pos:[8,48] width:144 height:32
	on btn1 pressed  do
		SetTransformLockFlags selection #All
	on btn2 pressed  do
		SetTransformLockFlags selection #None
)
createDialog unnamedRollout