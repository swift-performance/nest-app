import { Injectable } from '@nestjs/common';
export const __VERSION__ = 'testing'
@Injectable()
export class AppService {
  getVersion(): string {
    return __VERSION__
  }


}
