import { Injectable } from '@nestjs/common';
export const __VERSION__ = '0.1.1'
@Injectable()
export class AppService {
  getVersion(): string {
    return __VERSION__
  }


}
