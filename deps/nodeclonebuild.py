# Node clone and build
import commands, subprocess
import os
import sys
import shutil

# cd to our own dir
root = os.path.split(os.path.abspath( __file__ ))[0]
os.chdir(root)

def runcommand(cmd):
    return subprocess.check_call(cmd, shell=True)

def nodecompile():
    # Clone node from github
    print '--- CLONING ---'
    runcommand('git clone https://github.com/joyent/node.git')

    # Configure
    print '--- CONFIGURING ---'
    runcommand('cd node && ./configure')


    # Change node/out/node.target.mk
    print '--- CHANGING NODE TARGET ---'
    x = ""
    with open('node/out/node.target.mk', 'r') as f:
        x = f.read().replace('$(call do_cmd,link)', '$(call do_cmd,alink)')

    runcommand('rm node/out/node.target.mk && touch node/out/node.target.mk')

    with open('node/out/node.target.mk', 'w') as f:
        f.write(x)


    # Make
    print '--- BUILDING ---'
    runcommand('cd node && env CC=clang CXX=clang++ make')
    runcommand('mv node/out/Release/node node/out/Release/libnode.a')

def deletenonheaders():
    # Copy node to node-headers
    print '--- COPYING HEADER SHELL ---'
    shutil.copytree('node', 'node-headers', symlinks=True, ignore=lambda x, contents: ['.git', 'out'])
    
    print '--- PRUNING HEADER SHELL ---'
    headerexts = set(['.h', '.hh', '.h++', '.hpp'])
    for root, dirs, files in os.walk('node-headers'):
        print root
        for f in files:
            if '/test/' in root or os.path.splitext(f)[1] not in headerexts:
                print "Delete " + os.path.join(root, f)
                os.unlink(os.path.join(root, f))

    for root, dirs, files in os.walk('node-headers', topdown=False):
        if len(files) == 0:
            print root
            try:
                os.rmdir(root)
            except:
                pass


nodecompile()

# Walk the directory tree, find any files that are not .h, .hpp, .hh, .h++, .inc
# Delete them
deletenonheaders()
