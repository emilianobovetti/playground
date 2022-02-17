const { exec } = require('child_process');

const filterByRegex = (entries, regex) =>
  entries.filter(([filename]) => regex.test(filename));

const filterByExtensions = (entries, extensions) =>
  entries.filter(([filename]) =>
    extensions.some(ext => filename.endsWith(ext))
  );

const bufferExec = command =>
  new Promise((resolve, reject) => {
    let bufferError, stdoutChunks = [];

    const { stdout } = exec(command, { encoding: 'buffer' }, error => {
      if (error != null) {
        reject(error);
      } else if (bufferError != null) {
        reject(bufferError);
      } else {
        resolve(Buffer.concat(stdoutChunks));
      }
    });

    // `chunk` is a buffer because we set { encoding: 'buffer' }
    // then we can use `Buffer.concat(stdoutChunks)` to create a single buffer
    const onData = chunk => stdoutChunks.push(chunk);

    const finalize = error => {
      stdout.removeListener('data', onData);
      stdout.removeListener('end', finalize);
      stdout.removeListener('error', finalize);
      stdout.removeListener('close', finalize);

      if (error != null) {
        bufferError = error;
      }
    };

    stdout.on('data', onData);
    stdout.on('end', finalize);
    stdout.on('error', finalize);
    stdout.on('close', finalize);
  });

module.exports = {
  filterByRegex,
  filterByExtensions,
  bufferExec,
};
