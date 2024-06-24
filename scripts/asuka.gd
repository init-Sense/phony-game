extends Area2D

@onready var game_manager: Node2D = %GameManager
@onready var timer: Timer = $AsukaTimer
@onready var asuka_sprite: Sprite2D = $AsukaSprite
@onready var asuka_animation: AnimationPlayer = $AsukaSprite/AsukaAnimation
@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var player: CharacterBody2D = %Player
@onready var audio_manager: Node2D = $"../AudioManager"

var is_zooming_in: bool

@export var scale_up_speed: float = 0.2
@export var scale_down_speed: float = 1.0

func _ready() -> void:
	print("Asuka started")

func _on_area_entered(_area: Area2D) -> void:
	timer.start()
	is_zooming_in = true
	asuka_sprite.z_index = 2
	game_manager.brain_energy -= game_manager.multitasking_cost
	asuka_scale(scale_up_speed)
	camera.start_zoom(camera.asuka_zoom_value, camera.asuka_zoom_speed)

func _on_area_exited(_area: Area2D) -> void:
	timer.stop()
	is_zooming_in = false
	asuka_scale(scale_down_speed)
	camera.start_zoom(camera.default_zoom_value, camera.reset_zoom_speed)

func _on_asuka_animation_animation_finished(_anim_name: StringName) -> void:
	if is_zooming_in == false:
		asuka_sprite.z_index = 0

func asuka_scale(scale_speed) -> void:
	asuka_animation.speed_scale = scale_speed
	if is_zooming_in:
		asuka_animation.play("scale")
	else:
		asuka_animation.play_backwards("scale")
