const Benchmark = require('benchmark');

const log = (...args) => {
  console.log(...args);

  return args[0];
};


new Benchmark.Suite()
  .add('<first task>', () => {
    //
  })
  .add('<second task>', () => {
    //
  })
  .on('cycle', event => {
    const { name, stats, times } = event.target;

    log(' === ', name, ' === ');
    log({
      moe: stats.moe,
      rme: stats.rme,
      sem: stats.sem,
      mean: stats.mean,
      variance: stats.variance,
      deviation: stats.deviation,
    });
  })
  .on('complete', function () {
    log('Fastest is ' + this.filter('fastest').map('name'));
  })
  .run();
