import os
import struct

xdma_axis_wr_data = os.open("/dev/xdma0_h2c_0", os.O_WRONLY)

arr = [76]
data = struct.pack("<1Q", *arr)
os.pwrite(xdma_axis_wr_data, data, 0)
