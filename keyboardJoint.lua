-- Credit to Daanando

consleSett ={"Joint Forward Cycle =","Joint Backward Cycle =","Hold/Relax =", "Contract/Extend =", "L-Hand Toggle Grip", "R-Hand Toggle Grip"}
consleSett2 ={"] ={1,\"Joint Forward Cycle\"} ","] ={2,\"Joint Backward Cycle\"} ","] ={3,\"Hold/Relax\"} ", "] ={4,\"Contract/Extend\"}","] ={5,\"L-Hand Toggle Grip\"}","] ={6,\"R-Hand Toggle Grip\"}"}

jointCycle={"Neck", "Chest", "Lumbar", "Abs", "Right Pec", "Right Shoulder", "Right Elbow", "Left Pec", "Left Shoulder",
                "Left Elbow", "Right Wrist", "Left Wrist", "Right Glute", "Left Glute", "Right Hip", "Left Hip", "Right Knee", "Left Knee", "Right Ankle", "Left Ankle"}

stateCycle={[1]={"Extending", "Contracting", "Holding", "Relaxing"},
			[2]={"Contracting", "Extending", "Holding", "Relaxing"},
			[3]={"Lowering", "Raising", "Holding", "Relaxing"},
			[4]={"Right Rotate/Bend", "Left Rotate/Bend", "Holding", "Relaxing"}}

currentJoint=0
holdlax=3
extcon=1
gripStateL=1
gripStateR=1




txt=io.open("keyJointControl.txt","r")
if(txt==nil)then 
	txt=io.open("keyJointControl.txt","w")
	txt:write("keyControl ={")
	echo("Keybind Configure")
	echo(consleSett[1])
	setkeys =6
else
	setkeys=0
	txt:close()
	echo("Keybind Configure Found")
end

dofile("keyJointControl.txt")



local function keychecks(key) -- downkey
	
	if setkeys>0 then
		txt:write("[" .. key .. consleSett2[7-setkeys].."," )
		setkeys = setkeys - 1
		if setkeys == 0 then txt:write( "}"); txt:close() ; run_cmd("clear"); echo("Keybind Configure Done");setkeys = 0 ; dofile("keyJointControl.txt") else echo(consleSett[7-setkeys]) end
		-- return 1
	else
		remove_hook("key_down", "keychecks")
	end
end

local function handlekeys(key)
	playerSelected= get_world_state().selected_player
	if keyControl[key][1]==1 then
		currentJoint = currentJoint+1
		if currentJoint==20 then currentJoint=0 end
		jointInfo=get_joint_info(playerSelected, currentJoint)
	elseif keyControl[key][1]==2 then
		currentJoint = currentJoint-1
		if currentJoint==-1 then currentJoint=19 end
		jointInfo=get_joint_info(playerSelected, currentJoint)
	elseif keyControl[key][1]==3 then
		set_joint_state(playerSelected, currentJoint, holdlax)
		holdlax = holdlax+1
		if holdlax==5 then holdlax=3 end
		set_ghost(2)
		jointInfo=get_joint_info(playerSelected, currentJoint)
	elseif keyControl[key][1]==4 then
		set_joint_state(playerSelected,currentJoint, extcon)
		extcon=extcon+1
		if extcon==3 then extcon=1 end
		set_ghost(2)
		jointInfo=get_joint_info(playerSelected, currentJoint)
	elseif keyControl[key][1]==5 then
		set_grip_info(playerSelected,12,gripStateL)
		gripStateL=gripStateL+1
		if gripStateL==2 then gripStateL=0 end
	elseif keyControl[key][1]==6 then
		set_grip_info(playerSelected,11,gripStateR)
		gripStateR=gripStateR+1
		if gripStateR==2 then gripStateR=0 end
	end

end

local function displayJoint()
	if (currentJoint>=12 and currentJoint<=15) or currentJoint==3 or currentJoint>=18 then stateChoose=2
	elseif  currentJoint==5 or currentJoint==8 then stateChoose=3
	elseif currentJoint==1 or currentJoint==2 then stateChoose=4
	else stateChoose=1
	end
	set_color(0, 0, 0, 1)
	draw_text("Selected Joint: "..jointCycle[currentJoint+1], 15, 192, 1)
	draw_text("Joint State: "..stateCycle[stateChoose][jointInfo.state], 15, 217, 1)
end

add_hook("key_down","keychecks", keychecks)
add_hook("key_up","handlekeys",handlekeys)
add_hook("draw2d", "", displayJoint)


