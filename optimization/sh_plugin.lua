PLUGIN.name = "Optimization"
PLUGIN.author = "CallowayIsWeird#7502"
PLUGIN.desc = "Optimizes players insanely well!"

nut.util.include("sv_networking.lua")
nut.util.include("cl_menu.lua")

hook.Add("PlayerLoadedChar", "OpenOptimizationFunc", function (ply)
    timer.Simple(2, function()
        net.Start( "OpenOptimizationMenu" ) 
        net.Send( ply )
    end)
end)

concommand.Add("OptimizationEnableSpawn", function()
    RunConsoleCommand("gmod_mcore_test", "1")
	RunConsoleCommand("mat_queue_mode", "-1")
	RunConsoleCommand("cl_threaded_bone_setup", "1")
	RunConsoleCommand("cl_threaded_client_leaf_system", "1")
	RunConsoleCommand("r_threaded_client_shadow_manager", "1")
	RunConsoleCommand("r_threaded_particles", "1")
	RunConsoleCommand("r_threaded_renderables", "1")
	RunConsoleCommand("r_queued_ropes", "1")
    RunConsoleCommand("studio_queue_mode", "1")
end)

concommand.Add("OptimizationDisable", function()
    RunConsoleCommand("gmod_mcore_test", "0")
	RunConsoleCommand("mat_queue_mode", "0")
	RunConsoleCommand("cl_threaded_bone_setup", "0")
	RunConsoleCommand("cl_threaded_client_leaf_system", "0")
	RunConsoleCommand("r_threaded_client_shadow_manager", "0")
	RunConsoleCommand("r_threaded_particles", "0")
	RunConsoleCommand("r_threaded_renderables", "0")
	RunConsoleCommand("r_queued_ropes", "0")
    RunConsoleCommand("studio_queue_mode", "0")
end)

nut.command.add("nooptimize", {
    onRun = function(client, arguments)
        client:ConCommand("OptimizationDisable")
        client:ChatPrint("Optimization has been disabled.")
    end
})

nut.command.add("optimize", {
    onRun = function(client, arguments)
        client:ConCommand("OptimizationEnableSpawn")
        client:ChatPrint("Optimization has been enabled.")
    end
})