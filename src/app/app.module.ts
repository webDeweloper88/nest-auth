import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';

import { AppController } from '@app/app.controller';
import { AppService } from '@app/app.service';
import appConfig from '@config/app.config';
import dbConfig from '@config/db.config';
import jwtConfig from '@config/jwt.config';
import mailConfig from '@config/mail.config';
import redisConfig from '@config/redis.config';
import { PrismaModule } from '@prisma/prisma.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      // при желании: ['.env.local', `.env.${process.env.NODE_ENV}`, '.env']
      envFilePath: ['.env'],
      load: [appConfig, dbConfig, jwtConfig, redisConfig, mailConfig], // загрузка конфигов
      expandVariables: true, // разворачивает переменные окружения
    }),
    PrismaModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
