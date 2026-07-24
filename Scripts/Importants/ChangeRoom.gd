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
	
	# Buscar el nodo raíz de la habitación actual (ancestro en el grupo "Room")
	var room_actual: Node = self
	while room_actual != null and not room_actual.is_in_group("Room"):
		room_actual = room_actual.get_parent()
		
	if room_actual:
		Signals.change_room_with_fade(room_actual, room_destino)
	else:
		push_error("No encontré el Room actual (grupo 'Room') al intentar cambiar de sala.")
