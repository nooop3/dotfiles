from kitty.conf.types import Action, Definition

definition = Definition(
    '!kitten_options_utils',
    Action(
        'map', 'parse_map',
        {'key_definitions': 'kitty.conf.utils.KittensKeyMap'},
        ['kitty.types.ParsedShortcut', 'kitty.conf.utils.KeyAction']
    ),
)

agr = definition.add_group
egr = definition.end_group
opt = definition.add_option
map = definition.add_map

# main options {{{
agr('main', 'Main')

opt('some_option', '33',
    option_type='some_option_parser',
    long_text='''
Help text for this option
'''
    )
egr()  # }}}

# shortcuts {{{
agr('shortcuts', 'Keyboard shortcuts')

map('Quit', 'quit q quit')
egr()  # }}}
