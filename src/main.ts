import { Logger, ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import compression from 'compression';
import cookieParser from 'cookie-parser';
import helmet from 'helmet';

import { AppModule } from '@app/app.module';

/**
 *
 */
async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    bufferLogs: true,
  });
  const config = app.get(ConfigService);
  const port: number = config.get<number>('app.port') ?? 3000;
  const globalPrefix: string = config.get<string>('app.globalPrefix') ?? 'api';

  // Установка глобального префикса
  app.setGlobalPrefix(globalPrefix);

  // Security
  app.use(helmet());

  // Compression

  app.use(compression());

  // Cookies
  app.use(cookieParser());

  // Cors (Cross-Origin Resource Sharing)
  app.enableCors({
    origin: config.get<string>('app.cors.origin') || '*',
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  });

  // Global validation pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true, // выбрасываем лишние поля
      forbidNonWhitelisted: true, // ругаемся на лишние поля
      transform: true, // преобразуем к типам DTO
      transformOptions: { enableImplicitConversion: true },
      validateCustomDecorators: true,
    }),
  );

  app.setGlobalPrefix(globalPrefix, { exclude: [] });
  app.enableShutdownHooks();

  await app.listen(port);
  Logger.log(`Server running on http://localhost:${port}/${globalPrefix}`);
}
bootstrap().catch((error) => {
  // eslint-disable-next-line no-console
  console.error('Application failed to start:', error);
  process.exit(1);
});
