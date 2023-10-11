extends CharacterBody2D

enum {
	IDLE,
	RUNNING,
	JUMPING,
	FALLING,
	WALLSLIDING
}

const SPEED = 2000.0
const JUMP_VELOCITY = -350.0
const WALL_JUMP_VELOCITY = 500
const MAX_WALLSLIDE_SPEED = 100
const FRICTION = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var state = IDLE


	
func _ready():
	var apples = get_node("/root/Variables").apples_left
	var label = get_node("Apple/Label") as Label
	label.text = str(apples)

func _physics_process(delta):
	
	if state == IDLE or state == RUNNING:
		if Input.is_action_just_pressed("jump"):
			velocity.y += JUMP_VELOCITY
		if not is_on_floor():
			if sign(velocity.y) == 1:
				state = FALLING
			else:
				state = JUMPING
	
	if state in [WALLSLIDING, JUMPING, FALLING]:
		velocity.y += gravity * delta
		if is_on_wall():
			state = WALLSLIDING
		
	if state in [RUNNING, JUMPING, FALLING]:
		var dir = Input.get_axis("run_left", "run_right")
		if dir:
			velocity.x += dir * SPEED * delta
			$AnimatedSprite2D.flip_h = sign(dir) == -1
	
	if state == IDLE:
		$AnimatedSprite2D.play("idle")
		if Input.get_axis("run_left", "run_right"):
			state = RUNNING
	elif state == RUNNING:
		$AnimatedSprite2D.play("run")
		if not Input.get_axis("run_left", "run_right"):
			state = IDLE
	elif state == JUMPING:
		$AnimatedSprite2D.play("jump")
		if sign(velocity.y) == 1:
			state = FALLING
	elif state == FALLING:
		$AnimatedSprite2D.play("fall")
		if is_on_floor():
			state = IDLE
	elif state == WALLSLIDING:
		$AnimatedSprite2D.play("wall_slide")
		if not is_on_wall():
			state = FALLING
		$AnimatedSprite2D.flip_h = get_wall_normal().x == 1
		velocity.y = clamp(velocity.y, -MAX_WALLSLIDE_SPEED, MAX_WALLSLIDE_SPEED)
		if Input.is_action_just_pressed("jump"):
			state = JUMPING
			velocity = Vector2(WALL_JUMP_VELOCITY * get_wall_normal().x, JUMP_VELOCITY)
	
	velocity.x *= 1 - (delta * FRICTION)
	move_and_slide()


func die():
	get_tree().reload_current_scene()
	var player_vars = get_node("/root/Variables")
	player_vars.apples_left = 9


func _on_apple_body_entered(body):
	print("Apple Aquired!")
	var label = get_node("Apple/Label") as Label
	var i = int(label.text)
	i -= 1
	if(i <= 0):
		var a = get_node("WinText") as RichTextLabel
		var b = get_node("WinText2") as RichTextLabel
		a.visible = true
		b.visible = true
	label.text = str(i)
