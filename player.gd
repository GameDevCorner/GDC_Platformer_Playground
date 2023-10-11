extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	
func _ready():
	var apples = get_node("/root/Variables").apples_left
	var label = get_node("Apple/Label") as Label
	label.text = str(apples)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		#Play jump animation if rising, and fall animation if falling
		if sign(velocity.y) == -1:
			$AnimatedSprite2D.play("jump")
		else:
			$AnimatedSprite2D.play("fall")
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("run_left", "run_right")
	if direction:
		velocity.x = direction * SPEED
		
		if is_on_floor():
			$AnimatedSprite2D.flip_h = sign(direction) == -1
			$AnimatedSprite2D.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			$AnimatedSprite2D.play("idle")

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
