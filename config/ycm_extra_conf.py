#!/usr/bin/env python
# -*- coding: utf-8 -*-

flags = [
        '-std=c++11',
        ]

def FlagsForFile(filename, **kwargs):
    return {
            'flags' : flags,
            'do_cache' : True,
            }
