extends AudioStreamPlayer

export (Array,AudioStreamOGGVorbis)var audios : Array

func _ready():
	randomize()
	audios.shuffle()
	stream = audios[0]

#func _physics_process(delta):
#	if Input.is_action_just_pressed("ui_select"):
#		play_audio()

func play_audio():
	audios.push_back(audios[0])
	audios.pop_front()
	stream = audios[0]
	play(0)
	print(stream)
