class_name AttackSystem
extends Node
#I don't exactly know how the table in our files should fit, but this is so far the damage calculation
static func calculate_damage(attacker: Character, defender: Character, is_special: bool = false) -> int:
	var base_damage: float
	var defense: float
	
	if is_special:
		base_damage = attacker.special_attack
		defense = defender.special_defence
	else:
		base_damage = attacker.attack
		defense = defender.defence
	
	var damage = base_damage - (defense * 0.5)
	damage = damage * randf_range(0.85, 1.0)
	
	return max(1, int(damage))

static func execute_attack(attacker: Character, defender: Character, is_special: bool = false):
	var damage = calculate_damage(attacker, defender, is_special)
	defender.take_damage(damage)
	#print("%s attacks %s for %d damage!" % [attacker.name, defender.name, damage])
	
	return damage

static func execute_attack_with_skill(attacker: Character, defender: Character, skill: Skill):
	var base_damage = float(skill.damage) + (attacker.attack * 0.5)
	var defense = defender.defence * 0.5
	var damage = (base_damage - defense) * randf_range(0.85, 1.0)
	damage = max(1, int(damage))
	
	defender.take_damage(damage)
	#print("%s uses %s on %s for %d damage!" % [attacker.name, skill.skill_name, defender.name, damage])
	return damage
