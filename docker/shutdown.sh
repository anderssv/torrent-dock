#!/bin/bash

pgrep transmission | xargs kill
pgrep openvpn | xargs kill
