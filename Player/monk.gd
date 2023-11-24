extends CharacterBody2D

class_name Monk

signal healthChanged;

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation = get_node("AnimatedSprite2D")
var action = false;
var blocked = false;

@export var maxHealth = 3;
@onready var currentHealth = maxHealth;

@export var gameover = false;


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# HANDLE JUMP
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation.play("jump")
		action = true;
		await animation.animation_finished;
		action = false;
	
	# HANDLE PRONE
	if Input.is_action_just_pressed("ctrl"):
		animation.play("crouch")
		action = true;
		await animation.animation_finished;
		action = false

	var direction = Input.get_axis("ui_left", "ui_right") 

	if direction == -1:
		animation.scale.x = -1.705;
	elif direction == 1:
		animation.scale.x = 1.705;
		

	if direction:
		if !blocked:
			velocity.x = direction * SPEED;
		else:
			velocity.x = 0;

		# HANDLE WALK
		if velocity.y == 0 and !action:
			animation.play("walk")

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		# HANDLE IDLE
		if velocity.y == 0 and !action:
			animation.play("idle")

	# HANDLE FALL
	if velocity.y > 0 and !action:
		animation.play("fall");
	
	# HANDLE ATTACK
	if Input.is_action_just_pressed("left_click"):
		if is_on_floor():
			$AnimatedSprite2D/PunchHit/PunchHitBox.disabled = false;
			animation.play("punch");
			blocked = true;
		elif Input.is_action_pressed("char_s"):
			$AnimatedSprite2D/KickHit/KickHitBox.disabled = false;
			animation.play("kick");
		else:
			$AnimatedSprite2D/PunchHit/PunchHitBox.disabled = false;
			animation.play("flyingKick");
		action = true;
		await animation.animation_finished;
		action = false;
		blocked = false;
		animation.play("jump")
	else:
		$AnimatedSprite2D/KickHit/KickHitBox.disabled = true;		
		$AnimatedSprite2D/PunchHit/PunchHitBox.disabled = true;
	
	move_and_slide();


func increaseVel(v):
	velocity.y = v;


func _on_punch_hit_body_entered(body:Node2D):
	if body is EnemySkull:
		body.enemy_death();
		increaseVel(-650);
	
	if body is Soul:
		increaseVel(-650);


func decreasecurrentHealth():
	currentHealth -= 1;
		

func _on_player_hit_box_body_entered(_body:EnemySkull):
	decreasecurrentHealth();
	if currentHealth == 0:
		gameover = true;
		
	healthChanged.emit(currentHealth);

