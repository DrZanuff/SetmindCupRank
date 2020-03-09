extends Node

var url = "https://script.google.com/a/setmind.com.br/macros/s/AKfycbw-9gqMJa_y_g2l4YXhzNFW_oEYiWvlSv5WX2qv/exec"

func _ready():
	$HTTPRequest.request(url)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):

#	PoolByteArray().get_string_from_utf8()
	var response = body.get_string_from_utf8()
	var json = JSON.parse(response).result
	
	if json[1] != null:
		for i in json[1]:
			var img = Image.new()
			var pool = PoolByteArray(i[0])
			img.load_png_from_buffer( pool )
			
			var texture = ImageTexture.new()
			texture.create_from_image(img)
			
			var tr = TextureRect.new()
			tr.expand = true
			tr.stretch_mode = 6
			tr.size_flags_horizontal = 3
			tr.size_flags_vertical = 3
			tr.rect_min_size = Vector2(64,64)
			
			$ScrollContainer/VBoxContainer.add_child( tr )
			
			tr.texture = texture
			tr.name = str(i[1]).replace(".png","")
		
		if get_parent().has_method("debug_populate"):
			get_parent().get_node("data").array = json[0]
			if get_parent().debug:
				#Pegando o numero de colunas da primeira linha
				#Que representa as Categorias dos destaques
				get_parent().debug_populate( json[0][0].size() )
				get_parent().get_node("TimerScrollX").start(10)

