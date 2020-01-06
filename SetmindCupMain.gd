extends Node2D

onready var nodes = [$Ranking,$Videos,$Lista]

func _ready():
	start_timer()

func start_timer():
	var time = nodes[0].editor_description.split(":")[1]
	$Timer.start(int(time))

func _on_Timer_timeout():
	$AnimationPlayer.play("FadeCross")

func reorder_nodes():
	nodes[0].layer = 0
	nodes.push_back(nodes[0])
	nodes.pop_front()
	nodes[0].layer = 3
	start_timer()
#	printt(
#	nodes[0].name+":"+str(nodes[0].layer),
#	nodes[1].name+":"+str(nodes[1].layer),
#	nodes[2].name+":"+str(nodes[2].layer)
#	)
