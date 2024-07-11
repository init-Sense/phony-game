extends Area2D

signal rage

@export var dialogue_resource: Resource = load("res://dialogues/asuka.dialogue")
@export var dialogue_start: String = "asuka_intro"

@onready var timer: Timer = $AsukaTimer
@onready var camera: Camera2D = $"../Player/Camera2D"
@onready var eyes_sprite: AnimatedSprite2D = $EyesSprite
@onready var player: CharacterBody2D = %Player


# ----- INITIALIZATION AND PHYSICS -----

func _ready() -> void:
	connect("rage", BrainManager._on_asuka_timer_timeout)
	eyes_sprite.frame = 0


# ----- INTERACTIONS -----

func _on_area_entered(_area: Area2D) -> void:
	if PlayerManager.is_player_free():
		enter_asuka()

#func _on_area_exited(_area: Area2D) -> void:
	#if !PlayerManager.is_player_free():
		#exit_asuka()

func enter_asuka() -> void:
	timer.stop()
	player.target_position = Vector2(global_position)
	player.focus_speed = player.focus_speed_asuka
	PlayerManager.set_player_focusing_in_asuka()
	camera.set_camera_zoom(camera.asuka_zoom_value, camera.asuka_zoom_speed)
	StoryManager.start_dialogue(StoryManager.asuka_dialogue, dialogue_resource, dialogue_start, self)
	get_eyes_attention()

func exit_asuka() -> void:
	timer.start()
	PlayerManager.set_player_focusing_out()
	camera.set_camera_zoom(camera.default_zoom_value, camera.reset_zoom_speed)
	get_eyes_attention()
	
	#if StoryManager.current_dialogue_area == self:
		#StoryManager.end_dialogue()


# ----- SIGNALS -----

func _on_asuka_timer_timeout() -> void:
	emit_signal("rage")


# ----- UTILS -----

func get_eyes_attention() -> void:
	await get_tree().create_timer(0.3).timeout
	if PlayerManager.is_player_focusing_in_asuka():
		eyes_sprite.frame = 1
	elif PlayerManager.is_player_focusing_out():
		eyes_sprite.frame = 0
