/datum/nano_module
	var/name
	var/datum/host
	var/available_to_ai = TRUE
	var/datum/topic_manager/topic_manager
	var/list/using_access = list()

/datum/nano_module/New(var/datum/host, var/topic_manager)
	..()
	src.host = host
	src.topic_manager = topic_manager

/datum/nano_module/Destroy()
	host = null
	QDEL_NULL(topic_manager)
	. = ..()

/datum/nano_module/nano_host()
	RETURN_TYPE(/datum)
	return host ? host.nano_host() : src

/datum/nano_module/proc/can_still_topic(var/datum/nano_topic_state/state = GLOB.default_state)
	return CanUseTopic(usr, state) == STATUS_INTERACTIVE

/datum/nano_module/proc/check_eye(var/mob/user)
	return -1

//returns a list.
/datum/nano_module/proc/get_access(mob/user)
	. = using_access
	if(istype(user))
		. |= user.GetAccess()

/datum/nano_module/proc/check_access(var/mob/user, var/access)
	if(!access)
		return 1
	if(!islist(access))
		access = list(access) //listify a single access code.
	if(has_access(access, list(), using_access))
		return 1 //This is faster, and often enough.
	return has_access(access, list(), get_access(user)) //Also checks the mob's ID.

/datum/nano_module/nano_ui_data(mob/user)
	return host.initial_data()

/datum/nano_module/Topic(href, href_list)
	if(topic_manager && topic_manager.Topic(href, href_list))
		return TRUE
	. = ..()

/datum/nano_module/proc/get_host_z()
	var/atom/host = nano_host()
	return istype(host) ? get_z(host) : 0

/datum/nano_module/proc/print_text(var/text, var/mob/user)
	var/obj/item/modular_computer/MC = nano_host()
	if(istype(MC))
		if(!MC.printer)
			to_chat(user, "Error: No printer detected. Unable to print document.")
			return

		if(!MC.printer.print_text(text))
			to_chat(user, "Error: Printer was unable to print the document. It may be out of paper.")
	else
		to_chat(user, "Error: Unable to detect compatible printer interface. Are you running NTOSv2 compatible system?")

/datum/proc/initial_data()
	var/list/data = list()
	return data

/datum/proc/update_layout()
	return FALSE

//Allows computer programs to play sounds from the console
/datum/nano_module/proc/playsound_host(soundin, vol as num, vary, extrarange as num, falloff, var/is_global, var/use_pressure = TRUE)
	if (!host)
		return

	var/turf/T = get_turf(host)
	playsound(T, soundin, vol, vary, extrarange, falloff, is_global,use_pressure)
