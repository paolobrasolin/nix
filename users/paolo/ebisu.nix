{
  programs.git.includes = [
    {
      condition = "gitdir:~/pb/";
      contents = {
        user.name = "Paolo Brasolin";
        user.email = "paolo.brasolin@gmail.com";
        core.sshCommand = "ssh -F /dev/null -i ~/.ssh/pb-paolo_at_ebisu";
        #url."paolobrasolin_at_github.com".insteadOf = "git@github.com";
      };
    }
    {
      condition = "gitdir:~/dq/";
      contents = {
        user.name = "Paolo Brasolin";
        user.email = "paolo.brasolin@donq.io";
        core.sshCommand = "ssh -F /dev/null -i ~/.ssh/dq-paolo_at_ebisu";
        # url."pbrasolin-DQ_at_github.com".insteadOf = "git@github.com";
      };
    }
  ];
  # NOTE:these are to be paired with the commented `url`s above as an alternative to `sshCommand` but tbh I find the whole thing quite cursed.
  # programs.ssh = {
  #   matchBlocks."paolobrasolin_at_github.com" = {
  #     # host = "github.com";
  #     hostname = "github.com";
  #     # user = "paolobrasolin";
  #     user = "git";
  #     identitiesOnly = true;
  #     identityFile = "~/.ssh/pb-paolo_at_ebisu";
  #   };
  #   matchBlocks."pbrasolin-DQ_at_github.com" = {
  #     # host = "github.com";
  #     hostname = "github.com";
  #     # user = "pbrasolin-DQ";
  #     user = "git";
  #     identitiesOnly = true;
  #     identityFile = "~/.ssh/dq-paolo_at_ebisu";
  #   };
  # };
}
