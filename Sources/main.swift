// The Swift Programming Language
// https://docs.swift.org/swift-book

import MetalKit

guard let device = MTLCreateSystemDefaultDevice() else { 
    fatalError( "Failed to get the system's default Metal device." ) 
}

print("")
print("GPU name : \(device.name)")
print("GPU arch : \(device.architecture.name)")
print("maxThreadgroupMemoryLength : \(device.maxThreadgroupMemoryLength) bytes")
print("maxThreadsPerThreadgroup : \(device.maxThreadsPerThreadgroup)")

guard let exec_path = ProcessInfo.processInfo.arguments.first else {
    fatalError("Failed to retrieve exec path")
}

let exec_url = URL(fileURLWithPath: exec_path)
let exec_root = exec_url.deletingLastPathComponent()
                        .deletingLastPathComponent()
                        .deletingLastPathComponent(); 
let lib_url = exec_root.appendingPathComponent("Libs/add.metallib")

print("")
print("Making Metal library from: \(lib_url)")

let library = try device.makeLibrary(URL: lib_url)
let kernel = library.makeFunction(name: "add_arrays")!

let command_queue = device.makeCommandQueue()!
let command_buffer = command_queue.makeCommandBuffer()!
let encoder = command_buffer.makeComputeCommandEncoder()!
let pipeline = try device.makeComputePipelineState(function: kernel)
encoder.setComputePipelineState(pipeline)

let N = 32; 

let vec_a : [Int] = Array(0...N)
let vec_b : [Int] = Array(0...N)

print("")
print("Vec a: \(vec_a)")
print("Vec b: \(vec_b)")

let buffer_a = device.makeBuffer(bytes: vec_a as [Int], length : MemoryLayout<Int>.stride * vec_a.count, options:[]);
let buffer_b = device.makeBuffer(bytes: vec_b as [Int], length : MemoryLayout<Int>.stride * vec_b.count, options:[]);

let buffer_c = device.makeBuffer(length: MemoryLayout<Int>.stride * vec_a.count, options:[])! 

encoder.setBuffer(buffer_a, offset: 0, index: 0)
encoder.setBuffer(buffer_b, offset: 0, index: 1)
encoder.setBuffer(buffer_c, offset: 0, index: 2)

print("")
print("Running kernel")

let num_groups  = MTLSize(width: 1, height: 1, depth: 1)
let num_threads = MTLSize(width: N, height: 1, depth: 1)

encoder.dispatchThreadgroups(num_groups, threadsPerThreadgroup: num_threads)
encoder.endEncoding()

command_buffer.commit()
command_buffer.waitUntilCompleted()

print("")
print("Kernel finished")

let result_pointer = buffer_c.contents();
let result_buff_pointer = UnsafeBufferPointer(start: result_pointer.assumingMemoryBound(to: Int.self), count: N)
let result = Array(result_buff_pointer)
print("Results: \(result)")
