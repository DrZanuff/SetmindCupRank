extends MarginContainer


func _on_ImageRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var image = Image.new()
	var image_error = image.load_jpg_from_buffer(body)
	if image_error != OK:
		print("An error occurred while trying to display the image.")
		
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	# Assign to the child TextureRect node
	$PC/VB/Image/i.texture = texture
