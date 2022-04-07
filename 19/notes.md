# AlienCodex

To-View after

- https://ylv.io/ethernaut-alien-codex-solution/
- https://github.com/NotSurprised/Ethernaut-CTF-writeup/blob/master/20.%20Alien%20Codex/Alien%20Codex.md

1. According to retract() doesn't have a check for int underflow, we can simply calling it to make codex.length from 0 to 2\*\*256-1
