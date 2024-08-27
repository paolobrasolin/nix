{
  programs.git.includes = [
    {
      condition = "gitdir:~/pb/";
      contents = {
        user.name = "Paolo Brasolin";
        user.email = "paolo.brasolin@gmail.com";
        core.sshCommand = "ssh -F /dev/null -i ~/.ssh/paolo_at_kitsune";
      };
    }
    {
      condition = "gitdir:~/dq/";
      contents = {
        user.name = "Paolo Brasolin";
        user.email = "paolo.brasolin@donq.io";
        core.sshCommand = "ssh -F /dev/null -i ~/.ssh/pbrasolin-DQ_id_ed25519";
      };
    }
  ];
}
