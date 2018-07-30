local GetSpellInfo = GetSpellInfo

ArenaLiveSpectator.SpellDB = {
	["Dispels"] = { -- Dispels only trigger their cooldown when actively dispelling something.
					-- In Order to account for that in the cooldown tracker I need a fast way
					-- to know which spell is a dispel and which one is not.
		[2782] = true,				-- Druid: Remove Corruption
		[88423] = true,				-- Druid: Nature's Cure
		[115450] = true,			-- Monk: Detox
		[4987] = true,				-- Paladin: Cleanse
		[527] = true,				-- Priest: Purify
		[51886] = true,				-- Shaman: Cleanse Spirit
		[77130] = true,				-- Shaman: Purify Spirit
	},
	["Resurrects"] = {
		[50769] = "Revive (Druid)",
		[115178] = "Resuscitate (Monk)",
		[7328] = "Redemption (Paladin)",
		[2006] = "Resurrection (Priest)",
		[2008] = "Ancestral Spirit (Shaman)",
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
		[60192] = { -- Freezing Trap: Trap Launcher
			[82941] = 30,			-- Ice Trap: Trap Launcher
			[13809] = 30,			-- Ice Trap
			[1499] = 30,			-- Freezing Trap
		},
		[1499] = { -- Freezing Trap
			[82941] = 30,			-- Ice Trap: Trap Launcher
			[13809] = 30,			-- Ice Trap
			[60192] = 30,			-- Freezing Trap: Trap Launcher
		},
		[82941] = { -- Ice Trap: Trap Launcher
			[13809] = 30,			-- Ice Trap
			[60192] = 30,			-- Freezing Trap: Trap Launcher
			[1499] = 30,			-- Freezing Trap
		},
		[13809] = { -- Ice Trap
			[82941] = 30,			-- Ice Trap: Trap Launcher
			[60192] = 30,			-- Freezing Trap: Trap Launcher
			[1499] = 30,			-- Freezing Trap
		},
		[2062] = { -- Earth Elemental Totem
			[2894] = 500,		-- Fire Elemental Totem
		},
		[2894] = { -- Fire Elemental Totem
			[2062] = 500,		-- Earth Elemental Totem
		},
		[119911] = { -- Optical Blast
			[132409] = 24,				-- Spell lock (Warlock)
		},
		[119910] = { -- Spell lock
			[132409] = 24,				-- Spell lock (Warlock)
		},
		[6552] = { -- Pummel
			[102060] = 15,				-- Disrupting Shout
		},
		[102060] = { -- Disrupting Shout
			[6552] = 15,				-- Pummel
		},
	},
	["CooldownTypePriorities"] = {
		["TRINKET"] = 7,
		["RACIAL"] = 6,
		["DEF_CD"] = 5,
		["OFF_CD"] = 4,
		["CC"] = 3,
		["MISC"] = 2,
		["INTERRUPT"] = 1,
		["DISPEL"] = 1,
	},
	["CooldownTypes"] = {
		-- Trinket:
		[42292] = "TRINKET",
		
		
		-- Racial Abilities:
		[59752] = "RACIAL",		-- Human
		[20594] = "RACIAL",		-- Dwarf
		[58984] = "RACIAL",		-- Night Elf
		[20589] = "RACIAL",		-- Gnome
		[28880] = "RACIAL",		-- Draenei
		[59542] = "RACIAL",
		[59543] = "RACIAL",
		[59544] = "RACIAL",
		[59545] = "RACIAL",
		[59547] = "RACIAL",
		[59548] = "RACIAL",
		[121093] = "RACIAL",
		[68992] = "RACIAL",		-- Worgen
		[20572] = "RACIAL",		-- Orc
		[33697] = "RACIAL",
		[33702] = "RACIAL",
		[7744] = "RACIAL",		-- Undead
		[20549] = "RACIAL",		-- Tauren
		[26297] = "RACIAL",		-- Troll
		[69179] = "RACIAL",		-- Blood Elf
		[28730] = "RACIAL",
		[80483] = "RACIAL",
		[25046] = "RACIAL",
		[50613] = "RACIAL",
		[129597] = "RACIAL",
		[69070] = "RACIAL",		-- Goblin
		[107079] = "RACIAL",	-- Pandaren

		
		-- Death Knight:
		[48707] = "DEF_CD",		-- Anti-Magic Shell
		[51052] = "DEF_CD",		-- Anti-Magic Zone
		[49222] = "DEF_CD",		-- Bone Shield
		[48743] = "DEF_CD",		-- Death Pact
		[108201] = "DEF_CD",	-- Desecrated Ground
		[48792] = "DEF_CD",		-- Icbound Fortitude
		[49039] = "DEF_CD",		-- Lich Borne
		[48982] = "DEF_CD",		-- Rune Tap
		[55233] = "DEF_CD",		-- Vampiric Blood
		
		[49028] = "OFF_CD",		-- Dancing Rune Weapon
		[47568] = "OFF_CD",		-- Empowered Rune Weapon
		[77575] = "OFF_CD",		-- Outbreak
		[51271] = "OFF_CD",		-- Pillar of Frost
		[49016] = "OFF_CD",		-- Unholy Frenzy
		[49206] = "OFF_CD",		-- Summon Gargoyle
		[115989] = "OFF_CD",	-- Unholy Blight
		[46584] = "OFF_CD",		-- Raise dead
		
		[47528] = "INTERRUPT",	-- Mind Freeze
		
		[108194] = "CC",		-- Asphyxiate
		[49576] = "CC",			-- Death Grip
		[108199] = "CC",		-- Gorefiend's Grasp
		[108200] = "CC",		-- Remorsless Winter
		[47476] = "CC",			-- Strangulate
		
		[77606] = "MISC",		-- Dark Simulacrum
		[43265] = "MISC",		-- Death and Decay
		[96268] = "MISC",		-- Death's Advance
		[123693] = "MISC",		-- Plague Leech
		
		
		-- Druid
		[102351] = "DEF_CD",		-- Cenarion Ward
		[22812] = "DEF_CD",			-- Bark Skin 
		[108291] = "DEF_CD",		-- Heart of the Wild: Balance
		[108292] = "DEF_CD",		-- Heart of the Wild: Feral
		[108293] = "DEF_CD",		-- Heart of the Wild: Guardian
		[108294] = "DEF_CD",		-- Heart of the Wild: Restoration
		[124974] = "DEF_CD",		-- Nature's Vigil
		[132158] = "DEF_CD",		-- Nature's Swiftness
		[108238] = "DEF_CD",		-- Renewal
		[62606] = "DEF_CD",			-- Savage Defense
		[61336] = "DEF_CD",			-- Survival Insticts
		[740] = "DEF_CD",			-- Tranquility
		[102342] = "DEF_CD",		-- Iron Bark
		[5229] = "DEF_CD",			-- Enrage
		[106922] = "DEF_CD",		-- Might of Ursoc
		
		[106952] = "OFF_CD",		-- Berserk
		[112071] = "OFF_CD",		-- Celestial Alignment
		[102560] = "OFF_CD",		-- Incarnation: Chosen of Elune
		[102543] = "OFF_CD",		-- Incarnation: King of the Jungle
		[102558] = "OFF_CD",		-- Incarnation: Son of Ursoc
		[33891] = "OFF_CD",			-- Incarnation: Tree of Life
		[5217] = "OFF_CD",			-- Tiger's Fury
		
		[2782] = "DISPEL",			-- Remove Corruption
		[88423] = "DISPEL",			-- Nature's Cure
		
		[106839] = "INTERRUPT",		-- Skull Bash
		
		[99] = "CC",				-- Incapacitating Shout
		[102359] = "CC",			-- Mass Entanglement
		[5211] = "CC",				-- Mighty Bash
		[78675] = "CC",				-- Solar Beam
		[132469] = "CC",			-- Typhoon
		[102793] = "CC",			-- Ursol's Vortex
		
		[1850] = "MISC",			-- Dash
		[102280] = "MISC",			-- Displacer Beast
		[102693] = "MISC",			-- Force of Nature
		[106898] = "MISC",			-- Stampeding Roar
		[48505] = "MISC",			-- Starfall
		[18562] = "MISC",			-- Swiftmend
		[132302] = "MISC",			-- Wild Charge
		[48438] = "MISC",			-- Wild Growth
		[29166] = "MISC",			-- Innervate

		
		-- Hunter:
		[19263] = "DEF_CD",				-- Deterrence
		[148467] = "DEF_CD",			-- Deterrence (Crouching Tiger, Hidden Chimaera)
		[109304] = "DEF_CD",			-- Exhilaration
		[53271] = "DEF_CD",				-- Master's Call
		
		[131894] = "OFF_CD",			-- A Murder of Crows
		[120697] = "OFF_CD",			-- Lynx Rush
		[82726] = "OFF_CD",				-- Fervor
		[120679] = "OFF_CD",			-- Dire Beast
		[19574] = "OFF_CD",				-- Bestial Wrath
		[3045] = "OFF_CD",				-- Rapid Fire
		[121818] = "OFF_CD",			-- Stampede
		
		[147362] = "INTERRUPT",			-- Counter Shot
		
		[109248] = "CC",				-- Binding Shot
		[1499] = "CC",					-- Freezing Trap
		[19577] = "CC",					-- Intimidation
		[19386] = "CC",					-- Wyvern Sting
		
		[3674] = "MISC",				-- Black Arrow
		[120360] = "MISC",				-- Barrage
		[51753] = "MISC",				-- Camouflage
		[781] = "MISC",					-- Disengage
		[13813] = "MISC",				-- Explosive Trap
		[5384] = "MISC",				-- Feign Death
		[117050] = "MISC",				-- Glaive Toss
		[13809] = "MISC",				-- Ice Trap
		[109259] = "MISC",				-- Power Shot

		
		-- Mage:
		[108978] = "DEF_CD",			-- Alter Time
		[11958] = "DEF_CD",				-- Cold Snap
		[45438] = "DEF_CD",				-- Ice Block
		[12051] = "DEF_CD",				-- Evocation
		
		[12042] = "OFF_CD",				-- Arcane Power
		[11129] = "OFF_CD",				-- Combustion
		[84714] = "OFF_CD",				-- Frozen Orb
		[12472] = "OFF_CD",				-- Icy Veins
		[55342] = "OFF_CD",				-- Mirror Images
		
		[2139] = "INTERRUPT",			-- Counterspell
		
		[44572] = "CC",					-- Deep Freeze
		[31661] = "CC",					-- Dragon's Breath
		[102051] = "CC",				-- Frostjaw
		[122] = "CC",					-- Frost Nova
		[113724] = "CC",				-- Ring of Frost
		
		[108843] = "MISC",				-- Blazing Speed
		[1953] = "MISC",				-- Blink
		[120] = "MISC",					-- Cone of Cold
		--[2136] = "MISC",				-- Fire Blast
		[110959] = "MISC",				-- Greater Invisibility
		[11426] = "MISC",				-- Ice Barrier
		[115610] = "MISC",				-- Temporal Shield
		[111264] = "MISC",				-- Ice Ward
		[1463] = "OFF_CD",				-- Incanter's Ward \\ maybe i should set it MISC
		[66] = "MISC",					-- Invisibility
		[12043] = "MISC",				-- Presence of Mind
		
		
		-- Monk:
		[122278] = "DEF_CD",			-- Dampen Harm
		[122783] = "DEF_CD",			-- Diffuse Magic
		[115295] = "DEF_CD",			-- Guard
		[115213] = "DEF_CD",			-- Avert Harm
		[115203] = "DEF_CD",			-- Fortifying Brew
		[116849] = "DEF_CD",			-- Life Cocoon
		[137562] = "DEF_CD",			-- Nimble Brew
		[115310] = "DEF_CD",			-- Revival
		[122470] = "DEF_CD",			-- Touch of Karma
		[115176] = "DEF_CD",			-- Zen Meditation
		[116680] = "DEF_CD",			-- Thunder Focus Tea
		[116841] = "DEF_CD",			-- Tiger's Lust
		
		[115288] = "OFF_CD",			-- Energizing Brew
		[123904] = "OFF_CD",			-- Invoke Xuen, the White Tiger
		[115080] = "OFF_CD",			-- Touch of Death

		[116705] = "INTERRUPT",			-- Spear Hand Strike
		
		[115450] = "DISPEL",			-- Detox
		
		[119392] = "CC",				-- Charging Ox Wave
		[113656] = "CC",				-- Fists of Fury
		[119381] = "CC",				-- Leg Sweep
		[115078] = "CC",				-- Paralysis
		[116844] = "CC",				-- Ring of Peace
		[122057] = "CC",				-- Clash
		
		[115399] = "MISC";				-- Chi Brew
		[123986] = "MISC",				-- Chi Burst
		--[115008] = "MISC",				-- Chi Torpedo
		--[115098] = "MISC",				-- Chi Wave
		--[115072] = "MISC",				-- Expel Harm
		[101545] = "MISC",				-- Flying Serpent Kick
		--[109132] = "MISC",				-- Roll
		--[116847] = "MISC",				-- Rushing Jade Wind
		[119996] = "MISC",				-- Transcendence: Transfer
		--[124081] = "MISC",				-- Zen Sphere


		-- Paladin:
		[31850] = "DEF_CD",				-- Ardent Defender
		[31821] = "DEF_CD",				-- Devotion Aura
		[498] = "DEF_CD",				-- Divine Protection
		[642] = "DEF_CD",				-- Divine Shield
		[86659] = "DEF_CD",				-- Guardian of the Ancient Kings
		[1044] = "DEF_CD",				-- Hand of Freedom
		[1022] = "DEF_CD",				-- Hand of Protection
		[114039] = "DEF_CD",			-- Hand of Purity
		[6940] = "DEF_CD",				-- Hand of Sacrifice
		
		[31842] = "OFF_CD",				-- Divine Favor
		[31884] = "OFF_CD",				-- Avenging Wrath
		[105809] = "OFF_CD",			-- Holy Avenger
		
		[96231] = "INTERRUPT",			-- Rebuke
		
		[4987] = "DISPEL",				-- Cleanse
		
		[853] = "CC",					-- Hammer of Justice
		[105593] = "CC",				-- Fist of Justice
		[20066] = "CC",					-- Repentance
		[115750] = "CC",				-- Blinding Light
		
		[114157] = "MISC",				-- Execution Sentence
		[114165] = "MISC",				-- Holy Prism
		[114158] = "MISC",				-- Light's Hammer
		[54428] = "MISC",				-- Divine Plea
		[85499] = "MISC",				-- Speed of Light


		-- Priest:
		[108968] = "DEF_CD",			-- Void Shift
		[114214] = "DEF_CD", 			-- Angelic Bulwark
		[19236] = "DEF_CD", 			-- Desperate Prayer
		[47585] = "DEF_CD",				-- Dispersion
		[64843] = "DEF_CD",				-- Divine Hymn
		[586] = "DEF_CD",				-- Fade
		[47788] = "DEF_CD",				-- Guardian Spirit
		[73325] = "DEF_CD",				-- Leap of Faith
		[126135] = "DEF_CD",			-- Light Well
		[33206] = "DEF_CD",				-- Pain Suppression
		[62618] = "DEF_CD",				-- Power Word: Barrier
		[89485] = "DEF_CD",				-- Inner focus
		[109964] = "DEF_CD", 			-- Spirit Shell
		
		[123040] = "OFF_CD", 			-- Mind Bender
		[10060] = "OFF_CD",				-- Power Infusion
		[34433] = "OFF_CD",				-- Shadow Fiend
		
		[32375] = "DISPEL",				-- Mass Dispel
		[527] = "DISPEL",				-- Purify
		
		[88625] = "CC",					-- Holy Word: Chastise
		[64044] = "CC",					-- Psychic Horror
		[8122] = "CC",					-- Psychic Scream
		[15487] = "CC",					-- Silence
		[108920] = "CC",				-- Void Tendrils
		[108921] = "CC",				-- Psyfiend
		
		[81700] = "MISC",				-- Arch Angel
		[121135] = "MISC",				-- Cascade
		[127632] = "MISC",				-- Cascade (Shadow)
		[64901] = "MISC",				-- Hymn of Hope
		--[34861] = "MISC",				-- Circle of Healing
		[110744] = "MISC",				-- Divine Star
		[122121] = "MISC",				-- Divine Star
		[6346] = "MISC",				-- Fear Ward
		[120517] = "MISC",				-- Halo
		[120644] = "MISC",				-- Halo (Shadow)
		[14914] = "MISC",				-- Holy Fire
		[88685] = "MISC",				-- Holy Word: Sanctuary
		[88684] = "MISC",				-- Holy Word: Serenity
		[33076] = "MISC",				-- Prayer of Mending
		[112833] = "MISC", 				-- Shadow Guise 
		[129176] = "MISC",				-- Shadow Word: Death
		
		
		-- Rogue:
		[74001] = "DEF_CD",				-- Combat Readiness
		[5277] = "DEF_CD",				-- Evasion
		[14185] = "DEF_CD",				-- Preparation
		[1856] = "DEF_CD",				-- Vanish
		[31224] = "DEF_CD",				-- Cloak of Shadows
		
		[13750] = "OFF_CD",				-- Adrenaline Rush
		[51690] = "OFF_CD",				-- Killing Spree
		[137619] = "OFF_CD",			-- Marked for Death
		[51713] = "OFF_CD",				-- Shadow Dance
		[76577] = "OFF_CD",				-- Smoke Bomb
		[121471] = "OFF_CD",			-- Shadow Blades
		[79140] = "OFF_CD",				-- Vendetta
		
		[1766] = "INTERRUPT",			-- Kick
		
		[2094] = "CC",					-- Blind
		[1776] = "CC",					-- Gouge
		[408] = "CC",					-- Kidney Shot
		
		[36554] = "MISC",				-- Shadow Step
		[5938] = "MISC",				-- Shiv
		[114018] = "MISC",				-- Shroud of Concealment
		[2983] = "MISC",				-- Sprint
		[73981] = "MISC",				-- Redirect
		
		
		-- Shaman:
		[108271] = "DEF_CD",			-- Astral Shift
		[30823] = "DEF_CD",				-- Shamanistic Rage
		[108280] = "DEF_CD",			-- Healing Tide Totem
		[98008] = "DEF_CD",				-- Spirit Link Totem
		[58875] = "DEF_CD",				-- Spirit Walk
		[108270] = "DEF_CD",			-- Stone Bulwark Totem
		[108273] = "DEF_CD",			-- Windwalk Totem
		[108281] = "DEF_CD",			-- Ancestral Guidance
		[16188] = "DEF_CD",				-- Ancestral Swiftness
		
		[114049] = "OFF_CD",			-- Ascendance
		[16166] = "OFF_CD",				-- Elemental Mastery
		[51533] = "OFF_CD",				-- Feral Spirit
		[2894] = "OFF_CD",				-- Fire Elemental Totem
		
		[57994] = "INTERRUPT",			-- Windshear
		
		[51886] = "DISPEL",				-- Cleanse Spirit
		[77130] = "DISPEL",				-- Purify Spirit
		
		[51485] = "CC",					-- Earth Grab Totem
		[108269] = "CC",				-- Capacitor Totem
		[51514] = "CC",					-- Hex
		
		[108285] = "MISC",				-- Call of the Elements (Might change that to Defensive/Offensive)
		[2484] = "MISC",				-- Earthbind Totem
		[2062] = "MISC",				-- Earth Elemental Totem
		[117014] = "MISC",				-- Elemental Blast
		[8177] = "MISC",				-- Grounding Totem
		[73920] = "MISC",				-- Healing Rain
		[5394] = "MISC",				-- Healing Stream Totem
		[370] = "MISC",					-- Purge (Glyphed)
		[16190] = "MISC",				-- Mana Tide Totem
		--[61295] = "MISC",				-- Riptide
		[79206] = "MISC",				-- Spirit Walker's Grace
		[51490] = "MISC",				-- Thunderstorm
		[108287] = "MISC",				-- Totemic Projection
		[8143] = "MISC",				-- Tremor Totem

		
		-- Warlock: 
		[110913] = "DEF_CD",			-- Dark Bargain
		[108359] = "DEF_CD",			-- Dark Regeneration
		[108416] = "DEF_CD",			-- Sacrificial Pact
		[108482] = "DEF_CD",			-- Unbound Will
		[104773] = "DEF_CD",			-- Unending Resolve
		
		[113858] = "OFF_CD",			-- Dark Soul: Instability
		[113861] = "OFF_CD",			-- Dark Soul: Knowledge
		[113860] = "OFF_CD",			-- Dark Soul: Misery
		[108501] = "OFF_CD",			-- Grimoire of Service
		[108508] = "OFF_CD",			-- Mannoroth's Fury
		[103958] = "OFF_CD",			-- Metamorphosis

		[132409] = "INTERRUPT",			-- Spell lock (Warlock)
		
		[5484] = "CC",					-- Howl of Terror
		[6789] = "CC",					-- Mortal Coil
		[30283] = "CC",					-- Shadowfury
		
		[48020] = "MISC",				-- Demonic Cirle: Teleportation
		[111397] = "MISC",				-- Blood Horror
		[17962] = "MISC",				-- Conflagrate
		[109151] = "MISC",				-- Demonic Leap
		[120451] = "MISC",				-- Flames of Xoroth
		--[108503] = "MISC",				-- Grimoire of Sacrifice
		[105174] = "MISC",				-- Hand of Gul'dan
		[80240] = "MISC",				-- Havoc
		[137587] = "MISC",				-- Kil'jaeden's Cunning
		[108503] = "MISC",				-- Sacrifice
		
		-- Warrior:
		[18499] = "DEF_CD",				-- Berserker Rage
		[1160] = "OFF_CD",				-- Demoralizing Shout
		[114203] = "OFF_CD",			-- Demoralizing Banner
		[118038] = "DEF_CD",			-- Die by the Sword
		[55694] = "DEF_CD",				-- Enraged Regeneration
		[12975] = "DEF_CD",				-- Last Stand
		[97462] = "DEF_CD",				-- Rallying Cry
		[114029] = "DEF_CD",			-- Safeguard
		[2565] = "DEF_CD",				-- Shield Block
		[871] = "DEF_CD",				-- Shield Wall
		[114030] = "DEF_CD",			-- Vigilance
		
		[1719] = "OFF_CD",				-- Recklessness
		[114207] = "OFF_CD",			-- Skull Banner
		[107574] = "OFF_CD",			-- Avatar
		[12292] = "OFF_CD",				-- Blood Bath
		[46924] = "OFF_CD",				-- Blade Storm
		
		[102060] = "INTERRUPT",			-- Disrupting Shout
		[6552] = "INTERRUPT",			-- Pummel
		
		[107566] = "CC",				-- Staggering Shout
		[118000] = "CC",				-- Dragon Roar
		[5246] = "CC",					-- Intimidating Shout
		[46968] = "CC",					-- Shockwave
		[107570] = "CC",				-- Storm Bolt
		
		
		--[23881] = "MISC",				-- Blood Thirst
		[100] = "MISC",					-- Charge
		[86346] = "MISC",				-- Colossus Smash
		[6544] = "MISC",				-- Heroic Leap
		--[57755] = "MISC",				-- Heroic Throw
		[3411] = "MISC",				-- Intervene
		[114028] = "MISC",				-- Mass Spell Reflection
		--[6572] = "MISC",				-- Revenge
		[64382] = "MISC",				-- Shattering Throw
		[23922] = "MISC",				-- Shield Slam
		[23920] = "MISC",				-- Spell Reflection
		--[12328] = "MISC",				-- Sweeping Strikes
		--[6343] = "MISC",				-- Thunderclap
	},
	["CooldownClassSpecInfo"] = {
		["DEATHKNIGHT"] = {
			[0] = { -- Unskilled
				[47568] = 300,		-- Empowered Rune Weapon
				[48792] = 180,		-- Icebound Fortitude
				[77606] = 60,		-- Dark Simulacrum
				[77575] = 60,		-- Outbreak
				[47476] = 60,		-- Strangulate
				[48707] = 45,		-- Anti-Magic Shell
				[43265] = 30,		-- Death and Decay
				[49576] = 25,		-- Death Grip
				[47528] = 15,		-- Mind Freeze		
			},
			[250] = { -- Blood
				[47568] = 300,		-- Empowered Rune Weapon
				[48792] = 180,		-- Icebound Fortitude
				[49028] = 90,		-- Dancing Rune Weapon
				[49222] = 60,		-- Bone Shield
				[77606] = 60,		-- Dark Simulacrum
				[77575] = 60,		-- Outbreak
				[47476] = 60,		-- Strangulate
				[55233] = 60,		-- Vampiric Blood
				[48707] = 45,		-- Anti-Magic Shell
				[43265] = 30,		-- Death and Decay
				[48982] = {30, 2},	-- Runetap (with Enhanced Rune Tap Passive)
				[49576] = 20,		-- Death Grip (with Enhanced Death Grip Passive)
				[47528] = 15,		-- Mind Freeze
				[46584] = 60,		-- Raise dead
			},
			[251] = { -- Frost
				[47568] = 300,		-- Empowered Rune Weapon
				[48792] = 180,		-- Icebound Fortitude
				[77606] = 60,		-- Dark Simulacrum
				[51271] = 60,		-- Pillar of Frost
				[77575] = 60,		-- Outbreak
				[47476] = 60,		-- Strangulate
				[48707] = 45,		-- Anti-Magic Shell
				[43265] = 30,		-- Death and Decay
				[49576] = 25,		-- Death Grip
				[47528] = 15,		-- Mind Freeze
				[46584] = 60,		-- Raise dead
			},
			[252] = { -- Unholy
				[47568] = 300,		-- Empowered Rune Weapon
				[48792] = 180,		-- Icebound Fortitude
				[49206] = 180,		-- Summon Gargoyle
				[49016] = 180,		-- Unholy Frenzy
				[77606] = 60,		-- Dark Simulacrum
				[77575] = 60,		-- Outbreak
				[47476] = 60,		-- Strangulate
				[48707] = 45,		-- Anti-Magic Shell
				[43265] = 30,		-- Death and Decay
				[49576] = 25,		-- Death Grip
				[47528] = 15,		-- Mind Freeze
			},
		},		
		["DRUID"] = {
			[0] = {
				[1850] = 180,		-- Dash
				[106898] = 120,		-- Stampeding Roar
			},
			[102] = { -- Balance
				[112071] = 180,		-- Celestial Alignment
				[1850] = 180,		-- Dash
				[106898] = 120,		-- Stampeding Roar
				[22812] = 60,		-- Bark Skin
				[132158] = 60,		-- Nature's Swiftness
				[29166] = 180,		-- Innervate
				[106922] = 180,		-- Might of Ursoc
				[78675] = 60,		-- Solar Beam
				[48505] = 90,	-- Starfall
				[2782] = 8,			-- Remove Corruption
			},
			[103] = { -- Feral
				[106952] = 180,		-- Berserk
				[1850] = 180,		-- Dash
				[61336] = 180,		-- Survival Instincts
				[106898] = 120,		-- Stampeding Roar
				[5217] = 30,		-- Tiger's Fury
				[29166] = 180,		-- Innervate
				[106922] = 180,		-- Might of Ursoc
				[106839] = 15,		-- Skull Bash
				[2782] = 8,			-- Remove Corruption
			},
			[104] = { -- Guardian
				[106952] = 180,		-- Berserk
				[1850] = 180,		-- Dash
				[61336] = 180,		-- Survival Instincts
				[106898] = 120,		-- Stampeding Roar
				[22812] = 60,		-- Bark Skin
				[5229] = 60,		-- Enrage
				[29166] = 180,		-- Innervate
				[106922] = 180,		-- Might of Ursoc
				[106839] = 15,		-- Skull Bash
				[62606] = {12, 2}, 	-- Savage Defense
				[2782] = 8,			-- Remove Corruption
			},
			[105] = { -- Resto
				[740] = 180,		-- Tranquility (With Malfurion's Gift Passive)
				[1850] = 180,		-- Dash
				[106898] = 120,		-- Stampeding Roar
				[22812] = 60,		-- Bark Skin
				[102342] = 60,		-- Ironbark
				[106922] = 180,		-- Might of Ursoc
				[29166] = 180,		-- Innervate
				[132158] = 60,		-- Nature's Swiftness
				[18562] = 15,		-- Swiftmend
				[48438] = 8,		-- Wild Growth
				[88423] = 8,		-- Nature's Cure
			},
		},		
		["HUNTER"] = {
			[0] = { -- Unskilled
				[19263] = {180, 2},		-- Deterrence
				[51753] = 60,			-- Camouflage
				[53271] = 45,			-- Master's Call
				[5384] = 30,			-- Feign Death
				[147362] = 24,			-- Counter Shot
				[781] = 20,				-- Disengage
				[3045] = 120,			-- Rapid Fire
				[13813] = 30,			-- Explosive Trap
				[1499] = 30,			-- Freezing Trap
				[13809] = 30,			-- Ice Trap
			},
			[253] = { -- Beast Mastery
				[19263] = {180, 2},		-- Deterrence
				[19574] = 60,			-- Bestial Wrath
				[51753] = 60,			-- Camouflage
				[53271] = 45,			-- Master's Call
				[5384] = 30,			-- Feign Death
				[3045] = 120,			-- Rapid Fire
				[147362] = 24,			-- Counter Shot
				[781] = 20,				-- Disengage
				[13813] = 30,			-- Explosive Trap
				[1499] = 30,			-- Freezing Trap
				[13809] = 30,			-- Ice Trap
				[121818] = 300,			-- Stampede
			},
			[254] = { -- Marksmanship
				[19263] = {180, 2},		-- Deterrence
				[3045] = 120,			-- Rapid Fire
				[51753] = 60,			-- Camouflage
				[53271] = 45,			-- Master's Call
				[5384] = 30,			-- Feign Death
				[147362] = 24,			-- Counter Shot
				[781] = 20,				-- Disengage
				[13813] = 30,			-- Explosive Trap
				[1499] = 30,			-- Freezing Trap
				[13809] = 30,			-- Ice Trap
				[121818] = 300,			-- Stampede
			},
			[255] = { -- Survival
				[19263] = {180, 2},		-- Deterrence
				[51753] = 60,			-- Camouflage
				[3045] = 120,			-- Rapid Fire
				[53271] = 45,			-- Master's Call
				[3674] = 30,			-- Black Arrow
				[5384] = 30,			-- Feign Death
				[147362] = 24,			-- Counter Shot
				[781] = 20,				-- Disengage
				[13813] = 24,			-- Explosive Trap
				[1499] = 24,			-- Freezing Trap
				[13809] = 24,			-- Ice Trap
				[121818] = 300,			-- Stampede
			},
		},
		["MAGE"] = {
			[0] = { -- Unskilled
				[45438] = 300,			-- Ice Block
				[66] = 300,				-- Invisibility
				[122] = 30,				-- Frost Nova
				[2139] = 24,			-- Counterspell
				[1953] = 15,			-- Blink
				[120] = 12,				-- Cone of Cold
				--[2136] = 8,				-- Fireblast
				[108978] = 180,			-- Alter Time
				[55342] = 180,			-- Mirror Image
			},
			[62] = { -- Arcane
				[45438] = 300,			-- Ice Block
				[66] = 300,				-- Invisibility
				[12051] = 90,			-- Evocation (With Improved Evocation Passive)
				[12042] = 90,			-- Arcane Power
				[122] = 30,				-- Frost Nova
				[2139] = 24,			-- Counterspell
				[1953] = 15,			-- Blink
				[120] = 12,				-- Cone of Cold
				--[2136] = 8,				-- Fireblast
				[108978] = 180,			-- Alter Time
				[55342] = 180,			-- Mirror Image
			},
			[63] = { -- Fire
				[45438] = 300,			-- Ice Block
				[66] = 300,				-- Invisibility
				[11129] = 45,			-- Combustion
				[122] = 30,				-- Frost Nova
				[2139] = 24,			-- Counterspell
				[31661] = 20,			-- Dragon's Breath
				[1953] = 15,			-- Blink
				[120] = 12,				-- Cone of Cold
				[108853] = 8,			-- Inferno Blast
				[108978] = 180,			-- Alter Time
				[55342] = 180,			-- Mirror Image
			},
			[64] = { -- Frost
				[45438] = 300,			-- Ice Block
				[66] = 300,				-- Invisibility
				[12472] = 180,			-- Icy Veins
				[84714] = 60,			-- Frozen Orb
				[44572] = 30,			-- Deep Freeze
				[122] = 30,				-- Frost Nova
				[2139] = 24,			-- Counterspell
				[1953] = 15,			-- Blink
				[120] = 12,				-- Cone of Cold
				--[2136] = 8,				-- Fireblast
				[108978] = 180,			-- Alter Time
				[55342] = 180,			-- Mirror Image
			},
		},
		["MONK"] = {
			[0] = { -- Unskilled
				[115176] = 180,			-- Zen Meditation
				[115203] = 180,			-- Fortifying Brew
				[137562] = 120,			-- Nimble Brew
				[115080] = 90,			-- Touch of Death
				[119996] = 25,			-- Transcendence: Transfer
				--[109132] = {20, 2},		-- Roll
				--[115072] = 15,			-- Expel Harm
				[115078] = 15,			-- Paralysis
				[116705] = 15,			-- Spear Hand Strike
				[115450] = 8,			-- Detox
			},
			[268] = { -- Brewmaster
				[115176] = 180,			-- Zen Meditation
				[115203] = 180,			-- Fortifying Brew
				[137562] = 120,			-- Nimble Brew
				[115080] = 90,			-- Touch of Death
				[115295] = {30, 2},		-- Guard
				[115213] = 60,			-- Avert Harm
				[122057] = 25,			-- Clash
				[119996] = 25,			-- Transcendence: Transfer
				--[109132] = {20, 2},		-- Roll
				--[115072] = 15,			-- Expel Harm
				[115078] = 15,			-- Paralysis
				[116705] = 15,			-- Spear Hand Strike
				[115450] = 8,			-- Detox
			},
			[269] = { -- Windwalker
				[115176] = 180,			-- Zen Meditation
				[115203] = 180,			-- Fortifying Brew
				[137562] = 120,			-- Nimble Brew
				[122470] = 90,			-- Touch of Karma
				[115080] = 90,			-- Touch of Death
				[115288] = 60,			-- Energizing Brew
				[113656] = 25,			-- Fists of Fury
				[101545] = 25,			-- Flying Serpent Kick
				[119996] = 25,			-- Transcendence: Transfer
				--[109132] = {20, 2},		-- Roll
				--[115072] = 15,			-- Expel Harm
				[115078] = 15,			-- Paralysis
				[116705] = 15,			-- Spear Hand Strike
				[115450] = 8,			-- Detox
			},
			[270] = { -- Mistweaver
				[115176] = 180,			-- Zen Meditation
				[115310] = 180,			-- Revival
				[115203] = 180,			-- Fortifying Brew
				[137562] = 120,			-- Nimble Brew
				[116849] = 100,			-- Life Cocoon
				[115080] = 90,			-- Touch of Death
				[116680] = 45,			-- Thunder Focus Tea
				[119996] = 25,			-- Transcendence: Transfer
				--[109132] = {20, 2},		-- Roll
				--[115072] = 15,			-- Expel Harm
				[115078] = 15,			-- Paralysis
				[116705] = 15,			-- Spear Hand Strike
				[115450] = 8,			-- Detox
			},
		},		
		["PALADIN"] = {
			[0] = { -- Unskilled
				[642] = 300,			-- Divine Shield
				[1022] = 300,			-- Hand of Protection
				[6940] = 120,			-- Hand of Sacrifice
				[498] = 60,				-- Divine Protection
				[86659] = 180,			-- Guardian of the Ancient Kings
				[853] = 60,				-- Hammer of Justice
				[1044] = 25,			-- Hand of Freedom
				[96231] = 15,			-- Rebuke
			},
			[65] = { -- Holy
				[642] = 300,			-- Divine Shield
				[1022] = 300,			-- Hand of Protection
				[31842] = 180,			-- Divine Favor
				[86659] = 180,			-- Guardian of the Ancient Kings
				[31884] = 180,			-- Avenging Wrath
				[31821] = 180,			-- Devotion Aura
				[54428] = 120,			-- Divine Plea
				[6940] = 120,			-- Hand of Sacrifice
				[498] = 60,				-- Divine Protection
				[853] = 60,				-- Hammer of Justice
				[1044] = 25,			-- Hand of Freedom
				[96231] = 15,			-- Rebuke
				[4987] = 8,				-- Cleanse
			},
			[66] = { -- Protection
				[642] = 300,			-- Divine Shield
				[1022] = 300,			-- Hand of Protection
				[31850] = 180,			-- Ardent Defender
				[31884] = 180,			-- Avenging Wrath
				[86659] = 180,			-- Guardian of the Ancient Kings
				[6940] = 120,			-- Hand of Sacrifice
				[498] = 60,				-- Divine Protection
				[853] = 60,				-- Hammer of Justice
				[1044] = 25,			-- Hand of Freedom
				[96231] = 15,			-- Rebuke
			},
			[70] = { -- Retribution
				[642] = 300,			-- Divine Shield
				[1022] = 300,			-- Hand of Protection
				[31884] = 120,			-- Avenging Wrath
				[6940] = 120,			-- Hand of Sacrifice
				[498] = 60,				-- Divine Protection
				[86659] = 180,			-- Guardian of the Ancient Kings
				[853] = 60,				-- Hammer of Justice
				[1044] = 25,			-- Hand of Freedom
				[96231] = 15,			-- Rebuke
			},
		},
		["PRIEST"] = {
			[0] = { -- Unskilled
				[6346] = 180,			-- Fear Ward (Unglyhed)
				[34433] = 180,			-- Shadow Fiend
				[73325] = 90,			-- Leap of Faith
				[586] = 30,				-- Fade (Unglyhed)
				[64901] = 360,			-- Hymn of Hope
				[32375] = 15,			-- Mass Dispel (Mass Dispel only for Shadow)
				[33076] = 10,			-- Prayer of Mending
			},
			[256] = { -- Disc
				[108968] = 300,			-- Void shift
				[6346] = 180,			-- Fear Ward (Unglyhed)
				[34433] = 180,			-- Shadow Fiend
				[62618] = 180,			-- Power Word: Barrier
				[33206] = 120,			-- Pain Suppression (with Setbonus)
				[73325] = 90,			-- Leap of Faith
				[586] = 30,				-- Fade (Unglyhed)
				[64901] = 360,			-- Hymn of Hope
				[81700] = 30,			-- Archangel
				[32375] = 15,			-- Mass Dispel
				--[14914] = 10,			-- Holy Fire
				[33076] = 10,			-- Prayer of Mending
				[527] = 8,				-- Purify
				[109964] = 60,			-- Spirit Shell
				[89485] = 45,			-- Inner focus
			},
			[257] = { -- Holy
				[108968] = 300,			-- Void shift
				[6346] = 180,			-- Fear Ward (Unglyhed)
				[34433] = 180,			-- Shadow Fiend
				[64843] = 180,			-- Divine Hymn
				[126135] = 180,			-- Light Well
				[47788] = 120,			-- Guardian Spirit
				[73325] = 90,			-- Leap of Faith
				[88685] = 40,			-- Holy Word: Sanctuary
				[586] = 30,				-- Fade (Unglyhed)
				[88625] = 30,			-- Holy Word: Chastise
				[32375] = 15,			-- Mass Dispel
				[64901] = 360,			-- Hymn of Hope
				--[34861] = 10,			-- Circle of Healing
				--[14914] = 10,			-- Holy Fire
				[88684] = 10,			-- Holy Word: Serenity
				[33076] = 10,			-- Prayer of Mending
				[527] = 8,				-- Purify
			},
			[258] = { -- Shadow
				[6346] = 180,			-- Fear Ward (Unglyhed)
				[34433] = 180,			-- Shadow Fiend
				[47585] = 120,			-- Dispersion (Unglyphed)
				[73325] = 90,			-- Leap of Faith
				[64044] = 45,			-- Psychic Horror
				[64901] = 360,			-- Hymn of Hope
				[15487] = 45,			-- Silence (Unglyphed)
				[586] = 30,				-- Fade (Unglyhed)
				[32375] = 15,			-- Mass Dispel
				[33076] = 10,			-- Prayer of Mending
				[129176] = 8,			-- Shadow Word: Death
			},
		},		
		["ROGUE"] = {
			[0] = { -- Unskilled
				[114018] = 300,			-- Shroud of Concealment
				[14185] = 300,			-- Preparation
				[121471] = 180,			-- Shadow Blades
				[76577] = 180,			-- Smoke Bomb
				[2094] = 120,			-- Blind
				[5277] = 120,			-- Evasion
				[1856] = 120,			-- Vanish
				[31224] = 60,			-- Cloak of Shadows
				[2983] = 60,			-- Sprint
				[408] = 20,				-- Kidney Shot
				[1766] = 15,			-- Kick
				[1776] = 10,			-- Gouge
				[73981] = 60,			-- Redirect
				[5938] = 10,			-- Shiv
			},
			[259] = { -- Assassination
				[114018] = 300,			-- Shroud of Concealment
				[14185] = 300,			-- Preparation
				[121471] = 180,			-- Shadow Blades
				[76577] = 180,			-- Smoke Bomb
				[2094] = 120,			-- Blind
				[5277] = 120,			-- Evasion
				[1856] = 120,			-- Vanish
				[79140] = 120,			-- Vendetta
				[31224] = 60,			-- Cloak of Shadows
				[2983] = 60,			-- Sprint
				[408] = 20,				-- Kidney Shot
				[1766] = 15,			-- Kick
				[1776] = 10,			-- Gouge
				[73981] = 60,			-- Redirect
				[5938] = 10,			-- Shiv
			},
			[260] = { -- Combat
				[114018] = 300,			-- Shroud of Concealment
				[14185] = 300,			-- Preparation
				[13750] = 180,			-- Adrenaline Rush
				[121471] = 180,			-- Shadow Blades
				[76577] = 180,			-- Smoke Bomb
				[2094] = 120,			-- Blind
				[5277] = 120,			-- Evasion
				[51690] = 120,			-- Killing Spree
				[1856] = 120,			-- Vanish
				[31224] = 60,			-- Cloak of Shadows
				[2983] = 60,			-- Sprint
				[408] = 20,				-- Kidney Shot
				[1766] = 15,			-- Kick
				[1776] = 10,			-- Gouge
				[73981] = 60,			-- Redirect
				[5938] = 10,			-- Shiv
			},
			[261] = { -- Sublety
				[114018] = 300,			-- Shroud of Concealment
				[14185] = 300,			-- Preparation
				[121471] = 180,			-- Shadow Blades
				[76577] = 180,			-- Smoke Bomb
				[2094] = 120,			-- Blind
				[5277] = 120,			-- Evasion
				[1856] = 120,			-- Vanish
				[31224] = 60,			-- Cloak of Shadows
				[51713] = 60,			-- Shadow Dance
				[2983] = 60,			-- Sprint
				[408] = 20,				-- Kidney Shot
				[1766] = 15,			-- Kick
				[1776] = 10,			-- Gouge
				[73981] = 60,			-- Redirect
				[5938] = 10,			-- Shiv
			},
		},		
		["SHAMAN"] = {
			[0] = { -- Unskilled
				[2894] = 300,			-- Fire Elemental Totem
				[2062] = 300,			-- Earth Elemental Totem
				[8143] = 60,			-- Tremor Totem
				[5394] = 30,			-- Healing Stream Totem
				[2484] = 30,			-- Earthbind Totem
				[51514] = 45,			-- Hex
				[108269] = 45,			-- Capacitor Totem
				[8177] = 25,			-- Grounding Totem
				[57994] = 15,			-- Wind Shear		
				[73920] = 10,			-- Healing Rain
				[51886] = 8,			-- Cleanse Spirit
			},
			[262] = { -- Elemental
				[2894] = 300,			-- Fire Elemental Totem
				[2062] = 300,			-- Earth Elemental Totem
				[114049] = 180,			-- Ascendance
				[79206] = 120,			-- Spiritwalker's Grace
				[8143] = 60,			-- Tremor Totem
				[30823] = 60,			-- Shamanistic Rage
				[5394] = 30,			-- Healing Stream Totem
				[2484] = 30,			-- Earthbind Totem
				[51514] = 45,			-- Hex
				[108269] = 45,			-- Capacitor Totem
				[51490] = 45,			-- Thunderstorm
				[8177] = 25,			-- Grounding Totem
				[57994] = 15,			-- Wind Shear
				[73920] = 10,			-- Healing Rain
				[51886] = 8,			-- Cleanse Spirit
			},
			[263] = { -- Enhancement
				[2894] = 300,			-- Fire Elemental Totem
				[2062] = 300,			-- Earth Elemental Totem
				[114049] = 180,			-- Ascendance
				[51533] = 120,			-- Feral Spirit
				[79206] = 120,			-- Spiritwalker's Grace
				[58875] = 60,			-- Spirit Walk
				[30823] = 60,			-- Shamanistic Rage
				[8143] = 60,			-- Tremor Totem
				[5394] = 30,			-- Healing Stream Totem
				[2484] = 30,			-- Earthbind Totem
				[51514] = 45,			-- Hex
				[108269] = 45,			-- Capacitor Totem
				[8177] = 25,			-- Grounding Totem
				[57994] = 15,			-- Wind Shear
				[73920] = 10,			-- Healing Rain
				[51886] = 8,			-- Cleanse Spirit
			},
			[264] = { -- Restoration
				[2894] = 300,			-- Fire Elemental Totem
				[2062] = 300,			-- Earth Elemental Totem
				[114049] = 180,			-- Ascendance
				[108280] = 180,			-- Healing Tide Totem
				[98008] = 180,			-- Spirit Link Totem
				[16190] = 180,			-- Mana Tide Totem
				[79206] = 120,			-- Spiritwalker's Grace
				[8143] = 60,			-- Tremor Totem
				[5394] = 30,			-- Healing Stream Totem
				[2484] = 30,			-- Earthbind Totem
				[51514] = 45,			-- Hex
				[108269] = 45,			-- Capacitor Totem
				[8177] = 25,			-- Grounding Totem
				[57994] = 15,			-- Wind Shear	
				[73920] = 10,			-- Healing Rain
				[77130] = 8,			-- Purify Spirit
				--[61295] = 5,			-- Riptide (with Improved Riptide Passive)
			},
		},		
		["WARLOCK"] = {
			[0] = { -- Unskilled
				[104773] = 180,			-- Unending Resolve
				[132409] = 24,			-- Spell lock (Warlock)
			},
			[265] = { -- Affliction
				[104773] = 180,			-- Unending Resolve
				[113860] = 120,			-- Dark Soul: Misery
				[132409] = 24,			-- Spell lock (Warlock)
			},
			[266] = { -- Demonology
				[104773] = 180,			-- Unending Resolve
				[113861] = 120,			-- Dark Soul: Knowledge
				[105174] = 15,			-- Hand of Gul'dan 
				[109151] = 10,			-- Demonic Leap
				[103958] = 10,			-- Metamorphosis
				[132409] = 24,			-- Spell lock (Warlock)
			},
			[267] = { -- Destruction
				[104773] = 180,			-- Unending Resolve
				[113858] = 120,			-- Dark Soul: Instability
				[120451] = 60,			-- Flames of Xoroth
				[80240] = 20,			-- Havoc (With Enhanced Havoc Passive)
				[17962] = {12, 2},		-- Conflagrate
				[132409] = 24,			-- Spell lock (Warlock)
			},
		},		
		["WARRIOR"] = {
			[0] = { -- Unskilled
				[64382] = 300,			-- Shattering Throw
				[871] = 180,			-- Shield Wall
				[5246] = 90,			-- Intimidating Shout
				[6544] = 45,			-- Heroic Leap
				[18499] = 30,			-- Berserker Rage
				[3411] = 30,			-- Intervene
				[114207] = 180,			-- Skull Banner
				[23920] = 25,			-- Spell Reflection
				[100] = 20,				-- Charge
				[6552] = 15,			-- Pummel
				--[57755] = 6,			-- Heroic Throw
			},
			[71] = { -- Arms
				[64382] = 300,			-- Shattering Throw
				[97462] = 180,			-- Rallying Cry
				[1719] = 180,			-- Recklessness
				[114207] = 180,			-- Skull Banner
				[871] = 180,			-- Shield Wall
				[118038] = 120,			-- Die by the Sword
				[5246] = 90,			-- Intimidating Shout
				[6544] = 45,			-- Heroic Leap
				[18499] = 30,			-- Berserker Rage
				[3411] = 30,			-- Intervene
				[23920] = 25,			-- Spell Reflection
				[100] = 20,				-- Charge
				--[86346] = 20, 			-- Colossus Smash
				[6552] = 15,			-- Pummel
				[114203] = 180,			-- Demoralizing Banner
				--[12328] = 10,			-- Sweeping Strikes
				--[57755] = 30,			-- Heroic Throw
				--[6343] = 6,				-- Thunder Clap
			},
			[72] = { -- Fury
				[64382] = 300,			-- Shattering Throw
				[97462] = 180,			-- Rallying Cry
				[1719] = 180,			-- Recklessness
				[871] = 180,			-- Shield Wall
				[114207] = 180,			-- Skull Banner
				[118038] = 120,			-- Die by the Sword
				[5246] = 90,			-- Intimidating Shout
				[6544] = 45,			-- Heroic Leap
				[18499] = 30,			-- Berserker Rage
				[3411] = 30,			-- Intervene
				[23920] = 25,			-- Spell Reflection
				[100] = 20,				-- Charge
				[86346] = 20, 			-- Colossus Smash
				[6552] = 15,			-- Pummel
				[114203] = 180,			-- Demoralizing Banner
				--[57755] = 30,			-- Heroic Throw
				--[6343] = 6,				-- Thunder Clap
				--[23881] = 4.5,			-- Bloodthirst
			},
			[73] = { -- Protection
				[64382] = 300,			-- Shattering Throw
				[97462] = 180,			-- Rallying Cry
				[12975] = 180,			-- Last Stand
				[871] = 180,			-- Shield Wall
				[114207] = 180,			-- Skull Banner
				[1719] = 180,			-- Recklessness
				[5246] = 90,			-- Intimidating Shout
				[1160] = 60,			-- Demoralizing Shout
				[6544] = 45,			-- Heroic Leap
				[18499] = 30,			-- Berserker Rage
				[3411] = 30,			-- Intervene
				[23920] = 25,			-- Spell Reflection
				[100] = 20,				-- Charge
				[6552] = 15,			-- Pummel
				[114203] = 180,			-- Demoralizing Banner
				[2565] = 12,			-- Shield Block
				--[6572] = 9,				-- Revenge
				[23922] = 6,			-- Shield Slam
				--[6343] = 6,				-- Thunder Clap
			},
		},
	},
	["CooldownTalentInfo"] = {
		["DEATHKNIGHT"] = {
			[GetSpellInfo'123693'] = { -- Plague Leech
				["action"] = "ADD",
				["spellID"] = 123693,
				["value"] = 25,
			},
			[GetSpellInfo'115989'] = { -- Unholy Blight
				["action"] = "ADD",
				["spellID"] = 115989,
				["value"] = 90,
			},
			[GetSpellInfo'49039'] = { -- Lichborne
				["action"] = "ADD",
				["spellID"] = 49039,
				["value"] = 120,
			},
			[GetSpellInfo'51052'] = { -- Anti-Magic Zone
				["action"] = "ADD",
				["spellID"] = 51052,
				["value"] = 120,
			},
			[GetSpellInfo'96268'] = { -- Death's Advance
				["action"] = "ADD",
				["spellID"] = 96268,
				["value"] = 30,				
			},
			[GetSpellInfo'108194'] = { -- Asphyxiate
				["action"] = "REPLACE",
				["spellID"] = 108194,
				["replace"] = 49576,
				["value"] = 30,				
			},  
			[GetSpellInfo'48743'] = { -- Death Pact
				["action"] = "ADD",
				["spellID"] = 48743,
				["value"] = 120,				
			}, 
			[GetSpellInfo'108199'] = { -- Gorefiend's Grasp
				["action"] = "ADD",
				["spellID"] = 108199,
				["value"] = 60,				
			},
			[GetSpellInfo'108200'] = { -- Remorseless Winter
				["action"] = "ADD",
				["spellID"] = 108200,
				["value"] = 60,				
			}, 
			[GetSpellInfo'108201'] = { -- Desecrated Ground
				["action"] = "ADD",
				["spellID"] = 108201,
				["value"] = 120,				
			},
		},
		["DRUID"] = { 
			[GetSpellInfo'102280'] = { -- Displacer Beast
				["action"] = "ADD",
				["spellID"] = 102280,
				["value"] = 30,
			},
			[GetSpellInfo'132302'] = { -- Wild Charge
				["action"] = "ADD",
				["spellID"] = 132302,
				["value"] = 15,
			},  
			[GetSpellInfo'108238'] = { -- Renewal
				["action"] = "ADD",
				["spellID"] = 108238,
				["value"] = 120,
			},
			[GetSpellInfo'102351'] = { -- Cenarion Ward
				["action"] = "ADD",
				["spellID"] = 102351,
				["value"] = 30,
			},  
			[GetSpellInfo'102359'] = { -- Mass Entanglement
				["action"] = "ADD" ,
				["spellID"] = 102359,
				["value"] = 30,
			}, 
			[GetSpellInfo'132469'] = { -- Typhoon
				["action"] = "ADD",
				["spellID"] = 132469,
				["value"] = 30,
			},
			[GetSpellInfo'106731'] = { -- Incarnation
				["action"] = "ADD",
				["spellID"] = 102560,
				["value"] = 180,
			},
			[GetSpellInfo'106731'] = { -- Incarnation
				["action"] = "ADD",
				["spellID"] = 102543,
				["value"] = 180,
			},
			[GetSpellInfo'106731'] = { -- Incarnation
				["action"] = "ADD",
				["spellID"] = 102558,
				["value"] = 180,
			},
			[GetSpellInfo'106731'] = { -- Incarnation
				["action"] = "ADD",
				["spellID"] = 33891,
				["value"] = 180,
			},
			[GetSpellInfo'102693'] = { -- Force of Nature
				["action"] = "ADD",
				["spellID"] = 102693,
				["value"] = {20, 3},
			},
			[GetSpellInfo'99'] = { -- Disorienting Roar
				["action"] = "ADD",
				["spellID"] = 99,
				["value"] = 30,
			},
			[GetSpellInfo'102793'] = { -- Ursol's Vortex
				["action"] = "ADD",
				["spellID"] = 102793,
				["value"] = 60,				
			}, 
			[GetSpellInfo'5211'] = { -- Mighty Bash
				["action"] = "ADD",
				["spellID"] = 5211,
				["value"] = 50,
			},
			[GetSpellInfo'108288'] = { -- Heart of the Wild
				["action"] = "ADD",
				["spellID"] = 108291,
				["value"] = 360,
			},
			[GetSpellInfo'108288'] = { -- Heart of the Wild
				["action"] = "ADD",
				["spellID"] = 108292,
				["value"] = 360,
			},
			[GetSpellInfo'108288'] = { -- Heart of the Wild
				["action"] = "ADD",
				["spellID"] = 108293,
				["value"] = 360,
			},
			[GetSpellInfo'108288'] = { -- Heart of the Wild
				["action"] = "ADD",
				["spellID"] = 108294,
				["value"] = 360,
			},
			[GetSpellInfo'124974'] = { -- Nature's Vigil
				["action"] = "ADD",
				["spellID"] = 124974,
				["value"] = 90,
			},
		},  
		["HUNTER"] = { 
			[GetSpellInfo'118675'] = { -- Crouching Tiger, Hidden Chimaera
				["action"] = {"MODIFY_COOLDOWN", "REPLACE"},
				["spellID"] = {781, 148467},
				["replace"] = { nil, 19263},
				["value"] = {-10, {120, 2}},
			},  
			[GetSpellInfo'109248'] = { -- Binding Shot
				["action"] = "ADD",
				["spellID"] = 109248,
				["value"] = 45,				
			}, 
			[GetSpellInfo'19386'] = { -- Wyvern Sting
				["action"] = "ADD",
				["spellID"] = 19386,
				["value"] = 45,				
			}, 
			[GetSpellInfo'19577'] = { -- Intimidation
				["action"] = "ADD",
				["spellID"] = 19577,
				["value"] = 60,				
			}, 
			[GetSpellInfo'109304'] = { -- Exhilaration
				["action"] = "ADD",
				["spellID"] = 109304,
				["value"] = 120,
			},
			[GetSpellInfo'82726'] = { -- Fervor
				["action"] = "ADD",
				["spellID"] = 82726,
				["value"] = 30,
			},
			[GetSpellInfo'120679'] = { -- Dire Beast
				["action"] = "ADD",
				["spellID"] = 120679,
				["value"] = 30,
			},
			[GetSpellInfo'131894'] = { -- A Murder of Crows
				["action"] = "ADD",
				["spellID"] = 131894,
				["value"] = 120,
			},
			[GetSpellInfo'120697'] = { -- Lynx Rush
				["action"] = "ADD",
				["spellID"] = 120697,
				["value"] = 90,
			},
			[GetSpellInfo'117050'] = { -- Glaive Toss
				["action"] = "ADD",
				["spellID"] = 117050,
				["value"] = 15,				
			},
			[GetSpellInfo'109259'] = { -- Powershot
				["action"] = "ADD",
				["spellID"] = 109259,
				["value"] = 45,				
			},
			[GetSpellInfo'120360'] = { -- Barrage
				["action"] = "ADD",
				["spellID"] = 120360,
				["value"] = 30,				
			},			
		},
		["MAGE"] = {
			[GetSpellInfo'12043'] = { -- Presence of Mind
				["action"] = "ADD",
				["spellID"] = 12043,
				["value"] = 90,
			},
			[GetSpellInfo'108843'] = { -- Blazing Speed
				["action"] = "ADD",
				["spellID"] = 108843,
				["value"] = 25,
			},
			[GetSpellInfo'11426'] = { -- Ice Barrier
				["action"] = "ADD",
				["spellID"] = 11426,
				["value"] = 25,
			},
			[GetSpellInfo'115610'] = { -- Temporal Shield
				["action"] = "ADD",
				["spellID"] = 115610,
				["value"] = 25,
			},
			[GetSpellInfo'1463'] = { -- Incanter's Ward
				["action"] = "ADD",
				["spellID"] = 1463,
				["value"] = 25,
			},
			[GetSpellInfo'113724'] = { -- Ring of Frost
				["action"] = "ADD",
				["spellID"] = 113724,
				["value"] = 45,			
			},
			[GetSpellInfo'111264'] = { -- Ice Ward
				["action"] = "ADD",
				["spellID"] = 111264,
				["value"] = 20,			
			},
			[GetSpellInfo'102051'] = { -- Frostjaw
				["action"] = "ADD",
				["spellID"] = 102051,
				["value"] = 20,			
			},
			[GetSpellInfo'110959'] = { -- Greater Invisibility
				["action"] = "REPLACE",
				["spellID"] = 110959,
				["replace"] = 66,
				["value"] = 90,			
			},
			[GetSpellInfo'11958'] = { -- Cold Snap
				["action"] = "ADD",
				["spellID"] = 11958,
				["value"] = 180,			
			},
		},
		["MONK"] = {   
			-- [GetSpellInfo'115173'] = { -- Celerity
				-- ["action"] = {"MODIFY_COOLDOWN", "MODIFY_CHARGES" },
				-- ["spellID"] = {115008, 115008},
				-- ["value"] = {-5, 1},
			-- },
			[GetSpellInfo'116841'] = { -- Tiger's Lust
				["action"] = "ADD",
				["spellID"] = 116841,
				["value"] = 30,
			},
			-- [GetSpellInfo'115098'] = { -- Chi Wave
				-- ["action"] = "ADD",
				-- ["spellID"] = 115098,
				-- ["value"] = 15,
			-- },
			-- [GetSpellInfo'124081'] = { -- Zen Sphere
				-- ["action"] = "ADD",
				-- ["spellID"] = 124081,
				-- ["value"] = 10,
			-- },
			[GetSpellInfo'123986'] = { -- Chi Burst
				["action"] = "ADD",
				["spellID"] = 123986,
				["value"] = 30,
			},
			[GetSpellInfo'115399'] = { -- Chi Brew
				["action"] = "ADD",
				["spellID"] = 115399,
				["value"] = {45, 2},
			},
			[GetSpellInfo'116844'] = { -- Ring of Peace
				["action"] = "ADD",
				["spellID"] = 116844,
				["value"] = 45,			
			},
			[GetSpellInfo'119392'] = { -- Charging Ox Wave
				["action"] = "ADD",
				["spellID"] = 119392,
				["value"] = 30,			
			},
			[GetSpellInfo'119381'] = { -- Leg Sweep
				["action"] = "ADD",
				["spellID"] = 119381,
				["value"] = 45,			
			}, 
			[GetSpellInfo'122278'] = { -- Dampen Harm
				["action"] = "ADD",
				["spellID"] = 122278,
				["value"] = 90,			
			},
			[GetSpellInfo'122783'] = { -- Diffuse Magic
				["action"] = "ADD",
				["spellID"] = 122783,
				["value"] = 90,			
			},  
			-- [GetSpellInfo'116847'] = { -- Rushing Jade Wind
				-- ["action"] = "ADD",
				-- ["spellID"] = 116847,
				-- ["value"] = 6,			
			-- },
			[GetSpellInfo'123904'] = { -- Invoke Xuen, the White Tiger
				["action"] = "ADD",
				["spellID"] = 123904,
				["value"] = 180,			
			},
			-- [GetSpellInfo'115008'] = { -- Chi Torpedo
				-- ["action"] = "REPLACE",
				-- ["spellID"] = 115008,
				-- ["replace"] = 109132,
				-- ["value"] = {20, 2},			
			-- },
		},
		["PALADIN"] = {
			[GetSpellInfo'85499'] = { -- Speed of Light
				["action"] = "ADD",
				["spellID"] = 85499,
				["value"] = 45,			
			},
			[GetSpellInfo'105593'] = { -- Fist of Justice
				["action"] = "REPLACE",
				["spellID"] = 105593,
				["replace"] = 853,
				["value"] = 30,
			},
			[GetSpellInfo'20066'] = { -- Repentence
				["action"] = "ADD",
				["spellID"] = 20066,
				["value"] = 15,
			},
			[GetSpellInfo'114039'] = { -- Hand of Purity
				["action"] = "ADD",
				["spellID"] = 114039,
				["value"] = 30,
			},
			[GetSpellInfo'114154'] = { -- Unbreakable Will
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = {498, 642},
				["value"] = function(baseValue) return baseValue * 0.5; end,
			},
			[GetSpellInfo'105622'] = { -- Clemency
				["action"] = "MODIFY_CHARGES",
				["spellID"] = {1044, 1022, 6940},
				["value"] = 1,
			},
			[GetSpellInfo'105809'] = { -- Holy Avenger
				["action"] = "ADD",
				["spellID"] = 105809,
				["value"] = 120,				
			},
			[GetSpellInfo'114165'] = { -- Holy Prism
				["action"] = "ADD",
				["spellID"] = 114165,
				["value"] = 20,	
			},
			[GetSpellInfo"114158"] = { -- Light's Hammer
				["action"] = "ADD",
				["spellID"] = 114158,
				["value"] = 60,	
			},
			[GetSpellInfo'114157'] = { -- Execution Sentence
				["action"] = "ADD",
				["spellID"] = 114157,
				["value"] = 60,	
			},
		},
		["PRIEST"] = {
			[GetSpellInfo'19236'] = { -- Desperate Prayer
				["action"] = "ADD",
				["spellID"] = 19236,
				["value"] = 120,
			},
			[GetSpellInfo'112833'] = { -- Spectral Guise
				["action"] = "ADD",
				["spellID"] = 112833,
				["value"] = 30,
			},		
			[GetSpellInfo'114214'] = { -- Angelic Bulwark
				["action"] = "ADD",
				["spellID"] = 114214,
				["value"] = 90,
			},
			[GetSpellInfo'123040'] = { -- Mindbender
				["action"] = "REPLACE",
				["spellID"] = 123040,
				["replace"] = 34433,
				["value"] = 60,
			},
			[GetSpellInfo'108920'] = { -- Void Tendrils
				["action"] = "ADD",
				["spellID"] = 108920,
				["value"] = 30,
			},
			[GetSpellInfo'108921'] = { -- Psyfiend
				["action"] = "ADD",
				["spellID"] = 108921,
				["value"] = 45,
			},
			[GetSpellInfo'8122'] = { -- Psychic Scream
				["action"] = "ADD",
				["spellID"] = 8122,
				["value"] = 27,				-- With PvP-Glove Bonus
			},								
			[GetSpellInfo'10060'] = { -- Power Infusion
				["action"] = "ADD",
				["spellID"] = 10060,
				["value"] = 120,
			},
			[GetSpellInfo'121135'] = { -- Cascade
				["action"] = "ADD",
				["spellID"] = 121135,
				["value"] = 25,
			},					
			[GetSpellInfo'110744'] = { -- Divine Star
				["action"] = "ADD",
				["spellID"] = 110744,
				["value"] = 15,
			},					
			[GetSpellInfo'120517'] = { -- Halo
				["action"] = "ADD",
				["spellID"] = 120517,
				["value"] = 40,
			},					
			[GetSpellInfo'127632'] = { -- Cascade (Shadow)
				["action"] = "ADD",
				["spellID"] = 127632,
				["value"] = 25,
			},					
			[GetSpellInfo'122121'] = { -- Divine Star (Shadow)
				["action"] = "ADD",
				["spellID"] = 122121,
				["value"] = 15,
			},					
			[GetSpellInfo'120644'] = { -- Halo (Shadow)
				["action"] = "ADD",
				["spellID"] = 120644,
				["value"] = 40,
			},
		},
		["ROGUE"] = {
			[GetSpellInfo'74001'] = { -- Combat Readiness
				["action"] = "ADD",
				["spellID"] = 74001,
				["value"] = 120,
			},
			[GetSpellInfo'36554'] = { -- Shadowstep
				["action"] = "ADD",
				["spellID"] = 36554,
				["value"] = 20,
			},
			[GetSpellInfo'137619'] = { -- Marked for Death
				["action"] = "ADD",
				["spellID"] = 137619,
				["value"] = 60,
			},
		},
		["SHAMAN"] = {
			[GetSpellInfo'108270'] = { -- Stone Bulwark Totem
				["action"] = "ADD",
				["spellID"] = 108270,
				["value"] = 60,
			},
			[GetSpellInfo'108271'] = { -- Astral Shift
				["action"] = "ADD",
				["spellID"] = 108271,
				["value"] = 90,
			},
			[GetSpellInfo'51485'] = { -- Earthgrab Totem
				["action"] = "ADD",
				["spellID"] = 51485,
				["value"] = 30,
			},
			[GetSpellInfo'108273'] = { -- Windwalk Totem
				["action"] = "ADD",
				["spellID"] = 108273,
				["value"] = 10,
			}, 
			[GetSpellInfo'108285'] = { -- Call of the Elements
				["action"] = "ADD",
				["spellID"] = 108285,
				["value"] = 180,
			},
			[GetSpellInfo'108287'] = { -- Totemic Projection
				["action"] = "ADD",
				["spellID"] = 108287,
				["value"] = 10,
			}, 
			[GetSpellInfo'16166'] = { -- Elemental Mastery
				["action"] = "ADD",
				["spellID"] = 16166,
				["value"] = 90,
			},
			[GetSpellInfo'16188'] = { -- Ancestral Swiftness
				["action"] = "ADD",
				["spellID"] = 16188,
				["value"] = 90,
			},
			[GetSpellInfo'108281'] = { -- Ancestral Guidance
				["action"] = "ADD",
				["spellID"] = 108281,
				["value"] = 120,
			},
			[GetSpellInfo'117014'] = { -- Elemental Blast
				["action"] = "ADD",
				["spellID"] = 117014,
				["value"] = 12,
			},
		}, 		
		["WARLOCK"] = {
			[GetSpellInfo'108359'] = { -- Dark Regeneration
				["action"] = "ADD",
				["spellID"] = 108359,
				["value"] = 120,
			},
			[GetSpellInfo'5484'] = { -- Howl of Terror
				["action"] = "ADD",
				["spellID"] = 5484,
				["value"] = 40,
			},
			[GetSpellInfo'6789'] = { -- Mortal Coil
				["action"] = "ADD",
				["spellID"] = 6789,
				["value"] = 45,
			},
			[GetSpellInfo'30283'] = { -- Shadowfury
				["action"] = "ADD",
				["spellID"] = 30283,
				["value"] = 30,
			},
			[GetSpellInfo'108416'] = { -- Sacrificial Pact
				["action"] = "ADD",
				["spellID"] = 108416,
				["value"] = 60,
			},
			[GetSpellInfo'110913'] = { -- Dark Bargain
				["action"] = "ADD",
				["spellID"] = 110913,
				["value"] = 180,
			},
			[GetSpellInfo'111397'] = { -- Blood Horror
				["action"] = "ADD",
				["spellID"] = 111397,
				["value"] = 60,
			},
			[GetSpellInfo'108482'] = { -- Unbound Will
				["action"] = "ADD",
				["spellID"] = 108482,
				["value"] = 120,
			}, 
			[GetSpellInfo'108501'] = { -- Grimoire of Service
				["action"] = "ADD",
				["spellID"] = 108501,
				["value"] = 120,
			},
			-- [GetSpellInfo'108503'] = { -- Grimoire of Sacrifice
				-- ["action"] = "ADD",
				-- ["spellID"] = 108503,
				-- ["value"] = 30,
			-- },
			[GetSpellInfo'108505'] = { -- Archimonde's Darkness
				["action"] = "MODIFY_CHARGES",
				["spellID"] = {113861, 113860, 113858},
				["value"] = 1,
			},
			[GetSpellInfo'108508'] = { -- Mannoroth's Fury
				["action"] = "ADD",
				["spellID"] = 108508,
				["value"] = 60,
			},
		},
		["WARRIOR"] = {
			[GetSpellInfo'103826'] = { -- Juggernaut
				["action"] = "MODIFY",
				["spellID"] = 100,
				["value"] = -8,
			},
			[GetSpellInfo'103827'] = { -- Double Time
				["action"] = "MODIFY_CHARGES",
				["spellID"] = 100,
				["value"] = 1,
			},
			[GetSpellInfo'55694'] = { -- Enraged Regeneration
				["action"] = "ADD",
				["spellID"] = 55694,
				["value"] = 60,
			},  
			[GetSpellInfo'107570'] = { -- Stormbolt
				["action"] = "ADD",
				["spellID"] = 107570,
				["value"] = 30,
			},
			[GetSpellInfo'102060'] = { -- Disrupting Shout
				["action"] = "ADD",
				["spellID"] = 102060,
				["value"] = 40,
			},
			[GetSpellInfo'107566'] = { -- Staggering Shout
				["action"] = "ADD",
				["spellID"] = 107566,
				["value"] = 40,
			},
			[GetSpellInfo'46968'] = { -- Shockwave
				["action"] = "ADD",
				["spellID"] = 46968,
				["value"] = 40,
			},
			[GetSpellInfo'118000'] = { -- Dragon Roar
				["action"] = "ADD",
				["spellID"] = 118000,
				["value"] = 60,
			},
			[GetSpellInfo'114028'] = { -- Mass Spell Reflection
				["action"] = "ADD",
				["spellID"] = 114028,
				["value"] = 30,
			},
			[GetSpellInfo'114029'] = { -- Safeguard
				["action"] = "ADD",
				["spellID"] = 114029,
				["value"] = 30,
			},
			[GetSpellInfo'114030'] = { -- Vigilance
				["action"] = "ADD",
				["spellID"] = 114030,
				["value"] = 30,
			},
			[GetSpellInfo'107574'] = { -- Avatar
				["action"] = "ADD",
				["spellID"] = 107574,
				["value"] = 180,
			},
			[GetSpellInfo'12292'] = { -- Bloodbath
				["action"] = "ADD",
				["spellID"] = 12292,
				["value"] = 60,
			},
			[GetSpellInfo'46924'] = { -- Bladestorm
				["action"] = "ADD",
				["spellID"] = 46924,
				["value"] = 60,
			},
		},
	},
	["CooldownGlyphInfo"] = {
		["DEATHKNIGHT"] = {
			[63331] = { -- Glyph of Dark Simulacrum
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 77606,
				["value"] = -30,
			},
			[58673] = { -- Glyph of Icebound Fortitude
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 48792,
				["value"] = function(baseValue) return baseValue * 0.5; end,
			},
			[58686] = { -- Glyph of Mind Freeze
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 47528,
				["value"] = -1,
			},
			[59332] = { -- Glyph of Outbreak
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 77575,
				["value"] = function(baseValue) return 0; end,
			},
		},
		["DRUID"] = {
			[116216] = { -- Glyph of Skull Bash
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 106839,
				["value"] = 5,
			},
			[114223] = { -- Glyph of Survival Instincts
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 61336,
				["value"] = -60,
			},
			[59219] = { -- Glyph of Dash
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 1850,
				["value"] = -60,
			},
		},
		["HUNTER"] = {
			[119384] = { -- Glyph of Tranquilizing Shot (it adds a 10 sec cooldown to a spell normally not having a CD. That's why I use "ADD" here)
				["action"] = "ADD",
				["spellID"] = 1850,
				["value"] = 19801,
			},
		},
		["MAGE"] = {
			[62210] = { -- Glyph of Arcane Power
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 12042,
				["value"] = function(baseValue) return baseValue * 2; end,
			},
			[56368] = { -- Glyph of Combustion
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 11129,
				["value"] = function(baseValue) return baseValue * 2; end,
			},
			[115703] = { -- Glyph of Counterspell
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 2139,
				["value"] = 4,
			},
			[115703] = { -- Glyph of Frost Nova
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 122,
				["value"] = -5,
			},
		},
		["MONK"] = {
			[123761] = { -- Glyph of Mana Tea
				["action"] = "REPLACE",
				["spellID"] = 123761,
				["replace"] = 115294,
				["value"] = 10,
			},
			[123391] = { -- Glyph of Touch of Death
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 1850,
				["value"] = 120,
			},
			[123023] = { -- Glyph of Transcendence
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 119996,
				["value"] = -5,
			},
		},
		["PALADIN"] = {
			[146955] = { -- Glyph of Devotion Aura
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 31821,
				["value"] = -60,
			},
			[63223] = { -- Glyph of Divine Plea
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 54428,
				["value"] = function(baseValue) return baseValue * 0.5; end,
			},
		},
		["PRIEST"] = {
			[55678] = {	-- Glyph of Fear Ward
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 6346,
				["value"] = -60,
			},
			[63229] = { -- Glyph of Dispersion
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 47585,
				["value"] = -15,
			},
			[55688] = { -- Glyph of Psychic Horror
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 64044,
				["value"] = -10,
			},
		},
		["ROGUE"] = {
			[56805] = { -- Glyph of Kick
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 1766,
				["value"] = 4,
			},
		},
		["SHAMAN"] = {
			[55441] = { -- Glyph of Grounding Totem
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 8177,
				["value"] = 20,
			},
			[63291] = { -- Glyph of Hex
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 51514,
				["value"] = -10,
			},
			[55439] = { -- Glyph of Purge
				["action"] = "ADD",
				["spellID"] = 370,
				["value"] = 6,
			},
			-- [63273] = { -- Glyph of Riptide
				-- ["action"] = "MODIFY_COOLDOWN",
				-- ["spellID"] = 61295,
				-- ["value"] = function(baseValue) return 0; end,
			-- },
			[55454] = { -- Glyph of Spirit Walk
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 58875,
				["value"] = function(baseValue) return baseValue * 0.75; end,
			},
			[63270] = { -- Glyph of Thunder
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 63270,
				["value"] = -10,
			},
			[55451] = { -- Glyph of Wind Shear
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 57994,
				["value"] = 3,
			},
			[55455] = { -- Glyph of Disappearance
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 2894,
				["value"] = function(baseValue) return baseValue * 0.5; end,
			},
		},
		["WARLOCK"] = {
			[146964] = { -- Glyph of Unending Resolve
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 104773,
				["value"] = -60,
			},
			[146962] = { -- Glyph of Havoc
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 80240,
				["value"] = 35,
			},
			[148683] = { -- Glyph of Eternal Resolve
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 148688,
				["value"] = function(baseValue) return 0; end,
			},
			[63309] = { -- Glyph of Demonic Circle
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 48020,
				["value"] = -4,
			},
		},
		["WARRIOR"] = {
			[63325] = { -- Glyph of Death From Above
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 6544,
				["value"] = -15,
			},
			--[=[
			[63325] = { -- Glyph of Resonating Power
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 6343,
				["value"] = function(baseValue) return baseValue * 1.5; end,
			},]=]
			[63329] = { -- Glyph of Shield Wall
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 871,
				["value"] = 120,
			},
			[63328] = { -- Glyph of Spell Reflection
				["action"] = "MODIFY_COOLDOWN",
				["spellID"] = 23920,
				["value"] = -5,
			},
		},
	},
};


function ArenaLiveSpectator:GetCooldownInfo(class, infoType, id)

	local tableMod;
	if ( infoType == "glyph" ) then
		tableMod = "CooldownGlyphInfo";
	elseif ( infoType == "talent" ) then
		tableMod = "CooldownTalentInfo";
	else
		return nil;
	end

	if ( ArenaLiveSpectator.SpellDB[tableMod][class] and ArenaLiveSpectator.SpellDB[tableMod][class][id] ) then
		return ArenaLiveSpectator.SpellDB[tableMod][class][id]["action"], ArenaLiveSpectator.SpellDB[tableMod][class][id]["spellID"], ArenaLiveSpectator.SpellDB[tableMod][class][id]["value"], ArenaLiveSpectator.SpellDB[tableMod][class][id]["replace"];
	else
		return nil;
	end
end