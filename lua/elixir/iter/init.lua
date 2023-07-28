-- This entire file is copied from the Neovim source code and is used to polyfill
-- the vim.iter module.
-- The license belongs to them
-- Copyright Neovim contributors. All rights reserved.

-- Neovim is licensed under the terms of the Apache 2.0 license, except for
-- parts of Neovim that were contributed under the Vim license (see below).

-- Neovim's license follows:

-- ====
--                                  Apache License
--                            Version 2.0, January 2004
--                         https://www.apache.org/licenses/

--    TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

--    1. Definitions.

--       "License" shall mean the terms and conditions for use, reproduction,
--       and distribution as defined by Sections 1 through 9 of this document.

--       "Licensor" shall mean the copyright owner or entity authorized by
--       the copyright owner that is granting the License.

--       "Legal Entity" shall mean the union of the acting entity and all
--       other entities that control, are controlled by, or are under common
--       control with that entity. For the purposes of this definition,
--       "control" means (i) the power, direct or indirect, to cause the
--       direction or management of such entity, whether by contract or
--       otherwise, or (ii) ownership of fifty percent (50%) or more of the
--       outstanding shares, or (iii) beneficial ownership of such entity.

--       "You" (or "Your") shall mean an individual or Legal Entity
--       exercising permissions granted by this License.

--       "Source" form shall mean the preferred form for making modifications,
--       including but not limited to software source code, documentation
--       source, and configuration files.

--       "Object" form shall mean any form resulting from mechanical
--       transformation or translation of a Source form, including but
--       not limited to compiled object code, generated documentation,
--       and conversions to other media types.

--       "Work" shall mean the work of authorship, whether in Source or
--       Object form, made available under the License, as indicated by a
--       copyright notice that is included in or attached to the work
--       (an example is provided in the Appendix below).

--       "Derivative Works" shall mean any work, whether in Source or Object
--       form, that is based on (or derived from) the Work and for which the
--       editorial revisions, annotations, elaborations, or other modifications
--       represent, as a whole, an original work of authorship. For the purposes
--       of this License, Derivative Works shall not include works that remain
--       separable from, or merely link (or bind by name) to the interfaces of,
--       the Work and Derivative Works thereof.

--       "Contribution" shall mean any work of authorship, including
--       the original version of the Work and any modifications or additions
--       to that Work or Derivative Works thereof, that is intentionally
--       submitted to Licensor for inclusion in the Work by the copyright owner
--       or by an individual or Legal Entity authorized to submit on behalf of
--       the copyright owner. For the purposes of this definition, "submitted"
--       means any form of electronic, verbal, or written communication sent
--       to the Licensor or its representatives, including but not limited to
--       communication on electronic mailing lists, source code control systems,
--       and issue tracking systems that are managed by, or on behalf of, the
--       Licensor for the purpose of discussing and improving the Work, but
--       excluding communication that is conspicuously marked or otherwise
--       designated in writing by the copyright owner as "Not a Contribution."

--       "Contributor" shall mean Licensor and any individual or Legal Entity
--       on behalf of whom a Contribution has been received by Licensor and
--       subsequently incorporated within the Work.

--    2. Grant of Copyright License. Subject to the terms and conditions of
--       this License, each Contributor hereby grants to You a perpetual,
--       worldwide, non-exclusive, no-charge, royalty-free, irrevocable
--       copyright license to reproduce, prepare Derivative Works of,
--       publicly display, publicly perform, sublicense, and distribute the
--       Work and such Derivative Works in Source or Object form.

--    3. Grant of Patent License. Subject to the terms and conditions of
--       this License, each Contributor hereby grants to You a perpetual,
--       worldwide, non-exclusive, no-charge, royalty-free, irrevocable
--       (except as stated in this section) patent license to make, have made,
--       use, offer to sell, sell, import, and otherwise transfer the Work,
--       where such license applies only to those patent claims licensable
--       by such Contributor that are necessarily infringed by their
--       Contribution(s) alone or by combination of their Contribution(s)
--       with the Work to which such Contribution(s) was submitted. If You
--       institute patent litigation against any entity (including a
--       cross-claim or counterclaim in a lawsuit) alleging that the Work
--       or a Contribution incorporated within the Work constitutes direct
--       or contributory patent infringement, then any patent licenses
--       granted to You under this License for that Work shall terminate
--       as of the date such litigation is filed.

--    4. Redistribution. You may reproduce and distribute copies of the
--       Work or Derivative Works thereof in any medium, with or without
--       modifications, and in Source or Object form, provided that You
--       meet the following conditions:

--       (a) You must give any other recipients of the Work or
--           Derivative Works a copy of this License; and

--       (b) You must cause any modified files to carry prominent notices
--           stating that You changed the files; and

--       (c) You must retain, in the Source form of any Derivative Works
--           that You distribute, all copyright, patent, trademark, and
--           attribution notices from the Source form of the Work,
--           excluding those notices that do not pertain to any part of
--           the Derivative Works; and

--       (d) If the Work includes a "NOTICE" text file as part of its
--           distribution, then any Derivative Works that You distribute must
--           include a readable copy of the attribution notices contained
--           within such NOTICE file, excluding those notices that do not
--           pertain to any part of the Derivative Works, in at least one
--           of the following places: within a NOTICE text file distributed
--           as part of the Derivative Works; within the Source form or
--           documentation, if provided along with the Derivative Works; or,
--           within a display generated by the Derivative Works, if and
--           wherever such third-party notices normally appear. The contents
--           of the NOTICE file are for informational purposes only and
--           do not modify the License. You may add Your own attribution
--           notices within Derivative Works that You distribute, alongside
--           or as an addendum to the NOTICE text from the Work, provided
--           that such additional attribution notices cannot be construed
--           as modifying the License.

--       You may add Your own copyright statement to Your modifications and
--       may provide additional or different license terms and conditions
--       for use, reproduction, or distribution of Your modifications, or
--       for any such Derivative Works as a whole, provided Your use,
--       reproduction, and distribution of the Work otherwise complies with
--       the conditions stated in this License.

--    5. Submission of Contributions. Unless You explicitly state otherwise,
--       any Contribution intentionally submitted for inclusion in the Work
--       by You to the Licensor shall be under the terms and conditions of
--       this License, without any additional terms or conditions.
--       Notwithstanding the above, nothing herein shall supersede or modify
--       the terms of any separate license agreement you may have executed
--       with Licensor regarding such Contributions.

--    6. Trademarks. This License does not grant permission to use the trade
--       names, trademarks, service marks, or product names of the Licensor,
--       except as required for reasonable and customary use in describing the
--       origin of the Work and reproducing the content of the NOTICE file.

--    7. Disclaimer of Warranty. Unless required by applicable law or
--       agreed to in writing, Licensor provides the Work (and each
--       Contributor provides its Contributions) on an "AS IS" BASIS,
--       WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
--       implied, including, without limitation, any warranties or conditions
--       of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
--       PARTICULAR PURPOSE. You are solely responsible for determining the
--       appropriateness of using or redistributing the Work and assume any
--       risks associated with Your exercise of permissions under this License.

--    8. Limitation of Liability. In no event and under no legal theory,
--       whether in tort (including negligence), contract, or otherwise,
--       unless required by applicable law (such as deliberate and grossly
--       negligent acts) or agreed to in writing, shall any Contributor be
--       liable to You for damages, including any direct, indirect, special,
--       incidental, or consequential damages of any character arising as a
--       result of this License or out of the use or inability to use the
--       Work (including but not limited to damages for loss of goodwill,
--       work stoppage, computer failure or malfunction, or any and all
--       other commercial damages or losses), even if such Contributor
--       has been advised of the possibility of such damages.

--    9. Accepting Warranty or Additional Liability. While redistributing
--       the Work or Derivative Works thereof, You may choose to offer,
--       and charge a fee for, acceptance of support, warranty, indemnity,
--       or other liability obligations and/or rights consistent with this
--       License. However, in accepting such obligations, You may act only
--       on Your own behalf and on Your sole responsibility, not on behalf
--       of any other Contributor, and only if You agree to indemnify,
--       defend, and hold each Contributor harmless for any liability
--       incurred by, or claims asserted against, such Contributor by reason
--       of your accepting any such warranty or additional liability.

-- ====

-- The above license applies to all parts of Neovim except (1) parts that were
-- contributed under the Vim license and (2) externally maintained libraries.

-- The externally maintained libraries used by Neovim are:

--   - Klib: a Generic Library in C. MIT/X11 license.
--   - Lua: MIT license
--   - LuaJIT: a Just-In-Time Compiler for Lua. Copyright Mike Pall. MIT license.
--   - Luv: Apache 2.0 license
--   - libmpack: MIT license
--   - libtermkey: MIT license
--   - libuv. Copyright Joyent, Inc. and other Node contributors. Node.js license.
--   - libvterm: MIT license
--   - lua-cjson: MIT license
--   - lua-compat: MIT license
--   - tree-sitter: MIT license
--   - unibilium: LGPL v3
--   - xdiff: LGPL v2

-- ====

-- Any parts of Neovim that were contributed under the Vim license are licensed
-- under the Vim license unless the copyright holder gave permission to license
-- those contributions under the Apache 2.0 license.

-- The Vim license follows:

-- VIM LICENSE

-- I)  There are no restrictions on distributing unmodified copies of Vim except
--     that they must include this license text.  You can also distribute
--     unmodified parts of Vim, likewise unrestricted except that they must
--     include this license text.  You are also allowed to include executables
--     that you made from the unmodified Vim sources, plus your own usage
--     examples and Vim scripts.

-- II) It is allowed to distribute a modified (or extended) version of Vim,
--     including executables and/or source code, when the following four
--     conditions are met:
--     1) This license text must be included unmodified.
--     2) The modified Vim must be distributed in one of the following five ways:
--        a) If you make changes to Vim yourself, you must clearly describe in
-- 	  the distribution how to contact you.  When the maintainer asks you
-- 	  (in any way) for a copy of the modified Vim you distributed, you
-- 	  must make your changes, including source code, available to the
-- 	  maintainer without fee.  The maintainer reserves the right to
-- 	  include your changes in the official version of Vim.  What the
-- 	  maintainer will do with your changes and under what license they
-- 	  will be distributed is negotiable.  If there has been no negotiation
-- 	  then this license, or a later version, also applies to your changes.
-- 	  The current maintainer is Bram Moolenaar <Bram@vim.org>.  If this
-- 	  changes it will be announced in appropriate places (most likely
-- 	  vim.sf.net, www.vim.org and/or comp.editors).  When it is completely
-- 	  impossible to contact the maintainer, the obligation to send him
-- 	  your changes ceases.  Once the maintainer has confirmed that he has
-- 	  received your changes they will not have to be sent again.
--        b) If you have received a modified Vim that was distributed as
-- 	  mentioned under a) you are allowed to further distribute it
-- 	  unmodified, as mentioned at I).  If you make additional changes the
-- 	  text under a) applies to those changes.
--        c) Provide all the changes, including source code, with every copy of
-- 	  the modified Vim you distribute.  This may be done in the form of a
-- 	  context diff.  You can choose what license to use for new code you
-- 	  add.  The changes and their license must not restrict others from
-- 	  making their own changes to the official version of Vim.
--        d) When you have a modified Vim which includes changes as mentioned
-- 	  under c), you can distribute it without the source code for the
-- 	  changes if the following three conditions are met:
-- 	  - The license that applies to the changes permits you to distribute
-- 	    the changes to the Vim maintainer without fee or restriction, and
-- 	    permits the Vim maintainer to include the changes in the official
-- 	    version of Vim without fee or restriction.
-- 	  - You keep the changes for at least three years after last
-- 	    distributing the corresponding modified Vim.  When the maintainer
-- 	    or someone who you distributed the modified Vim to asks you (in
-- 	    any way) for the changes within this period, you must make them
-- 	    available to him.
-- 	  - You clearly describe in the distribution how to contact you.  This
-- 	    contact information must remain valid for at least three years
-- 	    after last distributing the corresponding modified Vim, or as long
-- 	    as possible.
--        e) When the GNU General Public License (GPL) applies to the changes,
-- 	  you can distribute the modified Vim under the GNU GPL version 2 or
-- 	  any later version.
--     3) A message must be added, at least in the output of the ":version"
--        command and in the intro screen, such that the user of the modified Vim
--        is able to see that it was modified.  When distributing as mentioned
--        under 2)e) adding the message is only required for as far as this does
--        not conflict with the license used for the changes.
--     4) The contact information as required under 2)a) and 2)d) must not be
--        removed or changed, except that the person himself can make
--        corrections.

-- III) If you distribute a modified version of Vim, you are encouraged to use
--      the Vim license for your changes and make them available to the
--      maintainer, including the source code.  The preferred way to do this is
--      by e-mail or by uploading the files to a server and e-mailing the URL.
--      If the number of changes is small (e.g., a modified Makefile) e-mailing a
--      context diff will do.  The e-mail address to be used is
--      <maintainer@vim.org>

-- IV)  It is not allowed to remove this license from the distribution of the Vim
--      sources, parts of it or from a modified version.  You may use this
--      license for previous Vim releases instead of the license that they came
--      with, at your option.


---@defgroup vim.iter
---
--- This module provides a generic interface for working with
--- iterables: tables, lists, iterator functions, pair()/ipair()-like iterators,
--- and \`vim.iter()\` objects.
---
--- \*vim.iter()\* wraps its table or function argument into an \*Iter\* object
--- with methods (such as |Iter:filter()| and |Iter:map()|) that transform the
--- underlying source data. These methods can be chained together to create
--- iterator "pipelines". Each pipeline stage receives as input the output
--- values from the prior stage. The values used in the first stage of the
--- pipeline depend on the type passed to this function:
---
--- - List tables pass only the value of each element
--- - Non-list tables pass both the key and value of each element
--- - Function iterators pass all of the values returned by their respective
---   function
--- - Tables with a metatable implementing __call are treated as function
---   iterators
---
--- Examples:
--- <pre>lua
---   local it = vim.iter({ 1, 2, 3, 4, 5 })
---   it:map(function(v)
---     return v * 3
---   end)
---   it:rev()
---   it:skip(2)
---   it:totable()
---   -- { 9, 6, 3 }
---
---   vim.iter(ipairs({ 1, 2, 3, 4, 5 })):map(function(i, v)
---     if i > 2 then return v end
---   end):totable()
---   -- { 3, 4, 5 }
---
---   local it = vim.iter(vim.gsplit('1,2,3,4,5', ','))
---   it:map(function(s) return tonumber(s) end)
---   for i, d in it:enumerate() do
---     print(string.format("Column %d is %d", i, d))
---   end
---   -- Column 1 is 1
---   -- Column 2 is 2
---   -- Column 3 is 3
---   -- Column 4 is 4
---   -- Column 5 is 5
---
---   vim.iter({ a = 1, b = 2, c = 3, z = 26 }):any(function(k, v)
---     return k == 'z'
---   end)
---   -- true
---
---   local rb = vim.ringbuf(3)
---   rb:push("a")
---   rb:push("b")
---   vim.iter(rb):totable()
---   -- { "a", "b" }
--- </pre>
---
--- In addition to the |vim.iter()| function, the |vim.iter| module provides
--- convenience functions like |vim.iter.filter()| and |vim.iter.totable()|.

---@class IterMod
---@operator call:Iter
local M = {}

---@class Iter
local Iter = {}
Iter.__index = Iter
Iter.__call = function(self)
  return self:next()
end

--- Special case implementations for iterators on list tables.
---@class ListIter : Iter
---@field _table table Underlying table data
---@field _head number Index to the front of a table iterator
---@field _tail number Index to the end of a table iterator (exclusive)
local ListIter = {}
ListIter.__index = setmetatable(ListIter, Iter)
ListIter.__call = function(self)
  return self:next()
end

--- Packed tables use this as their metatable
local packedmt = {}

local function unpack(t)
  if type(t) == 'table' and getmetatable(t) == packedmt then
    return _G.unpack(t, 1, t.n)
  end
  return t
end

local function pack(...)
  local n = select('#', ...)
  if n > 1 then
    return setmetatable({ n = n, ... }, packedmt)
  end
  return ...
end

local function sanitize(t)
  if type(t) == 'table' and getmetatable(t) == packedmt then
    -- Remove length tag
    t.n = nil
  end
  return t
end

--- Determine if the current iterator stage should continue.
---
--- If any arguments are passed to this function, then return those arguments
--- and stop the current iterator stage. Otherwise, return true to signal that
--- the current stage should continue.
---
---@param ... any Function arguments.
---@return boolean True if the iterator stage should continue, false otherwise
---@return any Function arguments.
local function continue(...)
  if select('#', ...) > 0 then
    return false, ...
  end
  return true
end

--- If no input arguments are given return false, indicating the current
--- iterator stage should stop. Otherwise, apply the arguments to the function
--- f. If that function returns no values, the current iterator stage continues.
--- Otherwise, those values are returned.
---
---@param f function Function to call with the given arguments
---@param ... any Arguments to apply to f
---@return boolean True if the iterator pipeline should continue, false otherwise
---@return any Return values of f
local function apply(f, ...)
  if select('#', ...) > 0 then
    return continue(f(...))
  end
  return false
end

--- Add a filter step to the iterator pipeline.
---
--- Example:
--- <pre>lua
--- local bufs = vim.iter(vim.api.nvim_list_bufs()):filter(vim.api.nvim_buf_is_loaded)
--- </pre>
---
---@param f function(...):bool Takes all values returned from the previous stage
---                            in the pipeline and returns false or nil if the
---                            current iterator element should be removed.
---@return Iter
function Iter.filter(self, f)
  return self:map(function(...)
    if f(...) then
      return ...
    end
  end)
end

---@private
function ListIter.filter(self, f)
  local inc = self._head < self._tail and 1 or -1
  local n = self._head
  for i = self._head, self._tail - inc, inc do
    local v = self._table[i]
    if f(unpack(v)) then
      self._table[n] = v
      n = n + inc
    end
  end
  self._tail = n
  return self
end

--- Add a map step to the iterator pipeline.
---
--- If the map function returns nil, the value is filtered from the iterator.
---
--- Example:
--- <pre>lua
--- local it = vim.iter({ 1, 2, 3, 4 }):map(function(v)
---   if v % 2 == 0 then
---     return v * 3
---   end
--- end)
--- it:totable()
--- -- { 6, 12 }
--- </pre>
---
---@param f function(...):any Mapping function. Takes all values returned from
---                           the previous stage in the pipeline as arguments
---                           and returns one or more new values, which are used
---                           in the next pipeline stage. Nil return values
---                           are filtered from the output.
---@return Iter
function Iter.map(self, f)
  -- Implementation note: the reader may be forgiven for observing that this
  -- function appears excessively convoluted. The problem to solve is that each
  -- stage of the iterator pipeline can return any number of values, and the
  -- number of values could even change per iteration. And the return values
  -- must be checked to determine if the pipeline has ended, so we cannot
  -- naively forward them along to the next stage.
  --
  -- A simple approach is to pack all of the return values into a table, check
  -- for nil, then unpack the table for the next stage. However, packing and
  -- unpacking tables is quite slow. There is no other way in Lua to handle an
  -- unknown number of function return values than to simply forward those
  -- values along to another function. Hence the intricate function passing you
  -- see here.

  local next = self.next

  --- Drain values from the upstream iterator source until a value can be
  --- returned.
  ---
  --- This is a recursive function. The base case is when the first argument is
  --- false, which indicates that the rest of the arguments should be returned
  --- as the values for the current iteration stage.
  ---
  ---@param cont boolean If true, the current iterator stage should continue to
  ---                    pull values from its upstream pipeline stage.
  ---                    Otherwise, this stage is complete and returns the
  ---                    values passed.
  ---@param ... any Values to return if cont is false.
  ---@return any
  local function fn(cont, ...)
    if cont then
      return fn(apply(f, next(self)))
    end
    return ...
  end

  self.next = function()
    return fn(apply(f, next(self)))
  end
  return self
end

---@private
function ListIter.map(self, f)
  local inc = self._head < self._tail and 1 or -1
  local n = self._head
  for i = self._head, self._tail - inc, inc do
    local v = pack(f(unpack(self._table[i])))
    if v ~= nil then
      self._table[n] = v
      n = n + inc
    end
  end
  self._tail = n
  return self
end

--- Call a function once for each item in the pipeline.
---
--- This is used for functions which have side effects. To modify the values in
--- the iterator, use |Iter:map()|.
---
--- This function drains the iterator.
---
---@param f function(...) Function to execute for each item in the pipeline.
---                       Takes all of the values returned by the previous stage
---                       in the pipeline as arguments.
function Iter.each(self, f)
  local function fn(...)
    if select('#', ...) > 0 then
      f(...)
      return true
    end
  end
  while fn(self:next()) do
  end
end

---@private
function ListIter.each(self, f)
  local inc = self._head < self._tail and 1 or -1
  for i = self._head, self._tail - inc, inc do
    f(unpack(self._table[i]))
  end
  self._head = self._tail
end

--- Collect the iterator into a table.
---
--- The resulting table depends on the initial source in the iterator pipeline.
--- List-like tables and function iterators will be collected into a list-like
--- table. If multiple values are returned from the final stage in the iterator
--- pipeline, each value will be included in a table.
---
--- Examples:
--- <pre>lua
--- vim.iter(string.gmatch('100 20 50', '%d+')):map(tonumber):totable()
--- -- { 100, 20, 50 }
---
--- vim.iter({ 1, 2, 3 }):map(function(v) return v, 2 * v end):totable()
--- -- { { 1, 2 }, { 2, 4 }, { 3, 6 } }
---
--- vim.iter({ a = 1, b = 2, c = 3 }):filter(function(k, v) return v % 2 ~= 0 end):totable()
--- -- { { 'a', 1 }, { 'c', 3 } }
--- </pre>
---
--- The generated table is a list-like table with consecutive, numeric indices.
--- To create a map-like table with arbitrary keys, use |Iter:fold()|.
---
---
---@return table
function Iter.totable(self)
  local t = {}

  while true do
    local args = pack(self:next())
    if args == nil then
      break
    end

    t[#t + 1] = sanitize(args)
  end
  return t
end

---@private
function ListIter.totable(self)
  if self.next ~= ListIter.next or self._head >= self._tail then
    return Iter.totable(self)
  end

  local needs_sanitize = getmetatable(self._table[1]) == packedmt

  -- Reindex and sanitize.
  local len = self._tail - self._head

  if needs_sanitize then
    for i = 1, len do
      self._table[i] = sanitize(self._table[self._head - 1 + i])
    end
  else
    for i = 1, len do
      self._table[i] = self._table[self._head - 1 + i]
    end
  end

  for i = len + 1, table.maxn(self._table) do
    self._table[i] = nil
  end

  self._head = 1
  self._tail = len + 1

  return self._table
end

--- Fold ("reduce") an iterator or table into a single value.
---
--- Examples:
--- <pre>lua
--- -- Create a new table with only even values
--- local t = { a = 1, b = 2, c = 3, d = 4 }
--- local it = vim.iter(t)
--- it:filter(function(k, v) return v % 2 == 0 end)
--- it:fold({}, function(t, k, v)
---   t[k] = v
---   return t
--- end)
--- -- { b = 2, d = 4 }
--- </pre>
---
---@generic A
---
---@param init A Initial value of the accumulator.
---@param f function(acc:A, ...):A Accumulation function.
---@return A
function Iter.fold(self, init, f)
  local acc = init

  --- Use a closure to handle var args returned from iterator
  local function fn(...)
    if select(1, ...) ~= nil then
      acc = f(acc, ...)
      return true
    end
  end

  while fn(self:next()) do
  end
  return acc
end

---@private
function ListIter.fold(self, init, f)
  local acc = init
  local inc = self._head < self._tail and 1 or -1
  for i = self._head, self._tail - inc, inc do
    acc = f(acc, unpack(self._table[i]))
  end
  return acc
end

--- Return the next value from the iterator.
---
--- Example:
--- <pre>lua
---
--- local it = vim.iter(string.gmatch('1 2 3', '%d+')):map(tonumber)
--- it:next()
--- -- 1
--- it:next()
--- -- 2
--- it:next()
--- -- 3
---
--- </pre>
---
---@return any
function Iter.next(self) -- luacheck: no unused args
  -- This function is provided by the source iterator in Iter.new. This definition exists only for
  -- the docstring
end

---@private
function ListIter.next(self)
  if self._head ~= self._tail then
    local v = self._table[self._head]
    local inc = self._head < self._tail and 1 or -1
    self._head = self._head + inc
    return unpack(v)
  end
end

--- Reverse an iterator.
---
--- Only supported for iterators on list-like tables.
---
--- Example:
--- <pre>lua
---
--- local it = vim.iter({ 3, 6, 9, 12 }):rev()
--- it:totable()
--- -- { 12, 9, 6, 3 }
---
--- </pre>
---
---@return Iter
function Iter.rev(self)
  error('rev() requires a list-like table')
  return self
end

---@private
function ListIter.rev(self)
  local inc = self._head < self._tail and 1 or -1
  self._head, self._tail = self._tail - inc, self._head - inc
  return self
end

--- Peek at the next value in the iterator without consuming it.
---
--- Only supported for iterators on list-like tables.
---
--- Example:
--- <pre>lua
---
--- local it = vim.iter({ 3, 6, 9, 12 })
--- it:peek()
--- -- 3
--- it:peek()
--- -- 3
--- it:next()
--- -- 3
---
--- </pre>
---
---@return any
function Iter.peek(self) -- luacheck: no unused args
  error('peek() requires a list-like table')
end

---@private
function ListIter.peek(self)
  if self._head ~= self._tail then
    return self._table[self._head]
  end
end

--- Find the first value in the iterator that satisfies the given predicate.
---
--- Advances the iterator. Returns nil and drains the iterator if no value is found.
---
--- Examples:
--- <pre>lua
---
--- local it = vim.iter({ 3, 6, 9, 12 })
--- it:find(12)
--- -- 12
---
--- local it = vim.iter({ 3, 6, 9, 12 })
--- it:find(20)
--- -- nil
---
--- local it = vim.iter({ 3, 6, 9, 12 })
--- it:find(function(v) return v % 4 == 0 end)
--- -- 12
---
--- </pre>
---
---@return any
function Iter.find(self, f)
  if type(f) ~= 'function' then
    local val = f
    f = function(v)
      return v == val
    end
  end

  local result = nil

  --- Use a closure to handle var args returned from iterator
  local function fn(...)
    if select(1, ...) ~= nil then
      if f(...) then
        result = pack(...)
      else
        return true
      end
    end
  end

  while fn(self:next()) do
  end
  return unpack(result)
end

--- Find the first value in the iterator that satisfies the given predicate, starting from the end.
---
--- Advances the iterator. Returns nil and drains the iterator if no value is found.
---
--- Only supported for iterators on list-like tables.
---
--- Examples:
--- <pre>lua
---
--- local it = vim.iter({ 1, 2, 3, 2, 1 }):enumerate()
--- it:rfind(1)
--- -- 5	1
--- it:rfind(1)
--- -- 1	1
---
--- </pre>
---
---@see Iter.find
---
---@return any
function Iter.rfind(self, f) -- luacheck: no unused args
  error('rfind() requires a list-like table')
end

---@private
function ListIter.rfind(self, f) -- luacheck: no unused args
  if type(f) ~= 'function' then
    local val = f
    f = function(v)
      return v == val
    end
  end

  local inc = self._head < self._tail and 1 or -1
  for i = self._tail - inc, self._head, -inc do
    local v = self._table[i]
    if f(unpack(v)) then
      self._tail = i
      return unpack(v)
    end
  end
  self._head = self._tail
end

--- Return the next value from the end of the iterator.
---
--- Only supported for iterators on list-like tables.
---
--- Example:
--- <pre>lua
--- local it = vim.iter({1, 2, 3, 4})
--- it:nextback()
--- -- 4
--- it:nextback()
--- -- 3
--- </pre>
---
---@return any
function Iter.nextback(self) -- luacheck: no unused args
  error('nextback() requires a list-like table')
end

function ListIter.nextback(self)
  if self._head ~= self._tail then
    local inc = self._head < self._tail and 1 or -1
    self._tail = self._tail - inc
    return self._table[self._tail]
  end
end

--- Return the next value from the end of the iterator without consuming it.
---
--- Only supported for iterators on list-like tables.
---
--- Example:
--- <pre>lua
--- local it = vim.iter({1, 2, 3, 4})
--- it:peekback()
--- -- 4
--- it:peekback()
--- -- 4
--- it:nextback()
--- -- 4
--- </pre>
---
---@return any
function Iter.peekback(self) -- luacheck: no unused args
  error('peekback() requires a list-like table')
end

function ListIter.peekback(self)
  if self._head ~= self._tail then
    local inc = self._head < self._tail and 1 or -1
    return self._table[self._tail - inc]
  end
end

--- Skip values in the iterator.
---
--- Example:
--- <pre>lua
---
--- local it = vim.iter({ 3, 6, 9, 12 }):skip(2)
--- it:next()
--- -- 9
---
--- </pre>
---
---@param n number Number of values to skip.
---@return Iter
function Iter.skip(self, n)
  for _ = 1, n do
    local _ = self:next()
  end
  return self
end

---@private
function ListIter.skip(self, n)
  local inc = self._head < self._tail and n or -n
  self._head = self._head + inc
  if (inc > 0 and self._head > self._tail) or (inc < 0 and self._head < self._tail) then
    self._head = self._tail
  end
  return self
end

--- Skip values in the iterator starting from the end.
---
--- Only supported for iterators on list-like tables.
---
--- Example:
--- <pre>lua
--- local it = vim.iter({ 1, 2, 3, 4, 5 }):skipback(2)
--- it:next()
--- -- 1
--- it:nextback()
--- -- 3
--- </pre>
---
---@param n number Number of values to skip.
---@return Iter
function Iter.skipback(self, n) -- luacheck: no unused args
  error('skipback() requires a list-like table')
  return self
end

---@private
function ListIter.skipback(self, n)
  local inc = self._head < self._tail and n or -n
  self._tail = self._tail - inc
  if (inc > 0 and self._head > self._tail) or (inc < 0 and self._head < self._tail) then
    self._head = self._tail
  end
  return self
end

--- Return the nth value in the iterator.
---
--- This function advances the iterator.
---
--- Example:
--- <pre>lua
---
--- local it = vim.iter({ 3, 6, 9, 12 })
--- it:nth(2)
--- -- 6
--- it:nth(2)
--- -- 12
---
--- </pre>
---
---@param n number The index of the value to return.
---@return any
function Iter.nth(self, n)
  if n > 0 then
    return self:skip(n - 1):next()
  end
end

--- Return the nth value from the end of the iterator.
---
--- This function advances the iterator.
---
--- Only supported for iterators on list-like tables.
---
--- Example:
--- <pre>lua
---
--- local it = vim.iter({ 3, 6, 9, 12 })
--- it:nthback(2)
--- -- 9
--- it:nthback(2)
--- -- 3
---
--- </pre>
---
---@param n number The index of the value to return.
---@return any
function Iter.nthback(self, n)
  if n > 0 then
    return self:skipback(n - 1):nextback()
  end
end

--- Slice an iterator, changing its start and end positions.
---
--- This is equivalent to :skip(first - 1):skipback(len - last + 1)
---
--- Only supported for iterators on list-like tables.
---
---@param first number
---@param last number
---@return Iter
function Iter.slice(self, first, last) -- luacheck: no unused args
  return self:skip(math.max(0, first - 1)):skipback(math.max(0, self._tail - last - 1))
end

--- Return true if any of the items in the iterator match the given predicate.
---
---@param pred function(...):bool Predicate function. Takes all values returned from the previous
---                                stage in the pipeline as arguments and returns true if the
---                                predicate matches.
function Iter.any(self, pred)
  local any = false

  --- Use a closure to handle var args returned from iterator
  local function fn(...)
    if select(1, ...) ~= nil then
      if pred(...) then
        any = true
      else
        return true
      end
    end
  end

  while fn(self:next()) do
  end
  return any
end

--- Return true if all of the items in the iterator match the given predicate.
---
---@param pred function(...):bool Predicate function. Takes all values returned from the previous
---                                stage in the pipeline as arguments and returns true if the
---                                predicate matches.
function Iter.all(self, pred)
  local all = true

  local function fn(...)
    if select(1, ...) ~= nil then
      if not pred(...) then
        all = false
      else
        return true
      end
    end
  end

  while fn(self:next()) do
  end
  return all
end

--- Return the last item in the iterator.
---
--- Drains the iterator.
---
--- Example:
--- <pre>lua
---
--- local it = vim.iter(vim.gsplit('abcdefg', ''))
--- it:last()
--- -- 'g'
---
--- local it = vim.iter({ 3, 6, 9, 12, 15 })
--- it:last()
--- -- 15
---
--- </pre>
---
---@return any
function Iter.last(self)
  local last = self:next()
  local cur = self:next()
  while cur do
    last = cur
    cur = self:next()
  end
  return last
end

---@private
function ListIter.last(self)
  local inc = self._head < self._tail and 1 or -1
  local v = self._table[self._tail - inc]
  self._head = self._tail
  return v
end

--- Add an iterator stage that returns the current iterator count as well as the iterator value.
---
--- For list tables, prefer
--- <pre>lua
--- vim.iter(ipairs(t))
--- </pre>
---
--- over
--- <pre>lua
--- vim.iter(t):enumerate()
--- </pre>
---
--- as the former is faster.
---
--- Example:
--- <pre>lua
---
--- local it = vim.iter(vim.gsplit('abc', '')):enumerate()
--- it:next()
--- -- 1	'a'
--- it:next()
--- -- 2	'b'
--- it:next()
--- -- 3	'c'
---
--- </pre>
---
---@return Iter
function Iter.enumerate(self)
  local i = 0
  return self:map(function(...)
    i = i + 1
    return i, ...
  end)
end

---@private
function ListIter.enumerate(self)
  local inc = self._head < self._tail and 1 or -1
  for i = self._head, self._tail - inc, inc do
    local v = self._table[i]
    self._table[i] = pack(i, v)
  end
  return self
end

--- Create a new Iter object from a table or iterator.
---
---@param src table|function Table or iterator to drain values from
---@return Iter
---@private
function Iter.new(src, ...)
  local it = {}
  if type(src) == 'table' then
    local mt = getmetatable(src)
    if mt and type(mt.__call) == 'function' then
      ---@private
      function it.next()
        return src()
      end

      setmetatable(it, Iter)
      return it
    end

    local t = {}

    -- Check if source table can be treated like a list (indices are consecutive integers
    -- starting from 1)
    local count = 0
    for _ in pairs(src) do
      count = count + 1
      local v = src[count]
      if v == nil then
        return Iter.new(pairs(src))
      end
      t[count] = v
    end
    return ListIter.new(t)
  end

  if type(src) == 'function' then
    local s, var = ...

    --- Use a closure to handle var args returned from iterator
    local function fn(...)
      if select(1, ...) ~= nil then
        var = select(1, ...)
        return ...
      end
    end

    ---@private
    function it.next()
      return fn(src(s, var))
    end

    setmetatable(it, Iter)
  else
    error('src must be a table or function')
  end
  return it
end

--- Create a new ListIter
---
---@param t table List-like table. Caller guarantees that this table is a valid list.
---@return Iter
---@private
function ListIter.new(t)
  local it = {}
  it._table = t
  it._head = 1
  it._tail = #t + 1
  setmetatable(it, ListIter)
  return it
end

--- Collect an iterator into a table.
---
--- This is a convenience function that performs:
--- <pre>lua
--- vim.iter(f):totable()
--- </pre>
---
---@param f function Iterator function
---@return table
function M.totable(f, ...)
  return Iter.new(f, ...):totable()
end

--- Filter a table or iterator.
---
--- This is a convenience function that performs:
--- <pre>lua
--- vim.iter(src):filter(f):totable()
--- </pre>
---
---@see |Iter:filter()|
---
---@param f function(...):bool Filter function. Accepts the current iterator or table values as
---                            arguments and returns true if those values should be kept in the
---                            final table
---@param src table|function Table or iterator function to filter
---@return table
function M.filter(f, src, ...)
  return Iter.new(src, ...):filter(f):totable()
end

--- Map and filter a table or iterator.
---
--- This is a convenience function that performs:
--- <pre>lua
--- vim.iter(src):map(f):totable()
--- </pre>
---
---@see |Iter:map()|
---
---@param f function(...):?any Map function. Accepts the current iterator or table values as
---                            arguments and returns one or more new values. Nil values are removed
---                            from the final table.
---@param src table|function Table or iterator function to filter
---@return table
function M.map(f, src, ...)
  return Iter.new(src, ...):map(f):totable()
end

---@type IterMod
return setmetatable(M, {
  __call = function(_, ...)
    return Iter.new(...)
  end,
})

