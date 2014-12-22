from target import entry_point, load_stdlib, init_load_path, LOAD_PATHS, load_path, BatchModeFn
from pixie.vm.atom import Atom
from pixie.vm.persistent_vector import EMPTY as EMPTY_VECTOR
from pixie.vm.symbol import symbol
from pixie.vm.code import intern_var

import pixie.vm.rt as rt
rt.init()

exit(1)

load_path.set_root(rt.wrap(u"./"))
LOAD_PATHS.set_root(Atom(EMPTY_VECTOR.conj(rt.wrap(u"./"))))
load_stdlib()

BatchModeFn(["pixie/preload.pxi"]).invoke([])

def target(*args):
    import pixie.vm.rt as rt
    driver = args[0]
    driver.exe_name = "pixie-vm"
    rt.__config__ = args[0].config





    return entry_point, None

import rpython.config.translationoption
print rpython.config.translationoption.get_combined_translation_config()

if __name__ == "__main__":
    entry_point(sys.argv)