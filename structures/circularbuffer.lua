--- @field private _buffer table
--- @field private _size number
--- @field private _head number
--- @field private _tail number
local circularbuffer = {}
circularbuffer.__index = circularbuffer

--- Creates a new circular buffer.
--- @param size number The size of the circular buffer.
--- @return table circularbuffer The new circular buffer.
function circularbuffer.new(size)
	local self = setmetatable({}, circularbuffer)
	self._size = size
	self._buffer = {}
	self._head = 1
	self._tail = 1
	return self
end

--- Adds a value to the circular buffer.
--- @param value any The value to add.
--- @return table circularbuffer The circular buffer.
function circularbuffer:add(value)
	self._buffer[self._head] = value
	self._head = self._head + 1
	if self._head > self._size then
		self._head = 1
	end
	if self._head == self._tail then
		self._tail = self._tail + 1
		if self._tail > self._size then
			self._tail = 1
		end
	end
	return self
end

--- Returns the number of values in the circular buffer.
--- @return number values The number of values in the circular buffer.
function circularbuffer:size()
	if self._head >= self._tail then
		return self._head - self._tail
	else
		return self._size - (self._tail - self._head)
	end
end

--- Checks if the circular buffer contains a value.
--- @param value any The value to check.
--- @return boolean contained True if the value is in the circular buffer, false otherwise.
function circularbuffer:contains(value)
	for i = self._tail, self._head - 1 do
		if self._buffer[i] == value then
			return true
		end
	end
	return false
end

--- Returns the value at the specified index.
--- @param index number The index of the value to return.
--- @return any value The value at the specified index.
function circularbuffer:get(index)
	if index < 1 or index > self:size() then
		error("Index out of bounds.")
	end
	local i = self._tail + index - 1
	if i > self._size then
		i = i - self._size
	end
	return self._buffer[i]
end

--- Returns the value at the specified index.
--- @param index number The index of the value to return.
--- @return any value The value at the specified index.
function circularbuffer:__index(index)
	if type(index) == "number" then
		return circularbuffer.get(self, index)
	else
		return circularbuffer[index]
	end
end

return circularbuffer