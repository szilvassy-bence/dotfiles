local M = {}

local function notify(msg, level)
    vim.schedule(function()
        vim.notify(msg, level or vim.log.levels.INFO, { title = "Deploy" })
    end)
end

local function current_dir_for_search(bufnr)
    local name = vim.api.nvim_buf_get_name(bufnr or 0)
    if name == "" then
        return vim.fn.getcwd()
    end
    return vim.fs.dirname(vim.fs.normalize(name))
end

local function find_deployment_file(bufnr)
    local start_dir = current_dir_for_search(bufnr)

    local found = vim.fs.find(".nvim/deploy_conf.lua", {
        path = start_dir,
        upward = true,
        type = "file",
        limit = 1,
    })[1]

    if not found then
        return nil, nil
    end

    local nvim_dir = vim.fs.dirname(found)
    local project_root = vim.fs.dirname(nvim_dir)

    return found, project_root
end

local function load_config(bufnr)
    local file, project_root = find_deployment_file(bufnr)
    if not file then
        return nil
    end

    local chunk, err = loadfile(file)
    if not chunk then
        notify("Nem sikerült betölteni: " .. file .. "\n" .. err, vim.log.levels.ERROR)
        return nil
    end

    local ok, cfg = pcall(chunk)
    if not ok then
        notify("Hibás deploy_conf.lua:\n" .. cfg, vim.log.levels.ERROR)
        return nil
    end

    if type(cfg) ~= "table" then
        notify("A deploy_conf.lua-nak egy Lua table-t kell visszaadnia", vim.log.levels.ERROR)
        return nil
    end

    if not cfg.remote or cfg.remote == "" then
        notify("A deploy_conf.lua-ból hiányzik a 'remote'", vim.log.levels.ERROR)
        return nil
    end

    cfg.project_root = project_root
    cfg.config_file = file
    cfg.rsync_args = cfg.rsync_args or {}

    return cfg
end

local function run_rsync(args, cwd, success_msg)
    vim.system(args, { cwd = cwd, text = true }, function(obj)
        if obj.code == 0 then
            notify(success_msg, vim.log.levels.INFO)
            return
        end

        local stderr = (obj.stderr or ""):gsub("%s+$", "")
        local stdout = (obj.stdout or ""):gsub("%s+$", "")
        local details = stderr ~= "" and stderr or stdout

        notify("rsync hiba (" .. obj.code .. ")\n" .. details, vim.log.levels.ERROR)
    end)
end

function M.upload_project()
    local cfg = load_config(0)
    if not cfg then
        return
    end

    local args = { "rsync" }
    vim.list_extend(args, vim.deepcopy(cfg.rsync_args))
    vim.list_extend(args, { "./", cfg.remote })

    run_rsync(args, cfg.project_root, "Project synched")
end

function M.upload_file()
    local cfg = load_config(0)
    if not cfg then
        return
    end

    local file = vim.api.nvim_buf_get_name(0)
    if file == "" then
        notify("Nincs fájl a buffer mögött", vim.log.levels.WARN)
        return
    end

    if vim.bo.buftype ~= "" then
        notify("Ez nem normál fájl buffer", vim.log.levels.WARN)
        return
    end

    local normalized = vim.fs.normalize(file)
    local rel = vim.fs.relpath(cfg.project_root, normalized)

    if not rel then
        notify("Az aktuális fájl nem a projekt gyökere alatt van", vim.log.levels.WARN)
        return
    end

    local args = { "rsync" }
    vim.list_extend(args, vim.deepcopy(cfg.rsync_args))
    vim.list_extend(args, { "--relative", "./" .. rel, cfg.remote })

    run_rsync(args, cfg.project_root, "File synched")
end

return M
