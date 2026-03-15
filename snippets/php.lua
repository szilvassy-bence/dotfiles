local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("php", {
    s("class", fmt([[
<?php
declare(strict_types=1);

namespace {};

class {}
{{
    public function __construct(${})
    {{
        ${};
    }}
}}
]], {
        i(1, "App\\Models"), -- 1. Namespace
        i(2, "MyClass"),     -- 2. Osztály neve
        i(3, "argument"),            -- 3. Konstruktor argumentumok
        i(4, "variable"),            -- 3. Konstruktor
    })),
})

ls.add_snippets("php", {
    s("amap", fmt([[
array_map(function(${}) {{
    return ${};
}}, ${});
]], {
        i(1, "item"),       -- A ciklusváltozó neve
        i(2, "item"),      -- A visszatérési érték
        i(3, "array"),     -- Az input tömb
    })),
})

ls.add_snippets("php", {
    s("vo", fmt([[
<?php
declare(strict_types=1);

namespace {};

readonly class {}
{{
    public function __construct(
        public ${}
    ) {{}}
}}
]], {
        i(1, "App\\ValueObjects"),
        i(2, "CategoryVO"),
        i(3, "variable")
    })),
})
