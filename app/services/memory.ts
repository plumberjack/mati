import { Database } from 'bun:sqlite';

type Where = Record<string, any>;
type Values = Record<string, any>;

const keys = Object.keys;
const pairs = Object.entries;

function joinKeys(keys: string[] | Where, joinBy: string) {
  const list = Array.isArray(keys) ? keys : Object.keys(keys);
  return list.map((key) => `${key} = $${key}`).join(joinBy);
}

export type MemoryQuery<V extends Values, W extends Where> =
  | { type: 'DELETE'; table: string; where: W }
  | { type: 'INSERT'; table: string; values: V }
  | { type: 'UPDATE'; table: string; values: V; where: W }
  | { type: 'SELECT'; table: string; fields?: [keyof W]; where?: Where };

export class Memory {
  private db: Database;

  constructor(config?: ConstructorParameters<typeof Database>[1]) {
    this.db = new Database(':memory:', config);
  }

  private buildQuery<V extends Values, W extends Where>(config: MemoryQuery<V, W>) {
    const { type, table } = config;

    const params: Values = {};
    let query = '';

    switch (type) {
      case 'SELECT': {
        const f = config.fields;
        query = `SELECT ${f?.length ? f.join(', ') : '*'} FROM ${table}`;

        if (config.where) {
          query += ` WHERE ${joinKeys(config.where, ' AND ')}`;
          for (const [k, v] of pairs(config.where)) params[`$${k}`] = v;
        }

        break;
      }

      case 'INSERT': {
        if (config.values) {
          const v = keys(config.values);
          query = `INSERT INTO ${table} (${v.join(', ')}) VALUES (${joinKeys(v, ', ')})`;
          for (const [k, v] of pairs(config.values)) params[`$${k}`] = v;
        }
        break;
      }

      case 'UPDATE': {
        if (config.values) {
          const values = joinKeys(config.values, ', ');
          query = `UPDATE ${table} SET ${values}`;
          for (const [k, v] of pairs(config.values)) params[`$${k}`] = v;
        }
        if (config.where) {
          query += ` WHERE ${joinKeys(config.where, ' AND ')}`;
          for (const [k, v] of pairs(config.where)) params[`$${k}`] = v;
        }
        break;
      }

      case 'DELETE': {
        query = `DELETE FROM ${table}`;
        if (config.where) {
          query += ` WHERE ${joinKeys(config.where, ' AND ')}`;
          for (const [k, v] of pairs(config.where)) params[`$${k}`] = v;
        }
        break;
      }
    }

    return { query, params };
  }

  async query<V extends Values, W extends Where>(config: MemoryQuery<V, W>) {
    const { query, params } = this.buildQuery(config);
    const statement = this.db.query(query);

    switch (config.type) {
      case 'SELECT':
        return statement.all(params);

      case 'INSERT':
      case 'DELETE':
      case 'UPDATE':
        return statement.run(params);
    }
  }

  close(throwOnError = false) {
    this.db.close(throwOnError);
  }

  create<V extends Values>(table: string, values: V) {
    return this.query({ type: 'INSERT', table, values });
  }

  read<W extends Where>(table: string, fields?: [keyof W], where?: W) {
    return this.query({ type: 'SELECT', table, fields, where });
  }

  update<V extends Values, W extends Where>(table: string, values: V, where: W) {
    return this.query({ type: 'UPDATE', table, values, where });
  }

  delete<W extends Where>(table: string, where: W) {
    return this.query({ type: 'DELETE', table, where });
  }
}

export default new Memory({ strict: true });
