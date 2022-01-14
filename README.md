WoW LUA Edit Macro Targets

When creating macros in World of Warcraft, you can target a specific player using `@player_name` or `target=player_name`. This addon allows the player to change the target value across all macros where the original target name is the matches what the player enters.


### Targeting using @

*macro example*

```
#showtooltip
/cast [@omadasala] Greater Heal
```

### Targeting using target=

*macro example*

```
#showtooltip
/cast [target=omadasala] Greater Heal
```

### Commands

`/bet` - opens the options window to type the original and new target values

`/bet replace original_name new_name` - updates macro targets without ui
