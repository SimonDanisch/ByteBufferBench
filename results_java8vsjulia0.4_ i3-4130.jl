using DataFrames, Gadfly

bench_results = [
"Julia 0.4 Linux" => [
"Reads" => 573.4552599685386,
"Writes" => 363.2127818523877,
"RandomReads" =>69.63025258973363,
"Reads Max" => 661.45020576393,
"Writes Max" => 392.8826016497298,
"RandomReads Max" =>71.48024092072097,
"Reads Min" => 181.95255543448434,
"Writes Min" => 152.04857939947928,
"RandomReads Min" =>51.39408617295767,
],
"OffHeapObject" => [

    "Writes" => 371.77464167774485,
    "Reads" => 829.2500941221662,
    "RandomReads" => 74.7115902988392,

    "Writes Max" => 377.77578312164286,
    "Reads Max" => 856.5092605352994,
    "RandomReads Max" => 75.93643309548803,

    "Writes Min" => 248.23771700537833,
    "Reads Min" => 537.576980351615,
    "RandomReads Min" =>  66.907238780474,
],
"HeapAllocatedObject" => [
"Writes" => 188.18196244621637,
"Reads" => 445.32287568205305,
"RandomReads" => 37.41588466077414,
"Writes Max" => 195.07272818495827,
"Reads Max" => 481.9711695449744,
"RandomReads Max" => 39.858549024616266,
"Writes Min" => 147.74000925916187,
"Reads Min" => 226.45632648208587,
"RandomReads Min" => 25.52332749948338,
],
"ByteBufferObject" => [
"Writes" => 123.2007458766334,
"Reads" => 108.02220479855986,
"RandomReads" => 19.14391825328175,
"Writes Max" => 123.97586789895209,
"Reads Max" => 108.47394204794833,
"RandomReads Max" => 19.300851289909282,
"Writes Min" => 84.3819506467522,
"Reads Min" => 88.61621404133483,
"RandomReads Min" => 17.667962205331296,
],
"DirectByteBufferObject" => [
"Writes" => 386.2558193195519,
"Reads" => 452.3695622969918,
"RandomReads" => 56.16322379268817,
"Writes Max" => 393.12611131837593,
"Reads Max" => 461.38875153602083,
"RandomReads Max" => 57.10969566380244,
"Writes Min" => 254.5620575456878,
"Reads Min" => 261.31638442232406,
"RandomReads Min" => 48.63806156235211,
],

]

types     = UTF8String[]
benchname = UTF8String[]
values    = Float64[]
for (k,v) in bench_results
    for (bk, bv) in v
        push!(types, k)
        push!(benchname, first(split(bk)))
        push!(values, bv)
    end
end

dfb = DataFrame(types=types, benchname=benchname, values=values)
println(dfb)

p = plot(dfb,
    x = :types,
    y = :values,
    color = :benchname,
    Scale.y_continuous,
    Guide.ylabel("Op/Sec(Millions)"),
    Guide.xlabel(nothing),
    Guide.yticks(ticks=collect(0:50:1000)),
    Theme(
        default_point_size = 1mm,
        guide_title_position = :left,
        colorkey_swatch_shape = :circle,
        minor_label_font = "Georgia",
        major_label_font = "Georgia",
    )
)
draw(PNG("benchmarks.png", 8inch, 8inch/golden), p)
