export class AppError extends Error {
  constructor(
    message: string,
    public status = 400,
    public code = 'BAD_REQUEST',
    public context?: Record<string, unknown>,
  ) {
    super(message);
    this.name = 'AppError';
  }
}

export const Unauthorized = (m = 'Not authenticated') => new AppError(m, 401, 'UNAUTHORIZED');
export const Forbidden = (m = 'Not authorized') => new AppError(m, 403, 'FORBIDDEN');
export const NotFound = (m = 'Not found') => new AppError(m, 404, 'NOT_FOUND');
export const Conflict = (m = 'Version conflict — record was modified by someone else') =>
  new AppError(m, 409, 'CONFLICT');
