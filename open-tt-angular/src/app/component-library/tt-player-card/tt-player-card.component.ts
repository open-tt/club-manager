import { Component, Input, OnInit } from '@angular/core';
import { Player } from '../../models/player';
import { TtMatchResultDialogComponent } from '../tt-match-result-dialog/tt-match-result-dialog.component';
import { Match } from '../../models/tournament';
import { MatDialog } from '@angular/material/dialog';
import { TtInvitationDialogComponent } from '../tt-invitation-dialog/tt-invitation-dialog.component';

@Component({
  selector: 'app-tt-player-card',
  templateUrl: './tt-player-card.component.html',
  styleUrls: ['./tt-player-card.component.css'],
})
export class TtPlayerCardComponent implements OnInit {
  @Input() player: Player = {
    id: 1,
    name: 'Eriel Marimon',
  };

  constructor(public dialog: MatDialog) {}

  ngOnInit(): void {}

  subtitle(): string {
    if (this.player?.tt_profile?.homeclub) {
      return this.player?.tt_profile?.homeclub;
    }
    return '-';
  }

  image(): string {
    if (this.player?.profile_img) {
      return this.player?.profile_img;
    }
    return 'https://www.kindpng.com/picc/m/429-4291136_table-tennis-png-download-ping-pong-icon-png.png';
  }

  openDialog(): void {
    const dialogRef = this.dialog.open(TtInvitationDialogComponent, {
      width: '30%',
      data: {
        host: this.player,
        recipient: this.player,
      },
    });

    dialogRef.afterClosed().subscribe((invite: object) => {
      if (!invite) {
        return;
      }
      // this.tournamentService.updateSingleMatch(updatedMatch);
    });
  }
}
