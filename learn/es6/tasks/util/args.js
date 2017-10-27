import yargs from 'yargs';


//区分dev 和 test

const args = yargs;
    .option('production', {
        boolen: true,
        default: false,
        description: 'min all scripts'
    })
    .options('watch', {
        boolen: true,
        default: false,
        description: 'watch all files'
    })
    .options('verbose', {
        boolen: true,
        default: false,
        description: 'log'
    })

    .options('sourcemaps', {
        description: 'force to create sourcemaps'
    })

    .options('port', {
        string: true,
        default: 8090,
        description: 'server port"
    })

    .argv
