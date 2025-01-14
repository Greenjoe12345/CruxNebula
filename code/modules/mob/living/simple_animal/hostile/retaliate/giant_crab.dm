/mob/living/simple_animal/hostile/retaliate/giant_crab
	name = "giant crab"
	desc = "A gigantic crustacean with a blue shell. Its left claw is nearly twice the size of its right."
	icon = 'icons/mob/simple_animal/bluecrab.dmi'
	mob_size = MOB_SIZE_LARGE
	speak_emote = list("clicks")
	emote_hear = list("clicks")
	emote_see = list("clacks")
	speak_chance = 1
	turns_per_move = 5
	meat_amount = 12
	can_escape = TRUE //snip snip
	break_stuff_probability = 15
	faction = "crabs"
	pry_time = 2 SECONDS
	mob_default_max_health = 350
	natural_weapon = /obj/item/natural_weapon/pincers/giant
	return_damage_min = 2
	return_damage_max = 5
	harm_intent_damage = 1
	natural_armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL
		)
	ability_cooldown = 2 MINUTES
	ai = /datum/ai/giant_crab

	var/mob/living/carbon/human/victim //the human we're grabbing
	var/grab_duration = 3 //duration of disable in life ticks to simulate a grab
	var/grab_damage = 6 //brute damage before reductions, per crab's life tick
	var/list/grab_desc = list("thrashes", "squeezes", "crushes")
	var/continue_grab_prob = 35 //probability that a successful grab will be extended by one life tick

/datum/ai/giant_crab
	expected_type = /mob/living/simple_animal/hostile/retaliate/giant_crab

/datum/ai/giant_crab/do_process(time_elapsed)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/giant_crab/crab = body
	if((crab.current_health > crab.get_max_health() / 1.5) && length(crab.enemies) && prob(10))
		if(crab.victim)
			crab.release_grab()
		crab.enemies = list()
		crab.LoseTarget()
		crab.visible_message(SPAN_NOTICE("\The [crab] lowers its pincer."))

/obj/item/natural_weapon/pincers/giant
	force = 15
	attack_verb = list("snipped", "pinched", "crushed")

/mob/living/simple_animal/hostile/retaliate/giant_crab/Initialize() //embiggen
	. = ..()
	set_scale(1.5)

/mob/living/simple_animal/hostile/retaliate/giant_crab/Destroy()
	. = ..()
	victim = null

/mob/living/simple_animal/hostile/retaliate/giant_crab/default_hurt_interaction(mob/user)
	. = ..()
	if(. && ishuman(user))
		reflect_unarmed_damage(user, BRUTE, "armoured carapace")

/mob/living/simple_animal/hostile/retaliate/giant_crab/do_delayed_life_action()
	..()
	process_grab()

/mob/living/simple_animal/hostile/retaliate/giant_crab/AttackingTarget()
	. = ..()
	if(ishuman(.))
		var/mob/living/carbon/human/H = .
		if(victim == H)
			if(!Adjacent(victim))
				release_grab()
			else if(prob(continue_grab_prob))
				SET_STATUS_MAX(H, STAT_WEAK, 1)
				SET_STATUS_MAX(H, STAT_STUN, 1)
				grab_damage++
				visible_message(SPAN_MFAUNA("\The [src] tightens its grip on \the [victim]!"))
				return

		if(!victim && can_act() && !is_on_special_ability_cooldown() && Adjacent(H))
			events_repository.register(/decl/observ/destroyed, victim, src, PROC_REF(release_grab))
			victim = H
			SET_STATUS_MAX(H, STAT_WEAK, grab_duration)
			SET_STATUS_MAX(H, STAT_STUN, grab_duration)
			visible_message(SPAN_MFAUNA("\The [src] catches \the [victim] in its powerful pincer!"))
			stop_automation = TRUE

/mob/living/simple_animal/hostile/retaliate/giant_crab/proc/process_grab()
	if(victim && !incapacitated())
		if(victim.stat >= UNCONSCIOUS || !Adjacent(victim) || !victim.incapacitated())
			release_grab()
			return
		visible_message(SPAN_DANGER("\The [src] [pick(grab_desc)] \the [victim] in its pincer!"))
		victim.apply_damage(grab_damage, BRUTE, BP_CHEST, DAM_EDGE, used_weapon = "crab's pincer")

/mob/living/simple_animal/hostile/retaliate/giant_crab/proc/release_grab()
	if(victim)
		visible_message(SPAN_NOTICE("\The [src] releases its grip on \the [victim]!"))
		events_repository.unregister(/decl/observ/destroyed, victim)
		victim = null
	set_special_ability_cooldown(ability_cooldown)
	stop_automation = FALSE
	grab_damage = initial(grab_damage)