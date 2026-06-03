local ca = require("cellular-automaton")

ca.register_animation({
    fps  = 30,
    name = "waves",
    init = function(grid)
        grid._wave_t = 0
        -- snapshot original grid
        local rows, cols = #grid, #grid[1]
        grid._wave_orig = {}
        for i = 1, rows do
            grid._wave_orig[i] = {}
            for j = 1, cols do
                grid._wave_orig[i][j] = {
                    char     = grid[i][j].char,
                    hl_group = grid[i][j].hl_group,
                }
            end
        end
    end,
    update = function(grid)
        grid._wave_t = grid._wave_t + 0.15
        local rows = #grid
        local cols = #grid[1]
        local orig = grid._wave_orig
        local t    = grid._wave_t
        for i = 1, rows do
            for j = 1, cols do
                -- vertical offset as a function of column and time
                local offset = math.floor(math.sin(j * 0.3 + t) * 2.5)
                local src_i  = i - offset
                if src_i >= 1 and src_i <= rows then
                    grid[i][j].char     = orig[src_i][j].char
                    grid[i][j].hl_group = orig[src_i][j].hl_group
                else
                    grid[i][j].char = " "
                end
            end
        end
        return true
    end,
})

ca.register_animation({
    fps  = 20,
    name = "matrix",
    init = function(grid)
        math.randomseed(os.time())
        local cols = #grid[1]
        grid._mat_heads = {}  -- row position of each column's head
        grid._mat_speed = {}  -- how many rows to advance per frame
        grid._mat_trail = {}  -- trail length per column
        for j = 1, cols do
            grid._mat_heads[j] = math.random(1, #grid)
            grid._mat_speed[j] = math.random(1, 3)
            grid._mat_trail[j] = math.random(4, 12)
        end
        -- blank everything
        for i = 1, #grid do
            for j = 1, cols do
                grid[i][j].char = " "
            end
        end
        grid._mat_chars = {
            "0","1","2","3","4","5","6","7","8","9",
            "ア","イ","ウ","エ","オ","カ","キ","ク","ケ","コ",
            "A","B","C","D","E","F","G","H","Z",
            "|","/","\\","-","+","*","#","@","$","%",
        }
    end,
    update = function(grid)
        local rows = #grid
        local cols = #grid[1]
        local chars = grid._mat_chars
        -- fade: shift column up (drop everything down by copying from row-1)
        -- then paint head and trail
        for j = 1, cols do
            -- advance head
            for _ = 1, grid._mat_speed[j] do
                grid._mat_heads[j] = grid._mat_heads[j] + 1
                if grid._mat_heads[j] > rows + grid._mat_trail[j] then
                    grid._mat_heads[j] = 0
                    grid._mat_speed[j] = math.random(1, 3)
                    grid._mat_trail[j] = math.random(4, 12)
                end
            end

            local head = grid._mat_heads[j]
            -- paint column
            for i = 1, rows do
                local dist = head - i
                if dist == 0 then
                    -- head: bright char
                    grid[i][j].char     = chars[math.random(#chars)]
                    grid[i][j].hl_group = "String"
                elseif dist > 0 and dist <= grid._mat_trail[j] then
                    -- trail: random char, fading
                    if math.random() < 0.3 then
                        grid[i][j].char = chars[math.random(#chars)]
                    end
                    grid[i][j].hl_group = "Comment"
                else
                    grid[i][j].char     = " "
                    grid[i][j].hl_group = nil
                end
            end
        end
        return true
    end,
})

ca.register_animation({
    fps  = 25,
    name = "plasma",
    init = function(grid)
        grid._plasma_t = 0
        -- snapshot chars for palette
        grid._plasma_palette = { " ", ".", "·", ":", ";", "+", "x", "X", "#", "@" }
    end,
    update = function(grid)
        grid._plasma_t = grid._plasma_t + 0.07
        local t   = grid._plasma_t
        local rows = #grid
        local cols = #grid[1]
        local pal  = grid._plasma_palette
        local np   = #pal
        for i = 1, rows do
            for j = 1, cols do
                local v = math.sin(i * 0.3 + t)
                        + math.sin(j * 0.3 + t)
                        + math.sin((i + j) * 0.2 + t)
                        + math.sin(math.sqrt(i * i + j * j) * 0.2)
                -- v is in [-4, 4], map to [1, np]
                local idx = math.floor((v + 4) / 8 * (np - 1)) + 1
                idx = math.max(1, math.min(np, idx))
                grid[i][j].char = pal[idx]
            end
        end
        return true
    end,
})

ca.register_animation({
    fps  = 20,
    name = "earthquake",
    init = function(grid)
        math.randomseed(os.time())
        grid._quake_frame = 0
        -- snapshot
        local rows, cols = #grid, #grid[1]
        grid._quake_orig = {}
        for i = 1, rows do
            grid._quake_orig[i] = {}
            for j = 1, cols do
                grid._quake_orig[i][j] = {
                    char     = grid[i][j].char,
                    hl_group = grid[i][j].hl_group,
                }
            end
        end
    end,
    update = function(grid)
        grid._quake_frame = grid._quake_frame + 1
        local frame = grid._quake_frame
        local rows  = #grid
        local cols  = #grid[1]
        local orig  = grid._quake_orig
        -- intensity decreases over time
        local intensity = math.max(0, 8 - math.floor(frame / 10))
        if intensity == 0 then
            -- restore
            for i = 1, rows do
                for j = 1, cols do
                    grid[i][j].char     = orig[i][j].char
                    grid[i][j].hl_group = orig[i][j].hl_group
                end
            end
            return false
        end
        for i = 1, rows do
            local shift = math.random(-intensity, intensity)
            for j = 1, cols do
                local src = j - shift
                if src >= 1 and src <= cols then
                    grid[i][j].char     = orig[i][src].char
                    grid[i][j].hl_group = orig[i][src].hl_group
                else
                    grid[i][j].char = " "
                end
            end
        end
        return true
    end,
})

ca.register_animation({
    fps  = 25,
    name = "ripple",
    init = function(grid)
        math.randomseed(os.time())
        grid._rip_t  = 0
        local rows, cols = #grid, #grid[1]
        grid._rip_cx = math.random(math.floor(cols * 0.2), math.floor(cols * 0.8))
        grid._rip_cy = math.random(math.floor(rows * 0.2), math.floor(rows * 0.8))
        -- snapshot
        grid._rip_orig = {}
        for i = 1, rows do
            grid._rip_orig[i] = {}
            for j = 1, cols do
                grid._rip_orig[i][j] = {
                    char     = grid[i][j].char,
                    hl_group = grid[i][j].hl_group,
                }
            end
        end
    end,
    update = function(grid)
        grid._rip_t = grid._rip_t + 0.2
        local t    = grid._rip_t
        local rows = #grid
        local cols = #grid[1]
        local cx   = grid._rip_cx
        local cy   = grid._rip_cy
        local orig = grid._rip_orig
        for i = 1, rows do
            for j = 1, cols do
                local dx   = j - cx
                local dy   = i - cy
                local dist = math.sqrt(dx * dx + dy * dy)
                -- radial displacement: sine wave emanating outward
                local disp = math.floor(math.sin(dist * 0.5 - t) * 2)
                -- sample from displaced position
                local angle = math.atan(dy, dx)
                local si    = math.floor(i + disp * math.sin(angle) + 0.5)
                local sj    = math.floor(j + disp * math.cos(angle) + 0.5)
                if si >= 1 and si <= rows and sj >= 1 and sj <= cols then
                    grid[i][j].char     = orig[si][sj].char
                    grid[i][j].hl_group = orig[si][sj].hl_group
                else
                    grid[i][j].char = " "
                end
            end
        end
        return true
    end,
})

ca.register_animation({
    fps  = 30,
    name = "gravity",
    update = function(grid)
        local rows = #grid
        local cols = #grid[1]
        local moved = false
        -- scan bottom-up so falling chars don't collide with themselves
        for i = rows - 1, 1, -1 do
            for j = 1, cols do
                if grid[i][j].char ~= " " and grid[i + 1][j].char == " " then
                    grid[i + 1][j].char     = grid[i][j].char
                    grid[i + 1][j].hl_group = grid[i][j].hl_group
                    grid[i][j].char         = " "
                    moved = true
                end
            end
        end
        return moved
    end,
})

ca.register_animation({
    fps  = 25,
    name = "vortex",
    init = function(grid)
        grid._vortex_t = 0
        local rows, cols = #grid, #grid[1]
        grid._vortex_orig = {}
        for i = 1, rows do
            grid._vortex_orig[i] = {}
            for j = 1, cols do
                grid._vortex_orig[i][j] = {
                    char     = grid[i][j].char,
                    hl_group = grid[i][j].hl_group,
                }
            end
        end
    end,
    update = function(grid)
        grid._vortex_t = grid._vortex_t + 0.08
        local t    = grid._vortex_t
        local rows = #grid
        local cols = #grid[1]
        local orig = grid._vortex_orig

        local tile_w = 96    -- vortex size/spacing in columns (smaller = more vortices)
        local tile_h = 48     -- vortex size/spacing in rows
        local R      = tile_w / 2   -- influence radius (visual units)
        local speed  = 1.2

        for i = 1, rows do
            for j = 1, cols do
                -- centre of the tile this cell sits in
                local tcol = math.floor((j - 1) / tile_w)
                local trow = math.floor((i - 1) / tile_h)
                local cx   = tcol * tile_w + tile_w / 2 + 0.5
                local cy   = trow * tile_h + tile_h / 2 + 0.5

                -- offset in visual units (rows count double: cells are ~2x tall)
                local vx = j - cx
                local vy = (i - cy) * 2
                local r  = math.sqrt(vx * vx + vy * vy)

                local fall = 1 - r / R
                if fall <= 0 then
                    -- outside this vortex's reach: leave untouched (seamless seams)
                    grid[i][j].char     = orig[i][j].char
                    grid[i][j].hl_group = orig[i][j].hl_group
                else
                    local dir   = ((tcol + trow) % 2 == 0) and 1 or -1
                    local angle = dir * t * speed * fall * fall  -- strongest at centre
                    local cosA  = math.cos(angle)
                    local sinA  = math.sin(angle)
                    local sx    = vx * cosA - vy * sinA
                    local sy    = vx * sinA + vy * cosA
                    local src_j = math.floor(cx + sx + 0.5)
                    local src_i = math.floor(cy + sy / 2 + 0.5)
                    if src_i >= 1 and src_i <= rows and src_j >= 1 and src_j <= cols then
                        grid[i][j].char     = orig[src_i][src_j].char
                        grid[i][j].hl_group = orig[src_i][src_j].hl_group
                    else
                        grid[i][j].char = " "
                    end
                end
            end
        end
        return true
    end,
})

ca.register_animation({
    fps  = 25,
    name = "fire",
    init = function(grid)
        math.randomseed(os.time())
        local rows, cols = #grid, #grid[1]
        -- heat map
        grid._fire_heat = {}
        for i = 1, rows do
            grid._fire_heat[i] = {}
            for j = 1, cols do
                grid._fire_heat[i][j] = 0
            end
        end
        -- seed bottom row
        for j = 1, cols do
            grid._fire_heat[rows][j] = 255
        end
        grid._fire_chars = { " ", ".", "·", ":", ";", "^", "x", "X", "#", "@", "█" }
    end,
    update = function(grid)
        local rows  = #grid
        local cols  = #grid[1]
        local heat  = grid._fire_heat
        local chars = grid._fire_chars
        local nc    = #chars

        -- re-seed bottom row randomly
        for j = 1, cols do
            heat[rows][j] = math.max(200, heat[rows][j] - math.random(0, 20))
        end

        -- propagate upward
        for i = 1, rows - 1 do
            for j = 1, cols do
                local sum = heat[i + 1][j]
                local cnt = 1
                if j > 1    then sum = sum + heat[i + 1][j - 1]; cnt = cnt + 1 end
                if j < cols then sum = sum + heat[i + 1][j + 1]; cnt = cnt + 1 end
                if i > 1    then sum = sum + heat[i + 1][j];     cnt = cnt + 1 end
                heat[i][j] = math.max(0, math.floor(sum / cnt) - math.random(0, 15))
            end
        end

        -- render
        for i = 1, rows do
            for j = 1, cols do
                local h   = heat[i][j]
                local idx = math.floor(h / 255 * (nc - 1)) + 1
                idx = math.max(1, math.min(nc, idx))
                grid[i][j].char = chars[idx]
                if h > 180 then
                    grid[i][j].hl_group = "ErrorMsg"
                elseif h > 100 then
                    grid[i][j].hl_group = "WarningMsg"
                elseif h > 50 then
                    grid[i][j].hl_group = "String"
                else
                    grid[i][j].hl_group = "Comment"
                end
            end
        end
        return true
    end,
})

ca.register_animation({
    fps  = 20,
    name = "scramble_sort",
    init = function(grid)
        math.randomseed(os.time())
        local rows, cols = #grid, #grid[1]
        -- flatten to 1D
        local flat = {}
        for i = 1, rows do
            for j = 1, cols do
                table.insert(flat, {
                    char     = grid[i][j].char,
                    hl_group = grid[i][j].hl_group,
                })
            end
        end
        -- shuffle
        for k = #flat, 2, -1 do
            local r = math.random(k)
            flat[k], flat[r] = flat[r], flat[k]
        end
        grid._ss_flat    = flat
        grid._ss_rows    = rows
        grid._ss_cols    = cols
        grid._ss_phase   = "chaos"  -- chaos → sorting
        grid._ss_frame   = 0
        grid._ss_ptr     = 1
    end,
    update = function(grid)
        local flat  = grid._ss_flat
        local rows  = grid._ss_rows
        local cols  = grid._ss_cols

        grid._ss_frame = grid._ss_frame + 1

        if grid._ss_phase == "chaos" and grid._ss_frame > 15 then
            grid._ss_phase = "sorting"
        end

        if grid._ss_phase == "chaos" then
            -- random swaps
            for _ = 1, 10 do
                local a = math.random(#flat)
                local b = math.random(#flat)
                flat[a], flat[b] = flat[b], flat[a]
            end
        else
            -- bubble sort passes, a few swaps per frame
            local swapped = false
            local passes  = 0
            local ptr     = grid._ss_ptr
            for _ = 1, 20 do
                if ptr >= #flat then
                    ptr = 1
                    passes = passes + 1
                    if passes > 2 then break end
                end
                local a = flat[ptr]
                local b = flat[ptr + 1]
                if a.char > b.char then
                    flat[ptr], flat[ptr + 1] = flat[ptr + 1], flat[ptr]
                    swapped = true
                end
                ptr = ptr + 1
            end
            grid._ss_ptr = ptr
            if not swapped and passes > 0 then
                -- sorted — write back and stop
                local idx = 1
                for i = 1, rows do
                    for j = 1, cols do
                        grid[i][j].char     = flat[idx].char
                        grid[i][j].hl_group = flat[idx].hl_group
                        idx = idx + 1
                    end
                end
                return false
            end
        end

        -- write flat back to grid
        local idx = 1
        for i = 1, rows do
            for j = 1, cols do
                grid[i][j].char     = flat[idx].char
                grid[i][j].hl_group = flat[idx].hl_group
                idx = idx + 1
            end
        end
        return true
    end,
})

local ca = require("cellular-automaton")

ca.register_animation({
    fps  = 20,
    name = "cyclic",
    init = function(grid)
        local rows, cols = #grid, #grid[1]
        -- assign integer levels based on whether cell has char
        math.randomseed(os.time())
        for i = 1, rows do
            for j = 1, cols do
                grid[i][j]._cy = math.random(0, 15)
                grid[i][j]._cy_char = grid[i][j].char
                grid[i][j]._cy_hl   = grid[i][j].hl_group
            end
        end
    end,
    update = function(grid)
        local rows = #grid
        local cols = #grid[1]
        local STATES = 16
        local snap = {}
        for i = 1, rows do
            snap[i] = {}
            for j = 1, cols do
                snap[i][j] = grid[i][j]._cy or 0
            end
        end
        for i = 1, rows do
            for j = 1, cols do
                local next_state = (snap[i][j] + 1) % STATES
                local should_advance = false
                for di = -1, 1 do
                    for dj = -1, 1 do
                        if not (di == 0 and dj == 0) then
                            local ni, nj = i + di, j + dj
                            if ni >= 1 and ni <= rows and nj >= 1 and nj <= cols then
                                if snap[ni][nj] == next_state then
                                    should_advance = true
                                    break
                                end
                            end
                        end
                    end
                    if should_advance then break end
                end
                if should_advance then
                    grid[i][j]._cy = next_state
                    -- visible on even states, space on odd — creates wave look
                    if next_state % 2 == 0 then
                        grid[i][j].char     = grid[i][j]._cy_char ~= " " and grid[i][j]._cy_char or "~"
                        grid[i][j].hl_group = grid[i][j]._cy_hl
                    else
                        grid[i][j].char = " "
                    end
                end
            end
        end
        return true
    end,
})

-- ─────────────────────────────────────────────────────────────
-- 4. DISSOLVE
--    Cells randomly disappear each frame, probability
--    increasing over time. Code evaporates.
-- ─────────────────────────────────────────────────────────────
ca.register_animation({
    fps  = 30,
    name = "dissolve",
    init = function(grid)
        grid._dissolve_frame = 0
        math.randomseed(os.time())
    end,
    update = function(grid)
        grid._dissolve_frame = (grid._dissolve_frame or 0) + 1
        local prob = math.min(0.02 * grid._dissolve_frame, 0.95)
        local rows = #grid
        local cols = #grid[1]
        local any_left = false
        for i = 1, rows do
            for j = 1, cols do
                if grid[i][j].char ~= " " then
                    if math.random() < prob then
                        grid[i][j].char = " "
                    else
                        any_left = true
                    end
                end
            end
        end
        return any_left
    end,
})

-- ─────────────────────────────────────────────────────────────
-- 5. STARFIELD
--    Characters drift upward, density decreasing.
--    Looks like the buffer is flying into space.
-- ─────────────────────────────────────────────────────────────
ca.register_animation({
    fps  = 20,
    name = "starfield",
    init = function(grid)
        math.randomseed(os.time())
    end,
    update = function(grid)
        local rows = #grid
        local cols = #grid[1]
        -- shift everything up by one row
        for i = 1, rows - 1 do
            for j = 1, cols do
                grid[i][j].char     = grid[i + 1][j].char
                grid[i][j].hl_group = grid[i + 1][j].hl_group
            end
        end
        -- bottom row: randomly keep some chars as "stars", rest space
        for j = 1, cols do
            if math.random() < 0.05 then
                -- keep original bottom char or use star chars
                local stars = { ".", "*", "+", "·", "✦" }
                grid[rows][j].char = stars[math.random(#stars)]
            else
                grid[rows][j].char = " "
            end
        end
        return true
    end,
})

-- ─────────────────────────────────────────────────────────────
-- 6. LANGTON'S ANT
--    Single ant walks the grid, flips cells black/white.
--    Creates chaos then suddenly ordered highways.
-- ─────────────────────────────────────────────────────────────
ca.register_animation({
    fps  = 30,
    name = "langtons_ant",
    init = function(grid)
        local rows, cols = #grid, #grid[1]
        -- ant state
        grid._ant = {
            r   = math.floor(rows / 2),
            c   = math.floor(cols / 2),
            dir = 0, -- 0=up 1=right 2=down 3=left
        }
        -- track which cells are "flipped" (originally space → filled or vice versa)
        grid._ant_flipped = {}
        for i = 1, rows do
            grid._ant_flipped[i] = {}
            for j = 1, cols do
                grid._ant_flipped[i][j] = false
                grid._ant_origchar = grid._ant_origchar or {}
                if not grid._ant_origchar[i] then grid._ant_origchar[i] = {} end
                grid._ant_origchar[i][j] = grid[i][j].char
            end
        end
    end,
    update = function(grid)
        local rows = #grid
        local cols = #grid[1]
        local ant = grid._ant
        local flipped = grid._ant_flipped
        local origchar = grid._ant_origchar

        -- run several steps per frame so it's visually interesting
        for _ = 1, 5 do
            local r, c = ant.r, ant.c
            local is_white = not flipped[r][c]

            if is_white then
                -- turn right
                ant.dir = (ant.dir + 1) % 4
            else
                -- turn left
                ant.dir = (ant.dir + 3) % 4
            end

            -- flip cell
            flipped[r][c] = not flipped[r][c]
            if flipped[r][c] then
                local ch = origchar[r][c]
                grid[r][c].char = ch ~= " " and ch or "░"
            else
                grid[r][c].char = origchar[r][c]
            end

            -- move
            local dr = { -1, 0, 1, 0 }
            local dc = { 0, 1, 0, -1 }
            ant.r = ((ant.r - 1 + dr[ant.dir + 1]) % rows) + 1
            ant.c = ((ant.c - 1 + dc[ant.dir + 1]) % cols) + 1
        end

        -- mark ant position
        grid[ant.r][ant.c].char = "▸"

        return true
    end,
})


vim.keymap.set("n", "<leader>za", "<cmd>CellularAutomaton waves<CR>",         { desc = "Waves" })
vim.keymap.set("n", "<leader>zb", "<cmd>CellularAutomaton matrix<CR>",        { desc = "Matrix" })
vim.keymap.set("n", "<leader>zc", "<cmd>CellularAutomaton plasma<CR>",        { desc = "Plasma" })
vim.keymap.set("n", "<leader>zd", "<cmd>CellularAutomaton earthquake<CR>",    { desc = "Earthquake" })
vim.keymap.set("n", "<leader>ze", "<cmd>CellularAutomaton make_it_rain<CR>",  { desc = "Make it rain" })
vim.keymap.set("n", "<leader>zf", "<cmd>CellularAutomaton ripple<CR>",        { desc = "Ripple" })
vim.keymap.set("n", "<leader>zg", "<cmd>CellularAutomaton gravity<CR>",       { desc = "Gravity" })
vim.keymap.set("n", "<leader>zh", "<cmd>CellularAutomaton vortex<CR>",        { desc = "Vortex" })
vim.keymap.set("n", "<leader>zi", "<cmd>CellularAutomaton fire<CR>",          { desc = "Fire" })
vim.keymap.set("n", "<leader>zj", "<cmd>CellularAutomaton scramble_sort<CR>", { desc = "Scramble Sort" })
vim.keymap.set("n", "<leader>zk", "<cmd>CellularAutomaton langtons_ant<CR>",  { desc = "Langton's Ant" })
vim.keymap.set("n", "<leader>zl", "<cmd>CellularAutomaton game_of_life<CR>",  { desc = "GoL" })
vim.keymap.set("n", "<leader>zm", "<cmd>CellularAutomaton cyclic<CR>",        { desc = "Cyclic" })
vim.keymap.set("n", "<leader>zn", "<cmd>CellularAutomaton dissolve<CR>",      { desc = "Dissolve" })
vim.keymap.set("n", "<leader>zo", "<cmd>CellularAutomaton starfield<CR>",     { desc = "Starfield" })

