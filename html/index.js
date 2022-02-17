const Metalsmith = require('metalsmith');
const browserSync = require('browser-sync').create();
const scss = require('./scss-plugin');

const args = process.argv.slice(2);
const sourceDir = 'src';
const buildDir = 'build';

const htmlPipeline =
  Metalsmith(__dirname)
    .source(sourceDir)
    .destination(buildDir)
    .use(scss());

const handleBuildError = e => {
  console.error(e);
  process.exit(1);
};

const handleWatchError = e => {
  console.error(e);
  browserSync.notify('There was an error, check your console', 10 * 1000);
};

const runBuild = pipeline =>
  new Promise((resolve, reject) =>
    pipeline.build(err => err == null ? resolve() : reject(err))
  );

const runServer = async () => {
  await runBuild(htmlPipeline).catch(handleBuildError);

  browserSync.init({ server: buildDir });
  browserSync.watch(`${sourceDir}/**/*`).on('change', filename => {
    runBuild(htmlPipeline).then(browserSync.reload, handleWatchError);
  });
};

switch (args[0]) {
  case undefined: case '-w': case '--watch':
    runServer();
    break;
  default:
    console.error(`Unknown arg "${args[0]}" ¯\\_(ツ)_/¯`);
    process.exit(1);
}
