{
  programs.git.includes = (map (ns: {
    condition = "gitdir:~/${ns}/";
    contents = {
      user.name = "Paolo Brasolin";
      user.email = "paolo.brasolin@gmail.com";
      core.sshCommand = "ssh -F /dev/null -i ~/.ssh/pb-paolo_at_ebisu";
    };
  }) ["pb" "vp" "bi" "ef" "uc"]) ++ [
    {
      condition = "gitdir:~/dq/";
      contents = {
        user.name = "Paolo Brasolin";
        user.email = "paolo.brasolin@donq.io";
        core.sshCommand = "ssh -F /dev/null -i ~/.ssh/dq-paolo_at_ebisu";
      };
    }
  ];
  # NOTE:these are to be paired with some `includes.*.contents.url`s as an alternative to `sshCommand` but tbh I find the whole thing quite cursed:
  # # url."paolobrasolin_at_github.com".insteadOf = "git@github.com";
  # # url."pbrasolin-DQ_at_github.com".insteadOf = "git@github.com";
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
