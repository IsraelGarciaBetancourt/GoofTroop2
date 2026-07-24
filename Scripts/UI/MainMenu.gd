extends Control

@onready var title_label: Label = $CenterContainer/VBoxContainer/TitleLabel
@onready var start_button: Button = $CenterContainer/VBoxContainer/MenuOptions/StartButton
@onready var exit_button: Button = $CenterContainer/VBoxContainer/MenuOptions/ExitButton

var time := 0.0

func _ready() -> void:
	start_button.grab_focus()
	
	# Efecto de fade in inicial del menú
	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)

func _process(delta: float) -> void:
	# Efecto de flotación sutil para el título
	time += delta
	title_label.position.y += sin(time * 2.5) * 0.15

func _on_start_button_pressed() -> void:
	start_button.disabled = true
	exit_button.disabled = true
	
	# Transición de fundido al escenario principal
	Signals.change_room_with_fade(self, "uid://d38aqrgaehprj")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
