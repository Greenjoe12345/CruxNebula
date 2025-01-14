/mob/living/simple_animal/hostile/retaliate/parrot/space
	name = "space parrot"
	desc = "It could be some all-knowing being that, for reasons we could never hope to understand, is assuming the shape and general mannerisms of a parrot - or just a rather large bird."
	gender = FEMALE
	mob_default_max_health = 750
	mob_size = MOB_SIZE_LARGE
	speak = list("...")
	speak_emote = list("professes","speaks unto you","elaborates","proclaims")
	emote_hear = list("sings a song to herself", "preens herself")
	natural_weapon = /obj/item/natural_weapon/giant
	min_gas = null
	max_gas = null
	minbodytemp = 0
	universal_understand = TRUE
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	see_in_dark = 7
	can_escape = TRUE
	relax_chance = 60 //a gentle beast
	impatience = 10
	parrot_isize = ITEM_SIZE_LARGE
	simple_parrot = TRUE
	ability_cooldown = 2 MINUTES

	meat_amount = 10
	bone_amount = 20
	skin_amount = 20

	var/list/subspecies = list(/decl/parrot_subspecies,
								/decl/parrot_subspecies/purple,
								/decl/parrot_subspecies/blue,
								/decl/parrot_subspecies/green,
								/decl/parrot_subspecies/red,
								/decl/parrot_subspecies/brown,
								/decl/parrot_subspecies/black)
	var/get_subspecies_name = TRUE

/mob/living/simple_animal/hostile/retaliate/parrot/space/Initialize()
	. = ..()
	var/subspecies_type = SAFEPICK(subspecies)
	if(subspecies_type)
		var/decl/parrot_subspecies/ps = GET_DECL(subspecies_type)
		icon_set = ps.icon_set
		skin_material = ps.feathers
		if(get_subspecies_name)
			SetName(ps.name)
	set_scale(2)
	update_icon()

/mob/living/simple_animal/hostile/retaliate/parrot/space/AttackingTarget()
	. = ..()
	if(ishuman(.) && can_act() && !is_on_special_ability_cooldown() && Adjacent(.))
		var/mob/living/carbon/human/H = .
		if(prob(70))
			SET_STATUS_MAX(H, STAT_WEAK, rand(2,3))
			set_special_ability_cooldown(ability_cooldown / 1.5)
			visible_message(SPAN_MFAUNA("\The [src] flaps its wings mightily and bowls over \the [H] with a gust!"))

		else if(H.get_equipped_item(slot_head_str))
			var/obj/item/clothing/head/HAT = H.get_equipped_item(slot_head_str)
			if(H.canUnEquip(HAT))
				visible_message(SPAN_MFAUNA("\The [src] rips \the [H]'s [HAT] off!"))
				set_special_ability_cooldown(ability_cooldown)
				H.try_unequip(HAT, get_turf(src))

//subtypes
/mob/living/simple_animal/hostile/retaliate/parrot/space/lesser
	name = "Avatar of the Howling Dark"
	subspecies = list(/decl/parrot_subspecies/black)
	get_subspecies_name = FALSE
	natural_weapon = /obj/item/natural_weapon/large
	mob_default_max_health = 300

/mob/living/simple_animal/hostile/retaliate/parrot/space/megafauna
	name = "giant parrot"
	desc = "A huge parrot-like bird."
	get_subspecies_name = FALSE
	mob_default_max_health = 350
	speak_emote = list("squawks")
	emote_hear = list("preens itself")
	natural_weapon = /obj/item/natural_weapon/large
	relax_chance = 30
	impatience = 5