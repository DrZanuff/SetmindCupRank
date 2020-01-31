extends Node2D

export (bool)var debug = false
var window_x = 1280

var scrolling = false
var scroll_target = 0
onready var wait = $TimerScrollX.wait_time
onready var holder = $Holder as HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	$DebugCam.current = debug
	if debug:
#		debug_populate(19)
		pass
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if debug:
		debug_move(delta)
	
	if scrolling:
		scroll_x(delta)
	
	if Input.is_action_just_pressed("ui_right") and !scrolling:
		start_scroll()

func scroll_x(delta):
	holder.rect_global_position.x = lerp(holder.rect_global_position.x ,
	scroll_target , 0.05)
	
	#Snaps position
	if (abs(scroll_target) - abs(holder.rect_global_position.x) < 1) or \
	(Input.is_action_just_pressed("ui_right")):
		holder.rect_global_position.x = scroll_target
		reoder()
		$TimerScrollX.paused = false
		scrolling = false
		
		
func reoder():
	for i in range(4):
		var obj = holder.get_child(0)
		holder.remove_child( holder.get_child(0) )
		holder.add_child(obj)
	holder.rect_global_position.x = 0
	pass

func debug_move(delta):
	if debug:
		var debug_speed = 800
		if Input.is_action_pressed("debug_right"):
			$DebugCam.global_position.x += delta * debug_speed

		if Input.is_action_pressed("debug_left"):
			$DebugCam.global_position.x -= delta * debug_speed


func debug_populate(x):
	if debug:
		#Populate with garbage template
#		var obj = load("res://Debug/BoxExample.tscn")
		var obj = load("res://Awards/Board/Board.tscn")
		for i in range(x):
			var new_obj = obj.instance()
			holder.add_child(new_obj)
			new_obj.update_data(get_node("data").array,i) ######################Colocar i aqui
#			new_obj.text = str("Object ", holder.get_child_count() )
#			new_obj.get_node("Body/Title").text = str("Object ", holder.get_child_count() )


func _on_TimerScrollX_timeout():
	start_scroll()

func start_scroll():
	$TimerScrollX.wait_time = wait
	scroll_target = holder.rect_global_position.x - window_x
	scrolling = true
	$TimerScrollX.paused = true
