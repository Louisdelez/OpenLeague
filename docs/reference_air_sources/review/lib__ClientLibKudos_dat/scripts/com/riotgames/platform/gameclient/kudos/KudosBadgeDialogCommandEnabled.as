package com.riotgames.platform.gameclient.kudos
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.rust.context.RustContext;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class KudosBadgeDialogCommandEnabled extends CommandBase
   {
      
      public static const LEADERSHIP_BADGE_INDEX:int = 0;
      
      public static const MENTOR_BADGE_INDEX:int = 1;
      
      public static const TEAMWORK_BADGE_INDEX:int = 2;
      
      public static const HONORABLE_OPPONENT_BADGE_INDEX:int = 3;
      
      private var timer:Timer;
      
      private var pendingBadges:int;
      
      private var dialog:KudosBadgeDialog;
      
      private var context:RustContext;
      
      public function KudosBadgeDialogCommandEnabled(param1:RustContext, param2:int, param3:int)
      {
         super();
         this.pendingBadges = param2;
         this.context = param1;
         this.timer = new Timer(param3);
      }
      
      public function displayAppropriateBadge(param1:int) : void
      {
         if(Boolean(this.getBitAtIndex(param1,LEADERSHIP_BADGE_INDEX)))
         {
            this.dialog = new KudosBadgeDialog(this.context,KudosBadgeDialog.LEADSHIP_BADGE);
            this.dialog.display();
         }
         if(Boolean(this.getBitAtIndex(param1,MENTOR_BADGE_INDEX)))
         {
            this.dialog = new KudosBadgeDialog(this.context,KudosBadgeDialog.MENTOR_BADGE);
            this.dialog.display();
         }
         if(Boolean(this.getBitAtIndex(param1,TEAMWORK_BADGE_INDEX)))
         {
            this.dialog = new KudosBadgeDialog(this.context,KudosBadgeDialog.TEAMWORK_BADGE);
            this.dialog.display();
         }
         if(Boolean(this.getBitAtIndex(param1,HONORABLE_OPPONENT_BADGE_INDEX)))
         {
            this.dialog = new KudosBadgeDialog(this.context,KudosBadgeDialog.HONORABLE_OPPONENT_BADGE);
            this.dialog.display();
         }
         onComplete();
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.stop();
         this.timer = null;
         this.displayAppropriateBadge(this.pendingBadges);
      }
      
      public function getTimer() : Timer
      {
         return this.timer;
      }
      
      override public function execute() : void
      {
         super.execute();
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.start();
      }
      
      private function getBitAtIndex(param1:uint, param2:uint) : uint
      {
         return param1 >> param2 & 1;
      }
      
      public function getDialog() : KudosBadgeDialog
      {
         return this.dialog;
      }
   }
}

