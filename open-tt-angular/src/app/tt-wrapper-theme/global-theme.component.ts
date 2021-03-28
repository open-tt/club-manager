import { Component, OnInit } from '@angular/core';
import { ComponentMode } from '../utils/enums';
import { environment } from '../../environments/environment';
import { CookieService } from '../services/cookie.service';
import { UserService } from '../services/user.service';
import { Router } from '@angular/router';
import { TTRoute } from '../routing.constants';

@Component({
  selector: 'app-global-theme',
  templateUrl: './global-theme.component.html',
  styleUrls: ['./global-theme.component.scss'],
})
export class GlobalThemeComponent implements OnInit {
  mode = ComponentMode.SHOW;
  enableHomePage = environment.enable_home_page;
  enableRegistrationPage = environment.enable_registration_page;
  enableHandicapTournamentPage = environment.enable_handicap_page;
  enableOrgPage = false;
  enableAdmissionsPage = false;
  enableMembershipPage = false;
  enableMembershipSummaryPage = false;
  hasLoggedInUser = false;

  handicapPageTitle = 'Handicap';
  homePageTitle = 'Home';

  handicapPageRoute = TTRoute.TOURNAMENT_HANDICAP;
  homePageRoute = TTRoute.HOME;

  events: string[] = [];
  opened: boolean;

  constructor(
    private cookieService: CookieService,
    private userService: UserService,
    private router: Router
  ) {}

  ngOnInit(): void {
    if (this.cookieService.hasLoggedInUser()) {
      this.userService.userApiToken = this.cookieService.getAuthTokenCookie();
      this.hasLoggedInUser = true;
      this.userService.loadUser();
      this.router.navigate([TTRoute.TOURNAMENT_HANDICAP]);
    }
  }
}
