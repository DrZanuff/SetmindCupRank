extends MarginContainer


func _on_ImageRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	if body.size() > 1:
		var image = Image.new()
		var image_error = image.load_jpg_from_buffer(body)
		
		if !image_error:
			var texture = ImageTexture.new()
			texture.create_from_image(image)
			# Assign to the child TextureRect node
			$PC/VB/HB/Image/i.texture = texture
