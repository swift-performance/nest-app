import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) { }
  /**
     * Default to get service version
     */
  @Get('/')
  getRoot(): object {
    return {
      version: this.appService.getVersion()
    }
  }

  /**
   * Get service version
   */
  @Get('/version')
  getVersion(): object {
    return {
      version: this.appService.getVersion()
    }
  }
}
