extends Area2D

@export_file("*.tscn") var room_destino: String
var cambiando := false

func _on_body_entered(body: Node) -> void:
	if cambiando:
		return
	if not body.is_in_group("Player"):
		return
	if room_destino.is_empty():
		push_error("Room destino NO asignado")
		return

	cambiando = true
	set_deferred("monitoring", false) # evita warning en Godot 4.5
	call_deferred("_cambiar_room")

func _cambiar_room() -> void:
	var room_actual := get_tree().get_first_node_in_group("Room")
	if room_actual == null:
		push_error("No encontré el Room actual (grupo 'Room'). Pon el grupo en el root del stage.")
		return

	var main_stage := room_actual.get_parent()
	if main_stage == null:
		push_error("El Room actual no tiene parent")
		return

	var packed := load(room_destino) as PackedScene
	if packed == null:
		push_error("No se pudo cargar la escena: " + room_destino)
		return

	var nuevo_room := packed.instantiate()
	main_stage.add_child(nuevo_room)
	room_actual.queue_free()
