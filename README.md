 Benchmarking Javas ByteBuffer implementations against my Julia ByteBuffer.
 `Julia Version 0.4 Version 0.4.0-dev+2654 (2015-01-13 01:45 UTC)`
 `java version "1.8.0_25"`
 Both on linux with `Intel® Core™ i3-4130 CPU @ 3.40GHz × 4`
 
Java Benchmarks are taken from: https://github.com/ashkrit/blog/tree/master/allocation
Which is from this article: http://www.javacodegeeks.com/2013/08/which-memory-is-faster-heap-or-bytebuffer-or-direct.html
Results:
(three value pairs for every benchmark: min, max, mean)
![Bench](/benchmarks.png)
My trivial, 27 line long, ByteBuffer implementation being only slightly slower than Javas OffHeapObject.

