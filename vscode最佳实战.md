我一直用pycharm,但是启动太慢了.转向vs. 这个东西刚开始用不太适应,我顺便总结下点东西

# 初始化安装软件
- 安装python,并安装py虚拟环境,待关联vs
- 安装vs并安装python插件
- 创建虚拟环境
```
pip install virtualenv
pip install virtualenvwrapper
pip install virtualenvwrapper-win
mkvirtualenv py27env
```

# 打开一个目录,写代码
.vscode里创建2个文件

- launch.json
```
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python",
            "type": "python",
            "request": "launch",
            "stopOnEntry": true,
            "program": "${file}",
            "debugOptions": [
                "WaitOnAbnormalExit",
                "WaitOnNormalExit",
                "RedirectOutput"
            ]
        },
        {
            "name": "Python Console App",
            "type": "python",
            "request": "launch",
            "stopOnEntry": true,
            "program": "${file}",
            "externalConsole": true,
            "debugOptions": [
                "WaitOnAbnormalExit",
                "WaitOnNormalExit"
            ]
        },
        {
            "name": "Django",
            "type": "python",
            "request": "launch",
            "stopOnEntry": true,
            "program": "${workspaceRoot}/manage.py",
            "args": [
                "runserver",
                "--noreload"
            ],
            "debugOptions": [
                "WaitOnAbnormalExit",
                "WaitOnNormalExit",
                "RedirectOutput",
                "DjangoDebugging"
            ]
        },
        {
            "name": "Watson",
            "type": "python",
            "request": "launch",
            "stopOnEntry": true,
            "program": "${workspaceRoot}/console.py",
            "args": [
                "dev",
                "runserver",
                "--noreload=True"
            ],
            "debugOptions": [
                "WaitOnAbnormalExit",
                "WaitOnNormalExit",
                "RedirectOutput"
            ]
        }
    ]
}
```

- tasks.json
```
{
    "version": "0.1.0",
    "command": "python",
    "isShellCommand": true,
    "args": ["${file}"],
    "showOutput": "always"
}
```

# 创建hello.py
- 写一些代码,使用ctrl+shit+b运行.


# 调大代码字体,并设置自动保存
- 懒得ctrl+s了
- 文件--首选项--设置
```
{
    "workbench.colorTheme": "Solarized Light",
    "window.zoomLevel": 1,
    "window.menuBarVisibility": "default",
    "editor.wordWrap": "on",
    "editor.fontSize": 16,
    "files.autoSave": "afterDelay",
    "terminal.integrated.shell.windows": "C:\\Program Files\\Git\\bin\\bash.exe",
    "editor.rulers": [80,120]
}
```

# 安装vs插件
- 快捷键插件: Sublime Text Keymap
  - ctrl+shift+d 复制一行
  - ctrl+shift + 上下箭头移动一行

- markdown all in one && markdown转pdf

## 其他比较常用的快键键
Alt+Shift+F　# 自动格式化代码 autopep8
Ctrl+Shift+P # 执行命令，如python help
ctrl+p #文件名快速打开


## 重点参考
记得每次安装插件的时候,看下他的使用说明.

https://code.visualstudio.com/docs/getstarted/tips-and-tricks
https://code.visualstudio.com/docs/languages/python#_install-python-extension


django怎么用我还没弄清楚.



## python路径设置
python.pythonPath
http://blog.csdn.net/seymour163/article/details/56623343


