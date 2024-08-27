{
  programs.git.includes = [
    {
      condition = "gitdir:~/pb/";
      contents = {
        user.name = "Paolo Brasolin";
        user.email = "paolo.brasolin@gmail.com";
      };
    }
    {
      condition = "gitdir:~/dq/";
      contents = {
        user.name = "Paolo Brasolin";
        user.email = "paolo.brasolin@donq.io";
      };
    }
  ];
}
