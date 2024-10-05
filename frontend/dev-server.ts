/**
 * When used as a watcher, some tools don't stop when the Phoenix server does,
 * resulting in zombie processes:
 *
 * https://hexdocs.pm/elixir/Port.html#module-zombie-operating-system-processes
 *
 * For our app in particular, this happens when we use npm to run dev scripts
 * directly as watchers. As a workaround, we can use this Node.js script as a
 * singular watcher that starts and stops the various dev scripts instead.
 */

import { spawn } from "child_process";

const devScript = spawn("npm", ["run", "dev"], { stdio: "inherit" });

process.stdin.on("close", () => {
  devScript.kill();
  process.exit();
});

process.stdin.resume();
