extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -250.0
const ORB_VELOCITY = -375.0

const ACCELERATION = 800
const FRICTION = 700

const ROTATION_WEIGHT = 4.0

@onready var sprite = $Sprite
@onready var jumpSfx = $JumpSfx
@onready var orbSfx = $OrbSfx
@onready var token_sfx = $TokenSfx


@onready var coyote_time = $CoyoteTime
@onready var orb_time = $OrbTime
@onready var camera = $Camera

var tokens = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = 0.0


func apply_gravity(delta) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_jump() -> void:
	if Input.is_action_pressed("jump"):
		if is_on_floor() or coyote_time.time_left > 0.0:
			velocity.y = JUMP_VELOCITY
			coyote_time.stop()
			orb_time.stop()
			
			jumpSfx.play()
		elif orb_time.time_left > 0.0:
			velocity.y = ORB_VELOCITY
			orb_time.stop()
			coyote_time.stop()
			
			orbSfx.play()

func handle_horizontal_movement(delta : float) -> void:
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

func update_animations(delta: float) -> void:
	sprite.rotation = lerp(sprite.rotation, direction / 4, ROTATION_WEIGHT * delta)
	if direction != 0:
		sprite.play("Run")
	else:
		sprite.play("Idle")
	
	if not is_on_floor():
		sprite.play("Jump_Fall")

func handle_camera() -> void:
	camera.global_position.x = 160
	
func _process(delta : float) -> void:
	direction = Input.get_axis("left", "right")
	
	handle_camera()
	
	update_animations(delta)


func _physics_process(delta : float) -> void:
	var was_on_floor = is_on_floor()
	
	apply_gravity(delta)
	
	handle_horizontal_movement(delta)
	handle_jump()
	
	move_and_slide()
	var has_left_floor = was_on_floor and not is_on_floor() and velocity.y >= 0
	if has_left_floor:
		coyote_time.start()
