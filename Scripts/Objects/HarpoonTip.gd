extends Area2D

func _draw() -> void:
	# Dibujar una punta de arpón metálica triangular retro
	var points := PackedVector2Array([
		Vector2(0, -12),   # Punta
		Vector2(10, 4),    # Aleta derecha
		Vector2(4, 2),     # Interior
		Vector2(4, 10),    # Base derecha
		Vector2(-4, 10),   # Base izquierda
		Vector2(-4, 2),    # Interior izquierda
		Vector2(-10, 4)    # Aleta izquierda
	])
	draw_polygon(points, [Color.DARK_GRAY, Color.LIGHT_GRAY, Color.LIGHT_GRAY, Color.GRAY, Color.GRAY, Color.DARK_GRAY, Color.DARK_GRAY])
