extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

const SPEED = 300.0
const JUMP_VELOCITY = -850.0
var alive = true

var can_move = true

func _physics_process(delta: float) -> void:
	# Kalau Player sudah mati, hentikan kontrol
	if not alive:
		return

	# =========================
	# ANIMATION
	# =========================
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "running"
	else:
		animated_sprite_2d.animation = "idle"


	# =========================
	# GRAVITY
	# =========================
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite_2d.animation = "jumping"

	if can_move:

		# =========================
		# JUMP
		# =========================
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_sound.play()


		# =========================
		# MOVEMENT
		# =========================
		var direction := Input.get_axis("left", "right")

		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)


		# =========================
		# MOVE PLAYER
		# =========================
		move_and_slide()


		# =========================
		# FLIP PLAYER
		# =========================
		if direction == 1.0:
			animated_sprite_2d.flip_h = false

		if direction == -1.0:
			animated_sprite_2d.flip_h = true


# =========================
# PLAYER DEATH
# =========================
func die() -> void:
	if not alive:
		return

	alive = false

	# Hentikan pergerakan
	velocity = Vector2.ZERO

	# Suara kematian
	death_sound.play()

	# Animasi kematian
	animated_sprite_2d.animation = "dying"
	animated_sprite_2d.play()

	print("Player mati")
