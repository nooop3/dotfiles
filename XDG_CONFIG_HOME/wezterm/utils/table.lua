local M = {}

M.merge_table = function(table1, table2)
	for _, value in ipairs(table2) do
		table1[#table1 + 1] = value
	end
	return table1
end

return M
