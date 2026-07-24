extends Node

@warning_ignore("unused_signal")
signal special_event_triggered(dialogue_id: String, line_id: int)

var cached_scenes := {}

func _ready() -> void:
	# Pre-cargar las escenas en la caché al iniciar el juego
	# para que todas las transiciones sean instantáneas desde la primera vez.
	get_packed_scene("uid://c8l3fwfb4yrxv") # Stage 1
	get_packed_scene("uid://dms7x67ne4fpl") # Stage 2

func get_packed_scene(room_path: String) -> PackedScene:
	if cached_scenes.has(room_path):
		return cached_scenes[room_path]
			
	# Cargar de forma síncrona y guardar en caché
	var packed = load(room_path) as PackedScene
	if packed:
		cached_scenes[room_path] = packed
	return packed

func change_room_with_fade(room_actual: Node, room_destino: String) -> void:
	# Desactivar movimiento del jugador actual
	var jugador = get_tree().get_first_node_in_group("Player")
	if jugador:
		if jugador.has_method("set_physics_process"):
			jugador.set_physics_process(false)
		if "canMove" in jugador:
			jugador.canMove = false
		if "velocity" in jugador:
			jugador.velocity = Vector2.ZERO

	# Crear CanvasLayer para la transición
	var canvas := CanvasLayer.new()
	canvas.layer = 100
	var color_rect := ColorRect.new()
	color_rect.color = Color.BLACK
	color_rect.color.a = 0.0
	color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(color_rect)
	add_child(canvas)
	
	# Animar fundido a negro
	var tween := create_tween()
	tween.tween_property(color_rect, "color:a", 1.0, 0.25)
	await tween.finished
	
	# Cambiar escenario usando la caché
	var main_stage := room_actual.get_parent()
	if main_stage:
		var packed := get_packed_scene(room_destino)
		if packed:
			var nuevo_room := packed.instantiate()
			main_stage.add_child(nuevo_room)
			room_actual.queue_free()
	
	# Esperar a que se instancie todo y buscar nuevo jugador
	await get_tree().process_frame
	var nuevo_jugador = get_tree().get_first_node_in_group("Player")
	if nuevo_jugador:
		if nuevo_jugador.has_method("set_physics_process"):
			nuevo_jugador.set_physics_process(false)
		if "canMove" in nuevo_jugador:
			nuevo_jugador.canMove = false

	await get_tree().create_timer(0.1).timeout
	
	# Animar fundido a transparente
	var tween_in := create_tween()
	tween_in.tween_property(color_rect, "color:a", 0.0, 0.25)
	await tween_in.finished
	
	# Reactivar movimiento
	if nuevo_jugador:
		if nuevo_jugador.has_method("set_physics_process"):
			nuevo_jugador.set_physics_process(true)
		if "canMove" in nuevo_jugador:
			nuevo_jugador.canMove = true
			
	canvas.queue_free()
