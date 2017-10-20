
import logging
'''
json格式
'''
def log_record(log_module_name, log_fname, log_level):
    '''
        日志记录模块
    '''
    op = {
        'debug':logging.DEBUG,
        'info':logging.INFO
        'WARNING':logging.WARNING
        'ERROR':logging.ERROR
        'CRITICAL':logging.CRITICAL
    }
    log_level = op.get(log_level)
    
    f = logging.FileHandler(log_fname, "a", "UTF-8")
    fmt = logging.Formatter(
        fmt='{"access_time":"%(asctime)s","access_name":"%(name)s","log_level":"%(levelname)s","log_module":"%(module)s","log_message":"%(message)s"}')
    f.setFormatter(fmt)

    loggerx = logging.Logger(log_module_name, level=log_level)
    loggerx.addHandler(f)
    return loggerx


# logger1 = log_record('test', 'test.log', 'debug')
# logger1.warning("test debug msg")


# logger2 = log_record('user', 'user.log', 'debug')
# logger2.warning("maotai login")
# logger2.warning("maotai registed")
# logger2.warning("maotai logout")
