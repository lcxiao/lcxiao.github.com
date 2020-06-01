//Windows
var spawn = require('child_process').exec;
hexo.on('new', function(data){
    spawn('start  "markdown编辑器绝对路径.exe" ' + data.path);
});

//macOS
var exec = require('child_process').exec;
hexo.on('new', function(data){
    exec('open -a "markdown编辑器绝对路径.app" ' + data.path);
});
