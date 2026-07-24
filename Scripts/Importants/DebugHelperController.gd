extends Node

func _ready():
	pass

# Obtener dinámicamente la etiqueta bajo el Room activo
func _get_debug_label(label_name: String) -> Label:
	var room := get_tree().get_first_node_in_group("Room")
	if room == null:
		return null
	return room.get_node_or_null("DebugLabels/" + label_name) as Label

func debugInfoMessageLabel(infoMessage):
	var infoMessageLabel = _get_debug_label("infoMessage_label")
	if infoMessageLabel:
		infoMessageLabel.text = str(infoMessage)

func debugPrevDirectionLabel(prevDirection):
	var prevDirectionLabel = _get_debug_label("prev_direction_label")
	if prevDirectionLabel:
		prevDirectionLabel.text = "prev_direction: " + str(prevDirection)

func debugPrevOrthogonalDirectionLabel(prev_orthogonal_direction):
	var prevOrthogonalDirectionLabel = _get_debug_label("prev_orthogonal_direction_label")
	if prevOrthogonalDirectionLabel:
		prevOrthogonalDirectionLabel.text = "prev_orthogonal_direction: " + str(prev_orthogonal_direction)

func debugMovementDirectionLabel(movementDirection):
	var movementDirectionLabel = _get_debug_label("movement_direction_label")
	if movementDirectionLabel:
		movementDirectionLabel.text = "movement_direction: " + str(movementDirection)

func debugHandsUpLabel(handsUp):
	var handsUpLabel = _get_debug_label("handsUp_label")
	if handsUpLabel:
		handsUpLabel.text = "handsUp: " + str(handsUp)

func debugKickingLabel(kicking):
	var kickingLabel = _get_debug_label("kicking_label")
	if kickingLabel:
		kickingLabel.text = "kicking: " + str(kicking)
