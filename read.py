import os
import struct

xdma_axis_rd_data = os.open("/dev/xdma0_c2h_0", os.O_RDONLY)

data_rd = os.pread(xdma_axis_rd_data, 8, 0)
#print(data_rd)
data_unpack = struct.unpack("<1Q", data_rd)

print(data_unpack)
