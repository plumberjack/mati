#!/usr/bin/env node

import './init';

const input = process.argv.slice(2);

switch (input.at(0)) {
  case 'start': {
    console.log('starting mati...');
  }
}
