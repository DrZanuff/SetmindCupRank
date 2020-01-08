extends Camera2D

var type = "idle"
var target = 0 #Target Y
onready var end = get_parent().get_node("End")
onready var pos = get_parent().get_node("Pos")
onready var ranking =  get_parent().get_node("Ranking")
var acc = 0
var margin_pos = -150
var margin_end = -300

func _physics_process(delta):
	if type == "scroll_down":
		global_position.y = lerp(global_position.y,target,acc)
		acc = lerp(acc+(0.001*delta),0.01,0.001)
		if global_position.y > target-10:
			scroll_up()

	if type == "scroll_up":
		global_position.y = lerp(global_position.y,target,acc)
		acc = lerp(acc+(0.001*delta),0.01,0.001)
		if global_position.y < target+10:
			scroll_down()
		
	if type == "idle":
		global_position.y = lerp(global_position.y,target,0.01)
	
	if type == "focus":
		global_position.y = lerp(global_position.y,target,0.07)

func _input(event):
	if event.is_action_pressed("scroll_down"):
		if target < 0:
			target = 0
		target = clamp(target+216,pos.global_position.y-75,  end.global_position.y-400) 
		get_parent().get_node("TimerPos").stop()
		scroll_idle()
		
	if event.is_action_pressed("scroll_up"):
		if target > 0:
			target = 0
		target = clamp(target-216,pos.global_position.y-75, end.global_position.y-400) 
		get_parent().get_node("TimerPos").stop()
		scroll_idle()
		

func scroll_idle():
#	acc = 0
	type = "idle"
	yield(get_tree().create_timer(5) ,"timeout")
	scroll_up()
	get_parent().get_node("TimerPos").start(20)

func scroll_target(id):
	target = (pos.global_position.y + (id * 72) ) - 144
	type = "focus"
	yield(get_tree().create_timer(5) ,"timeout")
	scroll_down()

func scroll_down():
	acc = 0
	yield(get_tree().create_timer(2) ,"timeout")
	ranking =  get_parent().get_node("Ranking")
	target = end.global_position.y-400
	type = "scroll_down"

func scroll_up():
	acc = 0
	yield(get_tree().create_timer(2) ,"timeout")
	ranking =  get_parent().get_node("Ranking")
	target = pos.global_position.y-75
	type = "scroll_up"