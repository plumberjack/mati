#!/usr/bin/env node

import './init';

const input = process.argv.slice(2);

console.log('input', input);

switch (input.at(0)) {
  case 'start': {
    console.log('starting mati...');
  }
}
