ArenaLive.spellDB = {
			["Trinket"] = { 42292, 120 }, -- SpellID and cooldown of the PvP-Trinket
			["Racials"] = {
					-- First Number is the SpellID, 2nd one is the CD. Use 0 if they don't have a shared CD.
					["Human"] = { 59752, 120 },
					["Dwarf"] = { 20594, 120 },
					["NightElf"] = { 58984, 120 },
					["Gnome"] = { 20589, 90 },
					["Draenei"] = { -- For some reason, as a Draenei every class has it's own "Gift of the Naaru" spell. So we have to add them all into the table
						["WARRIOR"] =  { 28880, 180 },
						["PALADIN"] = { 59542, 180 },
						["HUNTER"] = { 59543, 180 },
						["PRIEST"] = { 59544, 180 },
						["DEATHKNIGHT"] = { 59545, 180 },
						["SHAMAN"] = { 59547, 180 },
						["MAGE"] = { 59548, 180 },
						["MONK"] = { 121093, 180 } -- Need to test this as soon as MoP is out.
					},
					["Worgen"] = { 68992, 120, 0 },
					["Orc"] = { -- Since Orcs also have class-specific racials, we need to add all of them
						["WARRIOR"] = { 20572, 120 },
						["HUNTER"] = { 20572, 120 },
						["ROGUE"] = { 20572, 120 },
						["SHAMAN"] = { 33697, 120 },
						["MAGE"] = { 33702, 120 },
						["WARLOCK"] = { 33702, 120 },
						["DEATHKNIGHT"] = { 20572, 120 },
						["MONK"] = { 33697, 120 } -- I guess Monks will get the same racial version as Shamans, since it increases AP+Spell Power. Test this as soon as MoP is out
					},
					["Scourge"] = { 7744, 120 },
					["Tauren"] = { 20549, 120 },
					["Troll"] = { 26297, 180 },
					["BloodElf"] = {
						["WARRIOR"] = { 69179, 120 },
						["PALADIN"] = { 28730, 120 },
						["HUNTER"] = { 80483, 120 },
						["ROGUE"] = { 25046, 120 },
						["PRIEST"] = { 28730, 120 },
						["MAGE"] = { 28730, 120 },
						["WARLOCK"] = { 28730, 120 },
						["DEATHKNIGHT"] = { 50613, 120 },
						["MONK"] = { 129597, 120 }
					},
					["Goblin"] = { 69070, 120 },
					["Pandaren"] = { 107079, 120 }
			},
			["CooldownResets"] = {
				[11958] = {				-- Mage: Cold Snap
					[120] = true,			-- Cone of Cold
					[122] = true,			-- Frost Nova
					[45438] = true,			-- Ice Block
				},
				[11129] = {				-- Mage: Combustion
					[108853] = true,
				},
				[14185] = {				-- Rogue: Preparation
					[2983] = true,
					[1856] = true,
					[5277] = true,
				},
				[108285] = {			-- Shaman: Call of the Elements
					[8143] = true,
					[5394] = true,
					[2484] = true,
					[108269] = true,
					[8177] = true,
					[108270] = true,
					[51485] = true,
					[108273] = true,
					[157153] = true,
				},
				[108503] = { -- Sacrifice basically resets CD for warlocks interrupt
					[132409] = true,		-- Spell lock (Warlock)
				},
			},			
			["CCIndicator"] = { -- This table is used to track those spells, that are shown in the cc indcator.
				-- The order is [spellID] = Priority-Type.

				-- Death Knight
				[48707] = "defCD",			-- Anti-Magic Shell
				[51271] = "offCD", 			-- Pillar of Frost
				[49016] = "offCD",			-- Unholy Frenzy
				[91800] = "stun",			-- Gnaw (Petstun)
				[91797] = "stun", 			-- Monstrous Blow (Petstun)
				[115001] = "stun",			-- Remorseless Winter (stun)
				[108194] = "stun",			-- Asphyxiate
				[47476] = "silence",		-- Strangulate
				[96294] = "root",			-- Chains of Ice (root)
				[91807] = "root", 			-- Pet Leap Root
				
				-- Druid
				[110617] = "defCD",			-- Deterrence (Symbiosis)
				[33786] = "defCD",			-- Cyclone (Made that one a def CD, because the enemy is immune to everything during cyclone)
				[22570] = "stun",			-- Maim
				[9005] = "stun",			-- Pounce (stun)
				[102546] = "stun",			-- Pounce (stun, maybe the nonferalversion or something)
				[5211] = "stun",			-- Mighty Bash
				[81261] = "silence",		-- Solar Beam
				[114238] = "silence",		-- Fae Silence (Glyph of Fae Silence)
				[99] = "crowdControl",		-- Incapacitating Roar
				[2637] = "crowdControl",	-- Hibernate
				[113056] = "crowdControl",	-- Intimidating Roar (cower)
				[113004] = "crowdControl",	-- Intimidating Roar (flee)
				[339] = "root",				-- Entangling roots
				[19975] = "root",			-- Entangling roots (Nature's Grasp)
				[16979] = "root",			-- Wild Charge (root)
				[102359] = "root",			-- Mass Entanglement

				-- Hunter
				[5384] = "defCD",			-- Feign Death
				[19263] = "defCD",			-- Deterrence
				[117526] = "stun",			-- Binding Shot
				[19577] = "stun",			-- Intimidation (stun)
				[3355] = "crowdControl",	-- Freezing Trap
				[19386] = "crowdControl",	-- Wyvern Sting
				[1513] = "crowdControl",	-- Scare Beast
				[53148] = "root",			-- Charge (Tenacity Pet)
				[64803] = "root",			-- Entrapment (trap-roots)
				[136634] = "root",			-- Narrow Escape
				[19503] = "crowdControl",	-- Scatter Shot
				[90337] = "stun",			-- Bad Manner (Monkey Pet)
				[126246] = "stun",			-- Lullaby (Crane Pet)
				[126423] = "stun",			-- Petrifying Gaze (Basilisk Pet)
				[126355] = "stun",			-- Paralyzing Quill (Porcupine Pet)
				[56626] = "stun",			-- Sting (Wasp Pet)
				[50519] = "stun",			-- Sonic Blast (Bat Pet)
				[96201] = "stun",			-- Web Wrap (Spider-Pet Stun)
				[50541] = "disarm",			-- Clench (Scorpid Pet)
				[91644] = "disarm",			-- Snatch (Bird of Prey Pet)
				[53148] = "root",			-- Charge (Tenacity Pet)
				[64803] = "root",			-- Entrapment (trap-roots)
				[136634] = "root",			-- Narrow Escape
				[50245] = "root";			-- Pin (Crab Pet)
				[90327] = "root",			-- Lock Jaw (Dog Pet)
				[4167] = "root",			-- Web (Spider Pet)
				[54706] = "root",			-- Venom Web Spray (Silithid Pet)
				[34490] = "silence",		-- Silencing Shot
				
				-- Mage
				[45438] = "defCD",			-- Ice Block
				[12472] = "offCD",			-- Icy Veins
				[102051] = "stun",			-- Frost Jaw
				[44572] = "stun",			-- Deep Freeze
				[118271] = "stun";			-- Combustion Impact
				[118] = "crowdControl",		-- Standard Polymorph
				[61305] = "crowdControl",	-- Polymorph Cat
				[28272] = "crowdControl",	-- Polymorph Pig
				[61721] = "crowdControl",	-- Polymorph Rabbit
				[61780] = "crowdControl",	-- Polymorph Turkey (woot?!)
				[28271] = "crowdControl",	-- Polymorph Turtle
				[82691] = "crowdControl",	-- Ring of Frost
				[31661] = "crowdControl",	-- Dragon's Breath
				[122] = "root",				-- Frost Nova
				[33395] = "root",			-- Freeze (Pet Nova)
				[111340] = "root",			-- Ice Ward Root
				[110909] = "usefulBuffs",	-- Alter Time

				-- Monk
				[122278] = "defCD",			-- Dampen Harm
				[122783] = "defCD",			-- Diffuse Magic
				[116849] = "defCD", 		-- Life Cocoon
				[116844] = "defCD", 		-- Ring of Peace
				[122470] = "defCD",			-- Touch of Karma
				[115176] = "defCD",			-- Zen Meditation
				[120086] = "stun",			-- Fists of Fury
				[119392] = "stun",			-- Charging Ox Wave
				[122242] = "stun",			-- Clash (stun)
				[126451] = "stun",			-- Clash (stun)
				[119381] = "stun",			-- Leg Sweep
				[116709] = "silence",		-- Spear Hand Strike
				[137460] = "silence",		-- Silence (Ring of Peace)
				[123407] = "crowdControl",	-- Glyph of Breath of Fire
				[117368] = "disarm",		-- Grapple Weapon
				[137461] = "disarm",		-- Disarm (Ring of Peace)
				[115078] = "crowdControl",	-- Paralysis
				[116706] = "root",			-- Disable (root)
				[123393] = "root",			-- Spinning Fire Blossom
				[137562] = "usefulBuffs",	-- Nimble Brew

				-- Paladin
				[31850] = "defCD",			-- Ardent Defender
				[642] = "defCD",			-- Divine Shield
				[1022] = "defCD",			-- Hand of Protection
				[31842] = "offCD",			-- Divine Favor
				[31884] = "offCD",			-- Avenging Wrath
				[105593] = "stun",			-- Fist of Justice
				[853] = "stun",				-- Hammer of Justice
				[119072] = "stun",			-- Holy Wrath
				[31935] = "silence",		-- Avenger's Shield
				[145067] = "crowdControl",	-- Turn Evil
				[105421] = "crowdControl",	-- Blinding Light
				[20066] = "crowdControl",	-- Repentance
				
				-- Priest
				[113506] = "defCD", 		-- Cyclone (Symbiosis) (Made that one a def CD, because the enemy is immune to everything during cyclone)
				[33206] = "defCD",			-- Pain Suppression
				[47788] = "defCD",			-- Guardian Spirit
				[47585] = "defCD",			-- Dispersion
				[10060] = "offCD",			-- Power Infusion
				[64044] = "stun",			-- Psychic Horror
				[15487] = "silence",		-- Silence
				[87204] = "crowdControl",	-- Sin and Punishment(Vampiric Touch dispel fear)
				[8122] = "crowdControl",	-- Psychic Scream
				[113792] = "crowdControl",	-- Psychic Terror (Psyfiend)
				[605] = "crowdControl",		-- Dominate Mind
				[88625] = "crowdControl",	-- Holy Word: Chastise
				[9484] = "crowdControl",	-- Shackle Undead
				[114404] = "root",			-- Void Tendrils
				[87194] = "root",			-- Glyph of Mindblast
				[6346] = "usefulBuffs",		-- Fear Ward
				[34914] = "usefulDebuffs",	-- Vampiric Touch
				
				-- Rogue	
				[5277] = "defCD",			-- Evasion
				[31224] = "defCD",			-- Cloak of Shadows
				[121471] = "offCD",			-- Shadow Blades
				[88611] = "defCD",			-- Smokebomb
				[13750] = "offCD",			-- Adrenaline Rush
				[51690] = "offCD",			-- Killing Spree
				[51713] = "offCD",			-- Shadow Dance
				[408] = "stun", 			-- Kidney Shot
				[1833] = "stun",			-- Cheap Shot
				[51722] = "disarm", 		-- Dismantle
				[115197] = "root", 			-- Partial Paralysis (Paralitic Poison Shiv)
				[113953] = "stun",			-- Paralysis (Paralitic Poison Stun)
				[1330] = "silence",			-- Garrote - Silence
				[2094] = "crowdControl", 	-- Blind
				[1776] = "crowdControl", 	-- Gouge
				[6770] = "crowdControl", 	-- Sap
				
				-- Shaman
				[108271] = "defCD",			-- Astral Shift
				[30823] = "defCD",			-- Shamanistic Rage
				[114049] = "offCD",			-- Ascendance
				[16166] = "offCD",			-- Elemental Mastery
				[118905] = "stun",			-- Static Charge
				[118345] = "stun",			-- Pulverize (Primal Earth Elemental)
				[77505] = "stun",			-- Earthquake Stun
				[51514] = "crowdControl",	-- Hex
				[76780] = "crowdControl",	-- Bind Elemental
				[63685] = "root",			-- Frost Shock (including Frozen Power)
				[64695] = "root",			-- Earthgrab Totem
				
				-- Warlock
				[710] = "defCD",			-- Banish (It is marked as def CD for the same reason as Cyclone)
				[104773] = "defCD",			-- Unending Resolve
				[113858] = "offCD",			-- Dark Soul: Instability
				[113861] = "offCD",			-- Dark Soul: Knowledge
				[113860] = "offCD",			-- Dark Soul: Misery
				[6789] = "stun",			-- Mortal Coil
				[30283] = "stun",			-- Shadowfury
				[89766] = "stun",			-- Axe Toss	(Pet-stun)
				[22703] = "stun",			-- Infernal Awakening
				[24259] = "silence",		-- Spell lock (Pet-silence)
				[115782] = "silence",		-- Optical Blast (Pet-silence)
				[137143] = "crowdControl",	-- Blood Horror
				[5484] = "crowdControl",	-- Howl of Terror
				[118699] = "crowdControl",	-- Fear
				[115268] = "crowdControl",	-- Mesmerize (Pet-Charm)
				[6358] = "crowdControl",	-- Seduce (Pet-Charm)
				[30108] = "usefulDebuffs",	-- Unstable Affliction		
				
				-- Warrior
				[118038] = "defCD",			-- Die by the Sword
				[871] = "defCD",			-- Shield Wall
				[107574] = "offCD",			-- Avatar
				[1719] = "offCD",			-- Recklessness
				[7922] = "stun",			-- Warbringer
				[132168] = "stun",			-- Shockwave
				[118000] = "stun",			-- Dragon Roar
				[132169] = "stun",			-- Storm Bolt
				[58357] = "silence",		-- Heroic Throw silence ?
				[5246] = "crowdControl",	-- Intimidating Shout
				[20511] = "crowdControl", 	-- Intimidating Shout
				[95199] = "crowdControl",	-- Intimidating Shout
				[676] = "disarm",			-- Disarm
				[107566] = "root",			-- Staggering Shout
				[105771] = "root",			-- Charge
				[23920] = "usefulBuffs",	-- Spell Reflection
				[114028] = "usefulBuffs",	-- Mass Spell Reflection
			},
			["FilteredSpells"] = { --[[This list blocks spells that cause bugs in the casthistory.]]--

					[127797] = "Ursol's Vortex", -- This ability is no channel, but the UNIT_SPELLCAST_SUCCEEDED event fires for it multiple times, if an enemy player stands inside of it.
					[102794] = "Ursol's Vortex",
					[75] = "Auto Shot", -- For every autoshot a hunter casts, the cast history will create a button. So we filter it.
					[107270] = "Spinning Crane Kick",
					[5374] = "Mutilate", -- The real Mutilate-Spell triggers these two spells. We don't need to show all three of them in the CastHistory, so we block them too.
					[27576] = "Mutilate Off-Hand",
					[110745] = "Divine Star (Holy)",
					[122128] = "Divine Star (Shadow)",
					[120692] = "Halo (Holy)",
					[120696] = "Halo (Shadow)",
					[93217] = "Launch Quest",
					[93079] = "Launch Quest",
					[102470] = "Launch Quest",
					[100775] = "Trophy Collector",
					[836] = "LOGINEFFECT",
					[121473] = "Shadow Blade",
					[121474] = "Shadow Blade Off-hand",
					[137584] = "Shuriken Toss (Autoattack Mainhand)",
					[137585] = "Shuriken Toss Off-hand",
					[126526] = "Healing Sphere Charge Removal",
					[124040] = "Chi Torpedo",
					[126137] = "Lightspring Trigger",
			},
			["ShownBuffs"] = { -- I've decided to just show certain Buffs on the Buff-frame. Here is the List.
			-- Order is [SpellID] = "Castname",

				--Death Knight
				[48707] = "Anti-Magic Shell",
				[51052] = "Anti-Magic Zone",
				[48263] = "Blood Presence",
				[49222] = "Bone Shield",
				[118009] = "Desecrated Ground",
				[48266] = "Frost Presence",
				[48792] = "Icebound Fortitude",
				[49039] = "Lichborne",
				[51271] = "Pillar of Frost",
				[114556] = "Purgatory",
				[55610] = "Unholy Aura",
				[115989] = "Unholy Blight",
				[49016] = "Unholy Frenzy",
				[48265] = "Unholy Presence",
				[55233] = "Vampiric Blood",


				-- Druid
				[22812] = "Barkskin",
				[5487] = "Bear Form",
				[106951] = "Berserk",
				[50334] = "Berserk",
				[768] = "Cat Form",
				[102352] = "Cenarion Ward",
				[1850] = "Dash",
				[108291] = "Heart of the Wild (Balance)",
				[108292] = "Heart of the Wild (Feral)",
				[108293] = "Heart of the Wild (Guardian)",
				[108294] = "Heart of the Wild (Restoration)",
				[102560] = "Incarnation: Chosen of Elune",
				[102543] = "Incarnation: King of the Jungle",
				[102558] = "Incarnation: Son of Ursoc",
				[33891] = "Incarnation: Tree of Life",
				[29166] = "Innervate",
				[102342] = "Ironbark",
				[17007] = "Leader of the Pack",
				[33763] = "Lifebloom",
				[59990] = "Lifebloom",
				[94447] = "Lifebloom",
				[1126] = "Mark of the Wild",
				[106922] = "Might of Ursoc",
				[24858] = "Moonkin Form",
				[132158] = "Nature's Swiftness",
				[124974] = "Nature's Vigil",
				[5215] = "Prowl",
				[774] = "Rejuvenation",
				[8936] = "Regrowth",
				[77764] = "Stampeding Roar",
				[77761] = "Stampeding Roar",
				[106898] = "Stampeding Roar",
				[48505] = "Starfall",
				[61336] = "Survival Instincts",
				[5217] = "Tiger's Fury",
				[740] = "Tranquility",
				[783] = "Travel Form",
				
				-- Hunter
				[5118] = "Aspect of the Cheetah",
				[109260] = "Aspect of the Iron Hawk",
				[13165] = "Aspect of the Hawk",
				[13159] = "Aspect of the Pack",
				[19574] = "Bestial Wrath",
				[51755] = "Camouflage",
				[19263] = "Deterrence",
				[148467] = "Deterrence (Crouching Tiger, Hidden Chimera)",
				[5384] = "Feign Death",
				[119449] = "Glyph of Camouflage",
				[109260] = "Iron Hawk",
				[62305] = "Master's Call",
				[54216] = "Master's Call",
				[3045] = "Rapid Fire",
				[19506] = "Trueshot Aura",

				
				--Mage
				[110909] = "Alter Time",
				[1459] = "Arcane Brilliance",
				[12042] = "Arcane Power",
				[57761] = "Brain Freeze",
				[87023] = "Cauterize",
				[12051] = "Evocation",
				[7302] = "Frost Armor",
				[113862] = "Greater Invisibility",
				[11426] = "Ice Barrier",
				[45438] = "Ice Block",
				[108839] = "Ice Floes",
				[12472] = "Icy Veins",
				[66] = "Invisibility",
				[6117] = "Mage Armor",
				[30482] = "Molten Armor",
				[12043] = "Presence of Mind",

				
				-- Monk
				[122278] = "Dampen Harm",
				[122783] = "Diffuse Magic",
				[116781] = "Legacy of the White Tiger",
				[116849] = "Life Cocoon",
				[137562] = "Nimble Brew",
				[119611] = "Renewing Mist",
				[116844] = "Ring of Peace",
				[122470] = "Touch of Karma",
				[115176] = "Zen Meditation",
				
				--Paladin 
				[31850] = "Ardent Defender",
				[53563] = "Beacon of Light",
				[20217] = "Blessing of Kings",
				[19740] = "Blessing of Might",
				[31884] = "Avenging Wrath",
				[31821] = "Devotion Aura",
				[31842] = "Divine Favor",
				[54428] = "Divine Plea",
				[498] = "Divine Protection",
				[642] = "Divine Shield",
				[86698] = "Guardian of Ancient Kings",
				[86669] = "Guardian of Ancient Kings",
				[86659] = "Guardian of Ancient Kings",
				[1044] = "Hand of Freedom",
				[1022] = "Hand of Protection",
				[114039] = "Hand of Purity",
				[6940] = "Hand of Sacrifice",
				[1038] = "Hand of Salvation",
				[105809] = "Holy Avenger",
				[20925] = "Sacred Shield",
				[105361] = "Seal of Command",
				[20164] = "Seal of Justice",
				[20154] = "Seal of Righteousness",
				[31801] = "Seal of Truth",
				[85499] = "Speed of Light",				
				
				
				--Priest
				[121557] = "Angelic Feather",
				[81700] = "Archangel",
				[81209] = "Chakra: Chastise",
				[81206] = "Chakra: Sanctuary",
				[81208] = "Chakra: Serenity",
				[588] = "Inner Fire",
				[96267] = "Inner Focus",
				[77613] = "Grace",
				[73413] = "Inner Will",
				[47585] = "Dispersion",
				[64843] = "Divine Hymn",
				[6346] = "Fear Ward",
				[45242] = "Focused Will",
				[120587] = "Glyph of Mind Flay",
				[47788] = "Guardian Spirit",
				[33206] = "Pain Suppression",
				[114239] = "Phantasm",
				[10060] = "Power Infusion",
				[81782] = "Power Word: Barrier",
				[21562] = "Power Word: Fortitude",
				[17] = "Power Word: Shield",
				[123258] = "Power Word: Shield (Divine Insight Procc)",
				[41637] = "Prayer of Mending",
				[139] = "Renew",
				[15473] = "Shadowform",
				[112833] = "Spectral Guise",
				[27827] = "Spirit of Redemption",
				[109964] = "Spirit Shell",
				[114908] = "Spirit Shell: Absorb",
				[114255] = "Surge of Light",
				
				
				--Rogue
				[13750] = "Adrenaline Rush",
				[108212] = "Burst of Speed",
				[31224] = "Cloak of Shadows",
				[74001] = "Combat Readiness",
				[74002] = "Combat Insight (Combat Readiness Stacks)",
				[3408] = "Crippling Poison",
				[2823] = "Deadly Poison",
				[108215] = "Paralytic Poison",
				[108211] = "Leeching Poison",
				[5277] = "Evasion",
				[1966] = "Feint",
				[51690] = "Killing Spree",
				[108211] = "Leeching Poison",
				[5761] = "Mind-numbing Poison",
				[73651] = "Recuperate",
				[51713] = "Shadow Dance",
				[121471] = "Shadow Blades",
				[114018] = "Shroud of Concealment",
				[5171] = "Slice and Dice",
				[2983] = "Sprint",
				[1784] = "Stealth",
				[1856] = "Vanish",
				[8679] = "Wound Poison",
				

				--Shaman
				[108281] = "Ancestral Guidance",
				[16188] = "Ancestral Swiftness",
				[114049] = "Ascendance",
				[108271] = "Astral Shift",
				[974] = "Earth Shield",
				[16166] = "Elemental Mastery",
				[119523] = "Healing Stream Totem",
				[324] = "Lightning Shield",
				[61295] = "Riptide",
				[30823] = "Shamanistic Rage",
				[58875] = "Spirit Walk",
				[79206] = "Spiritwalker's Grace",
				[52127] = "Water Shield",
	
				
				--Warlock
				[111397] = "Blood Horror",
				[111400] = "Burning Rush",
				[114168] = "Dark Apotheosis",
				[110913] = "Dark Bargain",
				[109773] = "Dark Intent",
				[108359] = "Dark Regeneration",
				[113858] = "Dark Soul: Instability",
				[113861] = "Dark Soul: Knowledge",
				[113860] = "Dark Soul: Misery",
				[689] = "Drain Life",
				[103103] = "Drain Soul",
				[108503] = "Grimoire of Sacrifice",
				[108508] = "Mannoroth's Fury",
				[103958] = "Metamorphosis",
				[79957] = "Soul Link",
				[6229] = "Twilight Ward",
				[108416] = "Sacrificial Pact",
				[104773] = "Unending Resolve",

				
				--Warrior
				[107574] = "Avatar",
				[18499] = "Berserker Rage",
				[46924] = "Bladestorm",
				[12292] = "Bloodbath",
				[118038] = "Die by the Sword",
				[85730] = "Deadly Calm",
				[55694] = "Enraged Regeneration",
				[3411] = "Intervene",
				[12975] = "Last Stand",
				[114028] = "Mass Spell Reflection",
				[97463] = "Rallying Cry",
				[1719] = "Recklessness",
				[114029] = "Safeguard",
				[125667] = "Second Wind",
				[871] = "Shield Wall",
				[23920] = "Spell Reflection",
				[114206] = "Skull Banner",
				[16491] = "Second Wind",
				[29842] = "Second Wind",
				[12328] = "Sweeping Strikes",
				[114030] = "Vigilance",

				
				-- Other:
				[121279] = "Lifeblood",
			},
		["Dispels"] = {
			-- TO DO: SPEC SPECIFIC SPELLS
			["DRUID"] = { 88423, 8 }, 			-- Nature's Cure
			["MAGE"] = { 475, 8 },				-- Remove Curse
			["MONK"] = { 115450, 8 }, 			-- Detox
			["PALADIN"] = { 4987, 8 }, 			-- Cleanse
			["PRIEST"] = { 527, 8 }, 			-- Purify
			["SHAMAN"] = { 51886, 8 }, 			-- Cleanse Spirit
		},
		["Interrupts"] = {
			["DEATHKNIGHT"] = { 47528, 15 },	-- Mind Freeze
			["DRUID"] = { 106839, 15 }, 		-- Skull Bash
			["HUNTER"] = { 147362, 24 },		-- Counter Shot
			["MAGE"] = { 2139, 24 },			-- Counter Spell
			["PALADIN"] = { 96231, 15 }, 		-- Rebuke
			["ROGUE"] = { 1766, 15 }, 			-- Kick
			["SHAMAN"] = { 57994, 12 },			-- Wind Shear
			["WARLOCK"] = { 132409, 24 }, 		-- Spell lock Warlock (I use this one for all warlock counters and let them have a shared CD via the "SharedCooldowns" table.
			["WARRIOR"] = { 6552, 15 },			-- Pummel		
		},
		["SharedCooldowns"] = {
				[42292] = { -- PvP-Insignia
					[59752] = 120,			-- Human Racial
					[7744] = 30,			-- Will of the Forsaken
				},
				[59752] = { -- Human Racial
					[42292] = 120,			-- PvP-Insignia
				},
				[7744] = { -- Will of the Forsaken
					[42292] = 30,			-- PvP-Insignia
				},
				[119910] = { -- Spell Lock pet
					[132409] = 24,				-- Spell lock (Warlock)
				},
				[119911] = { -- Optical Blast
					[132409] = 24,				-- Spell lock (Warlock)
				},
				[171140] = { -- Shadowlock
					[132409] = 24,				-- Spell lock (Warlock)
				},
				[119910] = { -- Spell lock
					[132409] = 24,				-- Spell lock (Warlock)
				},
				[115782] = { -- Optical Blast
					[132409] = 24,				-- Spell Lock (Warlock)
				},
				[102060] = { -- Disrupting Shout
					[6552] = 15,				-- Pummel
				}
			},
		["DiminishingReturns"] =
			{						
				-- Roots:
				[96294] = "root", 				-- Chains of Ice
				
				[339] = "root", 				-- Entangling Roots
				[19975] = "root", 				-- Entangling Roots: Nature's Grasp
				[102359] = "root",				-- Mass Entanglement
				
				[53148] = "root",				-- Charge (Tenacity Pet)
				[64803] = "root",				-- Entrapment (trap-roots)
				[136634] = "root", 				-- Narrow Escape 
				[50245] = "root", 				-- Pin
				[90327] = "root", 				-- Lock Jaw
				[4167] = "root",  				-- Web 
				[54706] = "root",  				-- Venom Web Spray
				
				[33395] =  "root",  			-- Freeze
				[122] = "root",  				-- Frost Nova
				[111340] = "root",				-- Ice Ward Root
				
				[116706] = "root",  			-- Disable
				
				[87194] = "root",				-- Glyph of Mindblast
				[114404] = "root", 				-- Void Tendril's Grasp
				[115197] = "root", 				-- Partial Paralysis

				[64695] = "root",				-- Earthgrab (Earthgrab Totem)
				[63685] = "root", 				-- Frost Shock (Frozen Power Talent)
				[107566] = "root", 				-- Staggering Shout
				[105771] = "root",				-- Warbringer

				-- Short Roots:
				[64803] = "shortRoot",			-- Entrapment (trap-roots)
				[111340] = "shortRoot",			-- Ice Ward Root
				[123393] = "shortRoot",			-- Spinning Fire Blossom
				[64695] = "shortRoot", 			-- Earthgrab Totem
				
				-- Stuns:
				[108194] = "stun", 				-- Asphyxiate
				[91800] = "stun", 				-- Gnaw (Ghoul)
				[91797] = "stun", 				-- Monstrous Blow (Ghoul with Dark Transformation active)
				[115001] = "stun", 				-- Remorseless Winter
				
				[113801] = "stun", 				-- Bash
				[102795] = "stun", 				-- Bear Hug
				[22570] = "stun", 				-- Maim
				[5211] = "stun", 				-- Mighty Bash
				[163505] = "stun", 				-- Rake	
				[9005] = "stun", 				-- Pounce
				
				[117526] = "stun",				-- Binding Shot
				[19577] = "stun",				-- Intimidation (stun)			

				[90337] = "stun",				-- Bad Manner (Monkey Pet)
				[126246] = "stun",				-- Lullaby (Crane Pet)
				[126423] = "stun",				-- Petrifying Gaze (Basilisk Pet)
				[126355] = "stun",				-- Paralyzing Quill(Porcupine Pet)
				[56626] = "stun",				-- Sting (Wasp Pet)
				[50519] = "stun",				-- Sonic Blast (Bat Pet)
				[96201] = "stun",				-- Web Wrap (Spider-Pet Stun)
				
				[118271] = "stun", 				-- Combustion Impact
				[44572] = "stun", 				-- Deep Freeze
				
				[119392] = "stun", 				-- Charging Ox Wave
				[122242] = "stun", 				-- Clash
				[120086] = "stun", 				-- Fists of Fury
				[119381] = "stun", 				-- Leg Sweep
				
				[54934] = "stun", 				-- TODO: Glyph of Blinding Light
				[105593] = "stun", 				-- Fist of Justice
				[853] = "stun",					-- Hammer of Justice
				[119072] = "stun", 				-- Holy Wrath
				
				[1833] = "stun", 				-- Cheap Shot
				[408] = "stun", 				-- Kidney Shot
				
				[118345] = "stun",				-- Pulverize (Primal Earth Elemental)
				[118905] = "stun", 				-- Static Charge
				
				[103131] = "stun",				-- Axe Toss (Felguard)
				[22703] = "stun",				-- Infernal Awakening
				[30283] = "stun", 				-- Shadowfury
				
				[132168] = "stun", 				-- Shockwave
				[107570] = "stun",				-- Storm Bolt
				
				[20549] = "stun", 				-- War Stomp
				
				-- Short Stuns:				
				[77505] = "shortStun", 			-- Earthquake				
				[7922] = "shortStun",			-- Charge Stun
				[113953] = "shortStun", 		-- Paralysis
				[118895] = "shortStun", 		-- Dragon Roar
				
				-- Incapacitates:
				[99] = "incapacitate", 			-- Incapacitating Roar
				
				[2637] = "incapacitate",		-- Hibernate
				[3355] = "incapacitate", 		-- Freezing Trap
				[19386] = "incapacitate", 		-- Wyvern Sting
				
				[31661] = "incapacitate", 		-- Dragon's Breath
				[118] = "incapacitate", 		-- Polymorph
				[113724] = "incapacitate", 		-- Ring of Frost
				
				[123407] = "incapacitate",		-- Glyph of Breath of Fire
				[115078] = "incapacitate", 		-- Paralysis
				[137460] = "incapacitate",		-- Ring of Peace
				
				[20066] = "incapacitate", 		-- Repentance
				
				[605] = "incapacitate",			-- Dominate Mind
				[88625] = "incapacitate", 		-- Holy Word: Chastise
				[9484] = "incapacitate", 		-- Shackle Undead (?)
				
				
				[1776] = "incapacitate", 		-- Gouge
				[6770] = "incapacitate", 		-- Sap
				
				[76780] = "incapacitate",			-- Bind Elemental
				[51514] = "incapacitate", 		-- Hex
				
				[710] = "incapacitate",			-- Banish
				
				[107079] = "incapacitate", 		-- Quaking Palm (Racial)
				
				-- Short Mesmerizes:
				[99] = "shortIncapacitate", 		-- Disorienting Roar
				[19503] = "shortIncapacitate",		-- Scatter Shot
				[31661] = "shortIncapacitate", 	-- Dragon's Breath
				[123407] = "shortIncapacitate",	-- Glyph of Breath of Fire
				[88625] = "shortIncapacitate",		-- Holy Word: Chastise

				-- Disorients:
				[113056] = "fear",				-- Intimidating Roar (cower)
				[113004] = "fear",				-- Intimidating Roar (flee)
				[1513] = "fear", 				-- Scare Beast
				[10326] = "fear", 			-- Turn Evil
				[105421] = "fear", 		-- Blinding Light (?)
				
				[8122] = "fear", 			-- Psychic Scream
				[113792] = "fear", 				-- Psychic Terror
				
				[2094] = "fear", 			-- Blind

				[118699] = "fear", 		-- Fear
				[5484] = "fear", 			-- Howl of Terror
				[115268] = "fear", 		-- Mesmerize
				[6358] = "fear", 			-- Seduction

				[5246] = "fear",			-- Intimidating Shout
				[20511] = "fear", 				-- Intimidating Shout
				[95199] = "fear", 			-- Intimidating Shout

				
				-- Silences:
				[47476] = "silence", 			-- Strangulate
				
				[114238] = "silence",			-- Fae Silence (Glyph of Fae Silence)
				[81261] = "silence", 			-- Solar Beam				
				
				[34490] = "silence", 			-- Silencing Shot
				
				[55021] = "silence", 			-- Improved Counterspell
				[102051] = "silence", 			-- Frostjaw
				
				[31935] = "silence", 			-- Avenger's Shield
				
				[137460] = "silence",			-- Silence (Ring of Peace)
				[116709] = "silence", 			-- Spear Hand Strike
				[15487] = "silence", 			-- Silence
				
				[1330] = "silence", 			-- Garrote - Silence
				
				[24259] = "silence", 			-- Spell Lock
				[115782] = "silence", 			-- Optical Blast
				[129597] = "silence", 			-- Arcane Torrent
				
				-- Disarms:
				[50541] = "disarm", 			-- Clench
				[91644] = "disarm", 			-- Snatch
				
				[117368] = "disarm", 			-- Grapple Weapon
				[137461] = "disarm",			-- Disarm (Ring of Peace)
				
				[64058] = "disarm", 			-- Psychic Horror
				
				[51722] = "disarm", 			-- Dismantle
				
				[118093] = "disarm",			-- Disarm
				
				[676] = "disarm", 				-- Disarm
				[24259] = "silence", 			-- Spell Lock
				[115782] = "silence", 			-- Optical Blast
				
				
				[64044] = "horror", 		-- Psychic Horror
				[137143] = "horror", 		-- Blood Horror
				[6789] = "horror", 		-- Mortal Coil
				-- Knockbacks:
				-- Gorefiend's Grasp
				
				-- Typhoon
				-- Ursol's Vortex
				
				-- Glyph of Explosive Trap
				-- Thunderstorm
				-- Fellash (Shivarra)
				-- Whiplash (Succubus)

				-- Cyclone:
				[33786] = "cyclone", -- Cyclone
				
				-- Charms:
				[605] = "charm", -- Dominate Mind
			},
	};