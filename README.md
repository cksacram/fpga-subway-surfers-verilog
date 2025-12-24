# FPGA Subway Surfers–Style Game (Verilog + VGA) — Basys3

A real-time endless-runner game implemented on the AMD/Xilinx Artix-7 (Basys3) in **Verilog**, rendered over **VGA (640×480 @ ~60 Hz)**. You control a player across **three lanes** and **hover** to avoid incoming trains. Score increments when trains successfully pass; collisions freeze the game until reset.

## Gameplay
- **Goal:** Dodge trains as long as possible and maximize score.
- **Lanes:** 3 tracks; move left/right between lanes.
- **Hover mechanic:** Hover over the middle lane (limited energy). While hovering, the player flashes/changes color and energy drains; when not hovering, energy refills.
- **Collision:** If a train overlaps the player while not hovering, the game ends (freezes) and the player flashes until reset.
- **Cheat / God mode:** Optional switch to disable collisions.

## Controls (Basys3)
- **btnC:** Start game
- **btnL / btnR:** Move left / right (lane change)
- **btnU:** Hold to hover (only in middle lane, while energy > 0)
- **btnD:** Global reset
- **sw[3]:** God mode (immortal)

## Hardware/Display
- **VGA output:** 640×480 active region (pixel-addressed), driven by a 25 MHz pixel clock.
- **Raster scan counters:** `hCount`/`vCount` traverse an 800×525 timing grid; `Hsync`/`Vsync` are generated as active-low pulses to align each row/frame.
- **Rendering pipeline:** A display module chooses RGB values per pixel with priority (border → energy bar → player → trains → tracks → background).

## Design Highlights
### Player FSM
- One-hot encoded player state machine (idle/middle/left/right/hover).
- Debounced/clean one-cycle button pulses drive state transitions.
- Horizontal motion occurs during transitions to the next lane for smooth movement.

### Train System (Randomized)
- Multiple train FSM instances (two per lane) generate moving train rectangles.
- Train behavior: **random wait + random length** before descending.
- Randomness comes from an **8-bit LFSR**, producing:
  - Train lengths: `60 + [0..63]`
  - Wait times: `[0..127]`

### Scoring + Collision
- **score_pulse** asserted when a train crosses a score row just above the player, incrementing the 7-seg score counter.
- Collision detection checks rectangle overlap between player and any active train (unless god mode is enabled).
- Hover and collision flash effects use small counters/flip-flops for animation timing.


## How to Build (Vivado)
1. Open Vivado and create a project targeting **Basys3 (Artix-7)**.
2. Add the Verilog files from `src/`.
3. Add the Basys3 constraints file (`.xdc`) from `constraints/`.
4. Set the top module (e.g., `top_lab5.v` / your top-level).
5. Run **Synthesis → Implementation → Generate Bitstream**.
6. Program the Basys3 and connect it to a VGA monitor.

## Notes
- This project is fully synchronous and built around finite state machines and pixel-timed VGA rendering.
- The display module is the “glue” layer that combines pixel timing, animation, trains, player state, energy, collisions, and score into the final VGA output.
