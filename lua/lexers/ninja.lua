-- Ninja LPeg lexer.

local l = require('lexer')
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = 'ninja'}

-- Whitespace.
local ws = token(l.WHITESPACE, l.space^1)

-- Comments.
local comment = token(l.COMMENT, '#' * l.nonnewline^0)

-- Strings.
local sq_str = l.delimited_range("'", true)
local dq_str = l.delimited_range('"', true)
local string = token(l.STRING, sq_str + dq_str)

-- Numbers.
local number = token(l.NUMBER, l.float + l.integer)

-- Keyword.
local keyword = token(l.KEYWORD, l.space^1 + word_match{
	'command', 'depfile', 'deps', 'depth', 'description', 'generator', 'in',
	'in_newline', 'msvc_deps_prefix', 'out', 'pool', 'restat', 'rspfile', 
	'rspfile_content',
	})

-- Functions.
local functions = token(l.FUNCTION, word_match{
	'build', 'default', 'include', 'pool', 'rule', 'subninja', })

-- Variables.
local variable = token(l.VARIABLE,
                       '$' * (l.digit + l.word + l.delimited_range('{}', true)))

-- Operators.
local operator = token(l.OPERATOR, S('=:|'))

M._rules = {
  {'whitespace', ws},
  {'keyword', keyword},
  {'function', functions},
  {'string', string},
  {'comment', comment},
  {'number', number},
  {'variable', variable},
  {'operator', operator},
}

return M
