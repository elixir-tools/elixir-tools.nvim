local M = {}

function M.safe_path(path)
	return string.gsub(path, "/", "_")
end

function M.repo_path(repo, branch)
	local x = M.safe_path(string.format("%s-%s", repo, branch or "HEAD"))

	return x
end

return M
