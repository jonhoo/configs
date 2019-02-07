import xerox

class NvimClipboard(object):
    def __init__(self, vim):
        self.provides = ['clipboard']

    def clipboard_get(self):
        return xerox.paste().split('\n')

    def clipboard_set(self, lines):
        xerox.copy(u'\n'.join([line.decode('utf-8') for line in lines]))
