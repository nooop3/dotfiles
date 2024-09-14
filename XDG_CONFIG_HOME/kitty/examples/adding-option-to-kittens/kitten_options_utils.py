from kitty.conf.utils import KittensKeyDefinition, key_func, parse_kittens_key

func_with_args, args_funcs = key_func()
FuncArgsType = Tuple[str, Sequence[Any]]

def some_option_parser(val: str) -> int:
    return int(val) + 3000

def parse_map(val: str) -> Iterable[KittensKeyDefinition]:
    x = parse_kittens_key(val, args_funcs)
    if x is not None:
        yield x
