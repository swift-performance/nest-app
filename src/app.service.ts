import { Injectable } from '@nestjs/common';
export const __VERSION__ = '0.0.2'
@Injectable()
export class AppService {
  getVersion(): string {
    return __VERSION__
  }


}
