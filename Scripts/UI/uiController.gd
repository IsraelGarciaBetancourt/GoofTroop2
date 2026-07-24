extends Control

@onready var dataNode := get_tree().get_first_node_in_group("DataController")
@onready var lbCoin: Label = $CerezaCounter/Panel/Sprite2D/Label
@onready var animationCorazon: AnimationPlayer = $UIGoofy/UICorazones/UICorazonesAnimationPlayer
@onready var lbVidas: Label = $UIGoofy/LabelVidas

func _ready() -> void:
	if dataNode == null:
		push_error("No encontré /root/Main_Stage/DataController (¿se destruyó Main_Stage?)")
		return

	if not dataNode.dataChange.is_connected(updateData):
		dataNode.dataChange.connect(updateData)

	updateData()

func updateData() -> void:
	handleStats()
	handleCorazones()
	handleVidas()

func handleStats() -> void:
	# si coins está tipado en DataController, esto ya no será Variant
	lbCoin.text = str(dataNode.coins)

func handleCorazones() -> void:
	var coins: int = int(dataNode.coins) # fuerza int (evita Variant)
	var v: int = clamp(coins, 0, 6)
	var anim_name: String = str(v) + "_corazones"

	if animationCorazon.has_animation(anim_name):
		animationCorazon.play(anim_name)

func handleVidas() -> void:
	# si coins está tipado en DataController, esto ya no será Variant
	lbVidas.text = str(dataNode.vida)
