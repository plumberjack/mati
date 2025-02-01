import type { LoaderFunction, ActionFunction } from 'react-router';

export function createLoader<Context = unknown>(
  cb: LoaderFunction<Context>,
): LoaderFunction<Context> {
  return function (args) {
    return cb(args);
  };
}

export function createAction<Context = unknown>(
  cb: ActionFunction<Context>,
): ActionFunction<Context> {
  return function (args) {
    return cb(args);
  };
}
