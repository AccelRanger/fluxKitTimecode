# Flux Kit API Docs for direct and logging events


```
<components folder>.direct.*
<components folder>.call.functions
```

## Direct Logging Remotes

### `direct.effects`

| | |
|---|---|
| Type | `RemoteEvent` |
| Direction | Client → Server (fire) |

**Parameters**

| Name | Type | Description |
|---|---|---|
| `arg1` | `any` | Effect identifier/name |
| `arg2` | `any` | Effect argument/value |

**Invocation**
```lua
folder.direct.effects:FireServer(arg1, arg2)
```

**Behavior:** `logEvent("effects", arg1, arg2)`

---

### `direct.faders`

| | |
|---|---|
| Type | `RemoteEvent` |
| Direction | Client → Server (fire) |

**Parameters**

| Name | Type | Description |
|---|---|---|
| `arg1` | `any` | Fader identifier/name |
| `arg2` | `any` | Fader value |

**Invocation**
```lua
folder.direct.faders:FireServer(arg1, arg2)
```

**Behavior:** `logEvent("faders", arg1, arg2)`

---

### `direct.pyrotechnics`

| | |
|---|---|
| Type | `RemoteEvent` |
| Direction | Client → Server (fire) |

**Parameters**

| Name | Type | Description |
|---|---|---|
| `arg1` | `any` | Pyro identifier/name |
| `arg2` | `any` | Argument/value |
| `arg3` | `any` | Extra argument |

**Invocation**
```lua
folder.direct.pyrotechnics:FireServer(arg1, arg2, arg3)
```

**Behavior:** `logEvent("pyrotechnics", arg1, arg2, arg3)`

---

### `direct.status`

| | |
|---|---|
| Type | `RemoteEvent` |
| Direction | Client → Server (fire) |

**Parameters**

| Name | Type | Description |
|---|---|---|
| `arg1` | `any` | Status identifier/name |
| `arg2` | `any` | Status value |

**Invocation**
```lua
folder.direct.status:FireServer(arg1, arg2)
```

**Behavior:** `logEvent("status", arg1, arg2)`

---

## Call Logging Remote

### `call.functions`

| | |
|---|---|
| Type | `RemoteEvent` |
| Direction | Client → Server (fire) |

**Parameters**

| Name | Type | Description |
|---|---|---|
| `arg1` | `any` | Function identifier |
| `arg2` | `any` | Arguments passed to the function |
| `arg3` | `any` | External argument |
| `arg4` | `any` (optional) | "Functions expand" flag/data — presence toggles whether color compression runs |
| `arg5` | `{Color3}` (optional) | Table of `Color3` values, compressed via `ColourModule.compressColor3Table` before logging |

**Invocation**
```lua
-- without color data
folder.call.functions:FireServer(arg1, arg2, arg3)

-- with color data
folder.call.functions:FireServer(arg1, arg2, arg3, arg4, { Color3.new(1,0,0), Color3.new(0,1,0) })
```

**Behavior:**
```lua
if arg4 == nil then
    logEvent("functions", arg1, arg2, arg3)
else
    local compressedString = compressModule.compressColor3Table(arg5)
    logEvent("functions", arg1, arg2, arg3, arg4, compressedString)
end
```
