const gulp = require('gulp')
const webfont = require('gulp-webfont')
const cson = require('cson')
const fs = require('fs')
const path = require('path')

// default color
const COLOR = 'inherit';

gulp.task('generate-less', function () {
  let files = fs.readdirSync('icons/')
  let colors = cson.parseCSONFile('icons/colors.cson')
  let content = fs.readFileSync('styles/file-icons-header.less', 'utf8')
  content += '.dash-icons-enabled .tree-view .file {\n' + files
    .map(file => path.parse(file))
    .filter(file => file.ext === '.svg')
    .sort((a, b) => a.name.length - b.name.length)
    .map(file => {
      let type = 'file-icon'
      let color = colors[file.name] || COLOR
      if (Array.isArray(color)) {
        type = `file-icon-${color[0]}-gradient`
        color = `${color[0]}-gradient(${color.slice(1).join(', ')})`
      }
      return `  .${type}('${file.name}', ${color});`
    })
    .join('\n') + '\n}\n'
  fs.writeFileSync('styles/file-icons.less', content)
})

gulp.task('icons', function () {
  return gulp.src('icons/*.svg')
    .pipe(webfont({
      types: 'woff2',
      ligatures: true
    }))
    .pipe(gulp.dest('fonts'))
})

gulp.task('default', ['icons', 'generate-less'])
