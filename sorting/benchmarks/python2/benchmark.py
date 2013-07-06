#!/usr/bin/env python
# -*- coding: utf-8 -*-

import time

def timethese(times, funcs):
    """
    Run funcs (list of pairs "name, function") for specified times,
    measures and output time of their execution.
    """
    
    print "Benchmark: timing %d iterations of %s..." % (times, ", ".join([x[0] for x in funcs]))
    for (name, code) in funcs:
        start = time.clock()
        for i in (xrange(times)):
            code()
        stop = time.clock()
        delta = stop - start
        print "%-20s %10.2f secs, @ %10.2f/s" % (name, delta, times / delta)
