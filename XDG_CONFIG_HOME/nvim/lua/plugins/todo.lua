-- import todo-comments plugin safely
local status, todo = pcall(require, "todo-comments")
if not status then
	return
end

-- enable comment
todo.setup({})
