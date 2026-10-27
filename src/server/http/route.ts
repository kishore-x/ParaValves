import 'server-only';
import { NextResponse, type NextRequest } from 'next/server';
import { z, type ZodTypeAny } from 'zod';
import { getCurrentUser, type AuthUser } from '../auth/session';
import { assertCan } from '../auth/rbac';
import { AppError, Unauthorized } from './errors';

export interface Ctx<TBody = unknown> {
  user: AuthUser;
  body: TBody;
  req: NextRequest;
  params: Record<string, string>;
}

interface Options<TSchema extends ZodTypeAny> {
  permission?: string;
  schema?: TSchema;
}

type Handler<TSchema extends ZodTypeAny> = (
  ctx: Ctx<TSchema extends ZodTypeAny ? z.infer<TSchema> : unknown>,
) => Promise<unknown>;

/**
 * defineRoute enforces the seven-question API contract:
 * authenticated → authorized → org-scoped (user carries orgIds) → validated input.
 */
export function defineRoute<TSchema extends ZodTypeAny>(
  opts: Options<TSchema>,
  handler: Handler<TSchema>,
) {
  return async (req: NextRequest, segment: { params: Promise<Record<string, string>> }) => {
    try {
      const user = await getCurrentUser();
      if (!user) throw Unauthorized();
      if (opts.permission) assertCan(user, opts.permission);

      let body: unknown = undefined;
      if (req.method !== 'GET' && req.method !== 'DELETE') {
        const raw = await req.text();
        body = raw ? JSON.parse(raw) : {};
        if (opts.schema) {
          const parsed = opts.schema.safeParse(body);
          if (!parsed.success) {
            return NextResponse.json(
              { error: 'Validation failed', code: 'VALIDATION', details: parsed.error.flatten() },
              { status: 422 },
            );
          }
          body = parsed.data;
        }
      }

      const params = (await segment.params) ?? {};
      const result = await handler({ user, body: body as never, req, params });
      return NextResponse.json(result ?? { ok: true });
    } catch (e) {
      return handleError(e);
    }
  };
}

export function handleError(e: unknown): NextResponse {
  if (e instanceof AppError) {
    return NextResponse.json(
      { error: e.message, code: e.code, context: e.context ?? null },
      { status: e.status },
    );
  }
  const status = (e as { status?: number }).status;
  if (status === 403) return NextResponse.json({ error: (e as Error).message, code: 'FORBIDDEN' }, { status: 403 });
  console.error('[unhandled route error]', e);
  return NextResponse.json({ error: 'Internal server error', code: 'INTERNAL' }, { status: 500 });
}

export function pagination(req: NextRequest) {
  const url = new URL(req.url);
  const page = Math.max(1, Number(url.searchParams.get('page') ?? 1));
  const size = Math.min(100, Math.max(1, Number(url.searchParams.get('size') ?? 25)));
  const q = url.searchParams.get('q')?.trim() ?? '';
  const status = url.searchParams.get('status')?.trim() ?? '';
  return { page, size, offset: (page - 1) * size, q, status };
}
