# NestJS Test Conventions

- Use one bounded backend flow or persistence slice at a time.
- Prefer explicit HTTP status, payload shape, and database state assertions.
- Keep controller, service, and repository boundaries visible in the test setup.
- Use `nestjs-debug` when the main task is to investigate runtime behavior before deciding how to test it.
- Do not hide flaky backend tests behind retries or sleeps.
