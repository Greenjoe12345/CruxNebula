// Used for creating the exchange areas.
/area/turbolift
	name = "\improper Turbolift"
	base_turf = /turf/simulated/open
	requires_power = FALSE
	sound_env = SMALL_ENCLOSED
	holomap_color = HOLOMAP_AREACOLOR_LIFTS

	var/lift_floor_label = null
	var/lift_floor_name = null
	var/lift_announce_str = "Ding!"
	var/arrival_sound = 'sound/machines/ding.ogg'
	var/delay_time
