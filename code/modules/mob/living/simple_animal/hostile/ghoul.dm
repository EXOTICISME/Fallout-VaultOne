/mob/living/simple_animal/hostile/ferralghoul
	name = "Feral Ghoul"
	desc = "A lone flesh eating ghoul that has lost its mind."
	icon = 'icons/mob/human.dmi'
	icon_state = "feralghoul"
	icon_living = "feralghoul"
	icon_dead = "zombie_dead"
	turns_per_move = 5
	speak_emote = list("growls")
	emote_see = list("growls")
	a_intent = "harm"
	maxHealth = 300
	health = 300
	speed = 1.4
	harm_intent_damage = 8
	melee_damage_lower = 20
	melee_damage_upper = 20
	attacktext = "claws"
	attack_sound = 'sound/hallucinations/growl1.ogg'
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 350
	unsuitable_atmos_damage = 10
	environment_smash = 1
	robust_searching = 1
	stat_attack = 2
	gold_core_spawnable = 1
	faction = list("zombie")
	var/mob/living/carbon/human/stored_corpse = null
	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/zombie = 3)
	see_invisible = SEE_INVISIBLE_MINIMUM
	see_in_dark = 8
	layer = MOB_LAYER - 0.1



/mob/living/simple_animal/hostile/ferralghoul/AttackingTarget()
	..()
	if(istype(target, /mob/living))
		var/mob/living/L = target
		if(ishuman(L) && L.stat==DEAD)
			var/mob/living/carbon/human/H = L
			view(H) << "<span class='userdanger'>[src] feasts on [L] healing them."
			src.revive()
			src.LoseTarget()
			visible_message("<span class='danger'>[src] tears [L] to pieces!</span>")
			L.gib()
			return
		else if (L.stat==DEAD) //So they don't get stuck hitting a corpse
			src << "<span class='userdanger'>You feast on [L], restoring your health!</span>"
			src.revive()
			src.LoseTarget()
			visible_message("<span class='danger'>[src] tears [L] to pieces!</span>")
			L.gib()
			return
	if(src.health <= 200)
		if(prob(50))
			view(src) << "<span class='userdanger'>[src] lets out a large screech...this dosn't bode well.."
			playsound(loc, 'sound/ghoulscreech.wav', 50, 1, -1)
			for(var/mob/living/simple_animal/hostile/ferralghoul/F in range(50,src))
				if(F != src)
					if(F.stat != DEAD)
						walk_towards(F,src,3,3)

/*/mob/living/simple_animal/hostile/ferralghoul/death()
	..()
	if(stored_corpse)
		stored_corpse.loc = loc
		if(ckey)
			stored_corpse.ckey = src.ckey
			stored_corpse << "<span class='userdanger'>You're down, but not quite out. You'll be back on your feet within a minute or two.</span>"
			var/mob/living/simple_animal/hostile/zombie/holder/D = new/mob/living/simple_animal/hostile/zombie/holder(stored_corpse)
			D.faction = src.faction
		qdel(src)
		return
	src << "<span class='userdanger'>You're down, but not quite out. You'll be back on your feet within a minute or two.</span>"
	spawn(rand(800,1200))
		if(src)
			visible_message("<span class='danger'>[src] staggers to their feet!</span>")
			src.revive()

/mob/living/simple_animal/hostile/ferralghoul/proc/Zombify(mob/living/carbon/human/H)
	H.set_species(/datum/species/ferralghoul)
	if(H.head) //So people can see they're a zombie
		var/obj/item/clothing/helmet = H.head
		if(!H.unEquip(helmet))
			qdel(helmet)
	if(H.wear_mask)
		var/obj/item/clothing/mask = H.wear_mask
		if(!H.unEquip(mask))
			qdel(mask)
	var/mob/living/simple_animal/hostile/ferralghoul/Z = new /mob/living/simple_animal/hostile/zombie(H.loc)
	Z.faction = src.faction
	Z.appearance = H.appearance
	Z.transform = matrix()
	Z.pixel_y = 0
	for(var/mob/dead/observer/ghost in player_list)
		if(H.real_name == ghost.real_name)
			ghost.reenter_corpse()
			break
	Z.ckey = H.ckey
	H.stat = DEAD
	H.butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/mutant/zombie = 3) //So now you can carve them up when you kill them. Maybe not a good idea for the human versions.
	H.loc = Z
	Z.stored_corpse = H
	for(var/mob/living/simple_animal/hostile/ferralghoul/holder/D in H) //Dont want to revive them twice
		qdel(D)
	visible_message("<span class='danger'>[Z] staggers to their feet!</span>")
	Z << "<span class='userdanger'>You are now a zombie! Follow your creators lead!</span>"*/


/mob/living/simple_animal/hostile/spawner/ferralghoul
	name = "corpse pit"
	desc = "A pit full of zombies."
	icon_state = "tombstone"
	icon_living = "tombstone"
	icon = 'icons/mob/nest.dmi'
	health = 400
	maxHealth = 400
	list/spawned_mobs = list()
	max_mobs = 40
	spawn_time = 100
	mob_type = /mob/living/simple_animal/hostile/ferralghoul
	spawn_text = "emerges from"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	faction = list("zombie")


/mob/living/simple_animal/hostile/spawner/ferralghoul/lesser
	name = "lesser corpse pit"
	desc = "A pit full of less zombies."
	max_mobs = 10
	spawn_time = 150
	health = 200
	maxHealth = 200

/mob/living/simple_animal/hostile/spawner/ferralghoul/death()
	visible_message("<span class='danger'>[src] collapes, stopping the flow of zombies!</span>")
	qdel(src)


/mob/living/simple_animal/hostile/ferralghoul/holder
	name = "infection holder"
	icon_state = "none"
	icon_living = "none"
	icon_dead = "none"
	desc = "You shouldn't be seeing this."
	invisibility = 101
	unsuitable_atmos_damage = 0
	stat_attack = 2
	gold_core_spawnable = 0
	AIStatus = AI_OFF
	stop_automated_movement = 1
	density = 0

///mob/living/simple_animal/hostile/ferralghoul/holder/New()
	//..()
	//spawn(rand(800,1200))
		//if(src && istype(loc, /mob/living/carbon/human))
		//	var/mob/living/carbon/human/H = loc
			//Zombify(H)
		//qdel(src)
