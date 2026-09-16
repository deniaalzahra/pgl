extends Node2D

@onready var score_label: Label = $HUD/ScorePanel/ScoreLabel
@onready var fade: ColorRect = $HUD/Fade

var level: int = 1
var score: int = 0
var current_level_root: Node = null

func _ready() -> void:
	# Setup connection Apple dan Alien
	fade.modulate.a = 1.0 
	current_level_root = get_node("LevelRoot")
	await _load_level(level, true)

	# Tampilkan score awal
	update_score()

# =========================
# LEVEL MANAGEMENT
# =========================
func _load_level(level_number: int, first_load: bool) -> void:
	#Fade Out
	if not first_load:
		await _fade(1.0)
	
	if current_level_root:
		current_level_root.queue_free()
		
	#change level
	var level_path = "res://scenes/levels/level%s.tscn" % level_number
	current_level_root = load(level_path).instantiate()
	
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	_setup_level(current_level_root)
	
	#Fade In
	await _fade(0.0)

# =========================
# SETUP LEVEL
# =========================
func _setup_level(level_root: Node) -> void:
	# =========================
	# EXIT
	# =========================
	var exit = level_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)

	# =========================
	# APPLES
	# =========================
	var apples = level_root.get_node_or_null("Apples")

	if apples:
		for apple in apples.get_children():

			if apple.has_signal("collected"):
				apple.collected.connect(increase_score)

	# =========================
	# ENEMIES / ALIEN
	# =========================
	var enemies = level_root.get_node_or_null("Enemies")

	if enemies:
		for enemy in enemies.get_children():

			if enemy.has_signal("player_died"):
				enemy.player_died.connect(_on_player_died)

# =========================
# PLAYER DIED
# =========================
func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		level += 1
		body.can_move = false
		await _load_level(level, false)

func _on_player_died(body: Node2D) -> void:

	if body.alive:
		body.die()

		print("Player Killed")

# =========================
# INCREASE SCORE
# =========================
func increase_score() -> void:

	score += 1

	update_score()


# =========================
# UPDATE SCORE LABEL
# =========================
func update_score() -> void:

	score_label.text = "SCORE: %s" % score

# =========================
# FADE
# =========================
func _fade(to_alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(fade, "modulate:a", to_alpha, 1.5)
	await tween.finished
