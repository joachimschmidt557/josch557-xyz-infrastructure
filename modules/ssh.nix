{ config, pkgs, ... }:

{
  users.users.root.openssh.authorizedKeys.keys = [
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBgoPZIgGiqAycnu+g+TlZSMHjUpsYCmB5yoqBXAvP7M44wludUZBz/j0EqH4OOf3eN/MEld2uP7Ggw9OsPLnTc="
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBD0kQgPr56kpr+ZHf8DyP7Q9+C3vdeKXAMYu2r2fSZZ9Z9dPH7CQTomtaTXE3JXvyQ8N+JYUrRnZIX18LXPgy5Q="
  ];
}
