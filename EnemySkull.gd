extends CharacterBody2D;
class_name EnemySkull;

const SPEED = 150;

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity");
var player;
var chase = false;
var onDeath = false;

var can_flip = true

@onready var skull = get_node("AnimatedSprite2DSkull");

func _physics_process(delta):
	# colocar um movimento padrão para left e right
	# print(onDeath)
	if chase && !onDeath:
		skull.play("flying");
		player = $"../../Player/Monk";
		# print_debug(player)
		var direction = (player.position - self.position).normalized();
		
		if direction.x > 0: # if player is to the right
			skull.flip_h = true;
		
			if direction.y > 0: # if player is below
				velocity.y += 20 * delta;
				
				if (self.position.y > player.position.y - 30 && self.position.y < player.position.y + 30):
					velocity.y = 0;
				# print("down right");
				
		
			elif direction.y < 0: # if player is above
				velocity.y -= 20 * delta;
				# print("up right");
		
		else: # if player is to the left
			skull.flip_h = false;
		
			if direction.y > 0: # if player is below
				velocity.y += 20 * delta;
				if (self.position.y > player.position.y - 30 && self.position.y < player.position.y + 30):
					velocity.y = 0;
				# print("down left");
		
			elif direction.y < 0: # if player is above
				velocity.y -= 20 * delta;
				# print("up left");
		
		velocity.x = direction.x * SPEED;
		
	else:
		# permanece andando para o último lado quando estava perseguindo o player
		if !onDeath:
			skull.flip_h = true;
			skull.play("flying");
			velocity.x = SPEED;
			velocity.y = 0; 

	if is_on_wall():
		velocity.x *= -1
		skull.flip_h = !skull.flip_h;
		print('EnemySkull.gd - linha 62-65, me arruma enzo')


	move_and_slide();


func _on_player_detection_body_entered(body:Node2D):
	if body.name == "Monk":
		chase = true;


func _on_player_detection_body_exited(body:Node2D):
	if body.name == "Monk":
		chase = false;


func enemy_death():
	stopEnemy();
	$AnimatedSprite2DSkull.visible = false;
	$AnimatedSprite2DDeath.visible = true;
	get_node("AnimatedSprite2DDeath").play("death");
	await get_node("AnimatedSprite2DDeath").animation_finished;
	self.queue_free();


func stopEnemy():
	onDeath = true;
	velocity.y = 0;
	velocity.x = 0;
