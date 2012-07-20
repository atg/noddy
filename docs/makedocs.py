import subprocess
import json
import os
from ConfigParser import RawConfigParser
import io
import re
from jinja2 import Template
import pprint
from collections import OrderedDict

root = os.path.split(os.path.abspath( __file__ ))[0]
os.chdir(root)

with open('template.html', 'r') as f:
    template = Template(f.read())

pages = {}

categories = OrderedDict([
    ('Text', ['Recipe', 'Range', 'Clipboard']),
    ('Workspace', ['MainWindow', 'Tab', 'Editor', 'Document']),
    ('UI', ['Window', 'Sheet', 'Popover', 'Pane', 'Alert']),
])

for path in os.listdir("../api"):
    jtxt = subprocess.check_output("dox < ../api/" + path, shell=True)
    #print jtxt
    #print '\n\n\n\n\n\n\n'
    #print jtxt
    #filenamelower = os.path.splitext(path)[0]
    #filename = filenamelower.capitalize()
    
    j = json.loads(jtxt)
    for item in j:
        if 'ctx' not in item:
            continue
        if '@api private' in item['description']['full']:
            continue
        
        params = []
        ret = None
        for tag in item['tags']:
            if tag['type'] == 'param':
                params.append(tag)
            if tag['type'] == 'return':
                ret = tag
        item['params'] = params
        item['returns'] = ret
                
        for tag in item['tags']:
            if tag['type'] == 'memberOf' and tag['parent']:
                parent = tag['parent']
                break
        else:
            parent = item['ctx']['name']
        
        headerstring = item['ctx']['string']
        if item['ctx']['type'] == 'method':
            if '.prototype.' in item['ctx']['string']:
                headerstring = '.<span class="item-name">%s</span>(%s)' % (item['ctx']['name'], ', '.join('<var>' + param['name'] + '</var>' for param in params))
            else:
                headerstring = '<span class="parent-name">%s</span>.<span class="item-name">%s</span>(%s)' % (parent, item['ctx']['name'], ', '.join('<var>' + param['name'] + '</var>' for param in params))
        elif item['ctx']['type'] == 'function':
            if parent == item['ctx']['name']:
                headerstring = '<span class="item-name">%s</span>(%s)' % (item['ctx']['name'], ', '.join('<var>' + param['name'] + '</var>' for param in params))
            else:
                headerstring = '<span class="parent-name">%s</span>.<span class="item-name">%s</span>(%s)' % (parent, item['ctx']['name'], ', '.join('<var>' + param['name'] + '</var>' for param in params))
        #elif item['ctx']['type'] == 'constructor':
        #    headerstring = '%s(%s)' % (item['ctx']['name'], ', '.join(param['name'] for param in params))
        else:
            print "Unknown type %s" % item['ctx']['type']
        
        item['headerstring'] = headerstring
        #print item['ctx']['name']
        #print item['ctx']['type']

        if parent in pages:
            pages[parent].append(item)
        else:
            pages[parent] = [item]
# print json.dumps(pages, sort_keys=True, indent=4)

for category in categories:
    for item in categories[category][:]:
        if item not in pages:
            categories[category].remove(item)

for pagename in pages:
    with open(os.path.join('output', pagename.lower() + '.html'), 'w') as f:
        f.write(template.render(categories=categories, page=pages[pagename], pagename=pagename, pagenames=pages.keys()))

    