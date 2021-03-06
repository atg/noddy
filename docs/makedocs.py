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

def getsection(k):
    for tag in k['tags']:
        if tag['type'] == 'section':
            return tag['string']
    return 'Misc'

def orderby(values, keyfunc):
    keys = OrderedDict()
    for v in values:
        k = keyfunc(v)
        if k in keys:
            keys[k].append(v)
        else:
            keys[k] = [v]
    return keys


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
    sectiondict = orderby(j, getsection).items()
    for sectionname, sectionitems in sectiondict:
        isFirstOfSection = True
        for item in sectionitems:
            if 'ctx' not in item:
                continue
            if '@api private' in item['description']['full']:
                continue
            
            params = []
            ret = None
            isproperty = False
            for tag in item['tags']:
                if tag['type'] == 'param':
                    params.append(tag)
                if tag['type'] == 'return':
                    ret = tag
                if tag['type'] == 'isproperty':
                    isproperty = True
            item['params'] = params
            item['returns'] = ret
                    
            for tag in item['tags']:
                if tag['type'] == 'memberOf' and tag['parent']:
                    parent = tag['parent']
                    break
            else:
                parent = item['ctx']['name']
            
            item['sectionName'] = sectionname
            item['isFirstOfSection'] = isFirstOfSection if len(sectiondict) >= 2 else False
            isFirstOfSection = False
            headerstring = item['ctx']['string']
            basicheaderstring = item['ctx']['string']
            if isproperty:
                if '.prototype.' in item['ctx']['string']:
                    headerstring = '.<span class="item-name">%s</span>' % (item['ctx']['name'])
                    basicheaderstring = '.%s' % (item['ctx']['name'])
                else:
                    headerstring = '<span class="parent-name">%s</span>.<span class="item-name">%s</span>' % (parent, item['ctx']['name'])
                    basicheaderstring = '%s.%s' % (parent, item['ctx']['name'])
                    
            elif item['ctx']['type'] == 'method':
                if '.prototype.' in item['ctx']['string']:
                    headerstring = '.<span class="item-name">%s</span>(%s)' % (item['ctx']['name'], ', '.join('<var>' + param['name'] + '</var>' for param in params))
                    basicheaderstring = '%s()' % (item['ctx']['name'])
                else:
                    headerstring = '<span class="parent-name">%s</span>.<span class="item-name">%s</span>(%s)' % (parent, item['ctx']['name'], ', '.join('<var>' + param['name'] + '</var>' for param in params))
                    basicheaderstring = '%s.%s()' % (parent, item['ctx']['name'])
                    
            elif item['ctx']['type'] == 'function':
                if parent == item['ctx']['name']:
                    headerstring = '<span class="item-name">%s</span>(%s)' % (item['ctx']['name'], ', '.join('<var>' + param['name'] + '</var>' for param in params))
                    basicheaderstring = '%s()' % (item['ctx']['name'])
                else:
                    headerstring = '<span class="parent-name">%s</span>.<span class="item-name">%s</span>(%s)' % (parent, item['ctx']['name'], ', '.join('<var>' + param['name'] + '</var>' for param in params))
                    basicheaderstring = '%s.%s()' % (parent, item['ctx']['name'])
            
            #elif item['ctx']['type'] == 'constructor':
            #    headerstring = '%s(%s)' % (item['ctx']['name'], ', '.join(param['name'] for param in params))
            else:
                print "Unknown type %s" % item['ctx']['type']
            
            item['headerstring'] = headerstring
            item['basicheaderstring'] = basicheaderstring
            
            if parent in pages:
                pages[parent].append(item)
            else:
                pages[parent] = [item]
# print json.dumps(pages, sort_keys=True, indent=4)

for category in categories:
    for item in categories[category][:]:
        if item not in pages:
            categories[category].remove(item)

misc = list(pages.keys())
for category in categories:
    for item in categories[category]:
        if item in misc:
            misc.remove(item)        
if misc:
    categories['Misc'] = misc

for pagename in pages:
    with open(os.path.join('output', pagename.lower() + '.html'), 'w') as f:
        f.write(template.render(categories=categories, page=pages[pagename], pagename=pagename, pagenames=pages.keys()))

    