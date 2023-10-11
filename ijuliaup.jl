using Pkg, DelimitedFiles
Pkg.add("IJulia")
using IJulia

function installed_kernels()
    list = split(read(`jupyter kernelspec list`, String), "\n")[2:end-1]
    kernel_names = String[]
    kernel_locations = String[]

    for line in list
        name, location = split(line)
        push!(kernel_names, name)
        push!(kernel_locations, location)
    end

    return kernel_names
end

function show_kernels(kernels)
    println("")
    println("Installed jupyter kernels:")
    for (i, name) in enumerate(kernels)
        println("[$i] $(name)")
    end
    return nothing
end

function remove_kernels(kernels, kernels_to_remove)
    for n in kernels_to_remove
        run(`jupyter kernelspec remove $(kernels[n])`)
    end
    return nothing
end

function install_kernels_with_threads(threads)
    for t in threads
        installkernel("julia-$(VERSION)_$(t)_threads", env=Dict("JULIA_NUM_THREADS"=>"$t"))
    end
    return nothing
end



function ijuliaup()

    # show installed kernels
    kernel_names = installed_kernels()
    show_kernels(kernel_names)

    # Remove installed kernels
    println("")
    println("Remove some of the installed kernels? [y/N]")
    yn1 = readline()

    if yn1 == "y"
        println("Indicate number of the kernels to be removed")
        kernels_to_remove = vec(readdlm(IOBuffer(readline()), Int))

        remove_kernels(kernel_names, kernels_to_remove)

    end

    # show installed kernels after removal
    kernel_names = installed_kernels()
    show_kernels(kernel_names)

    # Install additional kernels
    println("")
    println("Add aditional IJulia jupyter kernels? [y/N]")
    yn2 = readline()

    if yn2 == "y"
        println("Indicate the number of Julia threads for the kernel")
        println("(To add multiple kernels, indicate the number of threads for each kernel seperated by spaces)")
        kernels_to_add = vec(readdlm(IOBuffer(readline()), Int))

        install_kernels_with_threads(kernels_to_add)

    end

    # show installed kernels after changes
    kernel_names = installed_kernels()
    show_kernels(kernel_names)

    return nothing

end

ijuliaup()
