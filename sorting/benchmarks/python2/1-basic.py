#!/usr/bin/env python
# -*- coding: utf-8 -*-

import random
import string

from benchmark import timethese

SAMPLE_SIZE             = 100 * 1000
BENCHMARK_ITERATIONS    = 100


def main():
    print "Generating sample data..."
    
    
    nums = generatate_num_data(SAMPLE_SIZE)
    strs = generatate_str_data(SAMPLE_SIZE)
    
    
    #b = num_asc(a)
    #print b
    #print a
    
    timethese(BENCHMARK_ITERATIONS,
        (
            ("num_asc",        lambda : common_asc(nums)),
            ("num_desc",       lambda : common_desc(nums)),
            ("num_desc_rev",   lambda : common_desc_rev(nums)),
            ("num_desc_cmp",   lambda : num_desc_cmp(nums)),
            ("str_asc",        lambda : common_asc(strs)),
            ("str_desc",       lambda : common_desc(strs)),
            ("str_desc_rev",   lambda : common_desc_rev(strs)),
            ("str_desc_cmp",   lambda : str_desc_cmp(strs)),
        )
    )


def generatate_num_data(N):
    """
    Generate sample sequence of integer numbers, size = N
    """
    
    itemrange = 1000 * 1000
    a = []

    for x in xrange(N):
        a.append(random.randint(0, itemrange - 1))
    return a


def generatate_str_data(N):
    """
    Generate sample sequence of strings, size = N
    """

    chars = string.ascii_uppercase + string.ascii_lowercase
    itemlen = 10
    a = []

    for x in xrange(N):
        a.append(''.join(random.choice(chars) for s in xrange(itemlen)))
    return a


def common_asc(data):
    return sorted(data)


def common_desc(data):
    ###return sorted(data).reverse()


def common_desc_rev(data):
    return sorted(data, reverse=True)


def num_desc_cmp(data):
    
    def rev_num_compare(a, b):
        return b - a
    
    return sorted(data, cmp=rev_num_compare)

def str_desc_cmp(data):
    
    def rev_str_compare(a, b):
        if a < b:
            return 1
        elif a > b:
            return -1
        else:
            return 0
    
    return sorted(data, cmp=rev_str_compare)



if __name__ == '__main__':
    main()
