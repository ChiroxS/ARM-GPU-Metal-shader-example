
#include <metal_stdlib>
using namespace metal;

kernel void add_arrays(device const int64_t *a [[buffer(0)]],
                       device const int64_t *b [[buffer(1)]],
                       device       int64_t *c [[buffer(2)]],
                       uint32_t id [[thread_position_in_grid]])
{
  c[id] = a[id] + b[id];
}

