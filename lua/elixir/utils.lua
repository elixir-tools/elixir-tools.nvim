local M = {}

function M.safe_path(path)
	return string.gsub(path, "/", "_")
end

function M.repo_path(repo, ref)
	local x = M.safe_path(string.format("%s-%s", repo, ref or "HEAD"))

	return x
end

return M
