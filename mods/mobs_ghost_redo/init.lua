--[[
    Mobs Ghost Redo - Adds ghosts.
    Copyright (C) 2018  Hamlet

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]


--
-- General variables
--

local ghost_daytime_check = minetest.settings:get_bool("ghost_daytime_check")
local minetest_log_level = minetest.settings:get("debug_log_level")

if (ghost_daytime_check == nil) then
	ghost_daytime_check = false
end


--
-- Functions
--

local function day_or_night()
	local daytime = false
	local time = minetest.get_timeofday() * 24000

	if (time >= 4700) and (time <= 19250) then
		daytime = true

	else
		daytime = false

	end

	return daytime
end

local function random_mesh()
	local mesh = ""
	local number = math.random(1, 2)

	if (number == 1) then
		mesh = "mobs_ghost_redo_ghost_1.b3d"

	elseif (number == 2) then
		mesh = "mobs_ghost_redo_ghost_2.b3d"
	end

	return mesh
end


--
-- Entity definition
--

mobs:register_mob("mobs_ghost_redo:ghost", {
	type = "monster",
	hp_min = 20,
	hp_max = 30,
	armor = 100,
	walk_velocity = 1,
	run_velocity = 4,
	walk_chance = 25,
	fly = true,
	view_range = 15,
	reach = 4,
	damage = 4,
	water_damage = 0,
	lava_damage = 0,
	light_damage = 2,
	suffocation = false,
	attack_animals = true,
	group_attack = true,
	attack_type = "dogfight",
	blood_amount = 0,
	immune_to = {
		{"all"},
		{"default:sword_steel", 6},
		{"default:sword_bronze", 6},
		{"default:sword_mese", 7},
		{"mobs_others:sword_obsidian", 7},
		{"default:sword_diamond", 8},
		{"moreores:sword_silver", 12},
		{"moreores:sword_mithril", 9}
	},
	makes_footstep_sound = false,
	sounds = {
		random = "mobs_ghost_redo_ghost_1",
		war_cry = "mobs_ghost_redo_ghost_2",
		attack = "mobs_ghost_redo_ghost_2",
		damage = "mobs_ghost_redo_ghost_hit",
		death = "mobs_ghost_redo_ghost_death",
	},
	visual = "mesh",
	visual_size = {x = 1, y = 1},
	collisionbox = {-0.25, 0, -0.3, 0.25, 1.3, 0.3},
	textures = {"mobs_ghost_redo_ghost.png"},
	mesh = "",
	animation = {
		stand_start = 0,
		stand_end = 80,
		stand_speed = 15,
      walk_start = 102,
      walk_end = 122,
      walk_speed = 12,
      run_start = 102,
      run_end = 122,
      run_speed = 10,
      fly_start = 102,
      fly_end = 122,
      fly_speed = 12,
      punch_start = 102,
      punch_end = 122,
      punch_speed = 25,
      die_start = 81,
      die_end = 101,
      die_speed = 28,
      die_loop = false,
	},

	on_spawn = function(self, pos)
		self.spawned = true
		self.mesh = random_mesh()
		self.counter = 0
		self.object:set_properties({
			spawned = self.spawned,
			mesh = self.mesh,
			counter = self.counter,
			physical = false,
			collide_with_objects = false
		})
		return true
	end,

	do_custom = function(self, dtime)
		if (ghost_daytime_check == true) then

			if (self.light_damage ~= 0) then
				self.light_damage = 0

				self.object:set_properties({
					light_damage = self.light_damage
				})
			end

			if (self.spawned == true) then
				local daytime = day_or_night()

				if (daytime == true) then
					self.object:remove()

				else
					self.spawned = false
					self.object:set_properties({
						spawned = self.spawned
					})

				end

			else
				if (self.counter < 15.0) then
					self.counter = self.counter + dtime

					self.object:set_properties({
						counter = self.counter
					})

				else
					local daytime = day_or_night()

					if (daytime == true) then
						self.object:remove()

					else
						self.counter = 0

						self.object:set_properties({
							counter = self.counter
						})

					end
				end
			end
		else
			if (self.light_damage ~= 2) then
				self.light_damage = 2

				self.object:set_properties({
					light_damage = self.light_damage
				})
			end
		end
	end
})


--
-- Ghost's spawn
--

mobs:spawn({name = "mobs_ghost_redo:ghost",
	nodes = {"bones:bones", "mobs_humans:human_bones"},
	neighbors = {"air"},
	max_light = 4,
	min_light = 0,
	interval = 60,
	chance = 7,
	active_object_count = 1,
	min_height = -30912,
	max_height = 31000,
	day_toggle = false
})


--
-- Ghost's egg
--

mobs:register_egg("mobs_ghost_redo:ghost", "Fantasma",
	"mobs_ghost_redo_egg_ghost.png", 0, false)


--
-- Alias
--

mobs:alias_mob("mobs:ghost", "mobs_ghost_redo:ghost")


--
-- Minetest engine debug logging
--

if (minetest_log_level == nil)
or (minetest_log_level == "action")
or	(minetest_log_level == "info")
or (minetest_log_level == "verbose")
then
	minetest.log("action", "[Mod] Mobs Ghost Redo [v0.5.1] loaded.")
end
