WoW LUA Edit Macro Targets

When creating macros in World of Warcraft, you can target a specific player using `@player_name` or `target=player_name`. This addon allows the player to change the target value across all macros where the original target name is the matches what the player enters.

### WoW Macro Targeting

#### using @
*macro example*

```
#showtooltip
/cast [@omadasala] Greater Heal
```

#### using target=

*macro example*

```
#showtooltip
/cast [target=omadasala] Flash Heal
```

### Open the edit macro targets window

`/bet`
- opens the options window to type the original and new target values


### Console Commands

#### help
WIP

#### replace

`/bet replace original_name new_name` - updates macro targets without ui

*example*

`/bet replace omadasala samcarter`. Now view the updated macros:

```
#showtooltip
/cast [@samcarter] Greater Heal
```

```
#showtooltip
/cast [target=samcarter] Flash Heal
```
