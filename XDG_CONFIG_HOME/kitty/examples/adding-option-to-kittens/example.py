from .kitten_options_types import Options, defaults
from kitty.conf.utils import load_config as _load_config, parse_config_base
from typing import Optional, Iterable, Dict, Any

def load_config(*paths: str, overrides: Optional[Iterable[str]] = None) -> Options:
    from .kitten_options_parse import  (
        create_result_dict, merge_result_dicts, parse_conf_item
    )

    def parse_config(lines: Iterable[str]) -> Dict[str, Any]:
        ans: Dict[str, Any] = create_result_dict()
        parse_config_base(
            lines,
            parse_conf_item,
            ans,
        )
        return ans

    overrides = tuple(overrides) if overrides is not None else ()
    opts_dict, found_paths = _load_config(defaults, parse_config, merge_result_dicts, *paths, overrides=overrides)
    opts = Options(opts_dict)
    opts.config_paths = found_paths
    opts.all_config_paths = paths
    opts.config_overrides = overrides
    return opts
