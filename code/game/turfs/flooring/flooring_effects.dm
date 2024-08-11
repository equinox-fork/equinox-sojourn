/obj/effect/damagedfloor
	layer = TURF_DECAL_LAYER
	icon = 'icons/turf/damage_overlays.dmi'
	icon_state = "damaged1"

/obj/effect/damagedfloor
	icon_state = "scorched1"

/obj/effect/damagedfloor/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/damagedfloor/LateInitialize(mapload)
	var/turf/simulated/floor/F = loc
	if(istype(F))
		F.break_tile(1)
	qdel(src)

/obj/effect/damagedfloor/fire/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/damagedfloor/fire/LateInitialize(mapload)
	var/turf/simulated/floor/F = loc
	if(istype(F))
		F.burn_tile()
	qdel(src)

/obj/effect/damagedfloor/rust
	icon_state = "rust"

/obj/effect/damagedfloor/rust/Initialize()
	icon_state = "rust[rand(1,9)]"
	..()
