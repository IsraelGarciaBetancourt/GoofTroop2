extends CharacterBody2D
class_name PirateAI

@export var patrol_speed: float = 120.0
@export var chase_speed: float = 160.0
@export var patrol_direction: Vector2 = Vector2.RIGHT
@export var detection_range: float = 220.0

var is_stunned: bool = false
var stun_timer: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var player_node: Node2D = null

func _ready() -> void:
	add_to_group("Enemy")
	player_node = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	if is_stunned:
		stun_timer -= delta
		if stun_timer <= 0.0:
			is_stunned = false
			modulate = Color.WHITE
		velocity = Vector2.ZERO
		move_and_slide()
		return
		
	var dir = patrol_direction
	if is_instance_valid(player_node):
		var dist = global_position.distance_to(player_node.global_position)
		if dist < detection_range:
			dir = (player_node.global_position - global_position).normalized()
			velocity = dir * chase_speed
		else:
			velocity = dir * patrol_speed
	else:
		velocity = dir * patrol_speed
		
	var collided = move_and_slide()
	if collided and velocity.length() > 0:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var normal = collision.get_normal()
			if normal.dot(patrol_direction) < -0.8:
				patrol_direction = -patrol_direction
				break
				
	_update_animations(dir)
	_check_player_contact()

func _update_animations(dir: Vector2) -> void:
	if is_stunned:
		anim_player.play("PirataAzul_Stop")
		return
		
	if velocity.length() == 0:
		anim_player.play("PirataAzul_Stop")
	else:
		if abs(dir.x) > abs(dir.y):
			anim_player.play("PirataAzul_Walking_Right")
			sprite.flip_h = dir.x < 0
		else:
			if dir.y < 0:
				anim_player.play("PirataAzul_Walking_Up")
			else:
				anim_player.play("PirataAzul_Walking_Down")

func stun(duration: float) -> void:
	is_stunned = true
	stun_timer = duration
	modulate = Color(0.5, 0.7, 1.0, 1.0) # Tono azulado

func defeat() -> void:
	var tween = create_tween()
	tween.tween_property(self, "rotation", 3.14 * 2.0, 0.4)
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, 0.4)
	await tween.finished
	queue_free()

func _check_player_contact() -> void:
	if is_instance_valid(player_node):
		var dist = global_position.distance_to(player_node.global_position)
		if dist < 45.0:
			var dataNode = get_tree().get_first_node_in_group("DataController")
			if dataNode and dataNode.has_method("take_damage"):
				dataNode.take_damage()
				var push_dir = (player_node.global_position - global_position).normalized()
				if "velocity" in player_node:
					player_node.velocity = push_dir * 300.0
