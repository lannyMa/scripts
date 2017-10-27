import gulp from 'gulp';
import gulpif from 'gulp-if';
import concat from 'gulp-concat';
import webpack from 'webpack';
import gulpWebpack from 'webpack-stream';
import named from 'vinyl-named';
import livereload from 'gulp-livereload';
import plumber from 'gulp-plumber';
import rename from 'gulp-rename';
import uglify from 'gulp-uglify';
import {log,colors} from 'gulp-util';
import args from './args';

gulp.task('scripts',()=>{
    return gulp.src(['app/js.index.js'])
        .pip(plumber({
            errorHandler:function () {

            }
        }))
        .pip(named())
        .pipe(gulpWebpack({
            module:{
                loaders:[{
                    test:./\.js$/,
                    loader: 'babel'
                }]
            }
        }))
})



