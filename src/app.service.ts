import { Injectable } from '@nestjs/common';
export const __VERSION__ = '0.0.3'
@Injectable()
export class AppService {
  getVersion(): string {
    return __VERSION__
  }


}
