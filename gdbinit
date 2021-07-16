python
import sys
sys.path.insert(0, '/home/dpike/.gdb/eigen/')
from printers import register_eigen_printers
register_eigen_printers (None)
end
