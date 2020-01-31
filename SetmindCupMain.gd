extends Node2D

onready var nodes = [$Ranking,$Videos,$News,$Lista,$News,$Videos,$Destaques]
var old_nodes_order = []
onready var lista_begin = [$Lista,$News,$Videos,$Destaques,$Ranking,$Videos,$News]
onready var award_begin = [$Destaques,$Ranking,$Videos,$News,$Lista,$News,$Videos]
var type_list = ""
var has_started = false

var link_timers = "https://script.google.com/macros/s/AKfycbxCtfW0kyg_BMAk9nOV_fvWn57TZc1rZE_FPgvkUht-XN93t0Q/exec"

func _ready():
	$HttpGetTimers.request(link_timers)
	$Ranking/ViewportContainer/Viewport/Ranking.connect("rank_ready",self,"start_scene")
	
	old_nodes_order = nodes.duplicate(true)
	start_timer()

func _input(event):
	if has_started:
		if event.is_action_pressed("view_rank"):
			has_started = false
			type_list = "rank"
			$AnimationPlayer.play("FadeSwitch")
	
		if event.is_action_pressed("view_awards"):
			has_started = false
			type_list = "awards"
			$AnimationPlayer.play("FadeSwitch")
		
		if event.is_action_pressed("view_awards_list"):
			has_started = false
			type_list = "list_awards"
			$AnimationPlayer.play("FadeSwitch")

func start_timer():
	var time = nodes[0].editor_description.split(":")[1]
	$Timer.start(int(time))

func _on_Timer_timeout():
	$AnimationPlayer.play("FadeCross")

func reset_nodes():
	nodes[0].layer = 0
	
	if nodes[0].name == "Videos":
		nodes[0].get_node("Videos/VideoPlayer").paused = true
	if nodes[0].name == "News":
		nodes[0].get_node("News/Timer").paused = true
		
	nodes = old_nodes_order.duplicate(true)
#	nodes = [$Ranking,$Videos,$News,$Lista,$News,$Videos,$Destaques]
	nodes[0].layer = 3
	
	if nodes[0].name == "Videos":
		nodes[0].get_node("Videos/VideoPlayer").paused = false
	if nodes[0].name == "News":
		nodes[0].get_node("News/Timer").paused = false
		
	start_timer()

func reorder_nodes(type):
	print("Vitor")
	nodes[0].layer = 0
	
	if nodes[0].name == "Videos":
		nodes[0].get_node("Videos/VideoPlayer").paused = true
	if nodes[0].name == "News":
		nodes[0].get_node("News/Timer").paused = true
	
	if type == "type":
		type = type_list
	
	if type == "reorder":
		nodes.push_back(nodes[0])
		nodes.pop_front()
		
	if type == "reset":
		nodes = old_nodes_order.duplicate(true)
	if type == "rank":
		nodes = old_nodes_order.duplicate(true)
	if type == "awards":
		nodes = award_begin.duplicate(true)
	if type == "list_awards":
		nodes = lista_begin.duplicate(true)

	
	print(type)

	nodes[0].layer = 3
	
	if nodes[0].name == "Videos":
		nodes[0].get_node("Videos/VideoPlayer").paused = false
	if nodes[0].name == "News":
		nodes[0].get_node("News/Timer").paused = false
	
	start_timer()

func start_scene():
	has_started = true


func _on_HttpGetTimers_request_completed(result, response_code, headers, body):
	var r = body as PoolByteArray
	var j = JSON.parse(r.get_string_from_utf8())
	var arr = j.result[0]
	print(arr)
	$News.editor_description = "Time:"+str(arr[0])
	$Destaques.editor_description = "Time:"+str(arr[1])
	$Videos.editor_description = "Time:"+str(arr[2])
	$Lista.editor_description = "Time:"+str(arr[3])
	$Ranking.editor_description = "Time:"+str(arr[4])
