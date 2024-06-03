-- sv_custom_vote_panel.lua

util.AddNetworkString("StartCustomVote")

local function StartCustomVote(question, voteOptions)
    net.Start("StartCustomVote")
    net.WriteString(question)
    net.WriteTable(voteOptions)
    net.Broadcast()
end

hook.Add("onVoteStarted", "CustomVotePanel", function(vote)
    local question = vote.question or "Vote"
    local voteOptions = {
        {id = "yes", name = "Yes"},
        {id = "no", name = "No"}
    }

    StartCustomVote(question, voteOptions)
end)
