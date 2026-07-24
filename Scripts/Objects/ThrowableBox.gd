extends CharacterBody2D
class_name ThrowableBox

enum State { GROUND, CARRIED, THROWN }
var current_state: State = State.GROUND

@export var throw_speed: float = 750.0
var throw_direction: Vector2 = Vector2.ZERO

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var grab_area: Area2D = $GrabArea

var carrier_node: Node2D = null

func _physics_process(delta: float) -> void:
	match current_state:
		State.CARRIED:
			# Seguir la cabeza del jugador de forma suave o rígida
			if is_instance_valid(carrier_node):
				global_position = carrier_node.global_position + Vector2(0, -75)
		State.THROWN:
			var collision = move_and_collide(throw_direction * throw_speed * delta)
			if collision:
				_on_impact(collision.get_collider())

func pick_up(carrier: Node2D) -> void:
	if current_state != State.GROUND:
		return
	
	current_state = State.CARRIED
	carrier_node = carrier
	
	# Deshabilitar colisiones físicas para evitar trabar al jugador
	collision_shape.set_deferred("disabled", true)
	grab_area.set_deferred("monitoring", false)
	grab_area.set_deferred("monitorable", false)
	
	# Opcional: Desactivar sombras o cambiar escala visual si fuera necesario

func throw(direction: Vector2) -> void:
	if current_state != State.CARRIED:
		return
	
	current_state = State.THROWN
	carrier_node = null
	throw_direction = direction
	
	# Rehabilitar colisiones
	collision_shape.set_deferred("disabled", false)
	
	# Esperar un frame físico para que no colisione inmediatamente con el jugador que lo lanzó
	await get_tree().physics_frame
	
	# Si la dirección es cero, por defecto tirar hacia abajo
	if throw_direction == Vector2.ZERO:
		throw_direction = Vector2.DOWN

func _on_impact(collider: Node) -> void:
	# Si golpea a un enemigo
	if collider.is_in_group("Enemy") or collider.has_method("defeat") or collider.name.begins_with("Pirata"):
		if collider.has_method("defeat"):
			collider.defeat()
		else:
			collider.queue_free() # Derrota instantánea
	
	# Animación de ruptura / Efecto
	_break_box()

func _break_box() -> void:
	# Aquí se puede spawnear un efecto visual de astillas y reproducir un sonido
	# Por ahora, simplemente eliminamos el nodo limpiamente.
	queue_free()
