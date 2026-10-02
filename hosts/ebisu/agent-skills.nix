# DonQ's agent skills (donq.darwinModules.agent-skills), for Claude Desktop
# and claude-dq but not claude-ag (~/.ag/.claude).
#
# The fleet default links them into Claude Code's managed folder, which every
# installation reads, claude-ag included; here they go to the two DonQ
# installations' own folders instead.
{
  programs.agent-skills = {
    harnesses = []; # no managed folder
    extraTargets = [
      {path = "~/.claude/skills";} # Claude Desktop (and plain `claude`)
      {path = "~/.dq/.claude/skills";} # claude-dq
    ];
  };
}
