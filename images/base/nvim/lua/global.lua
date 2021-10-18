function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

function _G.clients()
    dump(vim.lsp.get_active_clients())
end

function _G.client(id)
    dump(vim.lsp.get_client_by_id(id));
end

function _G.install_lsp_servers()
    if os.getenv('LSP_SERVERS') then
        local servers = vim.split(os.getenv('LSP_SERVERS'), ';')
        vim.cmd('LspInstall ' .. table.concat(servers, ' '))
    else
        print('LSP_SERVERS variable is not set')
    end

end

