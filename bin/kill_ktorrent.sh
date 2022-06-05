#!/bin/bash
kill -9 $(ps -ef | grep ktorrent | awk '{print $2}')