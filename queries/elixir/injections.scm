; extends

(call
  target: ((identifier) @_identifier (#eq? @_identifier "execute"))
  (arguments
    (string
      (quoted_content) @sql)))

(call (dot left: (alias) @_alias (#eq? @_alias "Repo") right: (identifier) @_identifier (#eq? @_identifier "query!")) (arguments (string (quoted_content) @sql))) @foo

((call
   target: (dot
             left: (alias) @_mod (#eq? @_mod "EEx")
             right: (identifier) @_func (#eq? @_func "function_from_string"))
   (arguments
     (string
       (quoted_content) @eex))))
