extends Node2D

@onready var phone_vibration: AudioStreamPlayer2D = get_node("/root/World/AudioManager/SFX/PhoneVibration")
@onready var phone_os: Control = get_node("/root/World/PhoneCanvas/Phone/PhoneOS")

signal notification

var rng = RandomNumberGenerator.new()
var probability: float = 0.01
var probability_increase: float = 0.0006

var are_notifications_cleared: bool = true


# ----- INIT -----

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	if !PlayerManager.is_player_focused_phone():
		handle_notifications()
	#if PlayerManager.is_player_focused_phone() and has_notification_arrived:
		#reset_notification()

# TODO reset notifications only when you read all of them


# ----- RANDOM NOTIFICATIONS -----

func handle_notifications() -> void:
	increase_probability()

	var random_number: float = rng.randf_range(0.0, 100.0)
	if random_number <= probability:
		phone_vibration.play()
		probability = 0.001
		are_notifications_cleared = false
		emit_signal("notification")

func increase_probability() -> void:
	probability += probability_increase
	# print("Probability increased by: ", probability_increase)

func reset_notification() -> void:
	#has_notification_arrived = false
	print("Notification::Reset::Relive")
