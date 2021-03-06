using Knockout, WebIO, Blink
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

cleanup = !AtomShell.isinstalled()
cleanup && AtomShell.install()

# write your own tests here
s = Observable(["a", "b", "c"])
t = Node(:select, attributes = Dict("data-bind" => "options : options", "id" => "myselect"));
n = (knockout(t, ["options" => s]));

w = Window(Blink.@d(:show => false)); sleep(5.0)

body!(w, n); sleep(1.0)

@test Blink.@js w document.querySelector("#myselect").children.length == 3
@test Blink.@js w document.querySelector("#myselect").children[0].value == "a"
@test Blink.@js w document.querySelector("#myselect").children[1].value == "b"
@test Blink.@js w document.querySelector("#myselect").children[2].value == "c"

s[] = ["c", "d"]
sleep(1.0)

@test Blink.@js w document.querySelector("#myselect").children.length == 2
@test Blink.@js w document.querySelector("#myselect").children[0].value == "c"
@test Blink.@js w document.querySelector("#myselect").children[1].value == "d"

include("testpair.jl")

cleanup && AtomShell.uninstall()
