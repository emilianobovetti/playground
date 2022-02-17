const sass = require('sass');
const path = require('path');
const { filterByExtensions } = require('./utils');

const lookupScssName = (relPath, importedUrl) => {
  const importedBasename = `_${path.basename(importedUrl)}`;
  const importedDirname = path.join(relPath, path.dirname(importedUrl));

  return `${path.join(importedDirname, importedBasename)}.scss`;
};

const asyncSassRender = opts =>
  new Promise((resolve, reject) =>
    sass.render(opts, (err, res) =>
      err == null ? resolve([opts.outFile, res]) : reject(err)
    )
  );

const renderScss = (opts, files, [scssFilename, scssFile]) => {
  const baseDir = path.dirname(scssFilename);
  const baseName = path.basename(scssFilename, '.scss');
  const outFile = `${path.join(baseDir, baseName)}.css`;

  return asyncSassRender({
    ...opts,
    outFile,
    data: scssFile.contents.toString(),
    // `indentedSyntax` is true for sass syntax, but it won't work
    // if the importer function returns the file content, so .sass
    // files aren't supported for now
    indentedSyntax: false,
    importer: (url, from) => {
      // TODO: why sass puts `../` in this path sometimes?
      const strippedFrom = from.replace(/^\.\.\//, '');
      // when `from` is 'stdin' path.dirname(from) is just '.'
      const relPath = path.join(baseDir, path.dirname(strippedFrom));
      const importedFile = files[lookupScssName(relPath, url)];

      return importedFile == null ? null : {
        contents: importedFile.contents.toString(),
      };
    },
  });
};

const isPartial = filename => path.basename(filename).startsWith('_');

const setCssArtifact = (files, resProm) =>
  resProm.then(([outFile, file]) => files[outFile] = { contents: file.css });

module.exports = (opts = {}) => {
  opts = { extensions: ['.scss'], ...opts };

  return (files, metalsmith, done) => {
    const { extensions } = opts;
    const scssFiles = filterByExtensions(Object.entries(files), extensions);

    const handleSuccess = res => {
      for (const [filename] of scssFiles) {
        delete files[filename];
      }

      done();
    };

    const handleFailure = err =>
      done(err instanceof Error ? err : new Error(err));

    const jobs = scssFiles
      .filter(([filename]) => !isPartial(filename))
      .map(entry => renderScss(opts, files, entry))
      .map(resProm => setCssArtifact(files, resProm));

    Promise.all(jobs).then(handleSuccess, handleFailure);
  };
};
