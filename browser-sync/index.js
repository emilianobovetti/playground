const browserSync = require('browser-sync').create();

const args = process.argv.slice(2);

const sourceDir = 'www';

const runServer = async () => {
  browserSync.init({ port: 3030, open: false, server: sourceDir });
  browserSync.watch(`${sourceDir}/**/*`);
};

switch (args[0]) {
  case undefined: case '-w': case '--watch':
    runServer();
    break;
  default:
    console.error(`Unknown arg "${args[0]}" ¯\\_(ツ)_/¯`);
    process.exit(1);
}
