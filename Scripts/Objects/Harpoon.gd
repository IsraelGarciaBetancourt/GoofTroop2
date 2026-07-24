extends Node2D
class_name Harpoon

enum State { EXTENDING, RETRACTING, PULLING_PLAYER }
var current_state: State = State.EXTENDING

@export var launch_speed: float = 700.0
@export var pull_speed: float = 650.0
@export var max_distance: float = 350.0

var launcher: CharacterBody2D = null
var direction: Vector2 = Vector2.ZERO
var distance_traveled: float = 0.0

@onready var chain_line: Line2D = $ChainLine
@onready var tip_area: Area2D = $TipArea

var grabbed_item: Node2D = null

func launch(player_node: CharacterBody2D, launch_dir: Vector2) -> void:
	launcher = player_node
	direction = launch_dir
	global_position = player_node.global_position
	
	# Rotar la punta según la dirección
	tip_area.rotation = direction.angle() + PI / 2.0
	
	# Desactivar movimiento del jugador
	if launcher:
		launcher.canMove = false
		if "velocity" in launcher:
			launcher.velocity = Vector2.ZERO
			
	# Inicializar la línea de la cadena
	chain_line.clear_points()
	chain_line.add_point(Vector2.ZERO) # Posición local del jugador
	chain_line.add_point(tip_area.position) # Posición local de la punta

func _physics_process(delta: float) -> void:
	if not is_instance_valid(launcher):
		queue_free()
		return
		
	# Actualizar línea de cadena (comienza en jugador y termina en la punta)
	chain_line.clear_points()
	chain_line.add_point(to_local(launcher.global_position))
	chain_line.add_point(tip_area.position)

	match current_state:
		State.EXTENDING:
			var step = direction * launch_speed * delta
			tip_area.position += step
			distance_traveled += step.length()
			
			if distance_traveled >= max_distance:
				current_state = State.RETRACTING
				
		State.RETRACTING:
			var target_local = to_local(launcher.global_position)
			var to_player = target_local - tip_area.position
			
			if to_player.length() < 20.0:
				_retraction_complete()
				return
				
			var step = to_player.normalized() * launch_speed * delta
			# Asegurar no pasarse del jugador
			if step.length() > to_player.length():
				tip_area.position = target_local
			else:
				tip_area.position += step
				
			# Si tenemos un ítem atrapado, traerlo con la punta
			if is_instance_valid(grabbed_item):
				grabbed_item.global_position = tip_area.global_position
				
		State.PULLING_PLAYER:
			# El arpón está clavado en una pared, arrastramos al jugador hacia la punta
			var to_tip = tip_area.global_position - launcher.global_position
			
			if to_tip.length() < 40.0:
				_pull_complete()
				return
				
			launcher.velocity = to_tip.normalized() * pull_speed
			launcher.move_and_slide()

func _on_tip_area_body_entered(body: Node2D) -> void:
	if body == launcher:
		return
		
	if current_state == State.EXTENDING:
		# Si golpea una pared (TileMap o StaticBody en layer 1)
		if body is TileMap or body is StaticBody2D or body.collision_layer & 1:
			current_state = State.PULLING_PLAYER
			
		# Si golpea un enemigo
		elif body.is_in_group("Enemy") or body.has_method("stun"):
			if body.has_method("stun"):
				body.stun(3.0)
			current_state = State.RETRACTING

func _on_tip_area_area_entered(area: Area2D) -> void:
	if current_state == State.EXTENDING:
		# Si golpea un ítem recolectable
		if area is RecolectableItem:
			grabbed_item = area
			# Desactivar colisiones del ítem mientras viaja
			area.set_deferred("monitoring", false)
			area.set_deferred("monitorable", false)
			current_state = State.RETRACTING

func _retraction_complete() -> void:
	# Devolver el control al jugador
	if launcher:
		launcher.canMove = true
		
	# Si trajimos un ítem, reactivar su detección para que se recolecte al tocar al jugador
	if is_instance_valid(grabbed_item):
		grabbed_item.set_deferred("monitoring", true)
		grabbed_item.set_deferred("monitorable", true)
		# Forzar recolección posicionándolo exactamente sobre el jugador
		grabbed_item.global_position = launcher.global_position
		
	queue_free()

func _pull_complete() -> void:
	if launcher:
		launcher.canMove = true
		if "velocity" in launcher:
			launcher.velocity = Vector2.ZERO
	queue_free()
