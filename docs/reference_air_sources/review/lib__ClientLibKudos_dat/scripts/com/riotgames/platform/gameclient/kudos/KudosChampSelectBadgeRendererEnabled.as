package com.riotgames.platform.gameclient.kudos
{
   import com.riotgames.platform.common.components.controls.HTMLToolTip;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import mx.controls.Image;
   import mx.events.ToolTipEvent;
   
   public class KudosChampSelectBadgeRendererEnabled implements IKudosChampSelectBadgeRenderer
   {
      
      private static const BADGE_X_OFFSET:int = -3;
      
      private static const BADGE_Y_OFFSET:int = -7;
      
      private var _badgeRendererDisplay:Image;
      
      public function KudosChampSelectBadgeRendererEnabled()
      {
         super();
      }
      
      public function addAsChildOf(param1:DisplayObjectContainer) : void
      {
         if(!this._badgeRendererDisplay)
         {
            this._badgeRendererDisplay = new Image();
         }
         param1.addChild(this._badgeRendererDisplay);
         this._badgeRendererDisplay.addEventListener(ToolTipEvent.TOOL_TIP_CREATE,this.handleToolTipCreate,false,0,true);
      }
      
      public function displayAppropriateBadge(param1:int, param2:int, param3:Boolean) : Boolean
      {
         if(!this._badgeRendererDisplay)
         {
            return false;
         }
         if(param1 == 0)
         {
            this._badgeRendererDisplay.source = "";
            this._badgeRendererDisplay.toolTip = "";
         }
         else if(Boolean(this.getBitAtIndex(param1,0)) && (param3 || param2 == GameParticipant.FRIENDLY_TEAM))
         {
            this._badgeRendererDisplay.source = new KudosChampSelectBadges.GreatLeaderBadge();
            this._badgeRendererDisplay.toolTip = RiotResourceLoader.getString("kudosChampSelectLeaderBadgeTooltip");
         }
         else if(Boolean(this.getBitAtIndex(param1,1)) && (param3 || param2 == GameParticipant.FRIENDLY_TEAM))
         {
            this._badgeRendererDisplay.source = new KudosChampSelectBadges.GreatMentorBadge();
            this._badgeRendererDisplay.toolTip = RiotResourceLoader.getString("kudosChampSelectMentorBadgeTooltip");
         }
         else if(Boolean(this.getBitAtIndex(param1,2)) && (param3 || param2 == GameParticipant.FRIENDLY_TEAM))
         {
            this._badgeRendererDisplay.source = new KudosChampSelectBadges.GreatTeammateBadge();
            this._badgeRendererDisplay.toolTip = RiotResourceLoader.getString("kudosChampSelectTeammateBadgeTooltip");
         }
         else if(Boolean(this.getBitAtIndex(param1,3)))
         {
            this._badgeRendererDisplay.source = new KudosChampSelectBadges.HonorableOpponentBadge();
            this._badgeRendererDisplay.toolTip = RiotResourceLoader.getString("kudosChampSelectHonorableBadgeTooltip");
         }
         else
         {
            this._badgeRendererDisplay.source = "";
            this._badgeRendererDisplay.toolTip = "";
         }
         return this._badgeRendererDisplay.source != "";
      }
      
      private function getBitAtIndex(param1:uint, param2:uint) : uint
      {
         return param1 >> param2 & 1;
      }
      
      public function updateLayout(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(Boolean(this._badgeRendererDisplay))
         {
            _loc3_ = Number(this._badgeRendererDisplay.getExplicitOrMeasuredWidth());
            _loc4_ = Number(this._badgeRendererDisplay.getExplicitOrMeasuredHeight());
            this._badgeRendererDisplay.setActualSize(_loc3_,_loc4_);
            this._badgeRendererDisplay.move(BADGE_X_OFFSET,BADGE_Y_OFFSET);
         }
      }
      
      public function get badgeRendererDisplay() : DisplayObject
      {
         return this._badgeRendererDisplay;
      }
      
      protected function handleToolTipCreate(param1:ToolTipEvent) : void
      {
         param1.toolTip = new HTMLToolTip();
      }
   }
}

