import { useFetcher } from 'react-router';
import { createAction, createLoader } from '~/utils';

export const loader = createLoader(({ params }) => {
  return Response.json('henlo');
});

export const action = createAction(async ({ request }) => {
  const data = await request.formData();
  console.log('data', Object.fromEntries(data.entries()));
  return Response.json('henlo');
});

export default function () {
  const fetcher = useFetcher();

  return (
    <div>
      <fetcher.Form method="post">
        <input name="email" type="email" required placeholder="email" />
        <button>send</button>
      </fetcher.Form>
    </div>
  );
}
