extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

signal player_died

const SPEED = 100.0

var directions = -1.0


func _ready() -> void:
	animated_sprite_2d.play()


func _process(delta: float) -> void:
	# Alien bergerak kiri dan kanan
	position.x += directions * SPEED * delta


# =========================
# ALIEN BERBALIK ARAH
# =========================
func _on_timer_timeout() -> void:
	directions *= -1

	animated_sprite_2d.flip_h = not animated_sprite_2d.flip_h


# =========================
# PLAYER MENYENTUH ALIEN
# =========================
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and body.alive:
		print("Player menyentuh Alien")

		# Kirim signal ke Main
		player_died.emit(body)
